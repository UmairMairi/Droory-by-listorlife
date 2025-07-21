import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/base/helpers/profanity_helper.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import '../../base/helpers/string_helper.dart';
import '../../base/network/api_constants.dart';
import 'dart:io';
import '../../res/assets_res.dart';
import '../../widgets/multi_select_category.dart';

class EditProfileView extends BaseView<ProfileVM> {
  const EditProfileView({super.key});

  Widget _buildAvatarContent(ProfileVM viewModel) {
    final currentUser = DbHelper.getUserModel();

    // If image was deleted, always show placeholder
    if (viewModel.isImageDeleted) {
      return _buildPlaceholderAvatar();
    }

    // Check for local image first (newly selected)
    if (viewModel.imagePath.isNotEmpty) {
      final file = File(viewModel.imagePath);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: 180,
            height: 180,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderAvatar();
            },
          ),
        );
      }
    }

    // Check for database image (only if not deleted)
    final hasDbImage = currentUser?.profilePic?.isNotEmpty == true;
    if (hasDbImage && !viewModel.isImageDeleted) {
      final imageUrl = getImageUrl(viewModel: viewModel);
      return ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 180,
          height: 180,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            // Show loading indicator instead of placeholder
            return Container(
              width: 180,
              height: 180,
              color: Colors.grey[100],
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderAvatar();
          },
        ),
      );
    }

    // No image - show placeholder
    return _buildPlaceholderAvatar();
  }

  Widget _buildPlaceholderAvatar() {
    final currentUser = DbHelper.getUserModel();
    final firstName = currentUser?.name ?? '';
    final lastName = currentUser?.lastName ?? '';

    // If we have names, show initials
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      String initials = "";
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        initials = '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
      } else if (firstName.isNotEmpty) {
        initials = firstName[0].toUpperCase();
      } else if (lastName.isNotEmpty) {
        initials = lastName[0].toUpperCase();
      }

      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade600,
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Fallback to person icon when no name is available
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade600,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showImageOptionsBottomSheet(BuildContext context, ProfileVM viewModel) {
    final currentUser = DbHelper.getUserModel();
    final hasImage = viewModel.imagePath.isNotEmpty ||
        (currentUser?.profilePic?.isNotEmpty == true);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Wrap(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    StringHelper.profilePicture,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        leading:
                            const Icon(Icons.camera_alt, color: Colors.blue),
                        title: Text(
                          StringHelper.takePhoto,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          String? imagePath =
                              await ImagePickerHelper.pickImageFromCamera();
                          if (imagePath != null) {
                            viewModel.imagePath = imagePath;
                          }
                        },
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        leading: const Icon(Icons.photo_library,
                            color: Colors.green),
                        title: Text(
                          StringHelper.chooseFromGallery,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          String? imagePath =
                              await ImagePickerHelper.pickImageFromGallery();
                          if (imagePath != null) {
                            viewModel.imagePath = imagePath;
                          }
                        },
                      ),
                      if (hasImage)
                        ListTile(
                          tileColor: Colors.white,
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            StringHelper.removePhoto,
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            viewModel.deleteImage();
                            DialogHelper.showToast(
                                message: StringHelper.photoRemovedUpdate);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, ProfileVM viewModel) {
    final currentUser = DbHelper.getUserModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.editProfile),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.clearEmailError();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: _buildAvatarContent(viewModel),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () =>
                          _showImageOptionsBottomSheet(context, viewModel),
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.firstName,
              hint: StringHelper.firstName,
              keyboardType: TextInputType.name,
              controller: viewModel.nameTextController,
              maxLength: 50,
            ),
            const Gap(20),

            AppTextField(
              title: "${StringHelper.lastName} ${StringHelper.optionalField}",
              hint: StringHelper.lastName,
              keyboardType: TextInputType.name,
              controller: viewModel.lastNameController,
              isMandatory: false,
              validator: (value) => null,
              maxLength: 50,
            ),
            const Gap(20),

            // Email Field with Error Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  title: StringHelper.email,
                  hint: StringHelper.enterYourEmailAddress,
                  keyboardType: TextInputType.emailAddress,
                  controller: viewModel.emailTextController,
                  validator: (value) => null,
                  onChanged: (value) {
                    if (viewModel.emailError?.isNotEmpty == true) {
                      viewModel.clearEmailError();
                    }
                  },
                  suffix: viewModel.isEmailVerified
                      ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 20,
                        )
                      : null,
                ),
                if (viewModel.emailError?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            viewModel.emailError!.replaceAll('_', ' '),
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            viewModel.clearEmailError();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red.shade600,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Gap(20),

            AppTextField(
              title: StringHelper.phoneNumber,
              hint: StringHelper.phoneNumber,
              onChanged: (value) {
                final currentPhone = currentUser?.phoneNo ?? '';
                final currentCountryCode = currentUser?.countryCode ?? '';
                final enteredPhone = value ?? '';

                viewModel.isPhoneVerified = currentUser?.phoneVerified != 0 &&
                    currentPhone == enteredPhone &&
                    currentCountryCode == viewModel.countryCode;

                viewModel.notifyListeners();
              },
              suffix: viewModel.isPhoneVerified
                  ? const Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 20,
                    )
                  : TextButton(
                      onPressed: () {
                        viewModel.sendVerificationPhone(
                            countryCode: viewModel.countryCode,
                            phone: viewModel.phoneTextController.text);
                      },
                      child: Text(
                        StringHelper.verify,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              prefix: CountryPicker(
                selectedCountry: viewModel.selectedCountry,
                dense: true,
                isEnable: false, // This disables the picker
                showLine: false,
                showFlag: true,
                showFlagCircle: false,
                showDialingCode: true,
                showName: false,
                withBottomSheet: true,
                showCurrency: false,
                showCurrencyISO: false,
                onChanged: (country) => viewModel.updateCountry(country),
              ),
              focusNode: viewModel.nodeText,
              keyboardType: TextInputType.phone,
              controller: viewModel.phoneTextController,
            ),

            const Gap(20),
            AppTextField(
              title: StringHelper.bio,
              hint: StringHelper.writeHere,
              keyboardType: TextInputType.multiline,
              controller: viewModel.bioTextController,
              maxLines: 5,
              minLines: 5,
              maxLength: 500,
            ),

            const Gap(20),
            CommonDropdown<String>(
              title: StringHelper.gender,
              titleColor: Colors.black,
              hint: viewModel.selectedGender ?? StringHelper.selectGender,
              onSelected: (String? value) {
                viewModel.selectedGender = value;
                viewModel.notifyListeners();
              },
              options: [
                StringHelper.male,
                StringHelper.female,
                StringHelper.preferNotToSay,
              ],
            ),

            const Gap(20),
            Text(
              StringHelper.howToConnect,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            MultiSelectCategory(
              onSelectedCommunicationChoice: (value) {
                if (value != null) {
                  viewModel.communicationChoice = value.toString();
                }
              },
            ),
            const Gap(30),

            AppElevatedButton(
              width: MediaQuery.of(context).size.width,
              onTap: () async {
                final firstName = viewModel.nameTextController.text.trim();
                final lastName = viewModel.lastNameController.text.trim();
                final bio = viewModel.bioTextController.text.trim();

                if (firstName.isEmpty) {
                  DialogHelper.showToast(
                      message: StringHelper.pleaseEnterFirstName);
                  return;
                }

                // Length validations
                if (firstName.length > 50) {
                  DialogHelper.showToast(
                      message: StringHelper.firstNameTooLong);
                  return;
                }

                if (lastName.isNotEmpty && lastName.length > 50) {
                  DialogHelper.showToast(message: StringHelper.lastNameTooLong);
                  return;
                }

                if (bio.length > 500) {
                  DialogHelper.showToast(message: StringHelper.bioTooLong);
                  return;
                }

                if (ProfanityHelper.containsProfanity(firstName)) {
                  ProfanityHelper.showProfanityError(context);
                  return;
                }

                if (lastName.isNotEmpty &&
                    ProfanityHelper.containsProfanity(lastName)) {
                  ProfanityHelper.showProfanityError(context);
                  return;
                }

                if (bio.isNotEmpty && ProfanityHelper.containsProfanity(bio)) {
                  ProfanityHelper.showProfanityError(context);
                  return;
                }

                if (!ProfanityHelper.isAppropriateForClassifieds(firstName)) {
                  ProfanityHelper.showSpamWarning(context);
                  return;
                }

                if (lastName.isNotEmpty &&
                    !ProfanityHelper.isAppropriateForClassifieds(lastName)) {
                  ProfanityHelper.showSpamWarning(context);
                  return;
                }

                if (bio.isNotEmpty &&
                    !ProfanityHelper.isAppropriateForClassifieds(bio)) {
                  ProfanityHelper.showSpamWarning(context);
                  return;
                }

                final currentEmail = currentUser?.email ?? '';
                final newEmail = viewModel.emailTextController.text.trim();
                final newPhone = viewModel.phoneTextController.text.trim();
                final newCountryCode = viewModel.countryCode;

                final emailChanged =
                    newEmail.isNotEmpty && newEmail != currentEmail;
                final phoneChanged = newPhone != (currentUser?.phoneNo ?? '') ||
                    newCountryCode != (currentUser?.countryCode ?? '');

                if (newEmail.isNotEmpty && emailChanged) {
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(newEmail)) {
                    viewModel.emailError = StringHelper.pleaseEnterValidEmail;
                    viewModel.notifyListeners();
                    return;
                  }

                  DialogHelper.showLoading();
                  try {
                    final emailExists =
                        await viewModel.checkIfEmailExists(newEmail);
                    DialogHelper.hideLoading();

                    if (emailExists) {
                      viewModel.emailError =
                          StringHelper.emailAlreadyRegistered;
                      viewModel.notifyListeners();
                      return;
                    }
                  } catch (e) {
                    DialogHelper.hideLoading();
                    viewModel.emailError = StringHelper.unableToVerifyEmail;
                    viewModel.notifyListeners();
                    return;
                  }
                }

                if (phoneChanged) {
                  viewModel.sendVerificationPhone(
                      countryCode: newCountryCode, phone: newPhone);
                  return;
                }

                if (newEmail.isNotEmpty && emailChanged) {
                  viewModel.sendVerificationMail(email: newEmail);
                  return;
                }

                DialogHelper.showLoading();
                await viewModel.updateProfileApi();
              },
              title: StringHelper.update,
            ),

            const Gap(20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton.icon(
                onPressed: () {
                  context.push('/delete-account');
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                label: Text(
                  StringHelper.deleteAccount,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getImageUrl({required ProfileVM viewModel}) {
    if (viewModel.imagePath.isNotEmpty) {
      return viewModel.imagePath;
    }

    String url = "${DbHelper.getUserModel()?.profilePic}";

    if (url.contains('http')) {
      return url;
    }
    if (!url.contains('http')) {
      return "${ApiConstants.imageUrl}/$url";
    }
    return AssetsRes.IC_USER_ICON;
  }
}
