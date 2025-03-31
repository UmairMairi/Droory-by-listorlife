import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';

import '../../../../../base/helpers/dialog_helper.dart';
import '../../../../../base/helpers/string_helper.dart';
import '../../../../../models/category_model.dart';
import '../../../../../models/product_detail_model.dart';
import '../../../../../view_model/sell_forms_vm.dart';
import '../../../../../widgets/amenities_widget.dart';
import '../../../../../widgets/app_map_widget.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/common_dropdown.dart';
import '../../../../../widgets/multi_select_category.dart';

class LandForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: false,
          child: AppTextField(
            title: StringHelper.propertyType,
            hint: StringHelper.select,
            controller: viewModel.propertyForTextController,
            readOnly: true,
            suffix: PopupMenuButton<String>(
              clipBehavior: Clip.hardEdge,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              onSelected: (String value) {
                viewModel.currentPropertyType = value;
                viewModel.propertyForTextController.text = value;
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
                RegExp(viewModel.regexToRemoveEmoji),
              ),
            ],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            fillColor: Colors.white,
            elevation: 6,
          ),
        ),
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
          fillColor: Colors.white,
          elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.type,
          hint: viewModel.propertyForTypeTextController.text,
          onSelected: (String? value) {
            viewModel.propertyForTypeTextController.text = value ?? "";
          },
          options: [
            "Agricultural Land",
            "Commercial Land",
            "Residential Land",
            "Industrial Land",
            "Mixed-Use Land",
            "Farm Land"
          ],
        ),
        AppTextField(
          title: StringHelper.areaSize,
          hint: StringHelper.enter,
          controller: viewModel.areaSizeTextController,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          maxLength: 7, // Adjusted for max 2,000,000
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(viewModel.regexToRemoveEmoji)),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '* This field is required';
            }

            final amount = num.tryParse(value);

            if (amount == null) {
              return '* Please enter a valid number';
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
        accessToUtilitiesWidget(context),
        paymentOptionWidget(context),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: StringHelper.rentalTerm,
            hint: viewModel.rentalTermsTextController.text,
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value ?? "";
            },
            options: [
              StringHelper.daily,
              StringHelper.weekly,
              StringHelper.monthly,
              StringHelper.yearly
            ],
          ),
        ),
        // Commented out as per previous requirements
        // Visibility(
        //   visible: viewModel.currentPropertyType.toLowerCase() == "rent",
        //   child: AppTextField(
        //     title: StringHelper.rentalPrice,
        //     controller: viewModel.rentalPriceTextController,
        //     hint: StringHelper.enterPrice,
        //     keyboardType: TextInputType.number,
        //     textInputAction: TextInputAction.done,
        //     maxLength: 6,
        //     inputFormatters: [
        //       FilteringTextInputFormatter.deny(
        //           RegExp(viewModel.regexToRemoveEmoji)),
        //       FilteringTextInputFormatter.digitsOnly,
        //     ],
        //     validator: (value) {
        //       if (value == null || value.trim().isEmpty) {
        //         return '* This field is required';
        //       }
        //
        //       final amount = num.tryParse(value);
        //
        //       if (amount == null) {
        //         return '* Please enter a valid number';
        //       }
        //
        //       if (amount < 1000) {
        //         return '* The minimum valid price is EGP 1000';
        //       }
        //
        //       if (amount > 3000000) {
        //         return '* The maximum valid price is EGP 1,000,000';
        //       }
        //
        //       return null;
        //     },
        //   ),
        // ),
        AppTextField(
          title: StringHelper.location,
          controller: viewModel.addressTextController,
          hint: StringHelper.select,
          readOnly: true,
          onTap: () async {
            Map<String, dynamic>? value = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppMapWidget()),
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
          suffix: Icon(Icons.location_on),
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(viewModel.regexToRemoveEmoji)),
          ],
          maxLines: 2,
          minLines: 1,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
        AppTextField(
          title: StringHelper.priceEgp,
          controller: viewModel.priceTextController,
          hint: StringHelper.enterPrice,
          maxLength: 10, // Adjusted for max 2,500,000,000
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
              return '* This field is required';
            }

            final amount = num.tryParse(value);

            if (amount == null) {
              return '* Please enter a valid number';
            }

            if (amount < 1000) {
              return '* The minimum valid price is EGP 1000';
            }

            if (viewModel.currentPropertyType.toLowerCase() == "rent") {
              if (amount > 5000000) {
                return '* The maximum valid price for rent is EGP 5,000,000';
              }
            } else if (viewModel.currentPropertyType.toLowerCase() == "sell") {
              if (amount > 2500000000) {
                return '* The maximum valid price for sale is EGP 2,500,000,000';
              }
            }

            return null;
          },
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  title: StringHelper.deposit,
                  controller: viewModel.depositTextController,
                  hint: StringHelper.enter,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: 7, // Adjusted for max 5,000,000
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final amount = num.tryParse(value);
                      if (amount == null) {
                        return '* ${StringHelper.enterValidNumber}';
                      }
                      final rentAmount =
                          num.tryParse(viewModel.priceTextController.text) ?? 0;
                      if (rentAmount > 0 && amount > rentAmount) {
                        return '* ${StringHelper.depositExceedPrice}';
                      }
                      if (amount > 5000000) {
                        return '* ${StringHelper.maxValidPrice} 5,000,000';
                      }
                    }
                    return null; // Deposit is not required
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: AppTextField(
                  title: "${StringHelper.depositPercentage} ",
                  controller: viewModel.percentageController,
                  hint: "%",
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: 3,
                  readOnly: viewModel.priceTextController.text.isEmpty ||
                      num.tryParse(viewModel.priceTextController.text) == null,
                  onTap: viewModel.priceTextController.text.isEmpty ||
                          num.tryParse(viewModel.priceTextController.text) ==
                              null
                      ? null
                      : () {},
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final percentage = num.tryParse(value);
                      if (percentage == null)
                        return '* ${StringHelper.invalidPercentage}';
                      if (percentage <= 0)
                        return '* ${StringHelper.mustBeGreaterThanZero}';
                      if (percentage > 100)
                        return '* ${StringHelper.maxOneHundredPercent}';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        AppTextField(
          title: StringHelper.describeWhatYouAreSelling,
          controller: viewModel.descriptionTextController,
          hint: StringHelper.enter,
          maxLines: 4,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(viewModel.regexToRemoveEmoji)),
          ],
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
        Visibility(
          visible: false,
          child: AmenitiesWidget(
            amenitiesChecked: viewModel.amenities,
            selectedAmenities: (List<int?> selectedIds) {
              debugPrint("$selectedIds");
              viewModel.amenities = selectedIds;
              debugPrint("${viewModel.amenities}");
            },
          ),
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
              viewModel.formKey.currentState?.validate();
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
              if (viewModel.propertyForTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectPropertyType);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().length < 10) {
                DialogHelper.showToast(
                  message: StringHelper.adLength,
                );
                return;
              }
              if (viewModel.propertyForTypeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsSelectType);
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsAddArea);
                return;
              }
              if (viewModel.accessToUtilitiesTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsEnterAccessUtilities);
                return;
              }
              if (viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectPaymentType);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&
                  viewModel.rentalTermsTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectRentalTerms);
                return;
              }
              if (viewModel.addressTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.locationIsRequired);
                return;
              }
              if (viewModel.priceTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.priceIsRequired);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&
                  viewModel.depositTextController.text.isNotEmpty) {
                // Validate deposit amount
                final depositAmount =
                    num.tryParse(viewModel.depositTextController.text);
                final priceAmount =
                    num.tryParse(viewModel.priceTextController.text) ?? 0;

                if (depositAmount == null) {
                  DialogHelper.showToast(
                      message: StringHelper.depositValidAmount);
                  return;
                }

                if (priceAmount > 0 && depositAmount > priceAmount) {
                  DialogHelper.showToast(
                      message: StringHelper.depositExceedPrice);
                  return;
                }
              }

// Check if deposit percentage is valid when present
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&
                  viewModel.percentageController.text.isNotEmpty) {
                // Validate deposit percentage
                final percentage =
                    num.tryParse(viewModel.percentageController.text);

                if (percentage == null) {
                  DialogHelper.showToast(
                      message: StringHelper.percentageValidAmount);
                  return;
                }

                if (percentage <= 0) {
                  DialogHelper.showToast(
                      message: StringHelper.percentageGreaterZero);
                  return;
                }

                if (percentage > 100) {
                  DialogHelper.showToast(
                      message: StringHelper.percentageExceed100);
                  return;
                }
              }
              if (viewModel.descriptionTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.descriptionIsRequired);
                return;
              }
              DialogHelper.showLoading();
              viewModel.editProduct(
                  productId: item?.id,
                  category: category,
                  subCategory: subCategory,
                  subSubCategory: subSubCategory,
                  brand: viewModel.selectedBrand,
                  models: viewModel.selectedModel);
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
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        } else ...{
          GestureDetector(
            onTap: () {
              viewModel.formKey.currentState?.validate();
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
              if (viewModel.propertyForTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectPropertyType);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().length < 10) {
                DialogHelper.showToast(
                  message: StringHelper.adLength,
                );
                return;
              }
              if (viewModel.propertyForTypeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsSelectType);
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsAddArea);
                return;
              }
              if (viewModel.accessToUtilitiesTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsEnterAccessUtilities);
                return;
              }
              if (viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectPaymentType);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&
                  viewModel.rentalTermsTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectRentalTerms);
                return;
              }
              if (viewModel.addressTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.locationIsRequired);
                return;
              }
              if (viewModel.priceTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.priceIsRequired);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&
                  viewModel.depositTextController.text.isNotEmpty) {
                // Validate deposit amount
                final depositAmount =
                    num.tryParse(viewModel.depositTextController.text);
                final priceAmount =
                    num.tryParse(viewModel.priceTextController.text) ?? 0;

                if (depositAmount == null) {
                  DialogHelper.showToast(
                      message: StringHelper.depositValidAmount);
                  return;
                }

                if (priceAmount > 0 && depositAmount > priceAmount) {
                  DialogHelper.showToast(
                      message: StringHelper.depositExceedPrice);
                  return;
                }
              }

// Check if deposit percentage is valid when present
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&
                  viewModel.percentageController.text.isNotEmpty) {
                // Validate deposit percentage
                final percentage =
                    num.tryParse(viewModel.percentageController.text);

                if (percentage == null) {
                  DialogHelper.showToast(
                      message: StringHelper.percentageValidAmount);
                  return;
                }

                if (percentage <= 0) {
                  DialogHelper.showToast(
                      message: StringHelper.percentageGreaterZero);
                  return;
                }

                if (percentage > 100) {
                  DialogHelper.showToast(
                      message: StringHelper.percentageExceed100);
                  return;
                }
              }
              if (viewModel.descriptionTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.descriptionIsRequired);
                return;
              }
              DialogHelper.showLoading();
              viewModel.addProduct(
                  category: category,
                  subCategory: subCategory,
                  subSubCategory: subSubCategory,
                  brand: viewModel.selectedBrand,
                  models: viewModel.selectedModel);
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
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        },
      ],
    );
  }

  accessToUtilitiesWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.accessToUtilities,
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StringHelper.waterSupply,
            StringHelper.electricity,
            StringHelper.gas,
            StringHelper.sewageSystem,
            StringHelper.roadAccess
          ].map((status) {
            return StatefulBuilder(
              builder: (context, setState) {
                bool isSelected = viewModel.currentAccessToUtilities
                    .split(",")
                    .contains(status);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: isSelected
                      ? Icon(Icons.radio_button_checked,
                          color: Theme.of(context).primaryColor)
                      : Icon(Icons.radio_button_unchecked,
                          color: Theme.of(context).disabledColor),
                  title: Text(
                    status,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  onTap: () {
                    List<String> utilities = viewModel.currentAccessToUtilities
                        .split(",")
                        .where((e) => e.isNotEmpty)
                        .toList();

                    if (isSelected) {
                      utilities.remove(
                          status); // Remove the status if already selected
                    } else {
                      utilities.add(status); // Add the status if not selected
                    }

                    // Update viewModel variables
                    viewModel.currentAccessToUtilities = utilities.join(",");
                    viewModel.accessToUtilitiesTextController.text =
                        viewModel.currentAccessToUtilities;

                    setState(() {}); // Rebuild the UI
                  },
                );
              },
            );
          }).toList(),
        )
      ],
    );
  }

  paymentOptionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.paymentType,
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StringHelper.installment,
            StringHelper.cashOrInstallment,
            StringHelper.cash
          ].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title:
                  Text(status, style: Theme.of(context).textTheme.titleSmall),
              value: status,
              groupValue: viewModel.currentPaymentOption.isNotEmpty
                  ? viewModel.currentPaymentOption.capitalized
                  : "",
              onChanged: (String? value) {
                viewModel.paymentTypeTextController.text = value ?? "";
                viewModel.currentPaymentOption = value ?? "";
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  completionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.completionStatus,
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [StringHelper.ready, StringHelper.offPlan].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title:
                  Text(status, style: Theme.of(context).textTheme.titleSmall),
              value: status,
              groupValue: viewModel.currentCompletion.capitalized,
              onChanged: (String? value) {
                viewModel.completionStatusTextController.text = value ?? "";
                viewModel.currentCompletion = value ?? "";
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  deliveryTermWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.deliveryTerm,
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StringHelper.moveInReady,
            StringHelper.underConstruction,
            StringHelper.shellAndCore,
            StringHelper.semiFinished
          ].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title:
                  Text(status, style: Theme.of(context).textTheme.titleSmall),
              value: status,
              groupValue: viewModel.currentDeliveryTerm.capitalized,
              onChanged: (String? value) {
                viewModel.deliveryTermTextController.text = value ?? "";
                viewModel.currentDeliveryTerm = value ?? "";
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
