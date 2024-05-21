import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/image_picker_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';

class EditProfile extends BaseView<ProfileVM> {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context, ProfileVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                    viewModel.imagePath.isEmpty
                        ? Image.asset(
                            AssetsRes.DUMMY_PROFILE,
                            fit: BoxFit.fill,
                            height: 250,
                            width: context.width,
                          )
                        : Image.file(
                            File(viewModel.imagePath),
                            fit: BoxFit.fill,
                            height: 250,
                            width: context.width,
                          ),
                    Positioned(
                      bottom: 10,
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
                title: 'Full Name',
                hint: 'Full Name',
                inputType: TextInputType.name,
                inputFormatters: AppTextInputFormatters.withNameFormatter(),
                controller: viewModel.nameTextController,
              ),
              const Gap(20),
              AppTextField(
                title: 'Email',
                hint: 'Email',
                inputType: TextInputType.emailAddress,
                inputFormatters: AppTextInputFormatters.withEmailFormatter(),
                controller: viewModel.emailTextController,
              ),
              const Gap(20),
              AppTextField(
                title: 'Phone Number',
                hint: 'Phone Number',
                inputType: TextInputType.phone,
                inputFormatters:
                    AppTextInputFormatters.withPhoneNumberFormatter(),
                controller: viewModel.phoneTextController,
              ),
              const Gap(20),
              AppTextField(
                title: 'Bio',
                hint: 'Write here...',
                inputType: TextInputType.multiline,
                controller: viewModel.bioTextController,
                lines: 5,
              ),
              const Gap(30),
              AppElevatedButton(
                width: context.width,
                onTap: () {
                  context.pop();
                },
                title: 'Update',
              ),
              const Gap(20),
            ],
          )),
    );
  }
}
