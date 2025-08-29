import 'dart:io'; // Not directly used, but often Flutter projects keep it.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
// import '../../../../widgets/app_map_widget.dart'; // Not directly used here
import '../../../../widgets/common_dropdown.dart';
import 'package:list_and_life/widgets/phone_form_verification_widget.dart'; // Added for phone verification

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

  // Helper method for form submission
  void _handleSubmit(BuildContext context, SellFormsVM viewModel) {
    // Phone verification check
    if (!viewModel.isPhoneVerified ||
        viewModel.currentPhone == null ||
        viewModel.currentPhone!.isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }

    // Validate FormFields first
    if (viewModel.formKey.currentState?.validate() != true) {
      // Validators in FormFields will show their specific messages
      return;
    }

    // Existing imperative checks from vehicles_sell_form.dart
    if (viewModel.mainImagePath.isEmpty) {
      DialogHelper.showToast(message: StringHelper.pleaseUploadMainImage);
      return;
    }
    // Year validation (already handled by FormField validator if subCategory matches)
    // But the original submit logic had a specific toast for year if empty for certain subCats
    if ([26, 98].contains(this.subCategory?.id) &&
        viewModel.yearTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.yearIsRequired);
      return;
    }
    if (viewModel.imagesList.isEmpty) {
      DialogHelper.showToast(
          message: StringHelper.pleaseUploadAddAtLeastOneImage);
      return;
    }
    if (viewModel.adTitleTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.adTitleIsRequired);
      return;
    }
    if (viewModel.adTitleTextController.text.trim().length < 10) {
      DialogHelper.showToast(message: StringHelper.adLength);
      return;
    }
    if (viewModel.descriptionTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.descriptionIsRequired);
      return;
    }
    if (viewModel.addressTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.locationIsRequired);
      return;
    }
    if (viewModel.priceTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.priceIsRequired);
      return;
    }
    // Price value validation is handled by AppTextField's validator

    DialogHelper.showLoading();
    if (viewModel.isEditProduct) {
      viewModel.editProduct(
        productId: this.item?.id,
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        // Note: 'models' is not passed here, matching original vehicles_sell_form
        onSuccess: () {
          Navigator.pop(context, true); // Pop with success state
        },
      );
    } else {
      viewModel.addProduct(
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        // Note: 'models' is not passed here, matching original vehicles_sell_form
      );
    }
  }

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    if (item != null && !viewModel.isEditProduct) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateTextFieldsItems(item: item);
      });
    }
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
          child: SingleChildScrollView(
            // Added SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Picture Section
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
                      if (viewModel.mainImagePath.isNotEmpty)
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
                          if (viewModel.imagesList.length < 15) {
                            // Show camera/gallery options
                            String? result =
                                await ImagePickerHelper.openImagePicker(
                              context: context,
                              isCropping: false,
                              forMultiple: true,
                            );

                            if (result == 'OPEN_MULTI_GALLERY') {
                              // User selected gallery, now open multi-select
                              List<String>? images = await ImagePickerHelper
                                  .pickMultipleImagesFromGallery();
                              if (images != null && images.isNotEmpty) {
                                for (var img in images) {
                                  if (viewModel.imagesList.length < 15) {
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

                // Brand Field (required when shown)
                if (brands?.isNotEmpty ?? false) ...{
                  if ([26, 27, 95, 97, 98, 99].contains(subCategory?.id)) ...{
                    FormField<CategoryModel?>(
                      initialValue: viewModel.selectedBrand,
                      validator: (value) {
                        if (value == null) {
                          return StringHelper
                              .fieldShouldNotBeEmpty; // Simplified message
                        }
                        return null;
                      },
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonDropdown<CategoryModel?>(
                              title: ([98].contains(subCategory?.id)
                                      ? StringHelper.brand
                                      : StringHelper.type) +
                                  " *", // Added asterisk to title
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
                                // field.validate(); // Validation handled by form submission
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
                                    color: Colors.red, // Standard error color
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  },
                },

                // Year Field (conditionally required)
                if ([26, 98].contains(subCategory?.id)) ...{
                  FormField<String>(
                    initialValue: viewModel.yearTextController.text.isNotEmpty
                        ? viewModel.yearTextController.text
                        : null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        // Year is required if it's shown for these categories.
                        return StringHelper.yearIsRequired;
                      }
                      final year = int.tryParse(value);
                      if (year == null) {
                        return StringHelper.enterValidNumber;
                      }
                      if (year < 1900) {
                        return StringHelper.yearMinLimit;
                      }
                      final currentYear = DateTime.now().year;
                      if (year > currentYear) {
                        return '${StringHelper.yearMaxLimit} $currentYear';
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            title: "${StringHelper.year} *",
                            titleColor: Colors.black,
                            controller: viewModel.yearTextController,
                            focusNode: viewModel.yearText,
                            hint: StringHelper.enter,
                            hintStyle: const TextStyle(
                                color: Color(0xffACACAC), fontSize: 14),
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 18),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(
                                RegExp(viewModel.regexToRemoveEmoji),
                              ),
                            ],
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              field.didChange(value);
                              // field.validate();
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
                  ),
                  const SizedBox(height: 16),
                },

                // KM Driven Field (conditionally required)
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
                        return StringHelper
                            .enterKmDriven; // More specific message
                      }
                      final km = num.tryParse(value);
                      if (km == null) {
                        return StringHelper.enterValidNumber;
                      }
                      if (km < 0) {
                        return StringHelper.kmDrivenNotNegative;
                      }
                      if (km > 1000000) {
                        return StringHelper.kmDrivenMaxLimit;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                },

                // Item Condition
                Text(
                  StringHelper.itemCondition,
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.itemCondition = 1,
                        child: Container(
                          height: 42,
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
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => viewModel.itemCondition = 2,
                        child: Container(
                          height: 42,
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
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Ad Title (Required)
                AppTextField(
                    title: "${StringHelper.adTitle} *", // Added asterisk
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
                    validator: (value) {
                      // Added validator
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
                    title:
                        "${StringHelper.describeWhatYouAreSelling} *", // Added asterisk
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
                    validator: (value) {
                      // Added validator
                      if (value == null || value.trim().isEmpty) {
                        return StringHelper.descriptionIsRequired;
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                // Location (Required)
                AppTextField(
                    title: "${StringHelper.location} *", // Added asterisk
                    hint: StringHelper.select,
                    controller: viewModel.addressTextController,
                    maxLines: 2,
                    minLines: 1,
                    readOnly: true,
                    suffix: const Icon(Icons.location_on,
                        color: Colors.grey), // Matched color with other forms
                    onTap: () async {
                      Map<String, dynamic>? value = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SellFormLocationScreen(viewModel: viewModel)),
                      );
                      if (value != null && value.isNotEmpty) {
                        viewModel.handleLocationSelectedFromAdForm(
                            value); // Using VM method
                      }
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14), // Matched padding
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp(viewModel.regexToRemoveEmoji)),
                    ],
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    fillColor: Colors.white,
                    // elevation: 6, // Elevation is not common for text fields, removed for consistency
                    validator: (value) {
                      // Added validator
                      if (value == null || value.trim().isEmpty) {
                        return StringHelper.locationIsRequired;
                      }
                      return null;
                    }),
                const SizedBox(height: 16),

                // Price (Required)
                AppTextField(
                  title: "${StringHelper.priceEgp} *", // Added asterisk
                  controller: viewModel.priceTextController,
                  hint: StringHelper.enterPrice,
                  maxLength:
                      9, // Max length seems specific to vehicles other than cars
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(9),
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  focusNode: viewModel.priceText,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.priceIsRequired; // Consistent message
                    }
                    final amount = num.tryParse(value);
                    if (amount == null) {
                      return StringHelper
                          .enterValidNumber; // Consistent message
                    }
                    if (amount < 50) {
                      return '${StringHelper.minValidPrice} 50';
                    }
                    // Specific max prices for vehicle subcategories
                    if ([26, 27].contains(subCategory?.id)) {
                      // Boats, Heavy Equipment
                      if (amount > 150000000) {
                        // 150 million
                        return '${StringHelper.maxValidPrice} 150,000,000';
                      }
                    } else if ([95, 97].contains(subCategory?.id)) {
                      // Motorcycles Accessories, Boats Accessories
                      if (amount > 400000) {
                        // 400k
                        return '${StringHelper.maxValidPrice} 400,000';
                      }
                    } else {
                      // Other vehicles (e.g., ID 98 Motorcycles, ID 99 Other Vehicles)
                      if (amount > 3000000) {
                        // 3 million
                        return '${StringHelper.maxValidPrice} 3,000,000';
                      }
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

                // How to Connect
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

                // Submit Button
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
