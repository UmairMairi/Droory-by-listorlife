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

class VillaForm extends StatelessWidget {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  final SellFormsVM viewModel;
  const VillaForm({
    super.key,
    required this.viewModel,
    this.type,
    this.category,
    this.subCategory,
    this.subSubCategory,
    this.brands,
    this.item});

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
          ],
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          fillColor: Colors.white,
          elevation: 6,
        ),

        CommonDropdown(
          title: StringHelper.type,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTypeTextController.text,
          onSelected: (String? value) {
            debugPrint("value ==111=> $value");
            viewModel.propertyForTypeTextController.text = value??"";
            debugPrint("value ==222=> ${viewModel.propertyForTypeTextController.text}");
          },
          options: ["Stand Alone","Townhouse","Twin House","I-Villa","Mansion"],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.propertyForTypeTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Stand Alone","Townhouse","Twin House","I-Villa","Mansion"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),

        AppTextField(
          title: StringHelper.areaSize,
          hint: StringHelper.enter,
          controller: viewModel.areaSizeTextController,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          maxLength: 6,
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

            if (amount < 100) {
              return '* The minimum valid area size 100';
            }

            if (amount > 100000) {
              return '* The maximum valid area size is 100,000';
            }

            return null;
          },
          textInputAction: TextInputAction.done,
          fillColor: Colors.white,
          elevation: 6,
        ),

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: AppTextField(
            title: StringHelper.insurance,
            hint: StringHelper.enter,
            controller: viewModel.insuranceTextController,
            maxLines: 4,
            minLines: 1,
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

        CommonDropdown(
          title: StringHelper.noOfBedrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBedroomsTextController.text,
          onSelected: (String? value) {
            viewModel.noOfBedroomsTextController.text = value??"";
          },
          options: ["Studio", "1", "2", "3", "4", "5", "6+"],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBedroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Studio", "1", "2", "3", "4", "5", "6+"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),

        CommonDropdown(
          title: StringHelper.noOfBathrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBathroomsTextController.text,
          onSelected: (String? value) {
            viewModel.noOfBathroomsTextController.text = value??"";
          },
          options: ['1', '2', '3', '4', '5', '6', '7', '7+'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBathroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['1', '2', '3', '4', '5', '6', '7', '7+']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text('$option Bathrooms'),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.level,
          //hint: StringHelper.select,
          hint: viewModel.levelTextController.text,
          onSelected: (String? value) {
            viewModel.levelTextController.text = value??"";
          },
          options: [StringHelper.ground, "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "Last Floor"],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.levelTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Ground", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "Last Floor"]
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        furnishedWidget(context),

        Visibility(
        visible: viewModel.currentPropertyType.toLowerCase() != "rent",
        child:deliveryTermWidget(context)),

        Visibility(
        visible: viewModel.currentPropertyType.toLowerCase() != "rent",
        child:completionWidget(context)),

        Visibility(
        visible: viewModel.currentPropertyType.toLowerCase() != "rent",
        child:paymentOptionWidget(context)),

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: StringHelper.rentalTerm,
            //hint: StringHelper.select,
            hint: viewModel.rentalTermsTextController.text,
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value??"";
            },
            options: [StringHelper.daily, StringHelper.weekly, StringHelper.monthly, StringHelper.yearly],
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.rentalTermsTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Daily', 'Weekly', 'Monthly', 'Yearly']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),

        AppTextField(
          title: StringHelper.location,
          controller: viewModel.addressTextController,
          hint: StringHelper.select,
          readOnly: true,
          onTap: () async {
            Map<String, dynamic>? value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppMapWidget()));
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
          maxLength: 6,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
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

            if (amount > 100000) {
              return '* The maximum valid price is EGP 100,000';
            }

            return null;
          },

        ),

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: AppTextField(
            title: StringHelper.deposit,
            controller: viewModel.depositTextController,
            hint: StringHelper.enter,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 6,
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

              if (amount < 1000) {
                return '* The minimum valid price is EGP 1000';
              }

              if (amount > 100000) {
                return '* The maximum valid price is EGP 100,000';
              }

              return null;
            },
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

        AmenitiesWidget(
            amenitiesChecked: viewModel.amenities,
            selectedAmenities: (List<int?> selectedIds) {
              debugPrint("$selectedIds");
              viewModel.amenities = selectedIds;
              debugPrint("${viewModel.amenities}");
            }),

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
                DialogHelper.showToast(
                    message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().length < 10) {
                DialogHelper.showToast(
                  message: StringHelper.adLength,
                );
                return;
              }
              if (viewModel.propertyForTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectType);
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsAddArea);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.insuranceTextController.text.isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsSelectInsurance);
                return;
              }
              if (viewModel.noOfBedroomsTextController.text.isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsSelectBedrooms);
                return;
              }
              if (viewModel.noOfBathroomsTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectBathrooms);
                return;
              }
              if (viewModel.levelTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectLevel);
                return;
              }
              if (viewModel.furnishingStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectFurnishing);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.deliveryTermTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectDeliveryTerm);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.completionStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectCompletionStatus);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectPaymentType);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.rentalTermsTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectRentalTerm);
                return;
              }

              if (viewModel.addressTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.locationIsRequired);
                return;
              }
              if (viewModel.priceTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.priceIsRequired);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.depositTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsEnterDeposit);
                return;
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
                StringHelper.updateNow,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        }
        else ...{
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
                DialogHelper.showToast(
                    message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().length < 10) {
                DialogHelper.showToast(
                  message: StringHelper.adLength,
                );
                return;
              }
              if (viewModel.propertyForTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectType);
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsAddArea);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.insuranceTextController.text.isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsSelectInsurance);
                return;
              }
              if (viewModel.noOfBedroomsTextController.text.isEmpty) {
                DialogHelper.showToast(message: StringHelper.plsSelectBedrooms);
                return;
              }
              if (viewModel.noOfBathroomsTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectBathrooms);
                return;
              }
              if (viewModel.levelTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectLevel);
                return;
              }
              if (viewModel.furnishingStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectFurnishing);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.deliveryTermTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectDeliveryTerm);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.completionStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectCompletionStatus);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectPaymentType);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.rentalTermsTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsSelectRentalTerm);
                return;
              }

              if (viewModel.addressTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.locationIsRequired);
                return;
              }
              if (viewModel.priceTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.priceIsRequired);
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.depositTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.plsEnterDeposit);
                return;
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
                style: TextStyle(
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

  furnishedWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.furnishing,
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [StringHelper.yes, StringHelper.no].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentFurnishing,
              onChanged: (String? value) {
                viewModel.furnishingStatusTextController.text = value ?? "";
                viewModel.currentFurnishing = value??"";
              },
            );
          }).toList(),
        ),
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
          children: [StringHelper.installment, StringHelper.cashOrInstallment, StringHelper.cash].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentPaymentOption,
              onChanged: (String? value) {
                viewModel.paymentTypeTextController.text = value ?? "";
                viewModel.currentPaymentOption = value??"";
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
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentCompletion.capitalized,
              onChanged: (String? value) {
                viewModel.completionStatusTextController.text = value ?? "";
                viewModel.currentCompletion = value??"";
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
          children: [StringHelper.moveInReady,StringHelper.underConstruction,StringHelper.shellAndCore,StringHelper.semiFinished].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentDeliveryTerm.capitalized,
              onChanged: (String? value) {
                viewModel.deliveryTermTextController.text = value ?? "";
                viewModel.currentDeliveryTerm = value??"";
              },
            );
          }).toList(),
        ),
      ],
    );
  }

}
