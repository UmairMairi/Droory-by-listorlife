import 'dart:developer';

import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';

import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../../base/helpers/string_helper.dart';
import '../../base/network/api_constants.dart';
import '../../widgets/app_map_widget.dart';
import '../../widgets/multi_select_category.dart';

class EditProfileView extends BaseView<ProfileVM> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context, ProfileVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.editProfile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    ImageView.circle(
                      image: getImageUrl(viewModel: viewModel),
                      borderWidth: 1,
                      borderColor: Colors.black,
                      height: 180,
                      width: 180,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: InkWell(
                        onTap: () async {
                          viewModel.imagePath =
                              await ImagePickerHelper.openImagePicker(
                                      context: context) ??
                                  '';
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.firstName,
              hint: StringHelper.firstName,
              keyboardType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
              controller: viewModel.nameTextController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.lastName,
              hint: StringHelper.lastName,
              keyboardType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
              controller: viewModel.lastNameController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.location,
              hint: StringHelper.location,
              keyboardType: TextInputType.text,
              readOnly: true,
              onTap: () async {
                Map<String, dynamic>? value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppMapWidget()));
                print(value);
                if (value != null && value.isNotEmpty) {
                  viewModel.latitude = "${value['latitude']}";
                  viewModel.longitude = "${value['longitude']}";
                  viewModel.locationTextController.text =
                      "${value['location']}, ${value['city']}, ${value['state']}";
                }
              },
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
              controller: viewModel.locationTextController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.email,
              hint: StringHelper.email,
              keyboardType: TextInputType.emailAddress,
              readOnly: false,
              inputFormatters: AppTextInputFormatters.withEmailFormatter(),
              controller: viewModel.emailTextController,
              suffix: viewModel.isEmailVerified
                  ? Icon(
                      Icons.verified,
                      color: Colors.green,
                    )
                  : TextButton(
                      onPressed: () {
                        viewModel.sendVerificationMail(
                            email: viewModel.emailTextController.text);
                      },
                      child: Text(
                        'Verify',
                        style: context.titleSmall?.copyWith(color: Colors.blue),
                      )),
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.phoneNumber,
              hint: StringHelper.phoneNumber,
              readOnly: false,
              onChanged: (value) {
                if (value != DbHelper.getUserModel()?.phoneNo) {
                  viewModel.isPhoneVerified =
                      DbHelper.getUserModel()?.phoneVerified != 0 &&
                          DbHelper.getUserModel()?.phoneNo == value;
                }
              },
              suffix: viewModel.isPhoneVerified
                  ? Icon(
                      Icons.verified,
                      color: Colors.green,
                    )
                  : TextButton(
                      onPressed: () {
                        viewModel.sendVerificationPhone(
                            phone: viewModel.phoneTextController.text);
                      },
                      child: Text(
                        'Verify',
                        style: context.titleSmall?.copyWith(color: Colors.blue),
                      )),
              prefix: CountryPicker(
                  selectedCountry: viewModel.selectedCountry,
                  dense: true,
                  isEnable: false,
                  //displays arrow, true by default
                  showLine: false,
                  showFlag: true,
                  showFlagCircle: false,
                  showDialingCode: true,
                  //displays dialing code, false by default
                  showName: false,
                  //displays Name, true by default
                  withBottomSheet: true,
                  //displays country name, true by default
                  showCurrency: false,
                  //eg. 'British pound'
                  showCurrencyISO: false,
                  onChanged: (country) => viewModel.updateCountry(country)),
              focusNode: viewModel.nodeText,
              keyboardType: TextInputType.phone,
              inputFormatters:
                  AppTextInputFormatters.withPhoneNumberFormatter(),
              controller: viewModel.phoneTextController,
            ),
            /*  const Gap(20),
            AppTextField(
              title: StringHelper.bio,
              hint: StringHelper.writeHere,
              inputType: TextInputType.multiline,
              controller: viewModel.bioTextController,
              lines: 5,
            ),*/
            const Gap(20),
            Text(
              StringHelper.howToConnect,
              style: context.textTheme.titleSmall,
            ),
            MultiSelectCategory(
              onSelectedCommunicationChoice: (CommunicationChoice value) {
                viewModel.communicationChoice = value.name;
              },
            ),
            const Gap(30),
            AppElevatedButton(
              width: context.width,
              onTap: () {
                if (viewModel.nameTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(
                      message: FormFieldErrors.firstNameRequired);
                  return;
                }
                if (viewModel.lastNameController.text.trim().isEmpty) {
                  DialogHelper.showToast(
                      message: FormFieldErrors.lastNameRequired);
                  return;
                }
                if (viewModel.emailTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(
                      message: FormFieldErrors.emailRequired);
                  return;
                }
                if (viewModel.emailTextController.text.trim().isNotEmail()) {
                  DialogHelper.showToast(message: FormFieldErrors.invalidEmail);
                  return;
                }
                DialogHelper.showLoading();
                viewModel.updateProfileApi();
              },
              title: StringHelper.update,
            ),
            const Gap(20),
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
    return "${ApiConstants.imageUrl}/$url";
  }
}
