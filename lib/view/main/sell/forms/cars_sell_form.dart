import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  const CarsSellForm(
      {super.key,
      this.type,
      this.category,
      this.subSubCategory,
      this.subCategory,
      this.item,
      this.brands});
  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 20; i++) {
      viewModel.yearsType.add((currentYear - i).toString());
    }

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
              KeyboardActionsItem(
                focusNode: viewModel.ownerText,
              ),
              KeyboardActionsItem(
                focusNode: viewModel.yearText,
              ),
              KeyboardActionsItem(
                focusNode: viewModel.kmDrivenText,
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
              GestureDetector(
                onTap: () async {
                  viewModel.mainImagePath =
                      await ImagePickerHelper.openImagePicker(
                              context: context, isCropping: true) ??
                          '';
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child:ImageView.rect(
                          image: viewModel.mainImagePath,
                          borderRadius: 10,
                          width: context.width,
                          placeholder: AssetsRes.IC_CAMERA,
                          height: 220),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageView.rect(
                              image: viewModel.imagesList[index].media ?? '',
                              fit: BoxFit.contain,
                              height: 80,
                              width: 100,
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: InkWell(
                            onTap: () {
                              viewModel.removeImage(index,
                                  data: viewModel.imagesList[index]);
                              /* viewModel.deletedImageIds.add(value)*/
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
                        if (viewModel.imagesList.length < 10) {
                          var image = await ImagePickerHelper.openImagePicker(
                                  context: context, isCropping: true) ??
                              '';
                          if (image.isNotEmpty) {
                            viewModel.addImage(image);
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
                        child:  Column(
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
                                : Colors.grey.withOpacity(0.5)),
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
                      )),
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
                                : Colors.grey.withOpacity(0.5)),
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
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              if (brands?.isNotEmpty ?? false) ...{
                CommonDropdown<CategoryModel?>(
                  title: StringHelper.brand,
                  hint: viewModel.brandTextController.text,
                  listItemBuilder: (context,model,selected,fxn){
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name??"");
                  },
                  options: brands??[],
                  onSelected: (CategoryModel? value) {
                    DialogHelper.showLoading();
                    viewModel.getModels(brandId: value?.id);
                    viewModel.selectedBrand = value;
                    viewModel.brandTextController.text = value?.name ?? '';
                  },
                  // readOnly: true,
                  // suffix: PopupMenuButton(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (CategoryModel value) {
                  //     DialogHelper.showLoading();
                  //     viewModel.getModels(brandId: value.id);
                  //     viewModel.selectedBrand = value;
                  //     viewModel.brandTextController.text = value.name ?? '';
                  //     viewModel.getModels(brandId: value.id);
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return brands!.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option.name ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // hint: StringHelper.select,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //       RegExp(viewModel.regexToRemoveEmoji)),
                  // ],
                ),
                CommonDropdown<CategoryModel?>(
                  title: StringHelper.models,
                  titleColor: Colors.black,
                  hint: viewModel.modelTextController.text,
                  //readOnly: true,
                  //hint: StringHelper.select,
                  listItemBuilder: (context,model,selected,fxn){
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name??"");
                  },
                  onSelected: (value) {
                    viewModel.selectedModel = value;
                    viewModel.modelTextController.text = value?.name ?? '';
                  },
                  options: viewModel.allModels,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // fillColor: Colors.white,
                  // contentPadding: const EdgeInsets.only(left: 20),
                  // suffix: PopupMenuButton<CategoryModel>(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (value) {
                  //     viewModel.selectedModel = value;
                  //     viewModel.modelTextController.text = value.name ?? '';
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.allModels.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option?.name ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //     RegExp(viewModel.regexToRemoveEmoji),
                  //   ),
                  // ],
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                )
              },
              CommonDropdown(
                title: StringHelper.year,
                titleColor: Colors.black,
                hint: viewModel.yearTextController.text,
                onSelected: (String? value) {
                  viewModel.yearTextController.text = value ?? '';
                },
                options: viewModel.yearsType,
                // readOnly: true,
                // focusNode: viewModel.yearText,
                // hint: StringHelper.enter,
                // hintStyle:
                //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                // fillColor: Colors.white,
                // contentPadding: const EdgeInsets.only(left: 20),
                // suffix: PopupMenuButton<String>(
                //   icon: const Icon(Icons.arrow_drop_down),
                //   onSelected: (value) {
                //     viewModel.yearTextController.text = value ?? '';
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return viewModel.yearsType.map((option) {
                //       return PopupMenuItem(
                //         value: option,
                //         child: Text(option),
                //       );
                //     }).toList();
                //   },
                // ),
                // inputFormatters: [
                //   LengthLimitingTextInputFormatter(4),
                //   FilteringTextInputFormatter.digitsOnly,
                //   FilteringTextInputFormatter.deny(
                //     RegExp(viewModel.regexToRemoveEmoji),
                //   ),
                // ],
                // keyboardType: TextInputType.number,
                // textInputAction: TextInputAction.done,
              ),
              CommonDropdown(
                title: StringHelper.fuel,
                titleColor: Colors.black,
                hint: viewModel.fuelTextController.text,
                onSelected: (String? value) {
                  viewModel.fuelTextController.text = value ?? '';
                },
                options: viewModel.fuelsType,
                // readOnly: true,
                // hint: StringHelper.enter,
                // hintStyle:
                //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                // fillColor: Colors.white,
                // contentPadding:
                //     const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                // suffix: PopupMenuButton<String>(
                //   icon: const Icon(Icons.arrow_drop_down),
                //   onSelected: (value) {
                //     viewModel.fuelTextController.text = value ?? '';
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return viewModel.fuelsType.map((option) {
                //       return PopupMenuItem(
                //         value: option,
                //         child: Text(option),
                //       );
                //     }).toList();
                //   },
                // ),
                // inputFormatters: [
                //   FilteringTextInputFormatter.deny(
                //     RegExp(viewModel.regexToRemoveEmoji),
                //   ),
                // ],
                // textInputAction: TextInputAction.done,
              ),
              Visibility(
                visible: false,
                child: CommonDropdown(
                  title: StringHelper.mileage,
                  titleColor: Colors.black,
                  hint: viewModel.mileageTextController.text,
                  onSelected: (String? value) {
                    viewModel.mileageTextController.text = value??"";
                  },
                  options: viewModel.mileageRanges,
                  // readOnly: true,
                  // hint: StringHelper.enter,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // fillColor: Colors.white,
                  // contentPadding: const EdgeInsets.only(left: 20),
                  // suffix: PopupMenuButton<String>(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (value) {
                  //     viewModel.mileageTextController.text = value;
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.mileageRanges.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(4),
                  //   FilteringTextInputFormatter.digitsOnly,
                  //   FilteringTextInputFormatter.deny(
                  //     RegExp(viewModel.regexToRemoveEmoji),
                  //   ),
                  // ],
                  // keyboardType: TextInputType.number,
                  // textInputAction: TextInputAction.done,
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: StringHelper.transmission,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ])),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      viewModel.transmission = 1;
                    },
                    child: Container(
                      width: 130,
                      height: 50,
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: viewModel.transmission == 1
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5)),
                        color: viewModel.transmission == 1
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
                          color: viewModel.transmission == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.transmission = 2;
                    },
                    child: Container(
                      width: 130,
                      height: 50,
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        color: viewModel.transmission == 2
                            ? Colors.black
                            : Colors.white,
                        border: Border.all(
                            color: viewModel.transmission == 2
                                ? Colors.transparent
                                : Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        StringHelper.manual,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: viewModel.transmission == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: false,
                child: AppTextField(
                  title: StringHelper.kmDriven,
                  titleColor: Colors.black,
                  controller: viewModel.kmDrivenTextController,
                  focusNode: viewModel.kmDrivenText,
                  readOnly: false,
                  hint: StringHelper.enter,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 20),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji),
                    ),
                  ],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
              ),
              AppTextField(
                title: StringHelper.noOfOwners,
                titleColor: Colors.black,
                controller: viewModel.numOfOwnerTextController,
                focusNode: viewModel.ownerText,
                hint: StringHelper.enter,
                hintStyle:
                    const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              AppTextField(
                title: StringHelper.adTitle,
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
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              AppTextField(
                title: StringHelper.describeWhatYouAreSelling, // Title text
                titleColor: Colors.black, // Title color
                controller:
                    viewModel.descriptionTextController, // Text controller
                hint: StringHelper.enter, // Hint text for the field
                hintStyle: const TextStyle(
                    color: Color(0xffACACAC),
                    fontSize: 14), // Style for the hint text
                fillColor: Colors.white, // Background color for the text field
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 18), // Padding for content inside the field
                maxLines: 4, // Maximum number of lines for the text field
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji), // Block emoji input
                  ),
                ],
                textInputAction: TextInputAction.done, // Keyboard action button
                keyboardType: TextInputType.text,
              ),
              AppTextField(
                title: StringHelper.location,
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
                    viewModel.addressTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                ],
                textInputAction: TextInputAction.done,
              ),
              // Price TextField
              AppTextField(
                title: StringHelper.priceEgp,
                titleColor: Colors.black,
                controller: viewModel.priceTextController,
                hint: StringHelper.enterPrice,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      num.parse(value) < 1000) {
                    return '* The minimum valid price is EGP 1000';
                  }

                  return null;
                },
                hintStyle:
                    const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji),
                  ),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
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

                    if (viewModel.yearTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.yearIsRequired);
                      return;
                    }

                    // if (viewModel.kmDrivenTextController.text.trim().isEmpty) {
                    //   DialogHelper.showToast(
                    //       message: StringHelper.kMDrivenIsRequired);
                    //   return;
                    // }

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
                    if (viewModel.descriptionTextController.text
                        .trim()
                        .isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.describeWhatYouAreSelling);
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

                    if (viewModel.yearTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.yearIsRequired);
                      return;
                    }

                    // if (viewModel.kmDrivenTextController.text.trim().isEmpty) {
                    //   DialogHelper.showToast(
                    //       message: StringHelper.kMDrivenIsRequired);
                    //   return;
                    // }

                    if (viewModel.adTitleTextController.text.trim().isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.adTitleIsRequired);
                      return;
                    }
                    if (viewModel.descriptionTextController.text
                        .trim()
                        .isEmpty) {
                      DialogHelper.showToast(
                          message: StringHelper.describeWhatYouAreSelling);
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
