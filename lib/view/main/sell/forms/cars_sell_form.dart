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
            KeyboardActionsItem(focusNode: viewModel.ownerText),
            KeyboardActionsItem(focusNode: viewModel.yearText),
            KeyboardActionsItem(focusNode: viewModel.kmDrivenText),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            // Wrapped in SingleChildScrollView for better usability
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
                const SizedBox(height: 16),
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
                                  context: context,
                                  isCropping: true,
                                ) ??
                                '';
                            if (image.isNotEmpty) {
                              viewModel.addImage(image);
                            }
                          } else {
                            DialogHelper.showToast(
                              message: StringHelper.imageMaxLimit,
                            );
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
                const SizedBox(height: 16),

                // Fields only for cars for sale (ID 13)
                if (subCategory?.id == 13) ...[
                  Text(
                    StringHelper.itemCondition,
                    style: context.textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          viewModel.itemCondition = 1;
                        },
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
                        onTap: () {
                          viewModel.itemCondition = 2;
                        },
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
                          CommonDropdown<CategoryModel?>(
                            title: "${StringHelper.brand} *",
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
                if (subCategory?.id == 13 && (brands?.isNotEmpty ?? false))
                  const SizedBox(height: 16),

                // Models Dropdown (required and only shown if brand is selected)
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
                          CommonDropdown<CategoryModel?>(
                            title: "${StringHelper.models} *",
                            titleColor: Colors.black,
                            hint: viewModel.modelTextController.text,
                            listItemBuilder: (context, model, selected, fxn) {
                              return Text(model?.name ?? '');
                            },
                            headerBuilder: (context, selectedItem, enabled) {
                              return Text(selectedItem?.name ?? "");
                            },
                            onSelected: (value) {
                              field.didChange(value);
                              field.validate();
                              viewModel.selectedModel = value;
                              viewModel.modelTextController.text =
                                  value?.name ?? '';
                            },
                            options: viewModel.allModels,
                          ),
                          if (field.hasError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(
                                  color: Color.fromARGB(223, 177, 31, 31),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                if (subCategory?.id == 13 && viewModel.selectedBrand != null)
                  const SizedBox(height: 16),

                // Year Dropdown (required for specific IDs)
                Visibility(
                  visible: [13, 26, 98, 27].contains(subCategory?.id),
                  child: Column(
                    children: [
                      FormField<String?>(
                        initialValue:
                            viewModel.yearTextController.text.isNotEmpty
                                ? viewModel.yearTextController.text
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
                              CommonDropdown<String?>(
                                title: "${StringHelper.year} *",
                                titleColor: Colors.black,
                                hint: viewModel.yearTextController.text,
                                onSelected: (String? value) {
                                  field.didChange(value);
                                  field.validate();
                                  viewModel.yearTextController.text =
                                      value ?? '';
                                },
                                options: viewModel.yearsType,
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

                // Common field: Fuel Type (required)
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
                        CommonDropdown<String?>(
                          title: "${StringHelper.fuel} *",
                          titleColor: Colors.black,
                          hint: viewModel.fuelTextController.text,
                          onSelected: (String? value) {
                            field.didChange(value);
                            field.validate();
                            viewModel.fuelTextController.text = value ?? '';
                          },
                          options: viewModel.fuelsType,
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
                const SizedBox(height: 16),

                // Fields only for cars for sale (ID 13)
                if (subCategory?.id == 13) ...[
                  CommonDropdown<String>(
                    title: StringHelper.carColorTitle,
                    titleColor: Colors.black,
                    hint: viewModel.carColorTextController.text,
                    onSelected: (String? value) {
                      viewModel.carColorTextController.text = value ?? '';
                    },
                    options: StringHelper.carColorOptions,
                  ),
                  const SizedBox(height: 16),
                  CommonDropdown<String>(
                    title: StringHelper.interiorColorTitle,
                    titleColor: Colors.black,
                    hint: viewModel.interiorColorTextController.text,
                    onSelected: (String? value) {
                      viewModel.interiorColorTextController.text = value ?? '';
                    },
                    options: StringHelper.carColorOptions,
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
                    options: viewModel.horsepowerOptions,
                  ),
                  const SizedBox(height: 16),
                  CommonDropdown<String>(
                    title: StringHelper.numbDoorsTitle,
                    titleColor: Colors.black,
                    hint: viewModel.numbDoorsTextController.text,
                    onSelected: (String? value) {
                      viewModel.numbDoorsTextController.text = value ?? '';
                    },
                    options: viewModel.numbDoorsOptions,
                  ),
                  const SizedBox(height: 16),
                  CommonDropdown<String>(
                    title: StringHelper.engineCapacityTitle,
                    titleColor: Colors.black,
                    hint: viewModel.engineCapacityTextController.text,
                    onSelected: (String? value) {
                      viewModel.engineCapacityTextController.text = value ?? '';
                    },
                    options: viewModel.engineCapacityOptions,
                  ),
                  const SizedBox(height: 16),
                ],

                // Common field: Body Type (required)
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
                        CommonDropdown<String?>(
                          title: "${StringHelper.bodyTypeTitle} *",
                          titleColor: Colors.black,
                          hint: viewModel.bodyTypeTextController.text.isEmpty
                              ? ""
                              : viewModel.bodyTypeTextController.text,
                          onSelected: (String? value) {
                            field.didChange(value);
                            field.validate();
                            viewModel.bodyTypeTextController.text = value ?? '';
                          },
                          options: StringHelper.bodyTypeOptions,
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
                const SizedBox(height: 16),

                // Common field: Transmission
                FormField<int>(
                  initialValue: viewModel.transmission,
                  validator: (value) {
                    if (value == 0) {
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
                            GestureDetector(
                              onTap: () {
                                viewModel.transmission = 1; // Update viewModel
                                field.didChange(1); // Update FormField value
                                field
                                    .validate(); // Trigger validation to clear error
                              },
                              child: Container(
                                width: 130,
                                height: 50,
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
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                viewModel.transmission = 2; // Update viewModel
                                field.didChange(2); // Update FormField value
                                field
                                    .validate(); // Trigger validation to clear error
                              },
                              child: Container(
                                width: 130,
                                height: 50,
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
                        return StringHelper.enterValidNumber;
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
                        return StringHelper
                            .fieldShouldNotBeEmpty; // Error message
                      }
                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonDropdown<String>(
                            title:
                                "${StringHelper.rentalCarTerm} *", // Add asterisk
                            titleColor: Colors.black,
                            hint: viewModel
                                    .carRentalTermTextController.text.isEmpty
                                ? ""
                                : viewModel.carRentalTermTextController.text,
                            onSelected: (String? value) {
                              field.didChange(value); // Update FormField value
                              field.validate(); // Trigger validation
                              viewModel.carRentalTermTextController.text =
                                  value ?? '';
                            },
                            options: viewModel.carRentalTermOptions,
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
                      return StringHelper.descriptionIsRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Common field: Location (required)
                AppTextField(
                  title: "${StringHelper.location} *",
                  titleColor: Colors.black,
                  controller: viewModel.addressTextController,
                  hint: StringHelper.select,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji),
                    ),
                  ],
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return StringHelper.locationIsRequired;
                    }
                    return null;
                  },
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
                      if (amount > 600000) {
                        return "${StringHelper.maxValidPrice} 600,000";
                      }
                    } else {
                      if (amount > 50000000) {
                        return "${StringHelper.maxValidPrice} 50,000,000";
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                      if (viewModel.yearTextController.text.trim().isEmpty &&
                          subCategory?.id == 13) {
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
                      if (viewModel.yearTextController.text.trim().isEmpty &&
                          subCategory?.id == 13) {
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
