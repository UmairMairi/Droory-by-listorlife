import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import '../../../../../base/helpers/dialog_helper.dart';
import '../../../../../base/helpers/string_helper.dart';
import '../../../../../models/category_model.dart';
import '../../../../../models/product_detail_model.dart';
import '../../../../../view_model/sell_forms_vm.dart';
import '../../../../../widgets/amenities_widget.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/common_dropdown.dart';
import '../../../../../widgets/multi_select_category.dart';
import '../../../../../widgets/phone_form_verification_widget.dart';

class LandForm extends StatefulWidget {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  final SellFormsVM viewModel;

  const LandForm({
    super.key,
    required this.viewModel,
    this.type,
    this.category,
    this.subCategory,
    this.subSubCategory,
    this.brands,
    this.item,
  });

  @override
  State<LandForm> createState() => _LandFormState();
}

class _LandFormState extends State<LandForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    widget.viewModel.addListener(_onViewModelUpdate);
    print("DEBUG LandForm initState:");
    print("  - widget.item is null? ${widget.item == null}");
    print(
        "  - hasInitializedForEdit = ${widget.viewModel.hasInitializedForEdit}");
    print("  - isEditProduct = ${widget.viewModel.isEditProduct}");

    if (widget.item != null && !widget.viewModel.hasInitializedForEdit) {
      print("DEBUG: Will initialize form with item data");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("DEBUG: Calling updateTextFieldsItems");
        widget.viewModel.updateTextFieldsItems(item: widget.item);
        widget.viewModel.hasInitializedForEdit = true;
        print("DEBUG: Set hasInitializedForEdit = true");
      });
    } else {
      print("DEBUG: Skipping initialization - why?");
      if (widget.item == null) print("  - item is null");
      if (widget.viewModel.hasInitializedForEdit)
        print("  - hasInitializedForEdit is already true");
    }
  }

  void _onViewModelUpdate() {
    if (_isMounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    widget.viewModel.removeListener(_onViewModelUpdate);
    super.dispose();
  }

  void _performSubmit(BuildContext context) {
    // 1. Validate all FormFields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Perform imperative checks for fields not handled by FormFields
    bool isValid = true;

    // FIX: Added phone verification check to match other forms
    if (!widget.viewModel.isPhoneVerified ||
        widget.viewModel.currentPhone == null ||
        widget.viewModel.currentPhone!.isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      isValid = false;
    }

    if (widget.viewModel.mainImagePath.isEmpty) {
      DialogHelper.showToast(message: StringHelper.pleaseUploadMainImage);
      isValid = false;
    }
    if (widget.viewModel.imagesList.isEmpty) {
      DialogHelper.showToast(
          message: StringHelper.pleaseUploadAddAtLeastOneImage);
      isValid = false;
    }

    if (widget.viewModel.currentPropertyType.toLowerCase() == "rent" &&
        widget.viewModel.depositTextController.text.isNotEmpty) {
      final depositAmountNum =
          num.tryParse(widget.viewModel.depositTextController.text);
      final priceAmountNum =
          num.tryParse(widget.viewModel.priceTextController.text) ?? 0;
      if (depositAmountNum != null &&
          priceAmountNum > 0 &&
          depositAmountNum > priceAmountNum) {
        DialogHelper.showToast(message: StringHelper.depositExceedPrice);
        isValid = false;
      }
    }

    if (!isValid) {
      return;
    }

    // 3. If all is valid, show loading and submit
    DialogHelper.showLoading();
    if (widget.viewModel.isEditProduct) {
      widget.viewModel.editProduct(
        productId: widget.item?.id,
        category: widget.category,
        subCategory: widget.subCategory,
        subSubCategory: widget.subSubCategory,
        brand: widget.viewModel.selectedBrand,
        models: widget.viewModel.selectedModel,
        onSuccess: () {
          if (mounted) {
            Navigator.pop(context, true);
          }
        },
      );
    } else {
      widget.viewModel.addProduct(
          category: widget.category,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
          brand: widget.viewModel.selectedBrand,
          models: widget.viewModel.selectedModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double fieldSpacing = 16.0;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            child: AppTextField(
              controller: widget.viewModel.propertyForTextController,
            ),
          ),
          const SizedBox(height: fieldSpacing),
          AppTextField(
            title: "${StringHelper.adTitle} *",
            hint: StringHelper.enter,
            controller: widget.viewModel.adTitleTextController,
            maxLines: 4,
            minLines: 1,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                RegExp(widget.viewModel.regexToRemoveEmoji),
              ),
              LengthLimitingTextInputFormatter(65),
            ],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            fillColor: Colors.white,
            elevation: 6,
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
          const SizedBox(height: fieldSpacing),

          // UPDATED: Changed from dropdown to horizontal cards like ApartmentForm and VillaForm
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${StringHelper.type} *",
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              FormField<String>(
                initialValue:
                    widget.viewModel.propertyForTypeTextController.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return StringHelper.plsSelectType;
                  }
                  return null;
                },
                builder: (FormFieldState<String> field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildLandTypeOption(
                              context,
                              StringHelper.agriculturalLand,
                              Icons.agriculture,
                              field,
                            ),
                            _buildLandTypeOption(
                              context,
                              StringHelper.commercialLand,
                              Icons.business,
                              field,
                            ),
                            _buildLandTypeOption(
                              context,
                              StringHelper.residentialLand,
                              Icons.home_outlined,
                              field,
                            ),
                            _buildLandTypeOption(
                              context,
                              StringHelper.industrialLand,
                              Icons.factory,
                              field,
                            ),
                            _buildLandTypeOption(
                              context,
                              StringHelper.mixedLand,
                              Icons.landscape,
                              field,
                            ),
                            _buildLandTypeOption(
                              context,
                              StringHelper.farmLand,
                              Icons.grass,
                              field,
                            ),
                          ],
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: Color(0xFFD32F2F),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: fieldSpacing),
          AppTextField(
            title: "${StringHelper.areaSize} *",
            hint: StringHelper.enter,
            controller: widget.viewModel.areaSizeTextController,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            maxLength: 8,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(widget.viewModel.regexToRemoveEmoji)),
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '* ${StringHelper.fieldShouldNotBeEmpty}';
              }
              final amount = num.tryParse(value);
              if (amount == null) {
                return '* ${StringHelper.enterValidNumber}';
              }
              if (amount < 10) {
                return '* ${StringHelper.minValidAreaSize} 10';
              }
              if (amount > 2000000) {
                return '* ${StringHelper.maxValidAreaSize} 2,000,000';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            fillColor: Colors.white,
            elevation: 6,
          ),
          const SizedBox(height: fieldSpacing),
          accessToUtilitiesWidget(context),
          const SizedBox(height: fieldSpacing),
          Visibility(
            visible:
                widget.viewModel.currentPropertyType.toLowerCase() != "rent",
            child: Column(
              children: [
                paymentOptionWidget(context),
                const SizedBox(height: fieldSpacing),
              ],
            ),
          ),
          Visibility(
            visible:
                widget.viewModel.currentPropertyType.toLowerCase() == "rent",
            child: Column(
              children: [
                FormField<String>(
                  initialValue: widget.viewModel.rentalTermsTextController.text,
                  validator: (value) {
                    if (widget.viewModel.currentPropertyType.toLowerCase() ==
                            "rent" &&
                        (value == null || value.trim().isEmpty)) {
                      return StringHelper.plsSelectRentalTerms;
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonDropdown(
                          title: "${StringHelper.rentalTerm} *",
                          hint: widget.viewModel.rentalTermsTextController.text
                                  .isEmpty
                              ? StringHelper.select
                              : widget.viewModel.rentalTermsTextController.text,
                          onSelected: (String? value) {
                            widget.viewModel.rentalTermsTextController.text =
                                value ?? "";
                            field.didChange(value);
                            field.validate();
                          },
                          options: [
                            StringHelper.daily,
                            StringHelper.weekly,
                            StringHelper.monthly,
                            StringHelper.yearly
                          ],
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 5),
                            child: Text(
                              field.errorText!,
                              style: const TextStyle(
                                color: Color(0xFFD32F2F),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: fieldSpacing),
              ],
            ),
          ),
          AppTextField(
            title: "${StringHelper.location} *",
            titleColor: Colors.black,
            hint: StringHelper.select,
            readOnly: true,
            controller: widget.viewModel.addressTextController,
            suffix: Icon(Icons.location_on, color: Colors.grey.shade600),
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            onTap: () async {
              Map<String, dynamic>? returnedLocationData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SellFormLocationScreen(viewModel: widget.viewModel),
                ),
              );

              if (returnedLocationData != null &&
                  returnedLocationData.isNotEmpty &&
                  mounted) {
                widget.viewModel
                    .handleLocationSelectedFromAdForm(returnedLocationData);
                _formKey.currentState?.validate();
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
                  RegExp(widget.viewModel.regexToRemoveEmoji)),
            ],
            maxLines: 2,
          ),
          const SizedBox(height: fieldSpacing),
          AppTextField(
            title: "${StringHelper.priceEgp} *",
            controller: widget.viewModel.priceTextController,
            hint: StringHelper.enterPrice,
            maxLength: 11,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(widget.viewModel.regexToRemoveEmoji)),
              FilteringTextInputFormatter.digitsOnly,
            ],
            focusNode: widget.viewModel.priceText,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '* ${StringHelper.fieldShouldNotBeEmpty}';
              }
              final amount = num.tryParse(value);
              if (amount == null) {
                return '* ${StringHelper.enterValidNumber}';
              }
              if (amount < 1000) {
                return '* ${StringHelper.minValidPrice} 1000';
              }
              if (widget.viewModel.currentPropertyType.toLowerCase() ==
                  "rent") {
                if (amount > 5000000) {
                  return '* ${StringHelper.maxValidPrice} 5,000,000';
                }
              } else if (widget.viewModel.currentPropertyType.toLowerCase() ==
                  "sell") {
                if (amount > 2500000000) {
                  return '* ${StringHelper.maxValidPrice} 2,500,000,000';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: fieldSpacing),
          Visibility(
            visible:
                widget.viewModel.currentPropertyType.toLowerCase() == "rent",
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        title: StringHelper.deposit,
                        controller: widget.viewModel.depositTextController,
                        hint: StringHelper.enter,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        maxLength: 7,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(widget.viewModel.regexToRemoveEmoji)),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final amount = num.tryParse(value);
                            if (amount == null) {
                              return '* ${StringHelper.enterValidNumber}';
                            }
                            final rentAmount = num.tryParse(widget
                                    .viewModel.priceTextController.text) ??
                                0;
                            if (rentAmount > 0 && amount > rentAmount) {
                              return '* ${StringHelper.depositExceedPrice}';
                            }
                            if (amount > 5000000) {
                              return '* ${StringHelper.maxValidPrice} 5,000,000';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: AppTextField(
                        title: "${StringHelper.depositPercentage} ",
                        controller: widget.viewModel.percentageController,
                        hint: "%",
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        maxLength: 3,
                        readOnly:
                            widget.viewModel.priceTextController.text.isEmpty ||
                                num.tryParse(widget
                                        .viewModel.priceTextController.text) ==
                                    null,
                        onTap:
                            widget.viewModel.priceTextController.text.isEmpty ||
                                    num.tryParse(widget.viewModel
                                            .priceTextController.text) ==
                                        null
                                ? null
                                : () {},
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(widget.viewModel.regexToRemoveEmoji)),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final percentage = num.tryParse(value);
                            if (percentage == null) {
                              return '* ${StringHelper.invalidPercentage}';
                            }
                            if (percentage <= 0) {
                              return '* ${StringHelper.mustBeGreaterThanZero}';
                            }
                            if (percentage > 100) {
                              return '* ${StringHelper.maxOneHundredPercent}';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: fieldSpacing),
              ],
            ),
          ),
          AppTextField(
            title: "${StringHelper.describeWhatYouAreSelling} *",
            controller: widget.viewModel.descriptionTextController,
            hint: StringHelper.enter,
            maxLines: 4,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(widget.viewModel.regexToRemoveEmoji)),
            ],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return StringHelper.descriptionIsRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: fieldSpacing),
          Visibility(
            visible: false,
            child: AmenitiesWidget(
              amenitiesChecked: widget.viewModel.amenities,
              selectedAmenities: (List<int?> selectedIds) {
                widget.viewModel.amenities = selectedIds;
              },
            ),
          ),
          const SizedBox(height: fieldSpacing),

          // FIX: Added the PhoneVerificationWidget
          PhoneVerificationWidget(
            onPhoneStatusChanged: (isVerified, phone) {
              widget.viewModel.updatePhoneVerificationStatus(isVerified, phone);
            },
            onAutoSubmit: () {
              _performSubmit(context);
            },
          ),

          const SizedBox(height: fieldSpacing),
          Text(
            StringHelper.howToConnect,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: fieldSpacing),
          MultiSelectCategory(
            choiceString: widget.viewModel.communicationChoice,
            onSelectedCommunicationChoice: (CommunicationChoice value) {
              widget.viewModel.communicationChoice = value.name;
            },
          ),
          const SizedBox(height: fieldSpacing),
          GestureDetector(
            onTap: () => _performSubmit(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100)),
              child: Text(
                widget.viewModel.isEditProduct
                    ? (widget.viewModel.adStatus == "deactivate"
                        ? StringHelper.updateRepublish
                        : StringHelper.updateNow)
                    : StringHelper.postNow,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Added method to build land type option cards (same style as apartment/villa)
  Widget _buildLandTypeOption(
    BuildContext context,
    String landType,
    IconData iconData,
    FormFieldState<String> field,
  ) {
    bool isSelected =
        widget.viewModel.propertyForTypeTextController.text == landType;

    return GestureDetector(
      onTap: () {
        widget.viewModel.propertyForTypeTextController.text = landType;
        field.didChange(landType);
        field.validate();
        if (_isMounted) {
          widget.viewModel.notifyListeners();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        width: 110, // Increased width for longer land type names
        height: 95,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 59, 130, 246).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 59, 130, 246)
                : Colors.grey.shade300,
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
            Icon(
              iconData,
              size: 30,
              color: isSelected
                  ? const Color.fromARGB(255, 59, 130, 246)
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                landType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: _isCurrentLanguageArabic(context)
                      ? 12
                      : 11, // Bigger text for Arabic
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.grey.shade700,
                  height: 1.1, // Tighter line height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to check if current language is Arabic
  bool _isCurrentLanguageArabic(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  Widget accessToUtilitiesWidget(BuildContext context) {
    final Map<String, IconData> utilityIcons = {
      StringHelper.waterSupply: Icons.water_drop_outlined,
      StringHelper.electricity: Icons.electric_bolt_outlined,
      StringHelper.gas: Icons.local_fire_department_outlined,
      StringHelper.sewageSystem: Icons.plumbing_outlined,
      StringHelper.roadAccess: Icons.route_outlined,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.accessToUtilities,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: utilityIcons.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 1, thickness: 0.5, indent: 50),
          itemBuilder: (context, index) {
            final utility = utilityIcons.keys.elementAt(index);
            final isSelected = widget.viewModel.currentAccessToUtilities
                .split(",")
                .map((e) => e.trim())
                .contains(utility);

            return InkWell(
              splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
              highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
              onTap: () {
                List<String> utilities = widget
                    .viewModel.currentAccessToUtilities
                    .split(",")
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                if (isSelected) {
                  utilities.remove(utility);
                } else {
                  utilities.add(utility);
                }

                final newValue = utilities.join(", ");
                widget.viewModel.currentAccessToUtilities = newValue;
                widget.viewModel.accessToUtilitiesTextController.text =
                    newValue;

                widget.viewModel.notifyListeners();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      utilityIcons[utility],
                      size: 22,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        utility,
                        style: TextStyle(
                          fontSize: 15,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget paymentOptionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.paymentType,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StringHelper.installment,
            StringHelper.cash,
            StringHelper.cashOrInstallment,
          ].map((status) {
            final isSelected = widget.viewModel.currentPaymentOption == status;
            return GestureDetector(
              onTap: () {
                widget.viewModel.paymentTypeTextController.text = status;
                widget.viewModel.currentPaymentOption = status;
                widget.viewModel.notifyListeners();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color.fromARGB(255, 59, 130, 246)
                        : Colors.grey,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
