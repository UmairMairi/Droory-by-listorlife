import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
// import '../../../../widgets/app_map_widget.dart'; // Not directly used here
import '../../../../widgets/image_view.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import 'package:list_and_life/widgets/phone_form_verification_widget.dart'; // Added for phone verification

class EducationSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;

  const EducationSellForm(
      {super.key,
      this.type,
      this.category,
      this.subCategory,
      this.subSubCategory,
      this.item,
      this.brands});

  // Helper method for form submission
  void _handleSubmit(BuildContext context, SellFormsVM viewModel) {
    // Phone verification check
    if (item != null && !viewModel.isEditProduct) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateTextFieldsItems(item: item);
      });
    }
    if (!viewModel.isPhoneVerified ||
        viewModel.currentPhone == null ||
        viewModel.currentPhone!.isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }

    // Validate FormFields (AdTitle, Description, Location, Price will have validators)
    if (viewModel.formKey.currentState?.validate() != true) {
      // Validators in FormFields will show their specific messages
      return;
    }

    // Imperative checks for fields not covered by FormField validators or complex conditions
    if (this.category?.id != 8) {
      // Image checks only if not category 8
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

    if (viewModel.educationTypeTextController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.pleaseSelectEducationType);
      return;
    }
    // Note: Brand/Model emptiness not checked in original submit logic for education

    DialogHelper.showLoading();
    if (viewModel.isEditProduct) {
      viewModel.editProduct(
        productId: this.item?.id,
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        models: viewModel.selectedModel,
        // onSuccess: () {
        //   // Added for consistency
        //   Navigator.pop(context, true);
        // } ;
      );
    } else {
      viewModel.addProduct(
          category: this.category,
          subCategory: this.subCategory,
          subSubCategory: this.subSubCategory,
          brand: viewModel.selectedBrand,
          models: viewModel.selectedModel);
    }
  }

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
                        // Original condition for edit
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
                          if (viewModel.imagesList.length < 10) {
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
                                  if (viewModel.imagesList.length < 10) {
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

                // Education Type (Required imperatively)
                CommonDropdown(
                  // Not using FormField, so imperative check needed
                  title: "${StringHelper.type} *", // Assuming type is required
                  hint: viewModel.educationTypeTextController.text.isEmpty
                      ? StringHelper.select // Provide a hint if empty
                      : viewModel.educationTypeTextController.text,
                  onSelected: (String? value) {
                    viewModel.educationTypeTextController.text = value ?? "";
                  },
                  options: viewModel.educationList,
                ),
                const SizedBox(height: 16),

                // Brand Dropdown Field
                if (brands?.isNotEmpty ?? false) ...[
                  CommonDropdown<CategoryModel?>(
                    title: StringHelper
                        .brand, // Not marked as required in original logic
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
                      // DialogHelper.showLoading();
                      viewModel.getModels(brandId: value?.id);
                      viewModel.selectedBrand = value;
                      viewModel.brandTextController.text = value?.name ?? '';
                    },
                  ),
                  const SizedBox(height: 16),

                  // Model Dropdown Field
                  if (viewModel.selectedBrand != null &&
                      viewModel.allModels
                          .isNotEmpty) // Show only if brand selected and models exist
                    CommonDropdown<CategoryModel?>(
                      title: StringHelper.models, // Not marked as required
                      titleColor: Colors.black,
                      hint: viewModel.modelTextController.text.isEmpty
                          ? StringHelper.select
                          : viewModel.modelTextController.text,
                      listItemBuilder: (context, model, selected, fxn) {
                        return Text(model?.name ?? '');
                      },
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(selectedItem?.name ?? "");
                      },
                      onSelected: (value) {
                        viewModel.selectedModel = value;
                        viewModel.modelTextController.text = value?.name ?? '';
                      },
                      options: viewModel.allModels,
                    ),
                  if (brands?.isNotEmpty ?? false)
                    const SizedBox(height: 16), // Spacing if brands were shown
                ],

                // Ad Title Field (Required)
                AppTextField(
                  title: "${StringHelper.adTitle} *",
                  controller: viewModel.adTitleTextController,
                  hint: StringHelper.enter,
                  maxLines: 4,
                  minLines: 1,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                    LengthLimitingTextInputFormatter(65),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.adTitleIsRequired;
                    }
                    if (value.trim().length < 10) {
                      return StringHelper.adLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field (Required)
                AppTextField(
                  title: "${StringHelper.describeWhatYouAreSelling} *",
                  controller: viewModel.descriptionTextController,
                  hint: StringHelper.enter,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.descriptionIsRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location Field (Required)
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

                // Price Field (Required)
                AppTextField(
                  title: "${StringHelper.priceEgp} *", // Title implies required
                  controller: viewModel.priceTextController,
                  hint: StringHelper.enterPrice,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        10), // Allows up to 9,999,999,999
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  focusNode: viewModel.priceText,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper
                          .priceIsRequired; // General required message
                    }
                    final amount = num.tryParse(value);
                    if (amount == null) {
                      return StringHelper.enterValidNumber;
                    }
                    if (amount < 1000) {
                      // Min price for education
                      return '${StringHelper.minValidPrice} 1,000';
                    }
                    if (amount > 8000000) {
                      // Max price for education (8 million)
                      return '${StringHelper.maxValidPrice} 8,000,000'; // Message corrected
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
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        viewModel.adStatus == "deactivate"
                            ? StringHelper.updateRepublish
                            : StringHelper.updateNow,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            // Corrected const
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
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
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(
                        StringHelper.postNow,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            // Corrected const
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
      ),
    );
  }
}
