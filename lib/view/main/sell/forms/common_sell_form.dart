import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/observer/route_observer.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/widgets/car_model_selection.dart';
import 'package:list_and_life/widgets/phone_form_verification_widget.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import 'package:list_and_life/view_model/car_brand_selection.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import '../../../../models/product_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/common_dropdown.dart';
import 'post_added_final_view.dart';

class CommonSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  final List<CategoryModel>? sizes;

  const CommonSellForm({
    super.key,
    required this.type,
    required this.category,
    required this.subCategory,
    required this.subSubCategory,
    this.item,
    required this.sizes,
    required this.brands,
  });

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    if (item != null && !viewModel.hasInitializedForEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.updateTextFieldsItems(item: item);
        viewModel.hasInitializedForEdit = true;
      });
    }

    void submitForm() {
      // Check phone verification first
      if (!viewModel.isPhoneVerified ||
          viewModel.currentPhone == null ||
          viewModel.currentPhone!.isEmpty) {
        DialogHelper.showToast(message: StringHelper.phoneRequired);
        return;
      }

      // Validate the form
      if (viewModel.formKey.currentState?.validate() != true) {
        return;
      }

      // Check if main image is uploaded
      if (viewModel.mainImagePath.isEmpty) {
        DialogHelper.showToast(
          message: StringHelper.pleaseUploadMainImage,
        );
        return;
      }

      // Check if at least one additional image is uploaded
      if (viewModel.imagesList.isEmpty) {
        DialogHelper.showToast(
          message: StringHelper.pleaseUploadAddAtLeastOneImage,
        );
        return;
      }

      // Show loading
      DialogHelper.showLoading();

      // Call appropriate method based on whether it's edit or add
      if (viewModel.isEditProduct) {
        viewModel.editProduct(
          productId: item?.id,
          category: category,
          subCategory: subCategory,
          subSubCategory: subSubCategory,
          brand: viewModel.selectedBrand,
          models: viewModel.selectedModel,
          onSuccess: () {
            Navigator.pop(context);
          },
        );
      } else {
        viewModel.addProduct(
          category: category,
          subCategory: subCategory,
          subSubCategory: subSubCategory,
          brand: viewModel.selectedBrand,
          models: viewModel.selectedModel,
          onSuccess: (model){
            context.pushReplacement(Routes.postAddedFinalView, extra: model);

            // final navigatorKey = AppPages.rootNavigatorKey;
            // // Use a post-frame callback to ensure navigation happens after the current frame
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   if (navigatorKey.currentContext != null) {
            //     GoRouter.of(navigatorKey.currentContext!).pushReplacement(Routes.postAddedFinalView, extra: model);
            //   }
            // });
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => PostAddedFinalView(
            //           data: model,
            //         )));
          }
        );
      }
    }

    debugPrint("subCategory?.id ${subCategory?.id}");

    // Brand dropdown title logic
    String brandTitle;

    if (category?.id == 5 || category?.id == 8 || category?.id == 7) {
      brandTitle = StringHelper.type;
    } else if (subCategory?.id == 22) {
      brandTitle = StringHelper.type;
    } else if (subCategory?.id == 23) {
      brandTitle = StringHelper.telecom;
    } else if (subCategory?.id == 4) {
      brandTitle = StringHelper.type;
    } else if (subCategory?.id == 91) {
      brandTitle = StringHelper.type;
    } else if (subCategory?.id == 95) {
      brandTitle = StringHelper.type;
    } else if (subCategory?.id == 19 || subSubCategory?.id == 7) {
      brandTitle = StringHelper.brand;
    } else if (subSubCategory?.id == 5) {
      brandTitle = StringHelper.type;
    } else {
      brandTitle = StringHelper.brand;
    }

    // Visibility logic
    bool showBrandDropdown = (brands?.isNotEmpty ?? false) &&
        ![11, 12, 13].contains(subSubCategory?.id);

    bool showModelsDropdown =
        (subCategory?.id == 20) && (viewModel.selectedBrand != null);

    bool showRam = category?.id == 1 &&
        subCategory?.id != 91 &&
        subCategory?.id != 18 &&
        subCategory?.id != 20 &&
        ![7, 11, 12, 13, 5, 14, 15, 19].contains(subSubCategory?.id);

    bool showStorage = category?.id == 1 &&
        subCategory?.id != 91 &&
        subCategory?.id != 18 &&
        subCategory?.id != 20 &&
        ![7, 11, 12, 13, 5, 14, 15, 19].contains(subSubCategory?.id);

    bool showScreenSize = (category?.id == 1 &&
            subCategory?.id != 91 &&
            subCategory?.id != 18 &&
            ![1, 2, 11, 12, 13, 5, 14, 15, 19].contains(subSubCategory?.id)) ||
        (subSubCategory?.id == 7);

    bool showPhoneRam = subCategory?.id == 20;
    bool showPhoneStorage = subCategory?.id == 20;

    // Define sub-subcategory lists for sizes dropdown
    final List<int> sizeTypeSubSubCats = [
      5,
      19,
      94,
      97,
      22,
      23,
      24,
      25,
      26,
      117,
      119,
      41,
      53,
      104,
      105,
      106,
      107,
      52,
      53,
      89,
      257,
      317
    ];
    final List<int> sizeBrandSubSubCats = [
      1,
      2,
      14,
      15,
      27,
      29,
      30,
      31,
      32,
      98,
      114,
      116,
      7
    ];

    // Determine if sizes dropdown should be shown
    bool shouldShowSizesDropdown() {
      if (subSubCategory != null) {
        return sizeTypeSubSubCats.contains(subSubCategory?.id) ||
            sizeBrandSubSubCats.contains(subSubCategory?.id);
      }
      return false;
    }

    // Set the title for the sizes dropdown
    String getSizesDropdownTitle() {
      if (subSubCategory != null) {
        if (sizeTypeSubSubCats.contains(subSubCategory?.id)) {
          return StringHelper.type;
        } else if (sizeBrandSubSubCats.contains(subSubCategory?.id)) {
          return StringHelper.brand;
        }
      }
      return "Size";
    }

    // Required-field title logic
    String brandTitleWithStar = brandTitle;
    if (showBrandDropdown && (brands?.isNotEmpty ?? false)) {
      brandTitleWithStar += " *";
    }

    String sizeTitle = getSizesDropdownTitle();
    String sizeTitleWithStar = sizeTitle;
    bool showSizeDropdown = shouldShowSizesDropdown() && subSubCategory != null;
    if (showSizeDropdown) {
      sizeTitleWithStar += " *";
    }

    return Form(
      key: viewModel.formKey,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          keyboardBarColor: Colors.grey[200],
          actions: [
            KeyboardActionsItem(focusNode: viewModel.priceText),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload Section
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
                      // X button - only show if there's a main image
                      if (viewModel.mainImagePath.isNotEmpty &&
                          category?.id != 8)
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
                                viewModel.removeImage(index,
                                    data: viewModel.imagesList[index]);
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
                              forMultiple: true,
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

                // SIZES Dropdown - Clean Version
                // SIZES Dropdown - Clean Version (No Loading Indicator)
                // SIZES Dropdown - Clean Version with Cached Loading
                if (showSizeDropdown) ...[
                  FutureBuilder<List<CategoryModel>>(
                    future:
                        viewModel.getCachedSizeOptions("${subSubCategory?.id}"),
                    builder: (context, snapshot) {
                      // Show loading indicator while waiting (only first time)
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sizeTitleWithStar,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Loading options...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }

                      // Only show if data exists and is not empty
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return FormField<CategoryModel?>(
                          validator: (value) {
                            if (showSizeDropdown && value == null) {
                              return StringHelper.fieldShouldNotBeEmpty;
                            }
                            return null;
                          },
                          initialValue: viewModel.selectedSize,
                          builder: (field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Custom Size Selection Field
                                GestureDetector(
                                  onTap: () async {
                                    final CategoryModel? selectedSize =
                                        await Navigator.push<CategoryModel>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CarBrandSelectionScreen(
                                          brands: snapshot.data ?? [],
                                          selectedBrand: viewModel.selectedSize,
                                          title: sizeTitleWithStar.replaceAll(
                                              " *", ""),
                                          showIcon: false,
                                        ),
                                      ),
                                    );

                                    if (selectedSize != null) {
                                      field.didChange(selectedSize);
                                      field.validate();
                                      viewModel.selectedSize = selectedSize;
                                      viewModel.sizeTextController.text =
                                          selectedSize.name ?? '';
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sizeTitleWithStar,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            // Size Name or Placeholder
                                            Expanded(
                                              child: Text(
                                                viewModel.selectedSize?.name ??
                                                    StringHelper.select,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      viewModel.selectedSize !=
                                                              null
                                                          ? FontWeight.w500
                                                          : FontWeight.w400,
                                                  color: viewModel
                                                              .selectedSize !=
                                                          null
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
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 8),
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

                      // Don't show anything if no data or empty data
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                // BRAND Dropdown - Clean Version
                if (showBrandDropdown && !showSizeDropdown) ...[
                  FormField<CategoryModel?>(
                    validator: (value) {
                      if (showBrandDropdown &&
                          (brands?.isNotEmpty ?? false) &&
                          value == null) {
                        return StringHelper.fieldShouldNotBeEmpty;
                      }
                      return null;
                    },
                    initialValue: viewModel.selectedBrand,
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
                                    title:
                                        brandTitleWithStar.replaceAll(" *", ""),
                                  ),
                                ),
                              );

                              if (selectedBrand != null) {
                                field.didChange(selectedBrand);
                                field.validate();

                                // Clear model selection when brand changes
                                viewModel.selectedModel = null;
                                viewModel.modelTextController.clear();
                                viewModel.allModels.clear();

                                // Update brand
                                viewModel.selectedBrand = selectedBrand;
                                viewModel.brandTextController.text =
                                    selectedBrand.name ?? '';

                                // Load new models for the selected brand
                                if (selectedBrand != null) {
                                  viewModel.getModels(
                                      brandId: selectedBrand.id);
                                }

                                // Force UI update
                                viewModel.notifyListeners();
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
                                    brandTitleWithStar,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
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
                  const SizedBox(height: 16),
                ],

                // MODELS Dropdown (for subCategory?.id == 20)
                if (subCategory?.id == 20 &&
                    viewModel.selectedBrand != null) ...[
                  FormField<CategoryModel?>(
                    validator: (value) {
                      if (subCategory?.id == 20 &&
                          viewModel.allModels.isNotEmpty &&
                          value == null) {
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
                                          models: viewModel.allModels
                                              .whereType<CategoryModel>()
                                              .toList(),
                                          selectedModel:
                                              viewModel.selectedModel,
                                          title: StringHelper.models ??
                                              "Select Model",
                                          brandName:
                                              viewModel.selectedBrand?.name,
                                          showIcon: false,
                                        ),
                                      ),
                                    );

                                    if (selectedModel != null) {
                                      field.didChange(selectedModel);
                                      field.validate();
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
                                                              .loadingModels ??
                                                          "Loading models..."
                                                      : StringHelper
                                                              .selectModel ??
                                                          "Select Model"),
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
                                                "${StringHelper.forText ?? "for"} ${viewModel.selectedBrand!.name}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Dropdown Arrow or Loading
                                      viewModel.allModels.isEmpty &&
                                              viewModel.selectedBrand != null
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
                  const SizedBox(height: 16),
                ],

                // Phone-specific RAM Dropdown
                if (showPhoneRam) ...[
                  CommonDropdown<String>(
                    title: StringHelper.ram,
                    hint: viewModel.ramTextController.text.isNotEmpty
                        ? viewModel.ramTextController.text
                        : "",
                    options: [
                      StringHelper.lessThan1GB,
                      StringHelper.gb1,
                      StringHelper.gb2,
                      StringHelper.gb3,
                      StringHelper.gb4,
                      StringHelper.gb6,
                      StringHelper.gb8,
                      StringHelper.gb12,
                      StringHelper.gb16,
                      StringHelper.gb16Plus,
                    ],
                    listItemBuilder: (context, option, selected, fxn) {
                      return Text(option);
                    },
                    headerBuilder: (context, selectedItem, enabled) {
                      return Text(selectedItem ?? "");
                    },
                    onSelected: (String? value) {
                      viewModel.ramTextController.text = value ?? '';
                      viewModel.notifyListeners();
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Phone-specific Storage Dropdown
                if (showPhoneStorage) ...[
                  CommonDropdown<String>(
                    title: StringHelper.strong,
                    hint: viewModel.storageTextController.text.isNotEmpty
                        ? viewModel.storageTextController.text
                        : "",
                    options: [
                      StringHelper.lessThan8GB,
                      StringHelper.gb8,
                      StringHelper.gb16,
                      StringHelper.gb32,
                      StringHelper.gb64,
                      StringHelper.gb128,
                      StringHelper.gb256,
                      StringHelper.gb512,
                      StringHelper.tb1,
                      StringHelper.tb1Plus,
                    ],
                    listItemBuilder: (context, option, selected, fxn) {
                      return Text(option);
                    },
                    headerBuilder: (context, selectedItem, enabled) {
                      return Text(selectedItem ?? "");
                    },
                    onSelected: (String? value) {
                      viewModel.storageTextController.text = value ?? '';
                      viewModel.notifyListeners();
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Item Condition
                Visibility(
                  visible: ![23, 46, 31].contains(subCategory?.id),
                  child: Text(
                    StringHelper.itemCondition,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                Visibility(
                  visible: ![23, 46, 31].contains(subCategory?.id),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
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
                  ),
                ),
                Visibility(
                  visible: ![23, 46].contains(subCategory?.id),
                  child: const SizedBox(height: 25),
                ),

                // Additional RAM, Storage, Screen Size for category 1 or 2
                if (category?.id == 1 || category?.id == 2) ...[
                  if (showRam) ...[
                    CommonDropdown<String>(
                      title: StringHelper.ram,
                      hint: viewModel.ramTextController.text.isNotEmpty
                          ? viewModel.ramTextController.text
                          : "",
                      options: [
                        StringHelper.lessThan4GB,
                        StringHelper.gb4,
                        StringHelper.gb8,
                        StringHelper.gb16,
                        StringHelper.gb32,
                        StringHelper.gb64,
                        StringHelper.gb64Plus,
                      ],
                      listItemBuilder: (context, option, selected, fxn) {
                        return Text(option);
                      },
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(selectedItem ?? "");
                      },
                      onSelected: (String? value) {
                        viewModel.ramTextController.text = value ?? '';
                        viewModel.notifyListeners();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (showStorage) ...[
                    CommonDropdown<String>(
                      title: StringHelper.strong,
                      hint: viewModel.storageTextController.text.isNotEmpty
                          ? viewModel.storageTextController.text
                          : "",
                      options: [
                        StringHelper.lessThan64GB,
                        StringHelper.gb64,
                        StringHelper.gb128,
                        StringHelper.gb256,
                        StringHelper.gb512,
                        StringHelper.tb1,
                        StringHelper.tb1_5,
                        StringHelper.tb2,
                        StringHelper.tb2Plus,
                      ],
                      listItemBuilder: (context, option, selected, fxn) {
                        return Text(option);
                      },
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(selectedItem ?? "");
                      },
                      onSelected: (String? value) {
                        viewModel.storageTextController.text = value ?? '';
                        viewModel.notifyListeners();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (showScreenSize) ...[
                    CommonDropdown<String?>(
                      title: StringHelper.screenSize,
                      hint: viewModel.screenSizeTextController.text,
                      onSelected: (String? value) {
                        viewModel.screenSizeTextController.text = value ?? '';
                      },
                      options: [
                        '24',
                        '28',
                        '32',
                        '40',
                        '43',
                        '48',
                        '50',
                        '55',
                        '58',
                        '65',
                        '70',
                        '75',
                        '85',
                        StringHelper.other
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                // Ad Title
                AppTextField(
                  title: "${StringHelper.adTitle} *",
                  controller: viewModel.adTitleTextController,
                  maxLines: 4,
                  minLines: 1,
                  cursorColor: Colors.black,
                  hint: StringHelper.enter,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                    LengthLimitingTextInputFormatter(65),
                  ],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.fieldShouldNotBeEmpty;
                    }
                    if (value.trim().length < 10) {
                      return StringHelper.adLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                AppTextField(
                  title: "${StringHelper.describeWhatYouAreSelling} *",
                  controller: viewModel.descriptionTextController,
                  maxLines: 4,
                  cursorColor: Colors.black,
                  hint: StringHelper.enter,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                  ],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.fieldShouldNotBeEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location Field
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

                // Price
                AppTextField(
                  title: "${StringHelper.priceEgp} *",
                  controller: viewModel.priceTextController,
                  hint: StringHelper.enterPrice,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
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

                    num minPrice = viewModel.getMinPrice(
                        category, subCategory, subSubCategory);
                    num maxPrice = viewModel.getMaxPrice(
                        category, subCategory, subSubCategory);

                    if (amount < minPrice) {
                      return '${StringHelper.minValidPrice} ${viewModel.formatPrice(minPrice)}';
                    }
                    if (amount > maxPrice) {
                      return '${StringHelper.maxValidPrice} ${viewModel.formatPrice(maxPrice)}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Verification Widget
                PhoneVerificationWidget(
                  onPhoneStatusChanged: (isVerified, phone) {
                    viewModel.updatePhoneVerificationStatus(isVerified, phone);
                  },
                  onAutoSubmit: () {
                    submitForm();
                  },
                ),
                const SizedBox(height: 16),

                // Communication Choice
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
                if (viewModel.isEditProduct)
                  GestureDetector(
                    onTap: submitForm,
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
                    onTap: submitForm,
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
}
