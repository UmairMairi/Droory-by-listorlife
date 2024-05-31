import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/helpers/image_picker_helper.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:permission_handler/permission_handler.dart';

class CompleteProfileView extends BaseView<ProfileVM> {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context, ProfileVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complete your Profile',
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
                      height: 120,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                        viewModel.imagePath.isEmpty
                            ? const ImageView.circle(
                                image: '',
                                height: 140,
                                width: 140,
                              )
                            : CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    FileImage(File(viewModel.imagePath)),
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
              title: 'First Name',
              hint: 'Enter',
              inputType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
            ),
            const Gap(10),
            AppTextField(
              title: 'Last Name',
              hint: 'Enter',
              inputType: TextInputType.name,
              inputFormatters: AppTextInputFormatters.withNameFormatter(),
            ),
            const Gap(10),
            AppTextField(
              title: 'Email',
              hint: 'Enter',
              inputType: TextInputType.emailAddress,
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
                        text: 'I agree with the ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Terms & Conditions.',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(Routes.termsOfUse);
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
                showDialog(
                    context: context,
                    builder: (context) {
                      return AppAlertDialogWithLottie(
                        title: 'Complete Profile',
                        onTap: () async {
                          context.pop();
                          if (await Permission.location.isGranted) {
                            if (context.mounted) context.go(Routes.main);
                          } else {
                            if (context.mounted) context.go(Routes.permission);
                          }
                        },
                        description:
                            'Your Profile has been created successfully!',
                      );
                    });
              },
              title: 'Continue',
            )
          ],
        ),
      ),
    );
  }
}
