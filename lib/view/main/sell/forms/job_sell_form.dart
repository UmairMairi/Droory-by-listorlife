
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';

import '../../../../base/helpers/dialog_helper.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../res/assets_res.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/image_view.dart';

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
    return Form(
      key: viewModel.formKey,
      child: SingleChildScrollView(
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
                    border: Border.all(color: Colors.black),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ImageView.rect(
                    image: viewModel.mainImagePath,
                    borderRadius: 10,
                    width: context.width,
                    placeholder: AssetsRes.IC_CAMERA,
                    height: 220),
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
            CommonDropdown(
              title: StringHelper.lookingFor,
              hint: viewModel.lookingForController.text,
              onSelected: (String? value) {
                viewModel.lookingForController.text = value ?? '';
              },
              options: ['I am looking job', 'I am hiring'],
              // hint: StringHelper.select,
              // readOnly: true,
              // suffix: PopupMenuButton<String?>(
              //   icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              //   onSelected: (String? value) {
              //     viewModel.lookingForController.text = value ?? '';
              //   },
              //   itemBuilder: (context) {
              //     return ['I am looking job', 'I am hiring'].map((option) {
              //       return PopupMenuItem(
              //         value: option,
              //         child: Text(option),
              //       );
              //     }).toList();
              //   },
              // ),
              // inputFormatters: [
              //   FilteringTextInputFormatter.deny(
              //       RegExp(viewModel.regexToRemoveEmoji)),
              // ],
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
            // Job Position Dropdown
            CommonDropdown(
              title: StringHelper.positionType,
              onSelected: (String? value) {
                viewModel.jobPositionTextController.text = value??"";
              },
              hint: viewModel.jobPositionTextController.text,
              options: viewModel.jobPositionList,
              // hint: StringHelper.select,
              // readOnly: true,
              // suffix: PopupMenuButton(
              //   icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              //   onSelected: (String value) {
              //     viewModel.jobPositionTextController.text = value;
              //   },
              //   itemBuilder: (context) {
              //     return viewModel.jobPositionList.map((option) {
              //       return PopupMenuItem(
              //         value: option,
              //         child: Text(option),
              //       );
              //     }).toList();
              //   },
              // ),
              // inputFormatters: [
              //   FilteringTextInputFormatter.deny(
              //       RegExp(viewModel.regexToRemoveEmoji)),
              // ],
            ),

            // Salary Period Dropdown
            CommonDropdown(
              title: StringHelper.salaryPeriod,
              hint: viewModel.jobSalaryTextController.text,
              onSelected: (String? value) {
                viewModel.jobSalaryTextController.text = value??"";
              },
              options: viewModel.salaryPeriodList,
              // hint: StringHelper.select,
              // readOnly: true,
              // suffix: PopupMenuButton(
              //   icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              //   onSelected: (String value) {
              //     viewModel.jobSalaryTextController.text = value;
              //   },
              //   itemBuilder: (context) {
              //     return viewModel.salaryPeriodList.map((option) {
              //       return PopupMenuItem(
              //         value: option,
              //         child: Text(option),
              //       );
              //     }).toList();
              //   },
              // ),
              // inputFormatters: [
              //   FilteringTextInputFormatter.deny(
              //       RegExp(viewModel.regexToRemoveEmoji)),
              // ],
            ),

            // Salary From Field
            AppTextField(
              title: StringHelper.salary,
              hint: StringHelper.enter,
              controller: viewModel.jobSalaryFromController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),
            // AppTextField(
            //   title: StringHelper.salaryFrom,
            //   hint: StringHelper.enter,
            //   controller: viewModel.jobSalaryFromController,
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [
            //     FilteringTextInputFormatter.digitsOnly,
            //     LengthLimitingTextInputFormatter(8),
            //     FilteringTextInputFormatter.deny(
            //         RegExp(viewModel.regexToRemoveEmoji)),
            //   ],
            // ),
            //
            // // Salary To Field
            // AppTextField(
            //   title: StringHelper.salaryTo,
            //   hint: StringHelper.enter,
            //   controller: viewModel.jobSalaryToController,
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [
            //     FilteringTextInputFormatter.digitsOnly,
            //     LengthLimitingTextInputFormatter(8),
            //     FilteringTextInputFormatter.deny(
            //         RegExp(viewModel.regexToRemoveEmoji)),
            //   ],
            // ),

            // Ad Title Field
            AppTextField(
              title: StringHelper.adTitle,
              hint: StringHelper.enter,
              controller: viewModel.adTitleTextController,
              minLines: 1,
              maxLines: 4,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

            // Description Field
            AppTextField(
              title: StringHelper.describeWhatYouAreSelling,
              hint: StringHelper.enter,
              controller: viewModel.descriptionTextController,
              maxLines: 4,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
            ),

            // Location Field
            AppTextField(
              title: StringHelper.location,
              hint: StringHelper.select,
              readOnly: true,
              controller: viewModel.addressTextController,
              suffix: const Icon(Icons.location_on),
              onTap: () async {
                Map<String, dynamic>? value = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppMapWidget()),
                );
                if (value != null && value.isNotEmpty) {
                  viewModel.addressTextController.text =
                      "${value['location']}, ${value['city']}, ${value['state']}";
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                    RegExp(viewModel.regexToRemoveEmoji)),
              ],
              maxLines: 2,
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

                  /* if (viewModel.mainImagePath.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadMainImage);
                    return;
                  }
                  if (viewModel.imagesList.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadAddAtLeastOneImage);
                    return;
                  }*/
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

                  /*  if (viewModel.mainImagePath.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadMainImage);
                    return;
                  }
                  if (viewModel.imagesList.isEmpty) {
                    DialogHelper.showToast(
                        message: StringHelper.pleaseUploadAddAtLeastOneImage);
                    return;
                  }*/
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
                    DialogHelper.showToast(
                        message: StringHelper.adTitleIsRequired);
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
    );
  }
}
