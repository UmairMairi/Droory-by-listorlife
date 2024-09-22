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

class EditProfileView extends BaseView<ProfileVM> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context, ProfileVM viewModel) {
    debugPrint('${DbHelper.getUserModel()?.id}');
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.editProfile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  ImageView.circle(
                    image: getImageUrl(),
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
            const Gap(20),
            AppTextField(
              title: StringHelper.firstName,
              hint: StringHelper.firstName,
              inputType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
              controller: viewModel.nameTextController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.lastName,
              hint: StringHelper.lastName,
              inputType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
              controller: viewModel.lastNameController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.email,
              hint: StringHelper.email,
              inputType: TextInputType.emailAddress,
              onTap: () {
                DialogHelper.showToast(
                    message: StringHelper.thisFieldIsNotEditable);
              },
              readOnly: true,
              inputFormatters: AppTextInputFormatters.withEmailFormatter(),
              controller: viewModel.emailTextController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.phoneNumber,
              hint: StringHelper.phoneNumber,
              onTap: () {
                DialogHelper.showToast(
                    message: StringHelper.thisFieldIsNotEditable);
              },
              readOnly: true,
              focusNode: viewModel.nodeText,
              inputType: TextInputType.phone,
              inputFormatters:
                  AppTextInputFormatters.withPhoneNumberFormatter(),
              controller: viewModel.phoneTextController,
            ),
            const Gap(20),
            AppTextField(
              title: StringHelper.bio,
              hint: StringHelper.writeHere,
              inputType: TextInputType.multiline,
              controller: viewModel.bioTextController,
              lines: 5,
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

  String getImageUrl() {
    String url = "${DbHelper.getUserModel()?.profilePic}";

    if (url.contains('http')) {
      return url;
    }
    return "${ApiConstants.imageUrl}/$url";
  }
}
