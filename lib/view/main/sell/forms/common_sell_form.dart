import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/multi_select_category.dart';

import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import '../../../../widgets/app_map_widget.dart';
import '../../../../widgets/app_text_field.dart';
import '../../../../widgets/common_dropdown.dart';

class CommonSellForm extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;

  const CommonSellForm(
      {super.key,
      required this.type,
      required this.category,
      required this.subCategory,
      required this.subSubCategory,
      this.item,
      required this.brands});

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
                height: 300,
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
                        fit: BoxFit.fill,
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
              if (category?.type?.toLowerCase() == "fashion") ...{
                FutureBuilder<List<CategoryModel>>(
                  future: viewModel.getSizeOptions("${subSubCategory?.id}"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CategoryModel> sizeOptions = snapshot.data ?? [];

                      if (sizeOptions.isNotEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CommonDropdown<CategoryModel?>(
                              title: StringHelper.size,
                              hint: viewModel.sizeTextController.text,
                              onSelected: (CategoryModel? value) {
                                viewModel.selectedModel = value;
                                viewModel.sizeTextController.text =
                                    value?.name ?? '';
                              },
                              options: sizeOptions,
                              listItemBuilder: (context,model,selected,fxn){
                                return Text(model?.name ?? '');
                              },
                              headerBuilder: (context, selectedItem, enabled) {
                                return Text(selectedItem?.name??"");
                              },
                              // readOnly: true,
                              // cursorColor: Colors.black,
                              // hint: StringHelper.select,
                              // hintStyle: const TextStyle(
                              //     color: Color(0xffACACAC), fontSize: 14),
                              // suffix: PopupMenuButton<CategoryModel>(
                              //   clipBehavior: Clip.hardEdge,
                              //   icon: const Icon(
                              //     Icons.arrow_drop_down,
                              //     color: Colors.black,
                              //   ),
                              //   onSelected: (value) {
                              //     viewModel.selectedModel = value;
                              //     viewModel.sizeTextController.text =
                              //         value.name ?? '';
                              //   },
                              //   itemBuilder: (BuildContext context) {
                              //     return sizeOptions.map((option) {
                              //       return PopupMenuItem(
                              //         value: option,
                              //         child: Text(option.name ?? ''),
                              //       );
                              //     }).toList();
                              //   },
                              // ),
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.deny(
                              //       RegExp(viewModel.regexToRemoveEmoji)),
                              // ],
                              // keyboardType: TextInputType.text,
                              // textInputAction: TextInputAction.done,
                            )
                          ],
                        );
                      }
                    }
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    }

                    return const SizedBox.shrink();
                  },
                ),
              },
              Text(
                StringHelper.itemCondition,
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
                        StringHelper.newText,
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
                        StringHelper.used,
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
              if (category?.id == 1) ...{
                /// RAM SPECIFICATION
                CommonDropdown(
                  title: StringHelper.ram,
                  hint: viewModel.ramTextController.text,
                  onSelected: (String? value) {
                    viewModel.ramTextController.text = value ?? '';
                  },
                  options: viewModel.ramOptions,
                  // readOnly: true,
                  // cursorColor: Colors.black,
                  // hint: StringHelper.select,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // suffix: PopupMenuButton<String>(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (value) {
                  //     viewModel.ramTextController.text = value ?? '';
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.ramOptions.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //       RegExp(viewModel.regexToRemoveEmoji)),
                  // ],
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                ),

                /// STORAGE SPECIFICATION
                CommonDropdown(
                  title: StringHelper.strong,
                  hint: viewModel.storageTextController.text,
                  onSelected: (String? value) {
                    viewModel.storageTextController.text = value ?? '';
                  },
                  options: viewModel.storageOptions,
                  // readOnly: true,
                  // cursorColor: Colors.black,
                  // hint: StringHelper.select,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // suffix: PopupMenuButton<String>(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (value) {
                  //     viewModel.storageTextController.text = value ?? '';
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.storageOptions.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //       RegExp(viewModel.regexToRemoveEmoji)),
                  // ],
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                ),

                /// SCREEN SIZE SPECIFICATION
                CommonDropdown(
                  title: StringHelper.screenSize,
                  hint: viewModel.screenSizeTextController.text,
                  onSelected: (String? value) {
                    viewModel.screenSizeTextController.text = value ?? '';
                  },
                  options: viewModel.screenSizeOptions,
                  // readOnly: true,
                  // cursorColor: Colors.black,
                  // hint: StringHelper.select,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // suffix: PopupMenuButton<String>(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (value) {
                  //     viewModel.screenSizeTextController.text = value ?? '';
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.screenSizeOptions.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //       RegExp(viewModel.regexToRemoveEmoji)),
                  // ],
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                ),
              },
              if (category?.id == 2 || subCategory?.subCategoryId == 4) ...{
                /// MATERIAL SPECIFICATION
                CommonDropdown(
                  title: StringHelper.material,
                  hint: viewModel.materialTextController.text,
                  onSelected: (String? value) {
                    viewModel.materialTextController.text = value ?? '';
                  },
                  options: viewModel.materialOptions,
                  // readOnly: true,
                  // cursorColor: Colors.black,
                  // hint: StringHelper.select,
                  // hintStyle:
                  //     const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  // suffix: PopupMenuButton<String>(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (value) {
                  //     viewModel.materialTextController.text = value ?? '';
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.materialOptions.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(
                  //       RegExp(viewModel.regexToRemoveEmoji)),
                  // ],
                  // keyboardType: TextInputType.text,
                  // textInputAction: TextInputAction.done,
                ),
              },

              /// Ad Title Section
              AppTextField(
                title: StringHelper.adTitle,
                controller: viewModel.adTitleTextController,
                maxLines: 4,
                minLines: 1,
                cursorColor: Colors.black,
                hint: StringHelper.enter,
                hintStyle:
                    const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

              /// Description Section
              AppTextField(
                title: StringHelper.describeWhatYouAreSelling,
                controller: viewModel.descriptionTextController,
                maxLines: 4,
                cursorColor: Colors.black,
                hint: StringHelper.enter,
                hintStyle:
                    const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

              /// Location Section
              AppTextField(
                title: StringHelper.location,
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
                    viewModel.state = value['state'];
                    viewModel.city = value['city'];
                    viewModel.country = value['country'];
                    viewModel.addressTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                  }
                },
                hint: StringHelper.select,
                suffix: const Icon(Icons.location_on),
                hintStyle:
                    const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
                ],
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),

              /// Price Section
              AppTextField(
                title: StringHelper.priceEgp,
                controller: viewModel.priceTextController,
                cursorColor: Colors.black,
                focusNode: viewModel.priceText,
                hint: StringHelper.enterPrice,
                hintStyle:
                    const TextStyle(color: Color(0xffACACAC), fontSize: 14),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.deny(
                      RegExp(viewModel.regexToRemoveEmoji)),
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
