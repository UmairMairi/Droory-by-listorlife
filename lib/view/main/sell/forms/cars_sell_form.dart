import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import '../../../../helpers/dialog_helper.dart';
import '../../../../helpers/image_picker_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';

class CarsSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  const CarsSellForm(
      {super.key,
      this.type,
      this.category,
      this.subSubCategory,
      this.subCategory,
      this.brands});
  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    print("brands => ${brands?.length}");
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Images",
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(0, 1),
                        blurRadius: 6,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: viewModel.mainImagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(viewModel.mainImagePath),
                          fit: BoxFit.contain,
                        ))
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Upload",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Wrap(
              children: List.generate(viewModel.imagesList.length + 1, (index) {
                if (index < viewModel.imagesList.length) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(0, 1),
                              blurRadius: 6,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(viewModel.imagesList[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: InkWell(
                          onTap: () {
                            viewModel.removeImage(index);
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
                      var image = await ImagePickerHelper.openImagePicker(
                              context: context, isCropping: true) ??
                          '';
                      if (image.isNotEmpty) {
                        viewModel.addImage(image);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 6,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Add",
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
              "Item Condition",
              style: context.textTheme.titleMedium,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.currentIndex = 1;
                  },
                  child: Container(
                    width: 105,
                    height: 42,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: viewModel.currentIndex == 1
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5)),
                      color: viewModel.currentIndex == 1
                          ? Colors.black
                          : const Color(0xffFCFCFD),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      "New",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: viewModel.currentIndex == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    viewModel.currentIndex = 2;
                  },
                  child: Container(
                    width: 105,
                    height: 42,
                    margin: const EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      color: viewModel.currentIndex == 2
                          ? Colors.black
                          : const Color(0xffFCFCFD),
                      border: Border.all(
                          color: viewModel.currentIndex == 2
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text(
                      "Used",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: viewModel.currentIndex == 2
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
              RichText(
                  text: const TextSpan(children: [
                TextSpan(
                  text: "Brand",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ])),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: viewModel.brandTextController,
                  readOnly: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 20,
                    ),
                    hintText: "Select",
                    hintStyle:
                        const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
                      clipBehavior: Clip.hardEdge,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      onSelected: (CategoryModel value) {
                        viewModel.selectedBrand = value;
                        viewModel.brandTextController.text = value.name ?? '';
                      },
                      itemBuilder: (BuildContext context) {
                        return brands!.map((option) {
                          return PopupMenuItem(
                            value: option,
                            child: Text(option.name ?? ''),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(viewModel.regexToRemoveEmoji)),
                  ],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
            },
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Year",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.yearTextController,
                readOnly: false,
                focusNode: viewModel.yearText,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Fuel",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.fuelTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Transmission",
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
                      "Automatic",
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
                      "Manual",
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
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Km Driven",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.kmDrivenTextController,
                readOnly: false,
                focusNode: viewModel.kmDrivenText,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: "Enter",
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "No. of Onwers",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.numOfOwnerTextController,
                cursorColor: Colors.black,
                focusNode: viewModel.ownerText,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Ad Title",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                maxLines: 4,
                minLines: 1,
                controller: viewModel.adTitleTextController,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Describe what you are selling",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.descriptionTextController,
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.addressTextController,
                maxLines: 2,
                minLines: 1,
                readOnly: true,
                onTap: () async {
                  Map<String, dynamic>? value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppMapWidget()));

                  if (value != null && value.isNotEmpty) {
                    viewModel.addressTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                  }
                },
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Select",
                    suffixIcon: Icon(Icons.location_on),
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: "Price (in EGP)",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ])),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextFormField(
                controller: viewModel.priceTextController,
                cursorColor: Colors.black,
                focusNode: viewModel.priceText,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: "Enter Price",
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (viewModel.mainImagePath.isEmpty) {
                  DialogHelper.showToast(message: "Please upload main image");
                  return;
                }
                if (viewModel.imagesList.isEmpty) {
                  DialogHelper.showToast(
                      message: "Please upload add at least one image");
                  return;
                }

                if (viewModel.yearTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: "Year is required");
                  return;
                }

                if (viewModel.kmDrivenTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: "KM Driven is required");
                  return;
                }

                if (viewModel.adTitleTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: "Ad title is required");
                  return;
                }
                if (viewModel.descriptionTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: "Description is required");
                  return;
                }
                if (viewModel.addressTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: "Location is required");
                  return;
                }
                if (viewModel.priceTextController.text.trim().isEmpty) {
                  DialogHelper.showToast(message: "Price is required");
                  return;
                }
                DialogHelper.showLoading();
                viewModel.addProduct(
                  category: category,
                  subCategory: subCategory,
                  subSubCategory: subSubCategory,
                  brands: viewModel.selectedBrand,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  "Post Now",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
