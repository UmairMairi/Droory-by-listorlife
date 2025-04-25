import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/common_dropdown.dart';

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
    debugPrint("subCategory?.id ${subCategory?.id}");
    // Brand dropdown title logic (unchanged)
    String brandTitle;
    if (category?.id == 5 || category?.id == 8 || category?.id == 7) {
      brandTitle = StringHelper.type;
    } else if (subCategory?.id == 22) {
      brandTitle = StringHelper.type;
      // Mobile Accessories
    } else if (subCategory?.id == 23) {
      brandTitle = StringHelper.telecom; // Mobile Numbers
    } else if (subCategory?.id == 4) {
      brandTitle = StringHelper.type; // Furniture
    } else if (subCategory?.id == 91) {
      brandTitle = StringHelper.type; // Video Games and Consoles
    } else if (subCategory?.id == 95) {
      brandTitle = StringHelper.type; // vehicles
    } else if (subCategory?.id == 19 || subSubCategory?.id == 7) {
      brandTitle = StringHelper.brand; // Home Appliances or sub-subcategory 7
    } else if (subSubCategory?.id == 5) {
      brandTitle = StringHelper.type; // Computer Accessories
    } else {
      brandTitle = StringHelper.brand; // Default
    }

    // Visibility logic (updated for Screen Size)
    bool showBrandDropdown = (brands?.isNotEmpty ?? false) &&
        ![11, 12, 13].contains(subSubCategory?.id);

    // Make the Models field visible only if subCategory == 20 AND a brand is chosen
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

    // Updated showScreenSize to include sub-subcategory 7 (Televisions)
    bool showScreenSize = (category?.id == 1 &&
            subCategory?.id != 91 &&
            subCategory?.id != 18 &&
            ![1, 2, 11, 12, 13, 5, 14, 15, 19].contains(subSubCategory?.id)) ||
        (subSubCategory?.id == 7);

    // Phone-specific RAM and Storage (if subCategory.id == 20)
    bool showPhoneRam = subCategory?.id == 20;
    bool showPhoneStorage = subCategory?.id == 20;

    // Define sub-subcategory lists for sizes dropdown (unchanged)
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

    // Determine if sizes dropdown should be shown (unchanged)
    bool shouldShowSizesDropdown() {
      if (subSubCategory != null) {
        return sizeTypeSubSubCats.contains(subSubCategory?.id) ||
            sizeBrandSubSubCats.contains(subSubCategory?.id);
      }
      return false;
    }

    // Set the title for the sizes dropdown (unchanged)
    String getSizesDropdownTitle() {
      if (subSubCategory != null) {
        if (sizeTypeSubSubCats.contains(subSubCategory?.id)) {
          return StringHelper.type;
        } else if (sizeBrandSubSubCats.contains(subSubCategory?.id)) {
          return StringHelper.brand;
        }
      }
      return "Size"; // Fallback title
    }

    // -- BEGIN REQUIRED-FIELD TITLE LOGIC
    // We just append "*" to the label to indicate required, if the field will be visible
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
    // -- END REQUIRED-FIELD TITLE LOGIC

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
                // Image Upload Section (unchanged)
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
                              Text(StringHelper.add,
                                  style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ),

                // SIZES Dropdown
                if (showSizeDropdown)
                  FutureBuilder<List<CategoryModel>>(
                    future: viewModel.getSizeOptions("${subSubCategory?.id}"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data?.isNotEmpty ?? false)) {
                        return FormField<CategoryModel?>(
                          validator: (value) {
                            // If we're actually showing the sizes, it becomes required.
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
                                CommonDropdown<CategoryModel?>(
                                  title: sizeTitleWithStar,
                                  titleColor: Colors.black,
                                  hint: viewModel.sizeTextController.text,
                                  options: snapshot.data!,
                                  listItemBuilder:
                                      (context, model, selected, fxn) {
                                    return Text(model?.name ?? '');
                                  },
                                  headerBuilder:
                                      (context, selectedItem, enabled) {
                                    return Text(selectedItem?.name ?? "");
                                  },
                                  onSelected: (CategoryModel? value) {
                                    field.didChange(value);
                                    field.validate(); // Force revalidation
                                    viewModel.selectedSize = value;
                                    viewModel.sizeTextController.text =
                                        value?.name ?? '';
                                  },
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 5),
                                    child: Text(
                                      field.errorText!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      }
                      // If there's no data, just return an empty widget
                      return const SizedBox.shrink();
                    },
                  ),

                // BRAND Dropdown (only if sizes dropdown isn’t shown)
                if (showBrandDropdown && !showSizeDropdown)
                  FormField<CategoryModel?>(
                    validator: (value) {
                      // If brand dropdown is visible & has data, require a value
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
                          // We make the title bigger and bolder here
                          // Text(
                          //   brandTitleWithStar,
                          //   style: const TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          CommonDropdown<CategoryModel?>(
                            title: brandTitleWithStar,
                            titleColor: Colors.black,
                            hint: viewModel.brandTextController.text,
                            listItemBuilder: (context, model, selected, fxn) {
                              return Text(model?.name ?? '');
                            },
                            headerBuilder: (context, selectedItem, enabled) {
                              return Text(selectedItem?.name ?? "");
                            },
                            options: brands ?? [],
                            onSelected: (CategoryModel? value) {
                              // IMPORTANT: We call 'didChange' and then 'validate'
                              // so the error goes away if a brand is chosen
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
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 1),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 202, 64, 54),
                                  fontSize: 11.5, // A little bigger
                                  fontWeight: FontWeight.bold, // Bolder
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                // MODELS Dropdown (appear only when brand is selected & subCategory == 20)
                if (showModelsDropdown)
                  FormField<CategoryModel?>(
                    validator: (value) {
                      // If subCategory is 20 and we show the models, let's require it
                      if (subCategory?.id == 20 && value == null) {
                        return StringHelper.fieldShouldNotBeEmpty;
                      }
                      return null;
                    },
                    initialValue: viewModel.selectedModel,
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonDropdown<CategoryModel?>(
                            title: StringHelper.models,
                            titleColor: Colors.black,
                            hint: viewModel.modelTextController.text,
                            listItemBuilder: (context, model, selected, fxn) {
                              return Text(model?.name ?? '');
                            },
                            headerBuilder: (context, selectedItem, enabled) {
                              return Text(selectedItem?.name ?? "");
                            },
                            options: viewModel.allModels,
                            onSelected: (value) {
                              field.didChange(value);
                              field.validate();
                              viewModel.selectedModel = value;
                              viewModel.modelTextController.text =
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
                                  color: Color.fromARGB(255, 152, 27, 27),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                // Phone-specific RAM/Storage
                if (showPhoneRam)
                  CommonDropdown<String?>(
                    title: StringHelper.ram,
                    hint: viewModel.ramTextController.text,
                    onSelected: (String? value) {
                      viewModel.ramTextController.text = value ?? '';
                    },
                    options: viewModel.phoneRamOptions,
                  ),
                if (showPhoneStorage)
                  CommonDropdown<String?>(
                    title: StringHelper.strong, // "Storage"
                    hint: viewModel.storageTextController.text,
                    onSelected: (String? value) {
                      viewModel.storageTextController.text = value ?? '';
                    },
                    options: viewModel.phoneStorageOptions,
                  ),

                // Item Condition (unchanged)
                Visibility(
                  visible: ![23, 46, 31].contains(subCategory?.id),
                  child: Text(
                    StringHelper.itemCondition,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                Visibility(
                  visible: ![23, 46, 31].contains(subCategory?.id),
                  child: Row(
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
                ),
                Visibility(
                  visible: ![23, 46].contains(subCategory?.id),
                  child: const SizedBox(height: 25),
                ),

                // Additional RAM, Storage, Screen Size if category 1 or 2
                if (category?.id == 1 || category?.id == 2) ...[
                  if (showRam)
                    CommonDropdown<String?>(
                      title: StringHelper.ram,
                      hint: viewModel.ramTextController.text,
                      onSelected: (String? value) {
                        viewModel.ramTextController.text = value ?? '';
                      },
                      options: viewModel.ramOptions,
                    ),
                  if (showStorage)
                    CommonDropdown<String?>(
                      title: StringHelper.strong, // "Storage"
                      hint: viewModel.storageTextController.text,
                      onSelected: (String? value) {
                        viewModel.storageTextController.text = value ?? '';
                      },
                      options: viewModel.storageOptions,
                    ),
                  if (showScreenSize)
                    CommonDropdown<String?>(
                      title: StringHelper.screenSize,
                      hint: viewModel.screenSizeTextController.text,
                      onSelected: (String? value) {
                        viewModel.screenSizeTextController.text = value ?? '';
                      },
                      options: viewModel.tvSizeOptions,
                    ),
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
                      return StringHelper
                          .adLength; // "Ad title must be at least 10 characters"
                    }
                    return null;
                  },
                ),

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

                // Location
                AppTextField(
                  title: "${StringHelper.location} *",
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
                      viewModel.state = value['state'];
                      viewModel.city = value['city'];
                      viewModel.country = value['country'];
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
                  hint: StringHelper.select,
                  suffix: const Icon(Icons.location_on),
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

                // Button
                if (viewModel.isEditProduct)
                  GestureDetector(
                    onTap: () {
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
                      // If everything in the form is valid, proceed
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
                  )
                else
                  GestureDetector(
                    onTap: () {
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
                      // If everything in the form is valid, proceed
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
