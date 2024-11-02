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
    return KeyboardActions(
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
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 6,
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
            RichText(
                text: TextSpan(children: [
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
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.enter,
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.propertyType,
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
                readOnly: true,
                controller: viewModel.propertyForTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                            child: Text(option ?? ''),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.areaSize,
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
                controller: viewModel.areaSizeTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  hintText: StringHelper.enter,
                  hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
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
                text: TextSpan(children: [
              TextSpan(
                text: 'No Of Bedrooms',
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
                readOnly: true,
                controller: viewModel.noOfBedroomsTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
                      clipBehavior: Clip.hardEdge,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      onSelected: (String value) {
                        viewModel.noOfBedroomsTextController.text = '$value';
                      },
                      itemBuilder: (BuildContext context) {
                        return ['1', '2', '3', '4', '5', '6', '7', '7+']
                            .map((option) {
                          return PopupMenuItem(
                            value: option,
                            child: Text('$option Bedrooms'),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.noOfBathrooms,
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
                readOnly: true,
                controller: viewModel.noOfBathroomsTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.furnishing,
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
                readOnly: true,
                controller: viewModel.furnishingStatusTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                            child: Text(option ?? ''),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.owner,
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
                readOnly: true,
                controller: viewModel.ownershipStatusTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                            child: Text(option ?? ''),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.paymentType,
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
                readOnly: true,
                controller: viewModel.paymentTypeTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                            child: Text(option ?? ''),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.completionStatus,
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
                readOnly: true,
                controller: viewModel.completionStatusTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                            child: Text(option ?? ''),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.deliveryTerms,
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
                readOnly: true,
                controller: viewModel.deliveryTermTextController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
                    hintStyle:
                        TextStyle(color: Color(0xffACACAC), fontSize: 14),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: PopupMenuButton(
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
                            child: Text(option ?? ''),
                          );
                        }).toList();
                      },
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
                text: TextSpan(children: [
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
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.enter,
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
                text: TextSpan(children: [
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
                    viewModel.state = value['state'];
                    viewModel.city = value['city'];
                    viewModel.country = value['country'];
                    viewModel.addressTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                  }
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.select,
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
                text: TextSpan(children: [
              TextSpan(
                text: StringHelper.priceEgp,
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
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    hintText: StringHelper.enterPrice,
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
                    DialogHelper.showToast(message: 'Please select Bathrooms');
                    return;
                  }

                  if (viewModel.furnishingStatusTextController.text.isEmpty) {
                    DialogHelper.showToast(message: 'Please select Furnishing');
                    return;
                  }

                  if (viewModel.ownershipStatusTextController.text.isEmpty) {
                    DialogHelper.showToast(message: 'Please select Ownership');
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
                    DialogHelper.showToast(message: 'Please select Bathrooms');
                    return;
                  }

                  if (viewModel.furnishingStatusTextController.text.isEmpty) {
                    DialogHelper.showToast(message: 'Please select Furnishing');
                    return;
                  }

                  if (viewModel.ownershipStatusTextController.text.isEmpty) {
                    DialogHelper.showToast(message: 'Please select Ownership');
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
    );
  }
}
