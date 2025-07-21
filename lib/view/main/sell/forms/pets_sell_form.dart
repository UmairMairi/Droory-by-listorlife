import 'dart:io'; // Kept for consistency, though not directly used.
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
// import '../../../../widgets/app_map_widget.dart'; // Not directly used here
import '../../../../widgets/common_dropdown.dart';
import '../../../../widgets/image_view.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import 'package:list_and_life/widgets/phone_form_verification_widget.dart'; // Added for phone verification

class PetsSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  final List<CategoryModel>? sizes; // sizes is part of PetsSellForm constructor

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

  // Helper method for form submission
  void _handleSubmit(BuildContext context, SellFormsVM viewModel) {
    // Phone verification check
    if (!viewModel.isPhoneVerified ||
        viewModel.currentPhone == null ||
        viewModel.currentPhone!.isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }

    // Validate FormFields (Brand/Size dropdowns, AdTitle, Description, Location, Price)
    if (viewModel.formKey.currentState?.validate() != true) {
      // Validators in FormFields will show their specific messages
      return;
    }

    // Imperative checks for fields not covered by FormField validators or complex conditions
    if (this.category?.id != 8) {
      // Image checks only if not category 8 (Services)
      if (viewModel.mainImagePath.isEmpty) {
        DialogHelper.showToast(message: StringHelper.pleaseUploadMainImage);
        return;
      }
      if (viewModel.imagesList.isEmpty) {
        DialogHelper.showToast(
            message: StringHelper.pleaseUploadAddAtLeastOneImage);
        return;
      }
    }

    DialogHelper.showLoading();

    if (viewModel.isEditProduct) {
      if (this.item?.id == null) {
        DialogHelper.hideLoading();
        DialogHelper.showToast(message: "Error: No product ID found");
        return;
      }

      viewModel.editProduct(
        productId: this.item!.id,
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        models: viewModel.selectedModel,
        onSuccess: () {
          Navigator.pop(context, true);
        },
      );
    } else {
      viewModel.addProduct(
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        models: viewModel.selectedModel,
      );
    }
  }

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    if (item != null && !viewModel.hasInitializedForEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateTextFieldsItems(item: item);
        viewModel.hasInitializedForEdit = true;
      });
    }
    // Determine if the brands dropdown should be shown
    bool showBrandDropdown = (brands?.isNotEmpty ?? false) &&
        (subSubCategory == null || ![70, 71, 73].contains(subSubCategory?.id));

    // Determine the title for the brands dropdown
    String brandTitle;
    if (subSubCategory != null && subSubCategory?.id == 73) {
      // Pet Accessories -> Type
      brandTitle = StringHelper.type;
    } else if (subSubCategory == null && subCategory?.id == 40) {
      // Other Pets -> Type
      brandTitle = StringHelper.type;
    } else if (category?.id == 8) {
      // Services -> Type
      brandTitle = StringHelper.type;
    } else {
      // Dogs, Cats, Birds, etc. -> Breed
      brandTitle = StringHelper.type;
    }

    // Determine if the sizes dropdown should be shown
    bool showSizesDropdown =
        subSubCategory != null && [69, 70, 71, 73].contains(subSubCategory?.id);

    // Determine the title for the sizes dropdown
    String sizeTitle;
    if (subSubCategory?.id == 73) {
      // Pet Accessories -> Type (e.g., for food, type of accessory)
      sizeTitle = StringHelper.type;
    } else {
      // Dogs (69), Cats (70), Birds (71) -> Breed
      sizeTitle = StringHelper.breed;
    }
    if (showSizesDropdown && (sizes?.isNotEmpty ?? false)) {
      // Ensure 'sizes' list is used for options
      // The FutureBuilder for sizes will use viewModel.getSizeOptions, ensure it aligns
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
          child: SingleChildScrollView(
            // Added SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringHelper.uploadImages,
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          viewModel.mainImagePath =
                              await ImagePickerHelper.openImagePicker(
                                    context: context,
                                    isCropping: false,
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
                      if (viewModel.mainImagePath.isNotEmpty &&
                          viewModel.isUserImage)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () {
                                viewModel.removeMainImage();
                              },
                              child: const Icon(Icons.cancel,
                                  color: Colors.red, size: 24),
                            ),
                          ),
                        ),
                    ],
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
                                viewModel.removeImage(
                                  index,
                                  data: viewModel.imagesList[index],
                                );
                              },
                              child:
                                  const Icon(Icons.cancel, color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          if (viewModel.imagesList.length < 13) {
                            // Show camera/gallery options
                            String? result =
                                await ImagePickerHelper.openImagePicker(
                              context: context,
                              isCropping: false,
                              forMultiple: false,
                            );

                            if (result == 'OPEN_MULTI_GALLERY') {
                              // User selected gallery, now open multi-select
                              List<String>? images = await ImagePickerHelper
                                  .pickMultipleImagesFromGallery();
                              if (images != null && images.isNotEmpty) {
                                for (var img in images) {
                                  if (viewModel.imagesList.length < 13) {
                                    viewModel.addImage(img);
                                  } else {
                                    DialogHelper.showToast(
                                        message: StringHelper.imageMaxLimit);
                                    break;
                                  }
                                }
                              }
                            } else if (result != null) {
                              // User selected camera, add single image
                              viewModel.addImage(result);
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
                              Text(StringHelper.add,
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(height: 16),

                // Brand Dropdown (for Breed/Type) with FormField validation
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
                            title: "$brandTitle *", // Mark as required
                            hint: viewModel.brandTextController.text.isEmpty
                                ? StringHelper.select
                                : viewModel.brandTextController.text,
                            listItemBuilder: (context, model, selected, fxn) {
                              return Text(model?.name ?? '');
                            },
                            headerBuilder: (context, selectedItem, enabled) {
                              return Text(selectedItem?.name ?? "");
                            },
                            options: brands ?? [],
                            onSelected: (CategoryModel? value) {
                              field.didChange(value);
                              // REMOVED: DialogHelper.showLoading();
                              // REMOVED: viewModel.getModels(brandId: value?.id);
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
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                // Size Dropdown (for Breed/Type within subSubCategory) with FormField validation
                if (showSizesDropdown)
                  FutureBuilder<List<CategoryModel>>(
                    future: viewModel.getSizeOptions("${subSubCategory?.id}"),
                    builder: (context, snapshot) {
                      // Show loader only if we're waiting AND there's no cached data
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          !viewModel.isEditProduct &&
                          !snapshot.hasData) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

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
                                  hint:
                                      viewModel.sizeTextController.text.isEmpty
                                          ? StringHelper.select
                                          : viewModel.sizeTextController.text,
                                  onSelected: (CategoryModel? value) {
                                    field.didChange(value);
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
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 2),
                                    child: Text(
                                      field.errorText!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Error loading options: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                // const SizedBox(height: 25); // Original spacing, adjusted by individual dropdowns

                // Ad Title (Required)
                AppTextField(
                    title: "${StringHelper.adTitle} *",
                    hint: StringHelper.enter,
                    controller: viewModel.adTitleTextController,
                    maxLines: 4,
                    minLines: 1,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 18),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji),
                      ),
                      LengthLimitingTextInputFormatter(65),
                    ],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    // elevation: 6, // Removed for consistency
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return StringHelper.adTitleIsRequired;
                      }
                      if (value.trim().length < 10) {
                        return StringHelper.adLength;
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                // Description (Required)
                AppTextField(
                    title: "${StringHelper.describeWhatYouAreSelling} *",
                    hint: StringHelper.enter,
                    controller: viewModel.descriptionTextController,
                    maxLines: 4,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 18),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji),
                      ),
                    ],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    fillColor: Colors.white,
                    // elevation: 6, // Removed for consistency
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return StringHelper.descriptionIsRequired;
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                // Location (Required)
                AppTextField(
                  title: "${StringHelper.location} *",
                  titleColor: Colors.black,
                  hint: StringHelper.select,
                  readOnly: true,
                  controller: viewModel.addressTextController,
                  suffix: Icon(Icons.location_on, color: Colors.grey.shade600),
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  onTap: () async {
                    Map<String, dynamic>? returnedLocationData =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SellFormLocationScreen(viewModel: viewModel)),
                    );
                    if (returnedLocationData != null &&
                        returnedLocationData.isNotEmpty) {
                      viewModel.handleLocationSelectedFromAdForm(
                          returnedLocationData);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.locationIsRequired;
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                  ],
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Price (Required)
                AppTextField(
                  title: "${StringHelper.priceEgp} *",
                  controller: viewModel.priceTextController,
                  hint: StringHelper.enterPrice,
                  maxLength: 10, // Allows for prices up to 1,000,000 and more
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
                      return StringHelper.priceIsRequired;
                    }
                    final amount = num.tryParse(value);
                    if (amount == null) {
                      return StringHelper.enterValidNumber;
                    }
                    if (amount < 50) {
                      // Min price for pets
                      return '${StringHelper.minValidPrice} 50';
                    }
                    if (amount > 1000000) {
                      // Max price for pets
                      return '${StringHelper.maxValidPrice} 1,000,000';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- START: Phone Verification Widget ---
                PhoneVerificationWidget(
                  onPhoneStatusChanged: (isVerified, phone) {
                    viewModel.updatePhoneVerificationStatus(isVerified, phone);
                  },
                  onAutoSubmit: () {
                    _handleSubmit(context, viewModel);
                  },
                ),
                const SizedBox(height: 16),
                // --- END: Phone Verification Widget ---

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
                const SizedBox(height: 16),

                if (viewModel.isEditProduct) ...{
                  GestureDetector(
                    onTap: () {
                      _handleSubmit(context, viewModel);
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
                      _handleSubmit(context, viewModel);
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
      ),
    );
  }
}
