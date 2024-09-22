import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/extensions/bool_extension.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/auth_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../../base/helpers/string_helper.dart';

class CompleteProfileView extends BaseView<AuthVM> {
  const CompleteProfileView({super.key});

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
                        border: Border.all(color: Colors.black, width: 1),
                        color: const Color(0xfff5f5f5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 0.1, // Spread radius
                            blurRadius: 0.1, // Blur radius
                            offset: const Offset(0, 0.1), // Offset from the top
                          ),
                        ],
                      ),
                      child: const CupertinoActivityIndicator(),
                    )
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ImageView.circle(
                          image: viewModel.imagePath,
                          height: 140,
                          width: 140,
                          borderColor: Colors.black,
                          borderWidth: 2,
                          placeholder: AssetsRes.IC_PROFILE,
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    viewModel.pickImage();
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: context.theme.cardColor,
                                  )),
                            )),
                      ],
                    ),
            ),
            const Gap(50),
            AppTextField(
              title: StringHelper.firstName,
              hint: StringHelper.enter,
              inputType: TextInputType.name,
              controller: viewModel.nameTextController,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
            ),
            const Gap(10),
            AppTextField(
              title: StringHelper.lastName,
              hint: StringHelper.enter,
              inputType: TextInputType.name,
              controller: viewModel.lNameTextController,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
            ),
            const Gap(10),
            AppTextField(
              title: StringHelper.email,
              hint: StringHelper.enter,
              inputType: TextInputType.emailAddress,
              controller: viewModel.emailTextController,
              inputFormatters: AppTextInputFormatters.withEmailFormatter(),
            ),
            const Gap(10),
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
            const Gap(50),
            AppElevatedButton(
              width: context.width,
              onTap: () {
                /*  if (viewModel.imagePath.isEmpty) {
                  DialogHelper.showToast(
                      message: FormFieldErrors.profilePicRequired);
                  return;
                }*/
                if (viewModel.nameTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(
                      message: FormFieldErrors.firstNameRequired);
                  return;
                }
                if (viewModel.lNameTextController.text.trim().isEmpty) {
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
                if (viewModel.agreedToTerms.isFalse) {
                  DialogHelper.showToast(
                      message: FormFieldErrors.acceptTermsRequired);
                  return;
                }

                DialogHelper.showLoading();
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
