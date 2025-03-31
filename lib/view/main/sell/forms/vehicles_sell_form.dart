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
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/common_dropdown.dart';

class VehiclesSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;

  const VehiclesSellForm({
    super.key,
    this.type,
    this.item,
    this.category,
    this.subSubCategory,
    this.subCategory,
    this.brands,
  });

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return Form(
      key: viewModel.formKey,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          keyboardBarColor: Colors.grey[200],
          actions: [
            KeyboardActionsItem(focusNode: viewModel.priceText),
            KeyboardActionsItem(focusNode: viewModel.yearText),
            KeyboardActionsItem(focusNode: viewModel.kmDrivenText),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Picture Section (unchanged)
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
                            child: const Icon(Icons.cancel, color: Colors.red),
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
                          if (image.isNotEmpty) viewModel.addImage(image);
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

              // Brand Field (required when shown)
              if (brands?.isNotEmpty ?? false) ...{
                if ([26, 27, 95, 97, 98, 99].contains(subCategory?.id)) ...{
                  FormField<CategoryModel?>(
                    initialValue: viewModel.selectedBrand,
                    validator: (value) {
                      if (value == null) {
                        return "* ${StringHelper.fieldShouldNotBeEmpty}";
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonDropdown<CategoryModel?>(
                            title: [98, 99].contains(subCategory?.id)
                                ? "${StringHelper.brand} *"
                                : "${StringHelper.type} *",
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
                              field.validate();
                              viewModel.selectedBrand = value;
                              viewModel.brandTextController.text =
                                  value?.name ?? '';
                            },
                          ),
                          if (field.hasError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(
                                  color: Color.fromARGB(
                                      255, 146, 47, 40), // Updated color
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                },
              },

              // Year Field (required when shown)
              if ([26, 98].contains(subCategory?.id)) ...{
                FormField<String?>(
                  initialValue: viewModel.yearTextController.text.isNotEmpty
                      ? viewModel.yearTextController.text
                      : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '* ${StringHelper.fieldShouldNotBeEmpty}';
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonDropdown<String?>(
                          title: "${StringHelper.year} *",
                          titleColor: Colors.black,
                          hint: viewModel.yearTextController.text,
                          onSelected: (String? value) {
                            field.didChange(value);
                            field.validate();
                            viewModel.yearTextController.text = value ?? '';
                          },
                          options: viewModel.yearsType,
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 2),
                            child: Text(
                              field.errorText!,
                              style: const TextStyle(
                                color: Color.fromARGB(
                                    255, 146, 47, 40), // Updated color
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              },

              // KM Driven Field (required when shown)
              if ([26, 98].contains(subCategory?.id)) ...{
                AppTextField(
                  title: "${StringHelper.kmDriven} *",
                  titleColor: Colors.black,
                  controller: viewModel.kmDrivenTextController,
                  focusNode: viewModel.kmDrivenText,
                  readOnly: false,
                  hint: StringHelper.enter,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 20),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji),
                    ),
                  ],
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '* Please enter KM driven';
                    }
                    final km = num.tryParse(value);
                    if (km == null) {
                      return '* Please enter a valid number';
                    }
                    if (km < 0) {
                      return '* KM driven cannot be negative';
                    }
                    if (km > 1000000) {
                      return '* KM driven cannot exceed 1000000';
                    }
                    return null;
                  },
                ),
              },

              // Item Condition (unchanged)
              Text(
                StringHelper.itemCondition,
                style: context.textTheme.titleMedium,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => viewModel.itemCondition = 1,
                    child: Container(
                      width: 105,
                      height: 42,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: viewModel.itemCondition == 1
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5),
                        ),
                        color: viewModel.itemCondition == 1
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
                            color: viewModel.itemCondition == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => viewModel.itemCondition = 2,
                    child: Container(
                      width: 105,
                      height: 42,
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        color: viewModel.itemCondition == 2
                            ? Colors.black
                            : const Color(0xffFCFCFD),
                        border: Border.all(
                          color: viewModel.itemCondition == 2
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          StringHelper.used,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: viewModel.itemCondition == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Ad Title (unchanged)
              AppTextField(
                title: StringHelper.adTitle,
                hint: StringHelper.enter,
                controller: viewModel.adTitleTextController,
                maxLines: 4,
                minLines: 1,
                cursorColor: Colors.black,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                  LengthLimitingTextInputFormatter(65),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

              // Description (unchanged)
              AppTextField(
                title: StringHelper.describeWhatYouAreSelling,
                hint: StringHelper.enter,
                controller: viewModel.descriptionTextController,
                maxLines: 4,
                cursorColor: Colors.black,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

              // Location (unchanged)
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
                        builder: (context) => const AppMapWidget()),
                  );
                  if (value != null && value.isNotEmpty) {
                    String address = "";
                    if ("${value['location'] ?? ""}".isNotEmpty)
                      address = "${value['location'] ?? ""}";
                    if ("${value['city'] ?? ""}".isNotEmpty)
                      address += ", ${value['city'] ?? ""}";
                    if ("${value['state'] ?? ""}".isNotEmpty)
                      address += ", ${value['state'] ?? ""}";
                    viewModel.addressTextController.text = address;
                  }
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                fillColor: Colors.white,
                elevation: 6,
              ),

              // Price (unchanged)
              AppTextField(
                title: StringHelper.priceEgp,
                controller: viewModel.priceTextController,
                hint: StringHelper.enterPrice,
                maxLength: 9,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(9),
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: viewModel.priceText,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return '* ${StringHelper.fieldShouldNotBeEmpty}';
                  final amount = num.tryParse(value);
                  if (amount == null)
                    return '* ${StringHelper.enterValidEmail}';
                  if (amount < 50) return '* ${StringHelper.minValidPrice} 50';
                  if ([26, 27].contains(subCategory?.id)) {
                    if (amount > 150000000)
                      return '* ${StringHelper.maxValidPrice}150,000,000';
                  } else if ([95, 97].contains(subCategory?.id)) {
                    if (amount > 400000)
                      return '* ${StringHelper.maxValidPrice} 400,000';
                  } else {
                    if (amount > 3000000)
                      return '* ${StringHelper.maxValidPrice} 3,000,000';
                  }
                  return null;
                },
              ),

              // How to Connect (unchanged)
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

              // Submit Button (unchanged)
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
                    if (viewModel.adTitleTextController.text.trim().length <
                        10) {
                      DialogHelper.showToast(message: StringHelper.adLength);
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
                    if (viewModel.adTitleTextController.text.trim().length <
                        10) {
                      DialogHelper.showToast(message: StringHelper.adLength);
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
      ),
    );
  }
}
