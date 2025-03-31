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
import '../../../../res/assets_res.dart';
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
  final List<CategoryModel>? sizes;
  const PetsSellForm({
    super.key,
    this.type,
    this.category,
    this.item,
    this.subSubCategory,
    this.subCategory,
    this.brands,
    this.sizes,
  });

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    // Determine if the brands dropdown should be shown
    bool showBrandDropdown = (brands?.isNotEmpty ?? false) &&
        (subSubCategory == null || ![70, 71, 73].contains(subSubCategory?.id));

    // Determine the title for the brands dropdown
    String brandTitle;
    if (subSubCategory != null && subSubCategory?.id == 73) {
      brandTitle = StringHelper.type;
    } else if (subSubCategory == null && subCategory?.id == 40) {
      brandTitle = StringHelper.type;
    } else {
      brandTitle = StringHelper.breed;
    }
    if (category?.id == 8) {
      brandTitle = StringHelper.type;
    }

    // Determine if the sizes dropdown should be shown
    bool showSizesDropdown =
        subSubCategory != null && [69, 70, 71, 73].contains(subSubCategory?.id);

    // Determine the title for the sizes dropdown
    String sizeTitle;
    if (subSubCategory?.id == 73) {
      sizeTitle = StringHelper.type;
    } else {
      sizeTitle = StringHelper.breed; // For 69, 70, 71
    }

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
          ],
        ),
        child: Padding(
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
              // Brand Dropdown with FormField validation
              if (showBrandDropdown)
                FormField<CategoryModel?>(
                  initialValue: viewModel.selectedBrand,
                  validator: (value) {
                    if (value == null) {
                      return StringHelper.fieldShouldNotBeEmpty;
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonDropdown<CategoryModel?>(
                          title: "$brandTitle *",
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
              // Size Dropdown with FormField validation
              if (showSizesDropdown)
                FutureBuilder<List<CategoryModel>>(
                  future: viewModel.getSizeOptions("${subSubCategory?.id}"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        (snapshot.data?.isNotEmpty ?? false)) {
                      return FormField<CategoryModel?>(
                        initialValue: viewModel.selectedSize,
                        validator: (value) {
                          if (value == null) {
                            return StringHelper.fieldShouldNotBeEmpty;
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonDropdown<CategoryModel?>(
                                title: "$sizeTitle *",
                                hint: viewModel.sizeTextController.text,
                                onSelected: (CategoryModel? value) {
                                  field.didChange(value);
                                  viewModel.selectedSize = value;
                                  viewModel.selectedSize = value;
                                  viewModel.sizeTextController.text =
                                      value?.name ?? '';
                                },
                                options: snapshot.data!,
                                listItemBuilder:
                                    (context, model, selected, fxn) {
                                  return Text(model?.name ?? '');
                                },
                                headerBuilder:
                                    (context, selectedItem, enabled) {
                                  return Text(selectedItem?.name ?? "");
                                },
                              ),
                              if (field.hasError)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 2),
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
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              const SizedBox(height: 25),
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
                  LengthLimitingTextInputFormatter(65),
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
                controller: viewModel.priceTextController,
                hint: StringHelper.enterPrice,
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                focusNode: viewModel.priceText,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return StringHelper.fieldShouldNotBeEmpty;
                  }
                  final amount = num.tryParse(value);
                  if (amount == null) {
                    return StringHelper.enterValidNumber;
                  }
                  if (amount < 50) {
                    return '* ${StringHelper.minValidPrice} 50';
                  }
                  if (amount > 1000000) {
                    return '* ${StringHelper.maxValidPrice} 1,000,000';
                  }
                  return null;
                },
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
                    if (viewModel.formKey.currentState?.validate() != true) {
                      return;
                    }
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
      ),
    );
  }
}
