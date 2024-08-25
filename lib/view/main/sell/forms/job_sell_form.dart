import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';

import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/prodect_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';

class JobSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  const JobSellForm(
      {required this.type,
      required this.category,
      required this.subCategory,
      this.subSubCategory,
      this.item,
      required this.brands,
      super.key});

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
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
              viewModel.mainImagePath = await ImagePickerHelper.openImagePicker(
                      context: context, isCropping: true) ??
                  '';
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 6,
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                          StringHelper.upload,
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
          if (brands?.isNotEmpty ?? false) ...{
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: StringHelper.brand,
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
                  hintText: StringHelper.select,
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
                      DialogHelper.showLoading();
                      viewModel.getModels(brandId: value.id);
                      viewModel.selectedBrand = value;
                      viewModel.brandTextController.text = value.name ?? '';
                      viewModel.getModels(brandId: value.id);
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
            RichText(
                text: const TextSpan(children: [
              TextSpan(
                text: StringHelper.models,
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
                controller: viewModel.modelTextController,
                readOnly: true,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                  ),
                  hintText: StringHelper.select,
                  hintStyle:
                      const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: PopupMenuButton<CategoryModel>(
                    clipBehavior: Clip.hardEdge,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    onSelected: (value) {
                      viewModel.selectedModel = value;
                      viewModel.modelTextController.text = value.name ?? '';
                    },
                    itemBuilder: (BuildContext context) {
                      return viewModel.allModels.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option?.name ?? ''),
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
              text: StringHelper.positionType,
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
              controller: viewModel.jobPositionTextController,
              readOnly: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 20,
                ),
                hintText: StringHelper.select,
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
                  onSelected: (String value) {
                    viewModel.jobPositionTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return viewModel.jobPositionList.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option),
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
          RichText(
              text: const TextSpan(children: [
            TextSpan(
              text: StringHelper.salaryPeriod,
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
              controller: viewModel.jobSalaryTextController,
              readOnly: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  left: 20,
                ),
                hintText: StringHelper.select,
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
                  onSelected: (String value) {
                    viewModel.jobSalaryTextController.text = value;
                  },
                  itemBuilder: (BuildContext context) {
                    return viewModel.salaryPeriodList.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option),
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
          RichText(
              text: const TextSpan(children: [
            TextSpan(
              text: StringHelper.salaryFrom,
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
              controller: viewModel.jobSalaryFromController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                hintText: StringHelper.enter,
                hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
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
              text: StringHelper.salaryTo,
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
              controller: viewModel.jobSalaryToController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 20,
                ),
                hintText: StringHelper.enter,
                hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
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
              text: StringHelper.adTitle,
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
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
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
              text: StringHelper.describeWhatYouAreSelling,
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
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
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
              text: StringHelper.location,
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
                print(value);
                if (value != null && value.isNotEmpty) {
                  viewModel.addressTextController.text =
                      "${value['location']}, ${value['city']}, ${value['state']}";
                }
              },
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  hintText: StringHelper.select,
                  suffixIcon: Icon(Icons.location_on),
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
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
          GestureDetector(
            onTap: () {
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
              if (viewModel.jobPositionTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.pleasesSelectPositionType);
                return;
              }
              if (viewModel.jobSalaryTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.pleaseSelectSalaryPeriod);
                return;
              }
              if (viewModel.jobSalaryFromController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.pleaseSelectSalaryForm);
                return;
              }

              if (viewModel.jobSalaryToController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.pleaseSelectSalaryTo);
                return;
              }

              if (viewModel.adTitleTextController.text.trim().isEmpty) {
                DialogHelper.showToast(message: StringHelper.adTitleIsRequired);
                return;
              }
              if (viewModel.descriptionTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.descriptionIsRequired);
                return;
              }
              if (viewModel.addressTextController.text.trim().isEmpty) {
                DialogHelper.showToast(
                    message: StringHelper.locationIsRequired);
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
              child: const Text(
                StringHelper.postNow,
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
    );
  }
}
