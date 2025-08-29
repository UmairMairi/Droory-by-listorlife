import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';
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
  const PropertyType({
    super.key,
    this.type,
    this.item,
    this.category,
    this.subSubCategory,
    this.subCategory,
    this.brands,
  });

  @override
  Widget build(BuildContext context, SellFormsVM viewModel) {
    var propertyType = [
      CategoryModel(type: "Rent", name: StringHelper.rent),
      CategoryModel(type: "Sell", name: StringHelper.sell),
    ];
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    // FIXED: Only reset if not editing
                    if (item == null) {
                      viewModel.resetTextFields();
                    }

                    // Set the selected property type
                    viewModel.currentPropertyType =
                        propertyType[index].type ?? "";
                    viewModel.propertyForTextController.text =
                        propertyType[index].type ?? "";

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
                        ),
                      ),
                    );
                  },
                  title: Text(
                    propertyType[index].name ?? "",
                    style: context.textTheme.titleSmall,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: propertyType.length,
            ),
          ],
        ),
      ),
    );
  }
}

class PropertySellForm extends StatefulWidget {
  final String? type;
  final CategoryModel? category;
  final CategoryModel? subCategory;
  final CategoryModel? subSubCategory;
  final List<CategoryModel>? brands;
  final ProductDetailModel? item;

  const PropertySellForm({
    super.key,
    this.type,
    this.item,
    this.category,
    this.subSubCategory,
    this.subCategory,
    this.brands,
  });

  @override
  State<PropertySellForm> createState() => _PropertySellFormState();
}

class _PropertySellFormState extends State<PropertySellForm> {
  @override
  void initState() {
    super.initState();
    // FIXED: Improved initialization logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<SellFormsVM>();

      if (widget.item != null) {
        // Editing existing property ad - populate with existing data
        viewModel.updateTextFieldsItems(item: widget.item);
      } else {
        // Creating new property ad - ensure clean state
        if (viewModel.currentPropertyType.isEmpty) {
          viewModel.resetTextFields();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SellFormsVM>(
      builder: (context, viewModel, child) {
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
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              viewModel.mainImagePath =
                                  await ImagePickerHelper.openImagePicker(
                                        context: context,
                                        isCropping: false,
                                      ) ??
                                      '';
                            },
                            child: ImageView.rect(
                              image: viewModel.mainImagePath,
                              borderRadius: 10,
                              width: context.width,
                              placeholder: AssetsRes.IC_CAMERA,
                              height: 220,
                            ),
                          ),
                          // X button - only show if there's a main image
                          if (viewModel.mainImagePath.isNotEmpty)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    viewModel.removeMainImage();
                                  },
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red, size: 24),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Improved compact grid layout for images
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: viewModel.imagesList.length > 6 ? 180 : double.infinity,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: viewModel.imagesList.length > 6 
                            ? const AlwaysScrollableScrollPhysics() 
                            : const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // 4 images per row instead of 2
                          childAspectRatio: 1.0, // Square images
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        padding: const EdgeInsets.all(8),
                        itemCount: viewModel.imagesList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < viewModel.imagesList.length) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: ImageView.rect(
                                      image: viewModel.imagesList[index].media ?? '',
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      viewModel.removeImage(
                                        index,
                                        data: viewModel.imagesList[index],
                                      );
                                    },
                                    child: const Icon(
                                      Icons.cancel, 
                                      color: Colors.red, 
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                if (viewModel.imagesList.length < 20) {
                                  List<String>? images = await ImagePickerHelper
                                      .pickMultipleImagesFromGallery();
                                  if (images != null && images.isNotEmpty) {
                                    for (var img in images) {
                                      if (viewModel.imagesList.length < 20) {
                                        viewModel.addImage(img);
                                      } else {
                                        DialogHelper.showToast(
                                            message: StringHelper.imageMaxLimit);
                                        break;
                                      }
                                    }
                                  }
                                } else {
                                  DialogHelper.showToast(
                                      message: StringHelper.imageMaxLimit);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400, 
                                    style: BorderStyle.solid
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 28,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      StringHelper.add,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    commonWidget(context, widget.subCategory?.id, viewModel),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget commonWidget(
      BuildContext context, dynamic subCatId, SellFormsVM viewModel) {
    debugPrint("subCatId ====> $subCatId");
    switch (subCatId) {
      case 83:
        return ApartmentForm(
          viewModel: viewModel,
          type: widget.type,
          brands: widget.brands,
          category: widget.category,
          item: widget.item,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
        );
      case 84:
        return VillaForm(
          viewModel: viewModel,
          type: widget.type,
          brands: widget.brands,
          category: widget.category,
          item: widget.item,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
        );
      case 87:
        return BusinessForm(
          viewModel: viewModel,
          type: widget.type,
          brands: widget.brands,
          category: widget.category,
          item: widget.item,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
        );
      case 88:
        return VacationForm(
          viewModel: viewModel,
          type: widget.type,
          brands: widget.brands,
          category: widget.category,
          item: widget.item,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
        );
      case 90:
        return LandForm(
          viewModel: viewModel,
          type: widget.type,
          brands: widget.brands,
          category: widget.category,
          item: widget.item,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
        );
      default:
        return DefaultForm(
          viewModel: viewModel,
          type: widget.type,
          brands: widget.brands,
          category: widget.category,
          item: widget.item,
          subCategory: widget.subCategory,
          subSubCategory: widget.subSubCategory,
        );
    }
  }
}
