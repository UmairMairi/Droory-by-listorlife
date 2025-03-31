import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/image_view.dart';

class JobSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  const JobSellForm({
    required this.type,
    required this.category,
    required this.subCategory,
    this.subSubCategory,
    this.item,
    required this.brands,
    super.key,
  });

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return Form(
      key: viewModel.formKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.uploadImages,
              style: context.textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () async {
                  viewModel.mainImagePath =
                      await ImagePickerHelper.openImagePicker(
                            context: context,
                            isCropping: true,
                          ) ??
                          '';
                },
                child: ImageView.rect(
                  image: viewModel.mainImagePath,
                  borderRadius: 10,
                  width: context.width,
                  placeholder: AssetsRes.IC_CAMERA,
                  height: 220,
                ),
              ),
            ),
            Wrap(
              children: List.generate(viewModel.imagesList.length + 1, (index) {
                if (index < viewModel.imagesList.length) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: 100,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ImageView.rect(
                          image: viewModel.imagesList[index].media ?? '',
                          height: 80,
                          width: 120,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            viewModel.removeImage(index,
                                data: viewModel.imagesList[index]);
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      if (viewModel.imagesList.length < 10) {
                        var image = await ImagePickerHelper.openImagePicker(
                              context: context,
                              isCropping: true,
                            ) ??
                            '';
                        if (image.isNotEmpty) {
                          viewModel.addImage(image);
                        }
                      } else {
                        DialogHelper.showToast(
                            message: StringHelper.imageMaxLimit);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(height: 2),
                          Text(
                            StringHelper.add,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),
            const SizedBox(height: 12), // Added spacing

            // Looking For Dropdown (Required)
            FormField<String?>(
              initialValue: viewModel.lookingForController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonDropdown(
                      title: "${StringHelper.lookingFor} *", // Added asterisk
                      hint: viewModel.lookingForController.text,
                      onSelected: (String? value) {
                        field.didChange(value);
                        field.validate(); // Revalidate to clear error
                        viewModel.lookingForController.text = value ?? '';
                      },
                      options: [
                        StringHelper.lookingJob,
                        StringHelper.hiringJob
                      ],
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10), // Added spacing

            // Specialty Dropdown (Required if available)
            if (brands?.isNotEmpty ?? false)
              FormField<CategoryModel?>(
                initialValue: viewModel.selectedBrand,
                validator: (value) {
                  if (value == null) {
                    return 'This field is required';
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonDropdown<CategoryModel?>(
                        title: "${StringHelper.specialty} *", // Added asterisk
                        hint: viewModel.brandTextController.text,
                        listItemBuilder: (context, model, selected, fxn) {
                          return Text(model?.name ?? '');
                        },
                        headerBuilder: (context, selectedItem, enabled) {
                          return Text(selectedItem?.name ?? "");
                        },
                        options: brands ?? [],
                        onSelected: (CategoryModel? value) {
                          field.didChange(value);
                          field.validate(); // Revalidate to clear error
                          DialogHelper.showLoading();
                          viewModel.getModels(brandId: value?.id);
                          viewModel.selectedBrand = value;
                          viewModel.brandTextController.text =
                              value?.name ?? '';
                        },
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 2),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 12), // Added spacing

            // Position Type Dropdown (Required)
            FormField<String?>(
              initialValue: viewModel.jobPositionTextController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonDropdown(
                      title: "${StringHelper.positionType} *", // Added asterisk
                      hint: viewModel.jobPositionTextController.text,
                      onSelected: (String? value) {
                        field.didChange(value);
                        field.validate(); // Revalidate to clear error
                        viewModel.jobPositionTextController.text = value ?? "";
                      },
                      options: viewModel.jobPositionList,
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16), // Added spacing

            // Salary Period Dropdown
            CommonDropdown(
              title: StringHelper.salaryPeriod,
              hint: viewModel.jobSalaryTextController.text,
              onSelected: (String? value) {
                viewModel.jobSalaryTextController.text = value ?? "";
              },
              options: viewModel.salaryPeriodList,
            ),
            const SizedBox(height: 16), // Added spacing

            // Work Setting Dropdown
            CommonDropdown(
              title: StringHelper.workSetting,
              hint: viewModel.workSettingTextController.text.isEmpty
                  ? ""
                  : viewModel.workSettingTextController.text,
              onSelected: (String? value) {
                viewModel.workSettingTextController.text = value ?? "";
              },
              options: viewModel.workSettingOptions,
            ),
            const SizedBox(height: 12), // Added spacing

            // Work Experience Dropdown (Required)
            FormField<String?>(
              initialValue: viewModel.workExperienceTextController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonDropdown(
                      title:
                          "${StringHelper.workExperience} *", // Added asterisk
                      hint: viewModel.workExperienceTextController.text.isEmpty
                          ? ""
                          : viewModel.workExperienceTextController.text,
                      onSelected: (String? value) {
                        field.didChange(value);
                        field.validate(); // Revalidate to clear error
                        viewModel.workExperienceTextController.text =
                            value ?? "";
                      },
                      options: viewModel.experienceOptions,
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12), // Added spacing

            // Work Education Dropdown (Required)
            FormField<String?>(
              initialValue: viewModel.workEducationTextController.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonDropdown(
                      title:
                          "${StringHelper.workEducation} *", // Added asterisk
                      hint: viewModel.workEducationTextController.text.isEmpty
                          ? ""
                          : viewModel.workEducationTextController.text,
                      onSelected: (String? value) {
                        field.didChange(value);
                        field.validate(); // Revalidate to clear error
                        viewModel.workEducationTextController.text =
                            value ?? "";
                      },
                      options: viewModel.workEducationOptions,
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 2),
                        child: Text(
                          field.errorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12), // Added spacing

            // Salary From Field
            AppTextField(
              title: StringHelper.salaryFrom,
              hint: StringHelper.enter,
              controller: viewModel.jobSalaryFromController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),
            const SizedBox(height: 12), // Added spacing

            // Salary To Field
            AppTextField(
              title: StringHelper.salaryTo,
              hint: StringHelper.enter,
              controller: viewModel.jobSalaryToController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),
            const SizedBox(height: 12), // Added spacing

            // Ad Title Field
            AppTextField(
              title: StringHelper.adTitle,
              hint: StringHelper.enter,
              controller: viewModel.adTitleTextController,
              minLines: 1,
              maxLines: 4,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
                LengthLimitingTextInputFormatter(65),
              ],
            ),
            const SizedBox(height: 12), // Added spacing

            // Description Field
            AppTextField(
              title: StringHelper.describeWhatYouAreSelling,
              hint: StringHelper.enter,
              controller: viewModel.descriptionTextController,
              maxLines: 4,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),
            const SizedBox(height: 12), // Added spacing

            // Location Field
            AppTextField(
              title: StringHelper.location,
              hint: StringHelper.select,
              readOnly: true,
              controller: viewModel.addressTextController,
              suffix: const Icon(Icons.location_on),
              onTap: () async {
                Map<String, dynamic>? value = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppMapWidget()),
                );
                if (value != null && value.isNotEmpty) {
                  String address = "";
                  if ("${value['location'] ?? ""}".isNotEmpty) {
                    address = "${value['location'] ?? ""}";
                  }
                  if ("${value['city'] ?? ""}".isNotEmpty) {
                    address += ", ${value['city'] ?? ""}";
                  }
                  if ("${value['state'] ?? ""}".isNotEmpty) {
                    address += ", ${value['state'] ?? ""}";
                  }
                  viewModel.addressTextController.text = address;
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
              maxLines: 2,
            ),
            const SizedBox(height: 12), // Added spacing

            Text(
              StringHelper.howToConnect,
              style: context.textTheme.titleSmall,
            ),
            MultiSelectCategory(
              choiceString: viewModel.communicationChoice,
              onSelectedCommunicationChoice: (CommunicationChoice value) {
                viewModel.communicationChoice = value.name;
              },
            ),
            const SizedBox(height: 12), // Added spacing

            if (viewModel.isEditProduct) ...{
              GestureDetector(
                onTap: () {
                  if (viewModel.formKey.currentState?.validate() != true) {
                    return;
                  }
                  if (viewModel.jobSalaryFromController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryForm);
                    return;
                  }
                  if (viewModel.adTitleTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.adTitleIsRequired);
                    return;
                  }
                  if (viewModel.adTitleTextController.text.trim().length < 10) {
                    DialogHelper.showToast(
                      message: StringHelper.adLength,
                    );
                    return;
                  }
                  if (viewModel.descriptionTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.descriptionIsRequired);
                    return;
                  }
                  if (viewModel.addressTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.locationIsRequired);
                    return;
                  }
                  DialogHelper.showLoading();
                  viewModel.editProduct(
                    productId: item?.id,
                    category: category,
                    subCategory: subCategory,
                    subSubCategory: subSubCategory,
                    brand: viewModel.selectedBrand,
                    models: viewModel.selectedModel,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    viewModel.adStatus == "deactivate"
                        ? StringHelper.updateRepublish
                        : StringHelper.updateNow,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            } else ...{
              GestureDetector(
                onTap: () {
                  if (viewModel.formKey.currentState?.validate() != true) {
                    return;
                  }
                  if (viewModel.jobSalaryFromController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryForm);
                    return;
                  }
                  if (viewModel.adTitleTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.adTitleIsRequired);
                    return;
                  }
                  if (viewModel.adTitleTextController.text.trim().length < 10) {
                    DialogHelper.showToast(
                      message: StringHelper.adLength,
                    );
                    return;
                  }
                  if (viewModel.descriptionTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.descriptionIsRequired);
                    return;
                  }
                  if (viewModel.addressTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.locationIsRequired);
                    return;
                  }
                  DialogHelper.showLoading();
                  viewModel.addProduct(
                    category: category,
                    subCategory: subCategory,
                    subSubCategory: subSubCategory,
                    brand: viewModel.selectedBrand,
                    models: viewModel.selectedModel,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    StringHelper.postNow,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            },
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
