import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import "package:list_and_life/widgets/sell_form_location_screen.dart";
import '../../../../../base/helpers/dialog_helper.dart';
import '../../../../../base/helpers/string_helper.dart';
import '../../../../../models/category_model.dart';
import '../../../../../models/product_detail_model.dart';
import '../../../../../view_model/sell_forms_vm.dart';
import '../../../../../widgets/amenities_widget.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/multi_select_category.dart';
import '../../../../../widgets/phone_form_verification_widget.dart';

class BusinessForm extends StatefulWidget {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  final SellFormsVM viewModel;

  const BusinessForm({
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
  State<BusinessForm> createState() => _BusinessFormState();
}

class _BusinessFormState extends State<BusinessForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isMounted = false;
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    widget.viewModel.addListener(_onViewModelUpdate);
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

  // Helper method to get appropriate text size based on language
  double _getTextSize(BuildContext context) {
    // Check multiple ways to detect Arabic
    final locale = Localizations.localeOf(context);
    final direction = Directionality.of(context);

    // Check if locale is Arabic or direction is RTL
    if (locale.languageCode == 'ar' || direction == TextDirection.rtl) {
      return 14.0; // Bigger for Arabic
    }
    return 12.0; // Smaller for English
  }

  void _performSubmit(BuildContext context) {
    setState(() {
      _hasAttemptedSubmit = true;
    });

    bool isValid = true;

    // Check phone verification first
    if (!widget.viewModel.isPhoneVerified ||
        widget.viewModel.currentPhone == null ||
        widget.viewModel.currentPhone!.isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      isValid = false;
    }

    // Validate FormFields using the FormKey
    if (!_formKey.currentState!.validate()) {
      isValid = false;
    }

    // Imperative checks
    if (widget.viewModel.mainImagePath.isEmpty) {
      DialogHelper.showToast(message: StringHelper.pleaseUploadMainImage);
      isValid = false;
    }
    if (widget.viewModel.imagesList.isEmpty) {
      DialogHelper.showToast(
          message: StringHelper.pleaseUploadAddAtLeastOneImage);
      isValid = false;
    }

    if (widget.viewModel.propertyForTextController.text.isEmpty) {
      DialogHelper.showToast(message: StringHelper.plsSelectPropertyType);
      isValid = false;
    }

    if (widget.viewModel.propertyForTypeTextController.text.isEmpty) {
      DialogHelper.showToast(message: StringHelper.plsSelectType);
      isValid = false;
    }

    if (widget.viewModel.currentPropertyType.toLowerCase() != "rent" &&
        widget.viewModel.completionStatusTextController.text.isEmpty) {
      DialogHelper.showToast(message: StringHelper.plsSelectCompletionStatus);
      isValid = false;
    }

    if (widget.viewModel.currentPropertyType.toLowerCase() != "rent" &&
        widget.viewModel.paymentTypeTextController.text.isEmpty) {
      DialogHelper.showToast(message: StringHelper.plsSelectPaymentType);
      isValid = false;
    }

    if (widget.viewModel.currentPropertyType.toLowerCase() == "rent" &&
        widget.viewModel.rentalTermsTextController.text.isEmpty) {
      DialogHelper.showToast(message: StringHelper.plsSelectRentalTerm);
      isValid = false;
    }

    // Deposit amount vs rent amount (if rent and deposit is entered)
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
        models: widget.viewModel.selectedModel,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double fieldSpacing = 16;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: false,
            child: AppTextField(
              title: StringHelper.propertyType,
              hint: StringHelper.select,
              controller: widget.viewModel.propertyForTextController,
              readOnly: true,
              suffix: PopupMenuButton<String>(
                clipBehavior: Clip.hardEdge,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                onSelected: (String value) {
                  widget.viewModel.currentPropertyType = value;
                  widget.viewModel.propertyForTextController.text = value;
                },
                itemBuilder: (BuildContext context) {
                  return ['Sell', 'Rent'].map((option) {
                    return PopupMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(widget.viewModel.regexToRemoveEmoji),
                ),
              ],
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              fillColor: Colors.white,
              elevation: 6,
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
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.factory,
                              LucideIcons.factory,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.fullBuilding,
                              LucideIcons.building_2,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.garage,
                              LucideIcons.car,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.warehouse,
                              LucideIcons.warehouse,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.restaurantCafe,
                              LucideIcons.utensils,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.offices,
                              LucideIcons.briefcase,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.medicalFacility,
                              LucideIcons.heart_handshake,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.showroom,
                              LucideIcons.store,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.hotelMotel,
                              LucideIcons.bed,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.gasStation,
                              LucideIcons.fuel,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.storageFacility,
                              LucideIcons.archive,
                              field,
                            ),
                            _buildBusinessTypeOption(
                              context,
                              StringHelper.other,
                              // LucideIcons.moreHorizontal,
                              LucideIcons.message_circle_more,
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
            title: "${StringHelper.area} *",
            hint: StringHelper.enter,
            controller: widget.viewModel.areaSizeTextController,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            textInputAction: TextInputAction.done,
            fillColor: Colors.white,
            elevation: 8,
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
              if (amount < 50) {
                return '* ${StringHelper.minValidAreaSize} 50';
              }
              if (amount > 1000000) {
                return '* ${StringHelper.maxValidAreaSize} 1,000,000';
              }
              return null;
            },
          ),
          const SizedBox(height: fieldSpacing),
          _buildFurnishedWidget(context),
          const SizedBox(height: fieldSpacing),
          Visibility(
            visible:
                widget.viewModel.currentPropertyType.toLowerCase() != "rent",
            child: Column(
              children: [
                FormField<String>(
                  initialValue:
                      widget.viewModel.completionStatusTextController.text,
                  validator: (value) {
                    if (widget.viewModel.currentPropertyType.toLowerCase() !=
                            "rent" &&
                        (value == null || value.trim().isEmpty)) {
                      return StringHelper.plsSelectCompletionStatus;
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCompletionWidget(context, field),
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
          Visibility(
            visible:
                widget.viewModel.currentPropertyType.toLowerCase() != "rent",
            child: Column(
              children: [
                FormField<String>(
                  initialValue: widget.viewModel.paymentTypeTextController.text,
                  validator: (value) {
                    if (widget.viewModel.currentPropertyType.toLowerCase() !=
                            "rent" &&
                        (value == null || value.trim().isEmpty)) {
                      return StringHelper.plsSelectPaymentType;
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPaymentOptionWidget(context, field),
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
                      return StringHelper.plsSelectRentalTerm;
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
                            StringHelper.yearly,
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

          // AMENITIES SECTION - Moved before location, price, description
          AmenitiesWidget(
            amenitiesChecked: widget.viewModel.amenities,
            selectedAmenities: (List<int?> selectedIds) {
              widget.viewModel.amenities = selectedIds;
            },
          ),
          const SizedBox(height: fieldSpacing),

          // LOCATION FIELD - Moved after amenities
          AppTextField(
            title: "${StringHelper.location} *",
            titleColor: Colors.black,
            hint: StringHelper.select,
            readOnly: true,
            controller: widget.viewModel.addressTextController,
            suffix: Icon(Icons.location_on, color: Colors.grey.shade600),
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            onTap: () async {
              Map<String, dynamic>? returnedLocationData = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SellFormLocationScreen(viewModel: widget.viewModel)),
              );

              if (returnedLocationData != null &&
                  returnedLocationData.isNotEmpty &&
                  mounted) {
                widget.viewModel
                    .handleLocationSelectedFromAdForm(returnedLocationData);
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

          // PRICE FIELD - Moved after amenities and location
          AppTextField(
            title: "${StringHelper.priceEgp} *",
            controller: widget.viewModel.priceTextController,
            hint: StringHelper.enterPrice,
            maxLength: 11,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(11),
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
                if (amount > 1000000) {
                  return '* ${StringHelper.maxValidPrice} 1,000,000';
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

          // DEPOSIT FIELD - Only for rent, moved after price
          Visibility(
            visible:
                widget.viewModel.currentPropertyType.toLowerCase() == "rent",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (amount > 1000000) {
                              return '* ${StringHelper.maxValidPrice} 1,000,000';
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

          // DESCRIPTION FIELD - Moved after price and deposit
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

          // PHONE VERIFICATION - After description
          PhoneVerificationWidget(
            onPhoneStatusChanged: (isVerified, phone) {
              widget.viewModel.updatePhoneVerificationStatus(isVerified, phone);
            },
            onAutoSubmit: () {
              _performSubmit(context);
            },
          ),
          const SizedBox(height: fieldSpacing),

          // HOW TO CONNECT - After phone verification
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

          // SUBMIT BUTTONS
          if (widget.viewModel.isEditProduct) ...[
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
                  widget.viewModel.adStatus == "deactivate"
                      ? StringHelper.updateRepublish
                      : StringHelper.updateNow,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ] else ...[
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
                  StringHelper.postNow,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletionWidget(
      BuildContext context, FormFieldState<String> field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${StringHelper.completionStatus} *",
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [StringHelper.ready, StringHelper.offPlan].map((status) {
            bool isSelected = widget.viewModel.currentCompletion == status;
            return GestureDetector(
              onTap: () {
                widget.viewModel.completionStatusTextController.text = status;
                widget.viewModel.currentCompletion = status;
                field.didChange(status);
                field.validate();
                if (_isMounted) {
                  widget.viewModel.notifyListeners();
                }
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

  Widget _buildFurnishedWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.furnishing,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [StringHelper.yes, StringHelper.no].map((status) {
            bool isSelected = widget.viewModel.currentFurnishing == status;
            return GestureDetector(
              onTap: () {
                widget.viewModel.furnishingStatusTextController.text = status;
                widget.viewModel.currentFurnishing = status;
                if (_isMounted) {
                  widget.viewModel.notifyListeners();
                }
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

  Widget _buildPaymentOptionWidget(
      BuildContext context, FormFieldState<String> field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${StringHelper.paymentType} *",
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
                field.didChange(status);
                field.validate();
                if (_isMounted) {
                  widget.viewModel.notifyListeners();
                }
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

  // Helper widget for business type options with icons
  Widget _buildBusinessTypeOption(
    BuildContext context,
    String businessType,
    IconData iconData,
    FormFieldState<String> field,
  ) {
    bool isSelected =
        widget.viewModel.propertyForTypeTextController.text == businessType;

    return GestureDetector(
      onTap: () {
        widget.viewModel.propertyForTypeTextController.text = businessType;
        field.didChange(businessType);
        field.validate();
        if (_isMounted) {
          widget.viewModel.notifyListeners();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        width: 110, // Slightly wider for business names
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
              size: 28,
              color: isSelected
                  ? const Color.fromARGB(255, 59, 130, 246)
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                businessType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: _getTextSize(context),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.grey.shade700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
