

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';

import '../../../../../base/helpers/dialog_helper.dart';
import '../../../../../base/helpers/string_helper.dart';
import '../../../../../models/category_model.dart';
import '../../../../../models/product_detail_model.dart';
import '../../../../../view_model/sell_forms_vm.dart';
import '../../../../../widgets/amenities_widget.dart';
import '../../../../../widgets/app_map_widget.dart';
import '../../../../../widgets/app_text_field.dart';
import '../../../../../widgets/multi_select_category.dart';

class BusinessForm extends StatelessWidget {
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
            viewModel.propertyForTypeTextController.text = value??"";
          },
          options: ["Factory", "Full building", "Garage", "Warehouse", "Clinic", "Restraunt/ cafe", "Offices", "Factory", "Pharmacy", "Medical facility", "Showroom", "Hotel/ motel", "Gas station", "Storage facility", "other"],
          //readOnly: true,
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
          //     return ["Factory", "Full building", "Garage", "Warehouse", "Clinic", "Restraunt/ cafe", "Offices", "Factory", "Pharmacy", "Medical facility", "Showroom", "Hotel/ motel", "Gas station", "Storage facility", "other"].map((option) {
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
          title: StringHelper.level,
          //hint: StringHelper.select,
          hint: viewModel.levelTextController.text,
          options: ["Ground", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "Last Floor"],
          onSelected: (String? value) {
            viewModel.levelTextController.text = value??"";
          },
          //readOnly: true,
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
        CommonDropdown(
          title: "No Of Bedrooms",
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
          title: StringHelper.furnishing,
          //hint: StringHelper.select,
          hint: viewModel.furnishingStatusTextController.text,
          onSelected: (String? value) {
            viewModel.furnishingStatusTextController.text = value??"";
          },
          options: ['Yes','No'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.furnishingStatusTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Yes','No']
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

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.completionStatus,
            //hint: StringHelper.select,
            hint: viewModel.completionStatusTextController.text,
            onSelected: (String? value) {
              viewModel.completionStatusTextController.text = value??"";
            },
            options: ['Ready', 'Off Plan'],
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.completionStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Ready', 'Off Plan'].map((option) {
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

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.paymentType,
            //hint: StringHelper.select,
            hint: viewModel.paymentTypeTextController.text,
            onSelected: (String? value) {
              viewModel.paymentTypeTextController.text = value??"";
            },
            options: ['Installment', 'Cash or Installment', 'cash'],
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.paymentTypeTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Installment', 'Cash or Installment', 'cash']
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
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: "Rental Term",
            //hint: StringHelper.select,
            hint: viewModel.rentalTermsTextController.text,
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value??"";
            },
            options: ['Daily', 'Weekly', 'Monthly', 'Yearly'],
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
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: AppTextField(
            title: "Rental Price",
            controller: viewModel.rentalPriceTextController,
            hint: StringHelper.enterPrice,
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(viewModel.regexToRemoveEmoji)),
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
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
              viewModel.addressTextController.text =
              "${value['location']}, ${value['city']}, ${value['state']}";
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
          maxLength: 8,
          inputFormatters: [
            FilteringTextInputFormatter.deny(
                RegExp(viewModel.regexToRemoveEmoji)),
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
        ),

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: AppTextField(
            title: "Deposit",
            controller: viewModel.depositTextController,
            hint: StringHelper.enter,
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp(viewModel.regexToRemoveEmoji)),
              FilteringTextInputFormatter.digitsOnly,
            ],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
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
                    message: 'Please select Property Type');
                return;
              }
              if (viewModel.adTitleTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().length < 10) {
                DialogHelper.showToast(
                  message: "Ad title must be at least 10 characters long.",
                );
                return;
              }
              if (viewModel.propertyForTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select Type');
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: 'Please add area of Property');
                return;
              }
              if (viewModel.noOfBedroomsTextController.text.isEmpty) {
                DialogHelper.showToast(message: 'Please select Bedrooms');
                return;
              }
              if (viewModel.noOfBathroomsTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select Bathrooms');
                return;
              }
              if (viewModel.furnishingStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select Furnishing');
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.rentalPriceTextController.text.isEmpty) {
                DialogHelper.showToast(message: 'Please enter rental price');
                return;
              }

              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.completionStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select completion status');
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select payment type');
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
                    message: 'Please select Property Type');
                return;
              }
              if (viewModel.adTitleTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.adTitleTextController.text.trim().length < 10) {
                DialogHelper.showToast(
                  message: "Ad title must be at least 10 characters long.",
                );
                return;
              }
              if (viewModel.propertyForTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select Type');
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: 'Please add area of Property');
                return;
              }
              if (viewModel.noOfBedroomsTextController.text.isEmpty) {
                DialogHelper.showToast(message: 'Please select Bedrooms');
                return;
              }
              if (viewModel.noOfBathroomsTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select Bathrooms');
                return;
              }
              if (viewModel.furnishingStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select Furnishing');
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" && viewModel.rentalPriceTextController.text.isEmpty) {
                DialogHelper.showToast(message: 'Please enter rental price');
                return;
              }

              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.completionStatusTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select completion status');
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() != "rent" && viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select payment type');
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
}
