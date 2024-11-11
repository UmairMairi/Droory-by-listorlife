import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';

import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/prodect_detail_model.dart';
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
  const JobSellForm(
      {required this.type,
      required this.category,
      required this.subCategory,
      this.subSubCategory,
      this.item,
      required this.brands,
      super.key});

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
            GestureDetector(
              onTap: () async {
                viewModel.mainImagePath =
                    await ImagePickerHelper.openImagePicker(
                            context: context, isCropping: true) ??
                        '';
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: viewModel.mainImagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(viewModel.mainImagePath),
                          fit: BoxFit.contain,
                        ))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            StringHelper.upload,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ImageView.rect(
                            image: viewModel.imagesList[index].media ?? '',
                            fit: BoxFit.contain,
                            height: 80,
                            width: 100,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
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
                      )
                    ],
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      var image = await ImagePickerHelper.openImagePicker(
                              context: context, isCropping: true) ??
                          '';
                      if (image.isNotEmpty) {
                        viewModel.addImage(image);
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
                          Icon(Icons.add),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            StringHelper.add,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
            ),
            if (brands?.isNotEmpty ?? false) ...{
              AppTextField(
                title: StringHelper.brand,
                controller: viewModel.brandTextController,
                hint: StringHelper.select,
                readOnly: true,
                suffix: PopupMenuButton<CategoryModel>(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  onSelected: (CategoryModel value) {
                    DialogHelper.showLoading();
                    viewModel.selectedBrand = value;
                    viewModel.brandTextController.text = value.name ?? '';
                    viewModel.getModels(brandId: value.id);
                  },
                  itemBuilder: (context) {
                    return brands!.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option.name ?? ''),
                      );
                    }).toList();
                  },
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
              ),

              // Model Dropdown Field
              AppTextField(
                title: StringHelper.models,
                controller: viewModel.modelTextController,
                hint: StringHelper.models,
                readOnly: true,
                suffix: PopupMenuButton<CategoryModel>(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  onSelected: (value) {
                    viewModel.selectedModel = value;
                    viewModel.modelTextController.text = value.name ?? '';
                  },
                  itemBuilder: (context) {
                    return viewModel.allModels.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option?.name ?? ''),
                      );
                    }).toList();
                  },
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
              ),
            },
            // Job Position Dropdown
            AppTextField(
              title: StringHelper.positionType,
              hint: StringHelper.select,
              readOnly: true,
              controller: viewModel.jobPositionTextController,
              suffix: PopupMenuButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                onSelected: (String value) {
                  viewModel.jobPositionTextController.text = value;
                },
                itemBuilder: (context) {
                  return viewModel.jobPositionList.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

            // Salary Period Dropdown
            AppTextField(
              title: StringHelper.salaryPeriod,
              hint: StringHelper.select,
              readOnly: true,
              controller: viewModel.jobSalaryTextController,
              suffix: PopupMenuButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                onSelected: (String value) {
                  viewModel.jobSalaryTextController.text = value;
                },
                itemBuilder: (context) {
                  return viewModel.salaryPeriodList.map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

            // Salary From Field
            AppTextField(
              title: StringHelper.salaryFrom,
              hint: StringHelper.enter,
              controller: viewModel.jobSalaryFromController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

            // Salary To Field
            AppTextField(
              title: StringHelper.salaryTo,
              hint: StringHelper.enter,
              controller: viewModel.jobSalaryToController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

            // Ad Title Field
            AppTextField(
              title: StringHelper.adTitle,
              hint: StringHelper.enter,
              controller: viewModel.adTitleTextController,
              maxLines: 4,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

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
                  viewModel.addressTextController.text =
                      "${value['location']}, ${value['city']}, ${value['state']}";
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
              maxLines: 2,
            ),
            Text(
              StringHelper.howToConnect,
              style: context.textTheme.titleSmall,
            ),
            MultiSelectCategory(
              onSelectedCommunicationChoice: (CommunicationChoice value) {
                viewModel.communicationChoice = value.name;
              },
            ),
            if (viewModel.isEditProduct) ...{
              GestureDetector(
                onTap: () {
                  viewModel.formKey.currentState?.validate();

                  if (viewModel.mainImagePath.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadMainImage);
                    return;
                  }
                  if (viewModel.imagesList.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadAddAtLeastOneImage);
                    return;
                  }
                  if (viewModel.jobPositionTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleasesSelectPositionType);
                    return;
                  }
                  if (viewModel.jobSalaryTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryPeriod);
                    return;
                  }
                  if (viewModel.jobSalaryFromController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryForm);
                    return;
                  }

                  if (viewModel.jobSalaryToController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryTo);
                    return;
                  }

                  if (viewModel.adTitleTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.adTitleIsRequired);
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
                      models: viewModel.selectedModel);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    StringHelper.updateNow,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            } else ...{
              GestureDetector(
                onTap: () {
                  viewModel.formKey.currentState?.validate();

                  if (viewModel.mainImagePath.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadMainImage);
                    return;
                  }
                  if (viewModel.imagesList.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadAddAtLeastOneImage);
                    return;
                  }
                  if (viewModel.jobPositionTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleasesSelectPositionType);
                    return;
                  }
                  if (viewModel.jobSalaryTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryPeriod);
                    return;
                  }
                  if (viewModel.jobSalaryFromController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryForm);
                    return;
                  }

                  if (viewModel.jobSalaryToController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseSelectSalaryTo);
                    return;
                  }

                  if (viewModel.adTitleTextController.text.trim().isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.adTitleIsRequired);
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
                      models: viewModel.selectedModel);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    StringHelper.postNow,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            },
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
