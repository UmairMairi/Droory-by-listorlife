import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/amenities_widget.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/prodect_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/app_text_field.dart';

class PropertySellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  const PropertySellForm(
      {super.key,
      this.type,
      this.item,
      this.category,
      this.subSubCategory,
      this.subCategory,
      this.brands});
  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return Form(
      key: viewModel.formKey,
      child: KeyboardActions(
        config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
            keyboardBarColor: Colors.grey[200],
            actions: [
              KeyboardActionsItem(
                focusNode: viewModel.priceText,
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    borderRadius: BorderRadius.circular(10)),
                child: GestureDetector(
                    onTap: () async {
                      viewModel.mainImagePath =
                          await ImagePickerHelper.openImagePicker(
                                  context: context, isCropping: true) ??
                              '';
                    },
                    child: ImageView.rect(
                        image: viewModel.mainImagePath,
                        borderRadius: 10,
                        width: context.width,
                        placeholder: AssetsRes.IC_CAMERA,
                        height: 220)),
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
                              width: 120),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: InkWell(
                            onTap: () {
                              viewModel.removeImage(index,
                                  data: viewModel.imagesList[index]);
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: () async {
                        if (viewModel.imagesList.length < 12) {
                          var image = await ImagePickerHelper.openImagePicker(
                                  context: context, isCropping: true) ??
                              '';
                          if (image.isNotEmpty) {
                            viewModel.addImage(image);
                          }
                        } else {
                          DialogHelper.showToast(
                              message: "You have reached at maximum limit");
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
                            Icon(Icons.add),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              StringHelper.add,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(
                height: 25,
              ),
              // Field 1: Ad Title
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

              // Field 2: Property Type
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

              // Field 3: Area Size
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

              // Field 4: No Of Bedrooms
              AppTextField(
                title: 'No Of Bedrooms',
                hint: StringHelper.enter,
                controller: viewModel.noOfBedroomsTextController,
                maxLines: 1,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                fillColor: Colors.white,
                elevation: 6,
              ),

              // Field 1: No Of Bathrooms
              AppTextField(
                title: StringHelper.noOfBathrooms,
                hint: StringHelper.select,
                controller: viewModel.noOfBathroomsTextController,
                readOnly: true,
                suffix: PopupMenuButton<String>(
                  clipBehavior: Clip.hardEdge,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    viewModel.noOfBathroomsTextController.text = "$value";
                  },
                  itemBuilder: (BuildContext context) {
                    return ['1', '2', '3', '4', '5', '6', '7', '7+']
                        .map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text('$option Bathrooms'),
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

              // Field 2: Furnishing Status
              AppTextField(
                title: StringHelper.furnishing,
                hint: StringHelper.select,
                controller: viewModel.furnishingStatusTextController,
                readOnly: true,
                suffix: PopupMenuButton<String>(
                  clipBehavior: Clip.hardEdge,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    viewModel.furnishingStatusTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Furnished', 'Unfurnished', 'Semi Furnished']
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

              // Field 3: Ownership Status
              AppTextField(
                title: StringHelper.owner,
                hint: StringHelper.select,
                controller: viewModel.ownershipStatusTextController,
                readOnly: true,
                suffix: PopupMenuButton<String>(
                  clipBehavior: Clip.hardEdge,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    viewModel.ownershipStatusTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Primary', 'Resell'].map((option) {
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

              // Field 4: Payment Type
              AppTextField(
                title: StringHelper.paymentType,
                hint: StringHelper.select,
                controller: viewModel.paymentTypeTextController,
                readOnly: true,
                suffix: PopupMenuButton<String>(
                  clipBehavior: Clip.hardEdge,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    viewModel.paymentTypeTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Installment', 'Cash or Installment', 'cash']
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

              // Field 5: Completion Status
              AppTextField(
                title: StringHelper.completionStatus,
                hint: StringHelper.select,
                controller: viewModel.completionStatusTextController,
                readOnly: true,
                suffix: PopupMenuButton<String>(
                  clipBehavior: Clip.hardEdge,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    viewModel.completionStatusTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Ready', 'Off Plan'].map((option) {
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
                title: StringHelper.deliveryTerms,
                controller: viewModel.deliveryTermTextController,
                hint: StringHelper.select,
                readOnly: true,
                suffix: PopupMenuButton<String>(
                  clipBehavior: Clip.hardEdge,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onSelected: (String value) {
                    viewModel.deliveryTermTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      'Finished',
                      'Not Finished',
                      'Core and sell',
                      'Semi finished'
                    ].map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList();
                  },
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.text,
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

              AmenitiesWidget(
                  amenitiesChecked: viewModel.amenities,
                  selectedAmenities: (List<int?> selectedIds) {
                    print(selectedIds);
                    viewModel.amenities = selectedIds;
                    print(viewModel.amenities);
                  }),
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

                    if (viewModel.adTitleTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.adTitleIsRequired);
                      return;
                    }

                    if (viewModel.propertyForTextController.text.isEmpty) {
                      DialogHelper.showToast(
                          message: 'Please select Property Type');
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

                    if (viewModel.ownershipStatusTextController.text.isEmpty) {
                      DialogHelper.showToast(
                          message: 'Please select Ownership');
                      return;
                    }

                    if (viewModel.descriptionTextController.text
                        .trim()
                        .isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.descriptionIsRequired);
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

                    if (viewModel.adTitleTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.adTitleIsRequired);
                      return;
                    }

                    if (viewModel.propertyForTextController.text.isEmpty) {
                      DialogHelper.showToast(
                          message: 'Please select Property Type');
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

                    if (viewModel.ownershipStatusTextController.text.isEmpty) {
                      DialogHelper.showToast(
                          message: 'Please select Ownership');
                      return;
                    }

                    if (viewModel.descriptionTextController.text
                        .trim()
                        .isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.descriptionIsRequired);
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
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
