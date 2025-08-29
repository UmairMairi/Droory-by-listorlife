import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/extensions/bool_extension.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/base/helpers/profanity_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/auth_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import 'dart:io';

import '../../base/helpers/string_helper.dart';
import '../../widgets/app_map_widget.dart';

class CompleteProfileView extends BaseView<AuthVM> {
  const CompleteProfileView({super.key});

  Widget _buildAvatarContent(AuthVM viewModel) {
    // Check for local image
    if (viewModel.imagePath.isNotEmpty) {
      final file = File(viewModel.imagePath);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: 140,
            height: 140,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderAvatar();
            },
          ),
        );
      }
    }

    // No image - show placeholder
    return _buildPlaceholderAvatar();
  }

  Widget _buildPlaceholderAvatar() {
    // For new user registration, always show person icon
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade600,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showImageOptionsBottomSheet(BuildContext context, AuthVM viewModel) {
    final hasImage = viewModel.imagePath.isNotEmpty;

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
                            viewModel.imagePath = '';
                            DialogHelper.showToast(
                                message: StringHelper.photoRemoved);
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
  Widget build(BuildContext context, AuthVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringHelper.completeYourProfile,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ImagePickerHelper.isLoading
                  ? Container(
                      height: 140,
                      width: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
                        color: Colors.grey.shade200,
                      ),
                      child: const CupertinoActivityIndicator(),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                          ),
                          child: _buildAvatarContent(viewModel),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () => _showImageOptionsBottomSheet(
                                context, viewModel),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
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
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const Gap(50),

            // First Name
            AppTextField(
              title: StringHelper.firstName,
              hint: StringHelper.enter,
              keyboardType: TextInputType.name,
              controller: viewModel.nameTextController,
              maxLength: 50,
            ),
            const Gap(10),

            // Last Name - Now Optional
            AppTextField(
              title: "${StringHelper.lastName} ${StringHelper.optionalField}",
              hint: StringHelper.enter,
              keyboardType: TextInputType.name,
              controller: viewModel.lNameTextController,
              isMandatory: false,
              validator: (value) => null,
              maxLength: 50,
            ),
            const Gap(10),

            // Bio Field
            AppTextField(
              title: StringHelper.bio,
              hint: StringHelper.writeHere,
              keyboardType: TextInputType.multiline,
              controller: viewModel.bioTextController,
              maxLines: 5,
              minLines: 5,
              maxLength: 500,
            ),
            const Gap(10),

            // Gender Selection
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
            const Gap(10),

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

            // Terms and Conditions
            Row(
              children: [
                Checkbox(
                  value: viewModel.agreedToTerms,
                  onChanged: (bool? value) {
                    viewModel.agreedToTerms = value ?? false;
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: StringHelper.iAgreeWithThe,
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: StringHelper.termsConditions,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(Routes.termsOfUse, extra: 2);
                                },
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ))
                        ]),
                  ),
                ),
              ],
            ),
            const Gap(20),

            // Continue Button with all validations
            AppElevatedButton(
              width: MediaQuery.of(context).size.width,
              onTap: () async {
                final firstName = viewModel.nameTextController.text.trim();
                final lastName = viewModel.lNameTextController.text.trim();
                final bio = viewModel.bioTextController.text.trim();

                // Only first name is required now
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

                // Profanity checks
                if (ProfanityHelper.containsProfanity(firstName)) {
                  ProfanityHelper.showProfanityError(context);
                  return;
                }

                // Only check last name if it's provided
                if (lastName.isNotEmpty &&
                    ProfanityHelper.containsProfanity(lastName)) {
                  ProfanityHelper.showProfanityError(context);
                  return;
                }

                if (bio.isNotEmpty && ProfanityHelper.containsProfanity(bio)) {
                  ProfanityHelper.showProfanityError(context);
                  return;
                }

                // Check for spam-like content
                if (!ProfanityHelper.isAppropriateForClassifieds(firstName)) {
                  ProfanityHelper.showSpamWarning(context);
                  return;
                }

                // Only check last name if it's provided
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

                // Terms validation
                if (viewModel.agreedToTerms.isFalse) {
                  DialogHelper.showToast(
                      message: StringHelper.pleaseAcceptTerms);
                  return;
                }

                // All validations passed - proceed with registration
                viewModel.completeProfileApi();
              },
              title: StringHelper.continueButton,
            )
          ],
        ),
      ),
    );
  }
}
