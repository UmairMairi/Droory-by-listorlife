import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/image_view.dart';
import '../../../../base/helpers/image_picker_helper.dart';
import '../../../../base/helpers/string_helper.dart';
import '../../../../models/category_model.dart';
import '../../../../models/product_detail_model.dart';
import '../../../../view_model/sell_forms_vm.dart';
import 'property_form/apartment_form.dart';
import 'property_form/business_form.dart';
import 'property_form/default_form.dart';
import 'property_form/land_form.dart';
import 'property_form/vacation_form.dart';
import 'property_form/villa_form.dart';

class PropertyType extends BaseView<SellFormsVM> {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;
  const PropertyType(
      {super.key,
      this.type,
      this.item,
      this.category,
      this.subSubCategory,
      this.subCategory,
      this.brands});
  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    var propertyType = ["Rent","Sell"];
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.includeSomeDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.propertyType,
              style: context.titleMedium,
            ),
            ListView.separated(
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      viewModel.currentPropertyType = propertyType[index];
                      viewModel.propertyForTextController.text = propertyType[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PropertySellForm(
                            type: type,
                            category: category,
                            subSubCategory: subSubCategory,
                            brands: brands,
                            subCategory: subCategory,
                            item: item,
                          )));
                    },
                    title: Text(
                      propertyType[index],
                      style: context.textTheme.titleSmall,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: propertyType.length),
          ],
        ),
      ),
    );
  }

}


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
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.includeSomeDetails),
      ),
      body: Form(
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
                const SizedBox(
                  height: 25,
                ),
                commonWidget(context,subCategory?.id, viewModel),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commonWidget(BuildContext context,dynamic subCatId,SellFormsVM viewModel){
    debugPrint("subCatId ====> $subCatId");
    switch(subCatId){
      case 83:
        return ApartmentForm(viewModel: viewModel,type: type,brands: brands,category: category,item: item,subCategory: subCategory,subSubCategory: subSubCategory,);
      case 84:
        return VillaForm(viewModel: viewModel,type: type,brands: brands,category: category,item: item,subCategory: subCategory,subSubCategory: subSubCategory,);
     case 87:
        return BusinessForm(viewModel: viewModel,type: type,brands: brands,category: category,item: item,subCategory: subCategory,subSubCategory: subSubCategory,);
     case 88:
        return VacationForm(viewModel: viewModel,type: type,brands: brands,category: category,item: item,subCategory: subCategory,subSubCategory: subSubCategory,);
        case 90:
        return LandForm(viewModel: viewModel,type: type,brands: brands,category: category,item: item,subCategory: subCategory,subSubCategory: subSubCategory,);
      default:
        return DefaultForm(viewModel: viewModel,type: type,brands: brands,category: category,item: item,subCategory: subCategory,subSubCategory: subSubCategory,);
    }
  }



}
