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
    this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
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

        AppTextField(
          title: StringHelper.type,
          hint: StringHelper.select,
          controller: viewModel.propertyForTypeTextController,
          readOnly: true,
          suffix: PopupMenuButton<String>(
            clipBehavior: Clip.hardEdge,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            onSelected: (String value) {
              viewModel.propertyForTypeTextController.text = value;
            },
            itemBuilder: (BuildContext context) {
              return ["Agricultural Land","Commercial Land","Residential Land","Industrial Land","Mixed-Use Land","Farm Land"].map((option) {
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


        accessToUtilitiesWidget(context),

        paymentOptionWidget(context),

        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: AppTextField(
            title: "Rental Term",
            hint: StringHelper.select,
            controller: viewModel.rentalTermsTextController,
            readOnly: true,
            suffix: PopupMenuButton<String>(
              clipBehavior: Clip.hardEdge,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              onSelected: (String value) {
                viewModel.rentalTermsTextController.text = value;
              },
              itemBuilder: (BuildContext context) {
                return ['Daily', 'Weekly', 'Monthly', 'Yearly']
                    .map((option) {
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
              }),
        ),

        Text(
          StringHelper.howToConnect,
          style: context.textTheme.titleSmall,
        ),

        MultiSelectCategory(
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
              if (viewModel.propertyForTypeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: "Please select type");
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: 'Please add area of Property');
                return;
              }
              if (viewModel.accessToUtilitiesTextController.text.isEmpty) {
                DialogHelper.showToast(message: 'Please enter access of utilities');
                return;
              }
              if (viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select payment type');
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&viewModel.rentalTermsTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: "Please select rental terms");
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
              if (viewModel.propertyForTypeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: "Please select type");
                return;
              }
              if (viewModel.areaSizeTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: 'Please add area of Property');
                return;
              }
              if (viewModel.accessToUtilitiesTextController.text.isEmpty) {
                DialogHelper.showToast(message: 'Please enter access of utilities');
                return;
              }
              if (viewModel.paymentTypeTextController.text.isEmpty) {
                DialogHelper.showToast(
                    message: 'Please select payment type');
                return;
              }
              if (viewModel.currentPropertyType.toLowerCase() == "rent" &&viewModel.rentalTermsTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: "Please select rental terms");
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

  accessToUtilitiesWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Access to Utilities",
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Water Supply','Electricity','Gas','Sewage System','Road Access'].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentAccessToUtilities,
              onChanged: (String? value) {
                viewModel.accessToUtilitiesTextController.text = value ?? "";
                viewModel.currentAccessToUtilities = value??"";
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
          children: ['Installment', 'Cash or Installment', 'cash'].map((status) {
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
          children: ['Ready', 'Off-Plan'].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentCompletion,
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
          "Delivery Term",
          style: context.textTheme.titleSmall,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Move-in Ready','Under Construction','Shell and Core','Semi-Finished'].map((status) {
            return RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(status,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              value: status,
              groupValue: viewModel.currentDeliveryTerm,
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
