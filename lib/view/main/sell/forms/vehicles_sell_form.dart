import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';

import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';

class VehiclesSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  const VehiclesSellForm(
      {super.key,
      this.type,
      this.item,
      this.category,
      this.subSubCategory,
      this.subCategory,
      this.brands});

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return Form(
      key: viewModel.formKey,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: Colors.grey[200],
            actions: [
              KeyboardActionsItem(
                focusNode: viewModel.priceText,
              ),
              KeyboardActionsItem(
                focusNode: viewModel.yearText,
              ),
              KeyboardActionsItem(
                focusNode: viewModel.kmDrivenText,
              ),
            ]),
        child: Padding(
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
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
                children:
                    List.generate(viewModel.imagesList.length + 1, (index) {
                  if (index < viewModel.imagesList.length) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(0, 1),
                                blurRadius: 6,
                              ),
                            ],
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
                        if (viewModel.imagesList.length < 12) {
                          var image = await ImagePickerHelper.openImagePicker(
                                  context: context, isCropping: true) ??
                              '';
                          if (image.isNotEmpty) {
                            viewModel.addImage(image);
                          }
                        } else {
                          DialogHelper.showToast(
                              message: "You have reached at maximum limit");
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
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
                  hint: StringHelper.select,
                  controller: viewModel.brandTextController,
                  readOnly: true,
                  suffix: PopupMenuButton<CategoryModel>(
                    clipBehavior: Clip.hardEdge,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    onSelected: (CategoryModel value) {
                      DialogHelper.showLoading();
                      viewModel.getModels(brandId: value.id);
                      viewModel.selectedBrand = value;
                      viewModel.brandTextController.text = value.name ?? '';
                      viewModel.getModels(brandId: value.id);
                    },
                    itemBuilder: (BuildContext context) {
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
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.black,
                ),
                AppTextField(
                  title: StringHelper.models,
                  hint: StringHelper.select,
                  controller: viewModel.modelTextController,
                  readOnly: true,
                  suffix: PopupMenuButton<CategoryModel>(
                    clipBehavior: Clip.hardEdge,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    onSelected: (value) {
                      viewModel.selectedModel = value;
                      viewModel.modelTextController.text = value.name ?? '';
                    },
                    itemBuilder: (BuildContext context) {
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
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.black,
                ),
              },
              // Year Text Field
              TextFormField(
                controller: viewModel.yearTextController,
                focusNode: viewModel.yearText,
                readOnly: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),

// KM Driven Text Field
              TextFormField(
                controller: viewModel.kmDrivenTextController,
                focusNode: viewModel.kmDrivenText,
                readOnly: false,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),

              Text(
                StringHelper.itemCondition,
                style: context.textTheme.titleMedium,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      viewModel.currentIndex = 1;
                    },
                    child: Container(
                      width: 105,
                      height: 42,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: viewModel.currentIndex == 1
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5)),
                        color: viewModel.currentIndex == 1
                            ? Colors.black
                            : const Color(0xffFCFCFD),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        StringHelper.newText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: viewModel.currentIndex == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.currentIndex = 2;
                    },
                    child: Container(
                      width: 105,
                      height: 42,
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        color: viewModel.currentIndex == 2
                            ? Colors.black
                            : const Color(0xffFCFCFD),
                        border: Border.all(
                            color: viewModel.currentIndex == 2
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        StringHelper.used,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: viewModel.currentIndex == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              // Ad Title Text Field
              TextFormField(
                maxLines: 4,
                minLines: 1,
                controller: viewModel.adTitleTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

// Description Text Field
              TextFormField(
                controller: viewModel.descriptionTextController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

// Location Text Field (Read-Only)
              TextFormField(
                controller: viewModel.addressTextController,
                maxLines: 2,
                minLines: 1,
                readOnly: true,
                onTap: () async {
                  Map<String, dynamic>? value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppMapWidget()),
                  );
                  if (value != null && value.isNotEmpty) {
                    viewModel.addressTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                  }
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: StringHelper.select,
                  suffixIcon: Icon(Icons.location_on),
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

// Price Text Field
              TextFormField(
                controller: viewModel.priceTextController,
                cursorColor: Colors.black,
                focusNode: viewModel.priceText,
                decoration: InputDecoration(
                  hintText: StringHelper.enterPrice,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
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

                    if (viewModel.yearTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.yearIsRequired);
                      return;
                    }

                    if (viewModel.kmDrivenTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.kMDrivenIsRequired);
                      return;
                    }

                    if (viewModel.adTitleTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.adTitleIsRequired);
                      return;
                    }
                    if (viewModel.descriptionTextController.text
                        .trim()
                        .isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.descriptionIsRequired);
                      return;
                    }
                    if (viewModel.addressTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.locationIsRequired);
                      return;
                    }
                    if (viewModel.priceTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.priceIsRequired);
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

                    if (viewModel.yearTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.yearIsRequired);
                      return;
                    }

                    if (viewModel.kmDrivenTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.kMDrivenIsRequired);
                      return;
                    }

                    if (viewModel.adTitleTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.adTitleIsRequired);
                      return;
                    }
                    if (viewModel.descriptionTextController.text
                        .trim()
                        .isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.descriptionIsRequired);
                      return;
                    }
                    if (viewModel.addressTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.locationIsRequired);
                      return;
                    }
                    if (viewModel.priceTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.priceIsRequired);
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
      ),
    );
  }
}
