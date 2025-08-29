import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/view_model/car_brand_selection.dart';
import 'package:list_and_life/widgets/car_model_selection.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import 'package:list_and_life/base/utils/utils.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
// import '../../../../widgets/app_map_widget.dart'; // Not directly used in this class structure, but good to keep if SellFormLocationScreen or VM needs it transitively.
import '../../../../widgets/common_dropdown.dart';
import '../../../../widgets/image_view.dart';
import 'package:list_and_life/widgets/phone_form_verification_widget.dart'; // Added for phone verification

class CarsSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;

  const CarsSellForm({
    super.key,
    this.type,
    this.category,
    this.subSubCategory,
    this.subCategory,
    this.item,
    this.brands,
  });

  // Helper method for form submission
  void _handleSubmit(BuildContext context, SellFormsVM viewModel) {
    // Phone verification check (from common_sell_form.dart)
    if (!viewModel.isPhoneVerified ||
        viewModel.currentPhone == null ||
        viewModel.currentPhone!.isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }

    // Existing validations from cars_sell_form.dart
    if (viewModel.formKey.currentState?.validate() != true) {
      return;
    }
    if (viewModel.mainImagePath.isEmpty) {
      DialogHelper.showToast(
        message: StringHelper.pleaseUploadMainImage,
      );
      return;
    }
    if (viewModel.imagesList.isEmpty) {
      DialogHelper.showToast(
        message: StringHelper.pleaseUploadAddAtLeastOneImage,
      );
      return;
    }
    // Year validation specific to cars (ID 13) - using widget's subCategory
    if (viewModel.yearTextController.text.trim().isEmpty &&
        this.subCategory?.id == 13) {
      DialogHelper.showToast(
        message: StringHelper.yearIsRequired,
      );
      return;
    }
    if (viewModel.adTitleTextController.text.trim().isEmpty) {
      DialogHelper.showToast(
        message: StringHelper.adTitleIsRequired,
      );
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
        message: StringHelper.describeWhatYouAreSelling,
      );
      return;
    }
    if (viewModel.addressTextController.text.trim().isEmpty) {
      DialogHelper.showToast(
        message: StringHelper.locationIsRequired,
      );
      return;
    }
    if (viewModel.priceTextController.text.trim().isEmpty) {
      DialogHelper.showToast(
        message: StringHelper.priceIsRequired,
      );
      return;
    }

    DialogHelper.showLoading();
    if (viewModel.isEditProduct) {
      viewModel.editProduct(
        productId: this.item?.id,
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        models: viewModel.selectedModel,
        onSuccess: () {
          Navigator.pop(
              context, true); // context is available from build method
        },
      );
    } else {
      viewModel.addProduct(
        category: this.category,
        subCategory: this.subCategory,
        subSubCategory: this.subSubCategory,
        brand: viewModel.selectedBrand,
        models: viewModel.selectedModel,
        // Assuming VM handles navigation or it's handled globally after addProduct
      );
    }
  }

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    // Define fuel type options using StringHelper
    if (item != null && !viewModel.isEditProduct) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateTextFieldsItems(item: item);
      });
    }
    final List<String> fuelTypeOptions = [
      StringHelper.petrol,
      StringHelper.diesel,
      StringHelper.electric,
      StringHelper.hybrid,
      // StringHelper.gas,
    ];

    return Form(
      key: viewModel.formKey,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          keyboardBarColor: Colors.grey[200],
          actions: [
            KeyboardActionsItem(focusNode: viewModel.priceText),
            KeyboardActionsItem(focusNode: viewModel.ownerText),
            KeyboardActionsItem(focusNode: viewModel.yearText),
            KeyboardActionsItem(focusNode: viewModel.kmDrivenText),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Common field: Upload Images
                Text(
                  StringHelper.uploadImages,
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
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
                      // X button - only show if there's a main image
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
                const SizedBox(height: 16),
                // Improved compact grid layout for images
                Container(
                  constraints: BoxConstraints(
                    maxHeight: viewModel.imagesList.length > 6 ? 180 : double.infinity,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: viewModel.imagesList.length > 6 
                        ? const AlwaysScrollableScrollPhysics() 
                        : const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 images per row instead of 2
                      childAspectRatio: 1.0, // Square images
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    padding: const EdgeInsets.all(8),
                    itemCount: viewModel.imagesList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < viewModel.imagesList.length) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageView.rect(
                                  image: viewModel.imagesList[index].media ?? '',
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(4),
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
                                child: const Icon(
                                  Icons.cancel, 
                                  color: Colors.red, 
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            if (viewModel.imagesList.length < 15) {
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
                            } else {
                              DialogHelper.showToast(
                                  message: StringHelper.imageMaxLimit);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400, 
                                style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 28,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  StringHelper.add,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Fields only for cars for sale (ID 13)
                if (subCategory?.id == 13) ...[
                  Text(
                    StringHelper.itemCondition,
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(
                      height: 10), // Add spacing between title and buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            viewModel.itemCondition = 1;
                          },
                          child: Container(
                            height: 42,
                            // FIX: Removed margin for RTL compatibility
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
                      const SizedBox(
                          width: 10), // FIX: Added SizedBox for spacing
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            viewModel.itemCondition = 2;
                          },
                          child: Container(
                            height: 42,
                            // FIX: Removed margin for RTL compatibility
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
                  const SizedBox(height: 16),
                ],

                // Brand Dropdown (required for ID 13 if brands are available)
                if (subCategory?.id == 13 && (brands?.isNotEmpty ?? false))
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
                          // Custom Brand Selection Field
                          GestureDetector(
                            onTap: () async {
                              final CategoryModel? selectedBrand =
                                  await Navigator.push<CategoryModel>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarBrandSelectionScreen(
                                    brands: brands ?? [],
                                    selectedBrand: viewModel.selectedBrand,
                                    showIcon: true,
                                    title: StringHelper.brand ?? "Select Brand",
                                  ),
                                ),
                              );

                              if (selectedBrand != null) {
                                field.didChange(selectedBrand);
                                field.validate(); // FIX: Validate on change
                                // DialogHelper.showLoading();
                                viewModel.getModels(brandId: selectedBrand.id);
                                viewModel.selectedBrand = selectedBrand;
                                viewModel.brandTextController.text =
                                    selectedBrand.name ?? '';
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: field.hasError
                                      ? Colors.red
                                      : Colors.grey.shade300,
                                  width: field.hasError ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${StringHelper.brand} *",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Brand Logo (if selected)
                                      if (viewModel.selectedBrand != null) ...[
                                        Container(
                                          width: 80,
                                          height: 80,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.grey.shade200),
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final logoPath =
                                                  _getBrandLogoPath(viewModel
                                                      .selectedBrand?.name);
                                              print(
                                                  "🔍 Trying to load logo: $logoPath");

                                              return SvgPicture.asset(
                                                logoPath,
                                                fit: BoxFit.contain,
                                                width: 80,
                                                height: 80,
                                                placeholderBuilder: (context) =>
                                                    Icon(
                                                  Icons.directions_car,
                                                  color: Colors.grey.shade600,
                                                  size: 60,
                                                ),
                                                // Add error handling
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(
                                                      "🚨 Error loading SVG: $error");
                                                  return Icon(
                                                    Icons.directions_car,
                                                    color: Colors.grey.shade600,
                                                    size: 60,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                      ],

                                      // Brand Name or Placeholder
                                      Expanded(
                                        child: Text(
                                          viewModel.selectedBrand?.name ??
                                              StringHelper.select,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                viewModel.selectedBrand != null
                                                    ? FontWeight.w500
                                                    : FontWeight.w400,
                                            color:
                                                viewModel.selectedBrand != null
                                                    ? Colors.black
                                                    : Colors.grey.shade500,
                                          ),
                                        ),
                                      ),

                                      // Dropdown Arrow
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey.shade600,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Error Text
                          if (field.hasError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 8),
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

                // Add spacing after brand selection
                if (subCategory?.id == 13 && (brands?.isNotEmpty ?? false))
                  const SizedBox(height: 16),

                if (subCategory?.id == 13 && viewModel.selectedBrand != null)
                  FormField<CategoryModel?>(
                    validator: (value) {
                      if (value == null) {
                        return StringHelper.fieldShouldNotBeEmpty;
                      }
                      return null;
                    },
                    initialValue: viewModel.selectedModel,
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom Model Selection Field
                          GestureDetector(
                            onTap: (viewModel.allModels.isNotEmpty)
                                ? () async {
                                    final CategoryModel? selectedModel =
                                        await Navigator.push<CategoryModel>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CarModelSelectionScreen(
                                          models: viewModel.allModels.cast<
                                              CategoryModel>(), // Cast to remove null
                                          selectedModel:
                                              viewModel.selectedModel,
                                          title: StringHelper.models ??
                                              "Select Model",
                                          brandName:
                                              viewModel.selectedBrand?.name,
                                        ),
                                      ),
                                    );

                                    if (selectedModel != null) {
                                      field.didChange(selectedModel);
                                      field
                                          .validate(); // FIX: Validate on change
                                      viewModel.selectedModel = selectedModel;
                                      viewModel.modelTextController.text =
                                          selectedModel.name ?? '';
                                    }
                                  }
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: viewModel.allModels.isEmpty
                                    ? Colors.grey.shade50
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: field.hasError
                                      ? Colors.red
                                      : Colors.grey.shade300,
                                  width: field.hasError ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${StringHelper.models} *",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Model Icon
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.grey.shade200),
                                        ),
                                        child: Icon(
                                          Icons.directions_car_outlined,
                                          color: Colors.grey.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Model Name or Placeholder
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              viewModel.selectedModel?.name ??
                                                  (viewModel.allModels.isEmpty
                                                      ? StringHelper
                                                          .loadingModels
                                                      : StringHelper
                                                          .selectModel),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    viewModel.selectedModel !=
                                                            null
                                                        ? FontWeight.w500
                                                        : FontWeight.w400,
                                                color:
                                                    viewModel.selectedModel !=
                                                            null
                                                        ? Colors.black
                                                        : Colors.grey.shade500,
                                              ),
                                            ),
                                            if (viewModel.selectedBrand != null)
                                              Text(
                                                "${StringHelper.forText} ${viewModel.selectedBrand!.name}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Dropdown Arrow or Loading
                                      viewModel.allModels.isEmpty
                                          ? SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.grey.shade600,
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey.shade600,
                                              size: 24,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Error Text
                          if (field.hasError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 8),
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
                if (subCategory?.id == 13 &&
                    viewModel.selectedBrand != null &&
                    viewModel.allModels.isNotEmpty)
                  const SizedBox(height: 16),

                // Year Numerical Input (required for specific IDs)
                Visibility(
                  visible: [13, 26, 98, 27].contains(subCategory?.id),
                  child: Column(
                    children: [
                      FormField<String>(
                        initialValue:
                            viewModel.yearTextController.text.isNotEmpty
                                ? viewModel.yearTextController.text
                                : null,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            // Making year required only if subCategory.id is 13 (Cars for Sale)
                            // For other categories like 26 (Boats), 98 (Motorcycles), 27 (Heavy Equipment)
                            // it was not explicitly marked as required in the original submit logic,
                            // so we keep it optional unless it's ID 13.
                            if (subCategory?.id == 13) {
                              return StringHelper
                                  .yearIsRequired; // Or a more specific message
                            }
                            return null; // Optional for other categories
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
                                title: (subCategory?.id == 13)
                                    ? "${StringHelper.year} *"
                                    : StringHelper.year,
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
                                  field
                                      .validate(); // FIX: Validate as user types
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
                    ],
                  ),
                ),

                // Fuel Type Selection (required)
                FormField<String?>(
                  initialValue: viewModel.fuelTextController.text.isNotEmpty
                      ? viewModel.fuelTextController.text
                      : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return StringHelper.fieldShouldNotBeEmpty;
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${StringHelper.fuel} *",
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: fuelTypeOptions.map((fuel) {
                              return _buildFuelTypeOption(
                                context,
                                fuel,
                                _getFuelSvgPath(fuel),
                                viewModel,
                                field,
                              );
                            }).toList(),
                          ),
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
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

                // Fields only for cars for sale (ID 13)
                if (subCategory?.id == 13) ...[
                  // Exterior Color Selection
                  _ColorSelectionWidget(
                    title: StringHelper.carColorTitle,
                    allColors: StringHelper.carColorOptions,
                    selectedColor: viewModel.carColorTextController.text,
                    onColorSelected: (color) {
                      viewModel.carColorTextController.text = color;
                      viewModel.notifyListeners();
                    },
                  ),
                  const SizedBox(height: 16),
                  // Interior Color Selection
                  _ColorSelectionWidget(
                    title: StringHelper.interiorColorTitle,
                    allColors: StringHelper.carColorOptions,
                    selectedColor: viewModel.interiorColorTextController.text,
                    onColorSelected: (color) {
                      viewModel.interiorColorTextController.text = color;
                      viewModel.notifyListeners();
                    },
                  ),
                  const SizedBox(height: 16),
                  // Number of Doors Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringHelper.numbDoorsTitle,
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            StringHelper.doors2,
                            StringHelper.doors3,
                            StringHelper.doors4,
                            StringHelper.doors5Plus
                          ].map((doors) {
                            bool isSelected =
                                viewModel.numbDoorsTextController.text == doors;
                            return GestureDetector(
                              onTap: () {
                                viewModel.numbDoorsTextController.text = doors;
                                viewModel.notifyListeners();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black.withOpacity(0.1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  doors,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Body Type Selection (required)
                FormField<String?>(
                  initialValue: viewModel.bodyTypeTextController.text.isNotEmpty
                      ? viewModel.bodyTypeTextController.text
                      : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return StringHelper.fieldShouldNotBeEmpty;
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${StringHelper.bodyTypeTitle} *",
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                StringHelper.bodyTypeOptions.map((bodyType) {
                              return _buildBodyTypeOption(
                                context,
                                bodyType,
                                _getBodyTypeSvgPath(bodyType),
                                viewModel,
                                field,
                              );
                            }).toList(),
                          ),
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
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

                const SizedBox(height: 20),

                // Transmission
                FormField<int>(
                  initialValue: viewModel.transmission,
                  validator: (value) {
                    if (value == 0) {
                      // Assuming 0 means not selected
                      return StringHelper.transmissionRequired;
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${StringHelper.transmission} *",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.transmission = 1; // Automatic
                                  field.didChange(1);
                                  field.validate(); // FIX: Validate on tap
                                },
                                child: Container(
                                  height: 50,
                                  // FIX: Removed margin for RTL compatibility
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: field.value == 1
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                    color: field.value == 1
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      StringHelper.automatic,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: field.value == 1
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    16), // FIX: Added SizedBox for robust spacing
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  viewModel.transmission = 2; // Manual
                                  field.didChange(2);
                                  field.validate(); // FIX: Validate on tap
                                },
                                child: Container(
                                  height: 50,
                                  // FIX: Removed margin for RTL compatibility
                                  decoration: BoxDecoration(
                                    color: field.value == 2
                                        ? Colors.black
                                        : Colors.white,
                                    border: Border.all(
                                      color: field.value == 2
                                          ? Colors.transparent
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      StringHelper.manual,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: field.value == 2
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
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
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
                CommonDropdown<String>(
                  title: StringHelper.horsepowerTitle,
                  titleColor: Colors.black,
                  hint: viewModel.horsePowerTextController.text.isEmpty
                      ? ""
                      : viewModel.horsePowerTextController.text,
                  onSelected: (String? value) {
                    viewModel.horsePowerTextController.text = value ?? '';
                  },
                  options: [
                    StringHelper.lessThan100HP,
                    StringHelper.hp100To200,
                    StringHelper.hp200To300,
                    StringHelper.hp300To400,
                    StringHelper.hp400To500,
                    StringHelper.hp500To600,
                    StringHelper.hp600To700,
                    StringHelper.hp700To800,
                    StringHelper.hp800Plus,
                    StringHelper.other
                  ],
                ),

                const SizedBox(height: 16),
                CommonDropdown<String>(
                  title: StringHelper.engineCapacityTitle,
                  titleColor: Colors.black,
                  hint: viewModel.engineCapacityTextController.text,
                  onSelected: (String? value) {
                    viewModel.engineCapacityTextController.text = value ?? '';
                  },
                  options: [
                    StringHelper.below500cc,
                    StringHelper.cc500To999,
                    StringHelper.cc1000To1499,
                    StringHelper.cc1500To1999,
                    StringHelper.cc2000To2499,
                    StringHelper.cc2500To2999,
                    StringHelper.cc3000To3499,
                    StringHelper.cc3500To3999,
                    StringHelper.cc4000Plus,
                    StringHelper.other
                  ],
                ),
                const SizedBox(height: 16),
                // Fields only for cars for sale (ID 13)
                if (subCategory?.id == 13) ...[
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
                        return StringHelper.enterKmDriven;
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
                  AppTextField(
                    title: "${StringHelper.noOfOwners} *",
                    titleColor: Colors.black,
                    controller: viewModel.numOfOwnerTextController,
                    focusNode: viewModel.ownerText,
                    hint: StringHelper.enter,
                    hintStyle:
                        const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 18),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji),
                      ),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringHelper
                            .enterValidNumber; // Or more specific like "Number of owners is required"
                      }
                      final int? number = int.tryParse(value);
                      if (number == null) {
                        return StringHelper.enterValidNumber;
                      }
                      if (number < 1 || number > 12) {
                        return StringHelper.numberBetween1And12;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Fields only for rental cars (ID 25)
                if (subCategory?.id == 25) ...[
                  FormField<String?>(
                    initialValue:
                        viewModel.carRentalTermTextController.text.isNotEmpty
                            ? viewModel.carRentalTermTextController.text
                            : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringHelper.fieldShouldNotBeEmpty;
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonDropdown<String>(
                            title: "${StringHelper.rentalCarTerm} *",
                            titleColor: Colors.black,
                            hint: viewModel
                                    .carRentalTermTextController.text.isEmpty
                                ? ""
                                : viewModel.carRentalTermTextController.text,
                            onSelected: (String? value) {
                              field.didChange(value);
                              field.validate(); // FIX: Validate on selection
                              viewModel.carRentalTermTextController.text =
                                  value ?? '';
                            },
                            options: [
                              StringHelper.daily,
                              StringHelper.monthly,
                              StringHelper.yearly
                            ],
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
                ],

                // Common field: Ad Title (required)
                AppTextField(
                  title: "${StringHelper.adTitle} *",
                  titleColor: Colors.black,
                  controller: viewModel.adTitleTextController,
                  hint: StringHelper.enter,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  maxLines: 4,
                  minLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji),
                    ),
                    LengthLimitingTextInputFormatter(65),
                  ],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.adTitleIsRequired;
                    }
                    if (value.trim().length < 10) {
                      // Moved this check here from submit logic
                      return StringHelper.adLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Common field: Description (required)
                AppTextField(
                  title: "${StringHelper.describeWhatYouAreSelling} *",
                  titleColor: Colors.black,
                  controller: viewModel.descriptionTextController,
                  hint: StringHelper.enter,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  maxLines: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji),
                    ),
                  ],
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper
                          .descriptionIsRequired; // Using the existing constant
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Common field: Location (required)
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

                // Common field: Price (required)
                AppTextField(
                  title: "${StringHelper.priceEgp} *",
                  controller: viewModel.priceTextController,
                  hint: StringHelper.enterPrice,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji),
                    ),
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
                      return "${StringHelper.minValidPrice} 50";
                    }
                    if (subCategory?.id == 25) {
                      // Rental cars
                      if (amount > 600000) {
                        return "${StringHelper.maxValidPrice} 600,000";
                      }
                    } else {
                      // Cars for sale and other vehicle types default
                      if (amount > 50000000) {
                        return "${StringHelper.maxValidPrice} 50,000,000";
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

                // Common field: How to Connect
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

                // Common buttons: Post or Update
                if (viewModel.isEditProduct)
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
                  )
                else
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getBrandLogoPath(String? brandName) {
    if (brandName == null) return 'assets/icons/car_brands/default.svg';

    print("🔍 Original brand name: '$brandName'");

    // Map Arabic names to English equivalents first
    Map<String, String> arabicToEnglish = {
      'ألفا روميو': 'Alfa Romeo',
      'أستون مارتن': 'Aston Martin',
      'أودي': 'Audi',
      'أفاتار': 'Avatr',
      'بي إم دبليو': 'BMW',
      'بي واي دي': 'BYD',
      'بايك': 'Baic',
      'بنتلي': 'Bentley',
      'بيستون': 'Bestune',
      'بريليانس': 'Brilliance',
      'بوغاتي': 'Bugatti',
      'بيوك': 'Buick',
      'كاديلاك': 'Cadillac',
      'شانا': 'Chana',
      'شانجان': 'Changan',
      'شانغي': 'Changhe',
      'شيري': 'Chery',
      'شيفروليه': 'Chevrolet',
      'كرايسلر': 'Chrysler',
      'ستروين': 'Citroen',
      'كوبرا': 'Cupra',
      'دي إف إس كي': 'DFSK',
      'دايو': 'Daewoo',
      'دايهاتسو': 'Daihatsu',
      'دودج': 'Dodge',
      'فاو': 'Faw',
      'فيراري': 'Ferrari',
      'فيات': 'Fiat',
      'فورد': 'Ford',
      'جي إيه سي': 'GAC',
      'جي إم سي': 'GMC',
      'جيلي': 'Geely',
      'جريت وول': 'Great Wall',
      'هافال': 'Haval',
      'هوندا': 'Honda',
      'هامر': 'Hummer',
      'هيونداي': 'Hyundai',
      'إنفينيتي': 'Infiniti',
      'إيسوزو': 'Isuzu',
      'جاك': 'Jac',
      'جاكوار': 'Jaguar',
      'جيتور': 'Jetour',
      'جيب': 'Jeep',
      'كيا': 'Kia',
      'كينغ لونغ': 'King Long',
      'لادا': 'Lada',
      'لامبورغيني': 'Lamborghini',
      'لاند روفر': 'Land Rover',
      'لكزس': 'Lexus',
      'ليفان': 'Lifan',
      'لينكون': 'Lincoln',
      'لوتس': 'Lotus',
      'إم جي': 'MG',
      'ميني': 'MINI',
      'مازيراتي': 'Maserati',
      'مازدا': 'Mazda',
      'مكلارين': 'McLaren',
      'مرسيدس بنز': 'Mercedes-Benz',
      'ميتسوبيشي': 'Mitsubishi',
      'نيسان': 'Nissan',
      'أوبل': 'Opel',
      'بيجو': 'Peugeot',
      'بورش': 'Porsche',
      'بروتون': 'Proton',
      'رينو': 'Renault',
      'رولز رويس': 'Rolls Royce',
      'سينوفا': 'Senova',
      'سكودا': 'Skoda',
      'سوايست': 'Soueast',
      'سبيرانزا': 'Speranza',
      'سانج يونغ': 'Ssang Yong',
      'سوبارو': 'Subaru',
      'سوزوكي': 'Suzuki',
      'سيات': 'seat',
      'تيسلا': 'Tesla',
      'تويوتا': 'Toyota',
      'فولكس فاجن': 'Volkswagen',
      'فولفو': 'Volvo',
      'إكس بينغ': 'XPeng',
      'شاومي': 'Xiaomi',
      'زيكر': 'Zeekr',
      'زوتي': 'Zotye',
      "صنع آخر": 'Other Make'
    };

    // Convert Arabic to English if needed
    String englishBrandName = arabicToEnglish[brandName] ?? brandName;
    print("🔍 After Arabic mapping: '$englishBrandName'");

    // Convert brand name to lowercase and remove spaces/hyphens for file naming
    String normalizedName = englishBrandName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');
    print("🔍 Normalized name: '$normalizedName'");

    String finalPath = 'assets/icons/car_brands/$normalizedName.svg';
    print("🔍 Final path: '$finalPath'");

    return finalPath;
  }

  Widget _buildBodyTypeOption(
    BuildContext context,
    String bodyType,
    String svgAssetPath,
    SellFormsVM viewModel,
    FormFieldState<String?> field,
  ) {
    bool isSelected = viewModel.bodyTypeTextController.text == bodyType;

    return GestureDetector(
      onTap: () {
        viewModel.bodyTypeTextController.text = bodyType;
        field.didChange(bodyType);
        field.validate(); // FIX: Validate on change
        viewModel.notifyListeners(); // To rebuild and show selection
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        width: 130,
        height: 110,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAssetPath,
              width: 48,
              height: 48,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                bodyType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFuelTypeOption(
    BuildContext context,
    String fuelType,
    String svgAssetPath,
    SellFormsVM viewModel,
    FormFieldState<String?> field,
  ) {
    bool isSelected = viewModel.fuelTextController.text == fuelType;

    return GestureDetector(
      onTap: () {
        viewModel.fuelTextController.text = fuelType;
        field.didChange(fuelType);
        field.validate(); // FIX: Validate on change
        viewModel.notifyListeners(); // To rebuild and show selection
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        width: 130,
        height: 110,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAssetPath,
              width: 48,
              height: 48,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                fuelType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBodyTypeSvgPath(String bodyType) {
    // Map translated body type to English for SVG path
    String normalizedBodyType = Utils.setBodyType(bodyType).toLowerCase();
    switch (normalizedBodyType) {
      case 'suv':
        return 'assets/icons/body_types/suv.svg';
      case 'hatchback':
        return 'assets/icons/body_types/hatchback.svg';
      case '4x4':
        return 'assets/icons/body_types/4x4.svg';
      case 'sedan':
        return 'assets/icons/body_types/sedan.svg';
      case 'coupe':
        return 'assets/icons/body_types/coupe.svg';
      case 'convertible':
        return 'assets/icons/body_types/convertible.svg';
      case 'estate':
        return 'assets/icons/body_types/estate.svg';
      case 'mpv':
        return 'assets/icons/body_types/mpv.svg';
      case 'pickup':
        return 'assets/icons/body_types/pickup.svg';
      case 'crossover':
        return 'assets/icons/body_types/crossover.svg';
      case 'van/bus': // Ensure your Utils.setBodyType handles this potential slash
        return 'assets/icons/body_types/van_bus.svg';
      case 'other':
        return 'assets/icons/body_types/other.svg';
      default:
        return 'assets/icons/body_types/sedan.svg'; // Fallback
    }
  }

  String _getFuelSvgPath(String fuelType) {
    // Map translated fuel type to English for SVG path
    String normalizedFuelType = Utils.setFuel(fuelType).toLowerCase();
    switch (normalizedFuelType) {
      case 'petrol':
        return 'assets/icons/fuel_types/petrol.svg';
      case 'diesel':
        return 'assets/icons/fuel_types/diesel.svg';
      case 'electric':
        return 'assets/icons/fuel_types/electric.svg';
      case 'hybrid':
        return 'assets/icons/fuel_types/hybrid.svg';
      case 'gas': // Added gas based on fuelTypeOptions
        return 'assets/icons/fuel_types/gas.svg'; // Assuming you have gas.svg
      default:
        return 'assets/icons/fuel_types/petrol.svg'; // Fallback
    }
  }
}

class _ColorSelectionWidget extends StatefulWidget {
  final String title;
  final List<String> allColors;
  final String selectedColor;
  final Function(String) onColorSelected;

  const _ColorSelectionWidget({
    required this.title,
    required this.allColors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<_ColorSelectionWidget> createState() => _ColorSelectionWidgetState();
}

class _ColorSelectionWidgetState extends State<_ColorSelectionWidget> {
  bool _showAll = false;
  final int _initialDisplayCount = 4;

  @override
  Widget build(BuildContext context) {
    final displayedColors = _showAll
        ? widget.allColors
        : widget.allColors.take(_initialDisplayCount).toList();

    final hasMoreToShow =
        widget.allColors.length > _initialDisplayCount && !_showAll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: displayedColors.map((color) {
            bool isSelected =
                widget.selectedColor.toLowerCase() == color.toLowerCase();
            return GestureDetector(
              onTap: () => widget.onColorSelected(color),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      color,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.black : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getColorFromName(color),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (hasMoreToShow ||
            (widget.allColors.length > _initialDisplayCount && _showAll))
          Padding(
            padding: const EdgeInsets.only(top: 12), // Increased padding
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showAll ? StringHelper.seeLess : StringHelper.seeMore,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 42, 46, 50),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    _showAll
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20, // Increased icon size
                    color: const Color.fromARGB(255, 30, 34, 38),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    // Map translated color to English for color mapping
    String normalizedColor = Utils.setColor(colorName).toLowerCase();
    switch (normalizedColor) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey.shade400;
      case 'gray': // Changed from 'grey' to 'gray' to match common usage, ensure Utils.setColor handles this
        return Colors.grey.shade600;
      case 'red':
        return Colors.red.shade700;
      case 'blue':
        return Colors.blue.shade700;
      case 'green':
        return Colors.green.shade700;
      case 'yellow':
        return Colors.yellow.shade700;
      case 'orange':
        return Colors.orange.shade700;
      case 'brown':
        return Colors.brown.shade700;
      case 'beige':
        return const Color(0xFFF5DEB3);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'burgundy':
        return const Color(0xFF800020);
      case 'purple':
        return Colors.purple.shade700;
      case 'pink':
        return Colors.pink.shade300;
      case 'turquoise':
        return const Color(0xFF40E0D0);
      case 'navy':
        return const Color(0xFF000080);
      case 'other color': // Ensure Utils.setColor handles this
        return Colors.grey; // Fallback for "Other Color"
      default:
        return Colors.grey; // Default fallback
    }
  }
}
