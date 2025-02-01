import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';

import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/common_dropdown.dart';
import '../../../../widgets/image_view.dart';

class PetsSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  const PetsSellForm(
      {super.key,
      this.type,
      this.category,
      this.item,
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
                        if (viewModel.imagesList.length < 10) {
                          var image = await ImagePickerHelper.openImagePicker(
                                  context: context, isCropping: true) ??
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
              if (brands?.isNotEmpty ?? false)
                CommonDropdown<CategoryModel?>(
                  title: StringHelper.breed,
                  hint: viewModel.brandTextController.text,
                  listItemBuilder: (context,model,selected,fxn){
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name??"");
                  },
                  options: brands??[],
                  onSelected: (CategoryModel? value) {
                    DialogHelper.showLoading();
                    viewModel.getModels(brandId: value?.id);
                    viewModel.selectedBrand = value;
                    viewModel.brandTextController.text = value?.name ?? '';
                  },
                  // readOnly: true,
                  // suffix: PopupMenuButton(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (CategoryModel value) {
                  //     DialogHelper.showLoading();
                  //     viewModel.getModels(brandId: value.id);
                  //     viewModel.selectedBrand = value;
                  //     viewModel.brandTextController.text = value.name ?? '';
                  //     viewModel.getModels(brandId: value.id);
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return brands!.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option.name ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // hint: StringHelper.select,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //       RegExp(viewModel.regexToRemoveEmoji)),
                  // ],
                ),

              const SizedBox(
                height: 25,
              ),
              // Ad Title
              AppTextField(
                title: StringHelper.adTitle,
                hint: StringHelper.enter,
                controller: viewModel.adTitleTextController,
                maxLines: 4,
                minLines: 1,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                elevation: 6,
              ),

              // Description
              AppTextField(
                title: StringHelper.describeWhatYouAreSelling,
                hint: StringHelper.enter,
                controller: viewModel.descriptionTextController,
                maxLines: 4,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                fillColor: Colors.white,
                elevation: 6,
              ),

              // Location
              AppTextField(
                title: StringHelper.location,
                hint: StringHelper.select,
                controller: viewModel.addressTextController,
                maxLines: 2,
                minLines: 1,
                readOnly: true,
                suffix: const Icon(Icons.location_on),
                onTap: () async {
                  Map<String, dynamic>? value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppMapWidget(),
                    ),
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                fillColor: Colors.white,
                elevation: 6,
              ),

              // Price
              AppTextField(
                title: StringHelper.priceEgp,
                hint: StringHelper.enterPrice,
                controller: viewModel.priceTextController,
                focusNode: viewModel.priceText,
                maxLength: 8,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                fillColor: Colors.white,
                elevation: 6,
              ),

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
