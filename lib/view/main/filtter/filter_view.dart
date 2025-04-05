import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/amenities_widget.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../base/network/api_constants.dart';
import '../../../base/network/api_request.dart';
import '../../../base/network/base_client.dart';
import '../../../models/category_model.dart';
import '../../../models/common/list_response.dart';
import '../../../models/filter_model.dart';
import '../../../widgets/app_map_widget.dart';

class FilterView extends StatefulWidget {
  final FilterModel? filters;
  const FilterView({super.key, this.filters});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  //SfRangeValues values = const SfRangeValues(00, 100000);
  //SfRangeValues salaryFromTo = const SfRangeValues(00, 100000);
  //SfRangeValues downValues = const SfRangeValues(00, 100000);
  //SfRangeValues areaValues = const SfRangeValues(00, 100000);
  //SfRangeValues kmDrivenValues = const SfRangeValues(0, 1000000);
  FilterModel filter = FilterModel();
  List<CategoryModel> categoriesList = [];
  List<CategoryModel> subCategoriesList = [];
  List<CategoryModel> subSubCategories = [];
  List<CategoryModel> brands = [];
  List<CategoryModel> allModels = [];
  List<CategoryModel> fashionSizes = [];

  List<int> selectedAmenities = [];
  List<String> yearsType = [];
  List<String> fuelsType = [
    StringHelper.petrol,
    StringHelper.diesel,
    StringHelper.electric,
    StringHelper.hybrid,
    StringHelper.gas
  ];
  List<String> transmissionType = [
    StringHelper.manual,
    StringHelper.automatic,
  ];
  List<CategoryModel> sortByList = [
    CategoryModel(name: StringHelper.priceHighToLow),
    CategoryModel(name: StringHelper.priceLowToHigh),
  ];
  List<CategoryModel> postedWithinList = [
    CategoryModel(id: 1, name: StringHelper.today),
    CategoryModel(id: 2, name: StringHelper.yesterday),
    CategoryModel(id: 3, name: StringHelper.lastWeek),
    CategoryModel(id: 4, name: StringHelper.lastMonth),
  ];
  List<CategoryModel> genders = [
    CategoryModel(name: StringHelper.male),
    CategoryModel(name: StringHelper.female)
  ];

  // Map of filters based on category ID
  Map<int, List<String>> filters = {
    // Vehicles// Services
    9: [
      StringHelper.jobType,
      StringHelper.education,
      StringHelper.salaryRange,
      StringHelper.experience
    ], // Jobs
  };
  List<String> brandSubSubCategoryIds = [
    '1',
    '2',
    '14',
    '15',
    '27',
    '29',
    '30',
    '31',
    '32',
    '33',
    '98',
    '114',
    '69',
  ];

  List<String> breedSubSubCategoryIds = [
    '70',
    '71',
  ];

// Helper function to determine the size title
  String _getSizeTitle(String? subSubCategoryId) {
    if (brandSubSubCategoryIds.contains(subSubCategoryId ?? '')) {
      return StringHelper.brand;
    }
    if (breedSubSubCategoryIds.contains(subSubCategoryId ?? '')) {
      return StringHelper.breed;
    }
    return StringHelper.type;
  }

  List<String> filtersCat = [];
  // Method to get filters based on the selected category ID
  List<String> getFiltersByCategory(int? categoryId) {
    return filters[categoryId] ?? [];
  }

  Future<void> getModels({required int? brandId}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getModelsUrl(brandId: "$brandId"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    DialogHelper.hideLoading();
    allModels = model.body ?? [];
    debugPrint("response ~--> $response");
    setState(() {});
  }

  @override
  void initState() {
    var vm = context.read<HomeVM>();
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 20; i++) {
      yearsType.add((currentYear - i).toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((t) => updateFilter(vm: vm));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.filter),
        centerTitle: true,
      ),
      body: Consumer<HomeVM>(builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Visibility(
                visible: filter.categoryId != "9",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      StringHelper.price,
                      style: context.textTheme.titleSmall,
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: context.width,
                            height: 50,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: viewModel.startPriceTextController,
                                cursorColor: Colors.black,
                                maxLength: 7,
                                //readOnly: true,
                                // onChanged: (value) {
                                //   setState(() {
                                //     if (value.isEmpty) {
                                //       values = SfRangeValues(
                                //           0,
                                //           int.parse(viewModel
                                //               .endPriceTextController.text));
                                //       return;
                                //     }
                                //
                                //     values = SfRangeValues(
                                //         int.parse(viewModel
                                //             .startPriceTextController.text),
                                //         int.parse(viewModel
                                //             .endPriceTextController.text));
                                //   });
                                // },
                                decoration: InputDecoration(
                                    counterText: "",
                                    fillColor: const Color(0xffFCFCFD),
                                    hintText: StringHelper.minPrice,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffEFEFEF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffEFEFEF)),
                                    ))),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          StringHelper.to,
                          style: context.textTheme.titleSmall,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: context.width,
                            height: 50,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: viewModel.endPriceTextController,
                              cursorColor: Colors.black,
                              maxLength: 7,
                              //readOnly: true,
                              // onChanged: (value) {
                              //   setState(() {
                              //     if (value.isEmpty) {
                              //       values = SfRangeValues(
                              //           int.parse(viewModel
                              //               .startPriceTextController.text),
                              //           100000);
                              //       return;
                              //     }
                              //
                              //     values = SfRangeValues(
                              //         int.parse(viewModel
                              //             .startPriceTextController.text),
                              //         int.parse(viewModel
                              //             .endPriceTextController.text));
                              //   });
                              // },
                              decoration: InputDecoration(
                                  counterText: "",
                                  fillColor: const Color(0xffFCFCFD),
                                  hintText: StringHelper.maxPrice,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffEFEFEF))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Color(0xffEFEFEF)))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // StatefulBuilder(
                    //   builder: (context, setState) {
                    //     return SfRangeSlider(
                    //       min: 0,
                    //       max: 100000,
                    //       values: values,
                    //       inactiveColor: Colors.grey,
                    //       activeColor: const Color(0xffFF385C),
                    //       showLabels: false,
                    //       interval: 1000, // Controls label intervals
                    //       stepSize:
                    //           1000, // Ensures the slider moves in steps of 1000
                    //       labelFormatterCallback:
                    //           (dynamic actualValue, String formattedText) {
                    //         return actualValue == 99999
                    //             ? ' $formattedText+'
                    //             : ' $formattedText';
                    //       },
                    //       onChanged: (SfRangeValues newValues) {
                    //         if ((newValues.end - newValues.start) >= 1000) {
                    //           debugPrint("newValues==> ${newValues.end}");
                    //           debugPrint(
                    //               "newValues start==> ${newValues.start}");
                    //           viewModel.startPriceTextController.text =
                    //               "${newValues.start.round()}";
                    //           viewModel.endPriceTextController.text =
                    //               "${newValues.end.round()}";
                    //           setState(() {
                    //             values = newValues;
                    //           });
                    //         }
                    //       },
                    //     );
                    //   },
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CommonDropdown<CategoryModel?>(
                title: StringHelper.category,
                hint: viewModel.categoryTextController.text,
                listItemBuilder: (context, model, selected, fxn) {
                  return Text(model?.name ?? '');
                },
                headerBuilder: (context, selectedItem, enabled) {
                  return Text(selectedItem?.name ?? "");
                },
                options: categoriesList,
                onSelected: (CategoryModel? value) {
                  resetFilters();
                  setState(() {
                    filtersCat = getFiltersByCategory(value?.id);
                  });

                  getSubCategory(id: "${value?.id}");
                  viewModel.categoryTextController.text = value?.name ?? '';
                  filter.categoryId = "${value?.id}";
                  if (filter.categoryId == "8" || filter.categoryId == "9") {
                    viewModel.itemCondition = 0;
                  }
                  filter.subcategoryId = "";
                  viewModel.currentPropertyType = "Sell";
                  brands.clear();
                  allModels.clear();
                  subCategoriesList.clear();
                  viewModel.brandsTextController.clear();
                  viewModel.modelTextController.clear();
                  viewModel.subCategoryTextController.clear();
                },
                //hint: StringHelper.selectCategory,
                // readOnly: true,
                // suffix: PopupMenuButton(
                //   icon: const Icon(Icons.arrow_drop_down),
                //   onSelected: (value) {
                //     setState(() {
                //       filtersCat = getFiltersByCategory(value.id);
                //     });
                //
                //     getSubCategory(id: "${value.id}");
                //     viewModel.categoryTextController.text = value.name ?? '';
                //     filter.categoryId = "${value.id}";
                //     filter.subcategoryId = "";
                //     viewModel.currentPropertyType = "Sell";
                //     brands.clear();
                //     allModels.clear();
                //     viewModel.brandsTextController.clear();
                //     viewModel.modelTextController.clear();
                //     viewModel.subCategoryTextController.clear();
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return categoriesList.map((option) {
                //       return PopupMenuItem(
                //         value: option,
                //         child: Text(option.name ?? ''),
                //       );
                //     }).toList();
                //   },
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (subCategoriesList.isNotEmpty) ...{
                CommonDropdown<CategoryModel?>(
                  title: filter.categoryId == '8'
                      ? StringHelper.selectServices
                      : filter.categoryId == '9'
                          ? StringHelper.jobType
                          : StringHelper.subCategory,
                  hint: viewModel.subCategoryTextController.text.trim().isEmpty
                      ? filter.categoryId == '8'
                          ? StringHelper.selectServices
                          : filter.categoryId == '9'
                              ? StringHelper.selectJobType
                              : StringHelper.selectSubCategory
                      : viewModel.subCategoryTextController.text,
                  onSelected: (CategoryModel? value) async {
                    viewModel.subCategoryTextController.text =
                        value?.name ?? '';
                    filter.subcategoryId = "${value?.id}";
                    viewModel.currentPropertyType = "Sell";
                    DialogHelper.showLoading();
                    brands.clear();
                    allModels.clear();
                    selectedAmenities.clear();
                    subSubCategories.clear(); // Clear sub-subcategories
                    fashionSizes.clear();
                    viewModel.propertyForTextController.clear();
                    viewModel.brandsTextController.clear();
                    viewModel.modelTextController.clear();
                    viewModel.noOfBathroomsTextController.clear();
                    viewModel.noOfBedroomsTextController.clear();
                    viewModel.furnishingStatusTextController.clear();
                    viewModel.accessToUtilitiesTextController.clear();
                    viewModel.ownershipStatusTextController.clear();
                    viewModel.propertyForTypeTextController.clear();
                    viewModel.paymentTypeTextController.clear();
                    viewModel.listedByTextController.clear();
                    viewModel.rentalTermsTextController.clear();
                    viewModel.completionStatusTextController.clear();
                    viewModel.deliveryTermTextController.clear();
                    viewModel.levelTextController.clear();
                    viewModel.ramTextController.clear();
                    viewModel.storageTextController.clear();
                    await getBrands(id: "${filter.subcategoryId}");
                    getSubSubCategories(id: "${filter.subcategoryId}");
                    filter.ram = "";
                    filter.storage = "";
                  },
                  listItemBuilder: (context, model, selected, fxn) {
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name ?? "");
                  },
                  options: subCategoriesList,
                  // controller: viewModel.subCategoryTextController,
                  // readOnly: true,
                  // suffix: PopupMenuButton(
                  //   icon: const Icon(Icons.arrow_drop_down),
                  //   onSelected: (value) async {
                  //     viewModel.subCategoryTextController.text =
                  //         value.name ?? '';
                  //     filter.subcategoryId = "${value.id}";
                  //     viewModel.currentPropertyType = "Sell";
                  //     DialogHelper.showLoading();
                  //     brands.clear();
                  //     allModels.clear();
                  //     viewModel.propertyForTextController.clear();
                  //     viewModel.brandsTextController.clear();
                  //     viewModel.modelTextController.clear();
                  //     await getBrands(id: "${filter.subcategoryId}");
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return subCategoriesList.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option.name ?? ''),
                  //       );vm.tvSizeTextController.clear();
                  //     }).toList();
                  //   },
                  // ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (subSubCategories.isNotEmpty) ...[
                  CommonDropdown<CategoryModel?>(
                    title: "Sub-Subcategory",
                    hint: (filter.subSubCategoryId == null ||
                            filter.subSubCategoryId!.isEmpty)
                        ? "Select Sub-Subcategory"
                        : getSubSubCategoryName(id: filter.subSubCategoryId),
                    onSelected: (CategoryModel? value) async {
                      filter.subSubCategoryId = "${value?.id}";
                      fashionSizes.clear();
                      viewModel.sizesTextController.clear();
                      // Clear the text
                      filter.sizeId = null; // Reset the sizeId in the filter
                      setState(() {
                        fashionSizes
                            .clear(); // Clear fashion sizes when sub-subcategory changes
                      });
                      await getFashionSizes(id: "${filter.subSubCategoryId}");
                    },
                    listItemBuilder: (context, model, selected, fxn) {
                      return Text(model?.name ?? '');
                    },
                    headerBuilder: (context, selectedItem, enabled) {
                      return Text(selectedItem?.name ?? "");
                    },
                    options: subSubCategories,
                  ),
                ],
              },

              Visibility(
                  visible: subCategoriesList.isNotEmpty &&
                      (filter.subcategoryId ?? "").isNotEmpty,
                  child:
                      commonWidget(context, filter.subcategoryId, viewModel)),
              if (brands.isNotEmpty) ...[
                CommonDropdown<CategoryModel?>(
                  title: (filter.subcategoryId ?? '') == '26' ||
                          (filter.subcategoryId ?? '') == '27' ||
                          (filter.subcategoryId ?? '') == '95' ||
                          (filter.subcategoryId ?? '') == '97' ||
                          (filter.subcategoryId ?? '') == '99' ||
                          (filter.subcategoryId ?? '') == '22' ||
                          (filter.categoryId ?? '') == '5' ||
                          (filter.categoryId ?? '') == '7' ||
                          (filter.categoryId ?? '') == '8'
                      ? StringHelper.type
                      : (filter.subcategoryId ?? '') == '23'
                          ? "telecom"
                          : (filter.categoryId ?? '') == '9'
                              ? StringHelper.specialty
                              : (filter.categoryId ?? '') == '6'
                                  ? StringHelper.breed
                                  : StringHelper.brand,
                  hint: viewModel.brandsTextController.text.trim().isEmpty
                      ? (filter.subcategoryId ?? '') == '26' ||
                              (filter.subcategoryId ?? '') == '27' ||
                              (filter.subcategoryId ?? '') == '95' ||
                              (filter.subcategoryId ?? '') == '97' ||
                              (filter.subcategoryId ?? '') == '99' ||
                              (filter.subcategoryId ?? '') == '22' ||
                              (filter.categoryId ?? '') == '5' ||
                              (filter.categoryId ?? '') == '7' ||
                              (filter.categoryId ?? '') == '8'
                          ? ""
                          : (filter.subcategoryId ?? '') == '23'
                              ? ""
                              : (filter.categoryId ?? '') == '9'
                                  ? StringHelper.specialty
                                  : (filter.categoryId ?? '') == '6'
                                      ? StringHelper.selectBreeds
                                      : StringHelper.selectBrands
                      : viewModel.brandsTextController.text,
                  onSelected: (CategoryModel? value) async {
                    viewModel.brandsTextController.text = value?.name ?? '';
                    filter.brandId = "${value?.id}";
                    viewModel.modelTextController.clear();
                    await getModels(brandId: int.parse("${filter.brandId}"));
                  },
                  options: brands,
                  listItemBuilder: (context, model, selected, fxn) {
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name ?? "");
                  },

                  // controller: viewModel.brandsTextController,
                  // readOnly: true,
                  // suffix: PopupMenuButton(
                  //   icon: const Icon(Icons.arrow_drop_down),
                  //   onSelected: (value) async {
                  //     viewModel.brandsTextController.text = value.name ?? '';
                  //     filter.brandId = "${value.id}";
                  //     viewModel.modelTextController.clear();
                  //     await getModels(brandId: int.parse("${filter.brandId}"));
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return brands.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option.name ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                ),
                if (filter.subSubCategoryId == '7') ...[
                  CommonDropdown<String?>(
                    title: "TV Size",
                    hint: viewModel.screenSizeTextController.text.isEmpty
                        ? "Select TV Size"
                        : viewModel.screenSizeTextController.text,
                    onSelected: (String? value) {
                      viewModel.screenSizeTextController.text = value ?? "";
                    },
                    options: viewModel.tvSizeOptions, // Already in HomeVM
                    listItemBuilder: (context, model, selected, fxn) {
                      return Text(model ?? '');
                    },
                    headerBuilder: (context, selectedItem, enabled) {
                      return Text(selectedItem ?? "");
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                // const SizedBox(
                //   height: 10,
                // ),
                // filter.categoryId == '6'
                //     ? CommonDropdown<CategoryModel?>(
                //         title: StringHelper.gender,
                //         hint:viewModel.genderTextController.text.trim().isEmpty? StringHelper.selectGender:viewModel.genderTextController.text,
                //   onSelected: (CategoryModel? value) {
                //     viewModel.genderTextController.text =
                //         value?.name ?? '';
                //   },
                //   listItemBuilder: (context,model,selected,fxn){
                //     return Text(model?.name ?? '');
                //   },
                //   headerBuilder: (context, selectedItem, enabled) {
                //     return Text(selectedItem?.name??"");
                //   },
                //   options: genders,
                //   // controller: viewModel.genderTextController,
                //   //       readOnly: true,
                //   //       suffix: PopupMenuButton(
                //   //         icon: const Icon(Icons.arrow_drop_down),
                //   //         onSelected: (value) {
                //   //           viewModel.genderTextController.text =
                //   //               value.name ?? '';
                //   //         },
                //   //         itemBuilder: (BuildContext context) {
                //   //           return genders.map((option) {
                //   //             return PopupMenuItem(
                //   //               value: option,
                //   //               child: Text(option.name ?? ''),
                //   //             );
                //   //           }).toList();
                //   //         },
                //   //       ),
                //       )
                //     : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                ),
              ],
              if (fashionSizes.isNotEmpty) ...[
                CommonDropdown<CategoryModel?>(
                  title: _getSizeTitle(filter.subSubCategoryId),
                  hint: viewModel.sizesTextController.text.trim().isEmpty
                      ? "Select Size"
                      : viewModel.sizesTextController.text,
                  onSelected: (CategoryModel? value) {
                    viewModel.sizesTextController.text = value?.name ?? '';
                    filter.sizeId = "${value?.id}";
                  },
                  options: fashionSizes,
                  listItemBuilder: (context, model, selected, fxn) {
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name ?? "");
                  },
                ),
                const SizedBox(height: 10),
              ],
              if (allModels.isNotEmpty && filter.categoryId != '3') ...{
                CommonDropdown<CategoryModel?>(
                  title: StringHelper.models,
                  hint: viewModel.modelTextController.text.trim().isEmpty
                      ? StringHelper.selectModel
                      : viewModel.modelTextController.text,
                  onSelected: (value) {
                    viewModel.modelTextController.text = value?.name ?? '';
                    filter.modelId = "${value?.id}";
                  },
                  options: allModels,
                  listItemBuilder: (context, model, selected, fxn) {
                    return Text(model?.name ?? '');
                  },
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(selectedItem?.name ?? "");
                  },
                  // readOnly: true,
                  // controller: viewModel.modelTextController,
                  // suffix: PopupMenuButton(
                  //   icon: const Icon(Icons.arrow_drop_down),
                  //   onSelected: (value) {
                  //     viewModel.modelTextController.text = value.name ?? '';
                  //     filter.modelId = value.id.toString();
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return allModels.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option.name ?? ''),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(4),
                  //   FilteringTextInputFormatter.digitsOnly,
                  // ],
                  // keyboardType: TextInputType.number,
                  // textInputAction: TextInputAction.done,
                ),
                const Gap(10),
              },
              // if (filter.categoryId == '4') ...[
              //   CommonDropdown(
              //     title: StringHelper.year,
              //     hint: viewModel.yearTextController.text.isEmpty
              //         ? StringHelper.selectYear
              //         : viewModel.yearTextController.text,
              //     onSelected: (value) {
              //       viewModel.yearTextController.text = value ?? '';
              //       filter.year = value;
              //     },
              //     options: yearsType,
              //     // readOnly: true,
              //     // controller: viewModel.yearTextController,
              //     // suffix: PopupMenuButton<String>(
              //     //   icon: const Icon(Icons.arrow_drop_down),
              //     //   onSelected: (value) {
              //     //     viewModel.yearTextController.text = value ?? '';
              //     //     filter.year = value;
              //     //   },
              //     //   itemBuilder: (BuildContext context) {
              //     //     return yearsType.map((option) {
              //     //       return PopupMenuItem(
              //     //         value: option,
              //     //         child: Text(option),
              //     //       );
              //     //     }).toList();
              //     //   },
              //     // ),
              //     // inputFormatters: [
              //     //   LengthLimitingTextInputFormatter(4),
              //     //   FilteringTextInputFormatter.digitsOnly,
              //     // ],
              //     // keyboardType: TextInputType.number,
              //     // textInputAction: TextInputAction.done,
              //   ),
              //   const SizedBox(
              //     height: 10,
              //   ),
              //   CommonDropdown(
              //     title: StringHelper.fuel,
              //     hint: viewModel.fuelTextController.text,
              //     onSelected: (value) {
              //       viewModel.fuelTextController.text = value ?? '';
              //       filter.fuel = value;
              //     },
              //     options: fuelsType,

              //     //hint: StringHelper.enter,
              //     // textInputAction: TextInputAction.done,
              //     // readOnly: true,
              //     // suffix: PopupMenuButton<String>(
              //     //   icon: const Icon(Icons.arrow_drop_down),
              //     //   onSelected: (value) {
              //     //     viewModel.fuelTextController.text = value ?? '';
              //     //     filter.fuel = value;
              //     //   },
              //     //   itemBuilder: (BuildContext context) {
              //     //     return fuelsType.map((option) {
              //     //       return PopupMenuItem(
              //     //         value: option,
              //     //         child: Text(option),
              //     //       );
              //     //     }).toList();
              //     //   },
              //     // ),
              //   ),
              //   const SizedBox(
              //     height: 10,
              //   ),

              //   const SizedBox(height: 10),
              //   AppTextField(
              //     title: StringHelper.mileage,
              //     controller: viewModel.mileageTextController,
              //     hint: StringHelper.mileage,
              //     maxLength: 6,
              //     keyboardType: TextInputType.number,
              //     inputFormatters: [
              //       LengthLimitingTextInputFormatter(6),
              //       FilteringTextInputFormatter.deny(
              //           RegExp(viewModel.regexToRemoveEmoji)),
              //       FilteringTextInputFormatter.digitsOnly,
              //     ],
              //     validator: (value) {
              //       // if (value != null || (value??"").trim().isNotEmpty) {
              //       //   final amount = num.tryParse("${value??0}");
              //       //
              //       //   if (amount == null) {
              //       //     return '* Please enter a valid mileage';
              //       //   }
              //       //
              //       //   if (amount < 1000) {
              //       //     return '* The minimum valid mileage is 1000';
              //       //   }
              //       //
              //       //   if (amount > 100000) {
              //       //     return '* The maximum valid mileage is 100,000';
              //       //   }
              //       // }

              //       return null;
              //     },
              //   ),
              //   CommonDropdown<String>(
              //     title: StringHelper
              //         .carColorTitle, // Uses the localized title from StringHelper
              //     titleColor: Colors.black,
              //     hint: viewModel.carColorTextController.text,
              //     onSelected: (String? value) {
              //       viewModel.carColorTextController.text = value ?? '';
              //     },
              //     options: StringHelper
              //         .carColorOptions, // Uses your localized color list
              //   ),
              //   CommonDropdown<String>(
              //     title: StringHelper.horsepowerTitle, // Localized title
              //     titleColor: Colors.black,
              //     hint: viewModel.horsePowerTextController.text.isEmpty
              //         ? ""
              //         : viewModel.horsePowerTextController.text,
              //     onSelected: (String? value) {
              //       viewModel.horsePowerTextController.text = value ?? '';
              //     },
              //     options:
              //         viewModel.horsepowerOptions, // Localized options list
              //   ),
              //   const SizedBox(height: 10),
              //   CommonDropdown<String>(
              //     title: StringHelper.rentalCarTerm, // Localized title
              //     titleColor: Colors.black,
              //     hint: viewModel.carRentalTermController.text.isEmpty
              //         ? ""
              //         : viewModel.carRentalTermController.text,
              //     onSelected: (String? value) {
              //       viewModel.carRentalTermController.text = value ?? "";
              //     },
              //     options: viewModel.carRentalTermOptions,
              //   ),
              //   CommonDropdown<String>(
              //     title: StringHelper.engineCapacityTitle, // Localized title
              //     titleColor: Colors.black,
              //     hint: viewModel.engineCapacityTextController.text.isEmpty
              //         ? ""
              //         : viewModel.engineCapacityTextController.text,
              //     onSelected: (String? value) {
              //       viewModel.engineCapacityTextController.text = value ?? '';
              //     },
              //     options:
              //         viewModel.engineCapacityOptions, // Localized options list
              //   ),
              //   CommonDropdown<String>(
              //     title: StringHelper.interiorColorTitle, // Localized title
              //     titleColor: Colors.black,
              //     hint: viewModel.interiorColorTextController.text.isEmpty
              //         ? ""
              //         : viewModel.interiorColorTextController.text,
              //     onSelected: (String? value) {
              //       viewModel.interiorColorTextController.text = value ?? '';
              //     },
              //     options:
              //         StringHelper.carColorOptions, // Localized options list
              //   ),
              //   CommonDropdown<String>(
              //     title: StringHelper.numbDoorsTitle, // Localized title
              //     titleColor: Colors.black,
              //     hint: viewModel.numbDoorsTextController.text.isEmpty
              //         ? ""
              //         : viewModel.numbDoorsTextController.text,
              //     onSelected: (String? value) {
              //       viewModel.numbDoorsTextController.text = value ?? '';
              //     },
              //     options: viewModel.numbDoorsOptions, // Localized options list
              //   ),
              //   CommonDropdown<String>(
              //     title: StringHelper.bodyTypeTitle, // Using localized title
              //     titleColor: Colors.black,
              //     hint: viewModel.bodyTypeTextController.text.isEmpty
              //         ? ""
              //         : viewModel.bodyTypeTextController.text,
              //     onSelected: (String? value) {
              //       viewModel.bodyTypeTextController.text = value ?? '';
              //     },
              //     options:
              //         StringHelper.bodyTypeOptions, // Using localized options
              //   ),
              //   // CommonDropdown(
              //   //   title: StringHelper.mileage,
              //   //   hint: viewModel.mileageTextController.text,
              //   //   onSelected: (value) {
              //   //     viewModel.mileageTextController.text = value??"";
              //   //   },
              //   //   options: viewModel.mileageRanges,
              //   // hint: StringHelper.select,
              //   // readOnly: true,
              //   // suffix: PopupMenuButton<String>(
              //   //   clipBehavior: Clip.hardEdge,
              //   //   icon: const Icon(
              //   //     Icons.arrow_drop_down,
              //   //     color: Colors.black,
              //   //   ),
              //   //   onSelected: (value) {
              //   //     viewModel.mileageTextController.text = value;
              //   //   },
              //   //   itemBuilder: (BuildContext context) {
              //   //     return viewModel.mileageRanges.map((option) {
              //   //       return PopupMenuItem(
              //   //         value: option,
              //   //         child: Text(option ?? ''),
              //   //       );
              //   //     }).toList();
              //   //   },
              //   // ),
              //   //),
              //   const SizedBox(
              //     height: 10,
              //   ),
              //   CommonDropdown(
              //     title: StringHelper.transmission,
              //     hint: viewModel.transmissionTextController.text.isEmpty
              //         ? StringHelper.selectTransmission
              //         : viewModel.transmissionTextController.text,
              //     onSelected: (value) {
              //       viewModel.transmissionTextController.text = value ?? "";
              //       filter.transmission = value?.toLowerCase();
              //     },
              //     options: transmissionType,
              //     // readOnly: true,
              //     // controller: viewModel.transmissionTextController,
              //     // suffix: PopupMenuButton<String>(
              //     //   icon: const Icon(Icons.arrow_drop_down),
              //     //   onSelected: (value) {
              //     //     viewModel.transmissionTextController.text = value;
              //     //     filter.transmission = value.toLowerCase();
              //     //   },
              //     //   itemBuilder: (BuildContext context) {
              //     //     return transmissionType.map((option) {
              //     //       return PopupMenuItem(
              //     //         value: option,
              //     //         child: Text(option),
              //     //       );
              //     //     }).toList();
              //     //   },
              //     // ),
              //     // inputFormatters: [
              //     //   LengthLimitingTextInputFormatter(4),
              //     //   FilteringTextInputFormatter.digitsOnly,
              //     // ],
              //     // keyboardType: TextInputType.number,
              //     // textInputAction: TextInputAction.done,
              //   ),
              //   // const SizedBox(
              //   //   height: 10,
              //   // ),
              //   Text(
              //     StringHelper.kmDriven,
              //     style: context.textTheme.titleSmall,
              //   ),
              //   const Gap(10),
              //   Row(
              //     children: [
              //       Expanded(
              //         child: SizedBox(
              //           width: context.width,
              //           height: 50,
              //           child: TextFormField(
              //             keyboardType: TextInputType.number,
              //             textAlign: TextAlign.center,
              //             controller: viewModel.minKmDrivenTextController,
              //             cursorColor: Colors.black,
              //             maxLength: 7,
              //             readOnly: true,
              //             decoration: InputDecoration(
              //               counterText: "",
              //               fillColor: const Color(0xffFCFCFD),
              //               hintText: "0 KM",
              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 borderSide:
              //                     const BorderSide(color: Color(0xffEFEFEF)),
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 borderSide:
              //                     const BorderSide(color: Color(0xffEFEFEF)),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 5),
              //       Text(StringHelper.to, style: context.textTheme.titleSmall),
              //       const SizedBox(width: 5),
              //       Expanded(
              //         child: SizedBox(
              //           width: context.width,
              //           height: 50,
              //           child: TextFormField(
              //             keyboardType: TextInputType.number,
              //             textAlign: TextAlign.center,
              //             controller: viewModel.maxKmDrivenTextController,
              //             cursorColor: Colors.black,
              //             maxLength: 7,
              //             readOnly: true,
              //             decoration: InputDecoration(
              //               counterText: "",
              //               fillColor: const Color(0xffFCFCFD),
              //               hintText: "1,000,000 KM",
              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 borderSide:
              //                     const BorderSide(color: Color(0xffEFEFEF)),
              //               ),
              //               focusedBorder: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 borderSide:
              //                     const BorderSide(color: Color(0xffEFEFEF)),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              //   const SizedBox(height: 15),
              //   StatefulBuilder(
              //     builder: (context, setState) {
              //       return SfRangeSlider(
              //         min: 0,
              //         max: 1000000,
              //         values: kmDrivenValues,
              //         inactiveColor: Colors.grey,
              //         activeColor: const Color(0xffFF385C),
              //         showLabels: false,
              //         interval: 100000, // Every 100,000 KM for visual markers
              //         stepSize: 1000, // Move in steps of 1,000 KM
              //         labelFormatterCallback:
              //             (dynamic actualValue, String formattedText) {
              //           return actualValue == 1000000
              //               ? '1,000,000+'
              //               : formattedText;
              //         },
              //         onChanged: (SfRangeValues newValues) {
              //           if ((newValues.end - newValues.start) >= 1000) {
              //             viewModel.minKmDrivenTextController.text =
              //                 "${newValues.start.round()}";
              //             viewModel.maxKmDrivenTextController.text =
              //                 "${newValues.end.round()}";
              //             setState(() {
              //               kmDrivenValues = newValues;
              //             });
              //           }
              //         },
              //       );
              //     },
              //   ),
              //   const SizedBox(height: 10),
              //   const SizedBox(
              //     height: 10,
              //   ),
              // ],
              if (filter.categoryId == '10' &&
                  filter.subcategoryId == '20') ...[
                CommonDropdown<String?>(
                  title: "RAM",
                  hint: viewModel.ramTextController.text.isEmpty
                      ? "Select RAM"
                      : viewModel.ramTextController.text,
                  onSelected: (String? value) {
                    viewModel.ramTextController.text = value ?? "";
                    filter.ram =
                        value != null ? value.replaceAll(" GB", "") : "";
                  },
                  options: viewModel.phoneRamOptions,
                ),
                const SizedBox(height: 10),
                CommonDropdown<String?>(
                  title: "Storage",
                  hint: viewModel.storageTextController.text.isEmpty
                      ? "Select Storage"
                      : viewModel.storageTextController.text,
                  onSelected: (String? value) {
                    viewModel.storageTextController.text = value ?? "";
                    filter.storage =
                        value != null ? value.replaceAll(" GB", "") : "";
                  },
                  options: viewModel.phoneStorageOptions,
                ),
                const SizedBox(height: 10),
              ],
              if (filter.categoryId == '1' &&
                  (filter.subSubCategoryId == '1' ||
                      filter.subSubCategoryId == '2')) ...[
                CommonDropdown(
                  title: "RAM",
                  hint: viewModel.ramTextController.text.isEmpty
                      ? "Select RAM"
                      : viewModel.ramTextController.text,
                  onSelected: (String? value) {
                    viewModel.ramTextController.text = value ?? "";
                    filter.ram =
                        value != null ? value.replaceAll(" GB", "") : "";
                  },
                  options: viewModel.storageOptions,
                ),
                const SizedBox(height: 10),
                CommonDropdown(
                  title: "Storage",
                  hint: viewModel.storageTextController.text.isEmpty
                      ? "Select Storage"
                      : viewModel.storageTextController.text,
                  onSelected: (String? value) {
                    viewModel.storageTextController.text = value ?? "";
                    filter.storage =
                        value != null ? value.replaceAll(" GB", "") : "";
                  },
                  options: viewModel.storageOptions,
                ),
                const SizedBox(height: 10),
              ],
              if (filter.categoryId == '11' &&
                  (filter.subcategoryId ?? "").isNotEmpty) ...{
                Visibility(
                    visible: filter.subcategoryId != "90",
                    child: AmenitiesWidget(
                      amenitiesChecked: selectedAmenities,
                      selectedAmenities: (List<int?> ids) {
                        filter.selectedAmnities = ids.join(',');
                      },
                    ))
              },
              if (filter.categoryId == '9') ...[
                CommonDropdown(
                  title: StringHelper.positionType,
                  hint: viewModel.jobPositionTextController.text,
                  onSelected: (String? value) {
                    viewModel.jobPositionTextController.text = value ?? "";
                  },
                  options: viewModel.jobPositionList,
                  // hint: StringHelper.select,
                  // readOnly: true,
                  // suffix: PopupMenuButton(
                  //   clipBehavior: Clip.hardEdge,
                  //   icon: const Icon(
                  //     Icons.arrow_drop_down,
                  //     color: Colors.black,
                  //   ),
                  //   onSelected: (String value) {
                  //     viewModel.jobPositionTextController.text = value;
                  //   },
                  //   itemBuilder: (BuildContext context) {
                  //     return viewModel.jobPositionList.map((option) {
                  //       return PopupMenuItem(
                  //         value: option,
                  //         child: Text(option),
                  //       );
                  //     }).toList();
                  //   },
                  // ),
                ),
                CommonDropdown(
                  title: StringHelper.workSetting,
                  hint: viewModel.workSettingTextController.text,
                  onSelected: (String? value) {
                    viewModel.workSettingTextController.text = value ?? "";
                  },
                  options: viewModel.workSettingOptions,
                ),
                CommonDropdown(
                  title: StringHelper.workExperience,
                  hint: viewModel.workExperienceTextController.text,
                  onSelected: (String? value) {
                    viewModel.workExperienceTextController.text = value ?? "";
                  },
                  options: viewModel.experienceOptions,
                ),
                CommonDropdown(
                  title: StringHelper.workEducation,
                  hint: viewModel.workEducationTextController.text,
                  onSelected: (String? value) {
                    viewModel.workEducationTextController.text = value ?? "";
                  },
                  options: viewModel.workEducationOptions,
                ),

                const SizedBox(
                  height: 15,
                ),
                Text(
                  StringHelper.salary,
                  style: context.textTheme.titleSmall,
                ),
                const Gap(10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: context.width,
                        height: 50,
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: viewModel.jobSalaryFromController,
                            cursorColor: Colors.black,
                            maxLength: 7,
                            // readOnly: true,
                            // onChanged: (value) {
                            //   setState(() {
                            //     if (value.isEmpty) {
                            //       salaryFromTo = SfRangeValues(
                            //           0,
                            //           int.parse(viewModel
                            //               .jobSalaryToController.text));
                            //       return;
                            //     }
                            //
                            //     salaryFromTo = SfRangeValues(
                            //         int.parse(
                            //             viewModel.jobSalaryFromController.text),
                            //         int.parse(
                            //             viewModel.jobSalaryToController.text));
                            //   });
                            // },
                            decoration: InputDecoration(
                                counterText: "",
                                fillColor: const Color(0xffFCFCFD),
                                hintText: StringHelper.minPrice,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEFEFEF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEFEFEF)),
                                ))),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      StringHelper.to,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: context.width,
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: viewModel.jobSalaryToController,
                          cursorColor: Colors.black,
                          maxLength: 7,
                          // readOnly: true,
                          // onChanged: (value) {
                          //   setState(() {
                          //     if (value.isEmpty) {
                          //       salaryFromTo = SfRangeValues(
                          //           int.parse(
                          //               viewModel.jobSalaryFromController.text),
                          //           100000);
                          //       return;
                          //     }
                          //
                          //     salaryFromTo = SfRangeValues(
                          //         int.parse(
                          //             viewModel.jobSalaryFromController.text),
                          //         int.parse(
                          //             viewModel.jobSalaryToController.text));
                          //   });
                          // },
                          decoration: InputDecoration(
                              counterText: "",
                              fillColor: const Color(0xffFCFCFD),
                              hintText: StringHelper.maxPrice,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEFEFEF))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEFEFEF)))),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                // StatefulBuilder(builder: (context, setState) {
                //   return SfRangeSlider(
                //     min: 0,
                //     max: 100000,
                //     values: salaryFromTo,
                //     inactiveColor: Colors.grey,
                //     activeColor: const Color(0xffFF385C),
                //     showLabels: false,
                //     interval: 1000, // Controls label intervals
                //     stepSize: 1000, // Ensures the slider moves in steps of 1000
                //     labelFormatterCallback:
                //         (dynamic actualValue, String formattedText) {
                //       return actualValue == 99999
                //           ? ' $formattedText+'
                //           : ' $formattedText';
                //     },
                //     onChanged: (SfRangeValues newValues) {
                //       if ((newValues.end - newValues.start) >= 1000) {
                //         viewModel.jobSalaryFromController.text =
                //             "${newValues.start.round()}";
                //         viewModel.jobSalaryToController.text =
                //             "${newValues.end.round()}";
                //         setState(() {
                //           salaryFromTo = newValues;
                //         });
                //       }
                //     },
                //   );
                // }),
                const SizedBox(
                  height: 10,
                ),
                // const Gap(10),
                // CommonDropdown(
                //   title: StringHelper.salaryPeriod,
                //   hint:viewModel.jobSalaryTextController.text,
                //   options: viewModel.salaryPeriodList,
                //   onSelected: (String? value) {
                //     viewModel.jobSalaryTextController.text = value??"";
                //   },
                //   // controller: viewModel.jobSalaryTextController,
                //   // readOnly: true,
                //   // suffix: PopupMenuButton(
                //   //   clipBehavior: Clip.hardEdge,
                //   //   icon: const Icon(
                //   //     Icons.arrow_drop_down,
                //   //     color: Colors.black,
                //   //   ),
                //   //   onSelected: (String value) {
                //   //     viewModel.jobSalaryTextController.text = value;
                //   //   },
                //   //   itemBuilder: (BuildContext context) {
                //   //     return viewModel.salaryPeriodList.map((option) {
                //   //       return PopupMenuItem(
                //   //         value: option,
                //   //         child: Text(option),
                //   //       );
                //   //     }).toList();
                //   //   },
                //   // ),
                // ),
                // const Gap(10),
                // AppTextField(
                //   title: StringHelper.salary,
                //   hint: StringHelper.enter,
                //   controller: viewModel.jobSalaryFromController,
                //   inputFormatters: [
                //     FilteringTextInputFormatter.digitsOnly,
                //     LengthLimitingTextInputFormatter(8),
                //   ],
                // ),
                // const Gap(10),
                // AppTextField(
                //   title: StringHelper.salaryTo,
                //   hint: StringHelper.enter,
                //   controller: viewModel.jobSalaryToController,
                //   inputFormatters: [
                //     FilteringTextInputFormatter.digitsOnly,
                //     LengthLimitingTextInputFormatter(8),
                //   ],
                // ),
                //const Gap(10),
              ],
              AppTextField(
                title: StringHelper.location,
                hint: StringHelper.selectLocation,
                controller: viewModel.locationTextController,
                readOnly: true,
                suffix: const Icon(Icons.location_on),
                onTap: () async {
                  Map<String, dynamic>? value = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AppMapWidget()));
                  debugPrint("$value");
                  if (value != null && value.isNotEmpty) {
                    String address = "";

                    if ("${value['location'] ?? ""}".isNotEmpty) {
                      address = "${value['location'] ?? ""}";
                    }
                    if ("${value['city'] ?? ""}".isNotEmpty) {
                      address += ", ${value['city'] ?? ""}";
                    }
                    if ("${value['state'] ?? ""}".isNotEmpty) {
                      address += ", ${value['state'] ?? ""}";
                    }

                    viewModel.locationTextController.text = address;
                    viewModel.latitude = double.parse(value['latitude']);
                    viewModel.longitude = double.parse(value['longitude']);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CommonDropdown<CategoryModel?>(
                title: StringHelper.sortBy,
                hint: viewModel.sortByTextController.text.isEmpty
                    ? StringHelper.sortBy
                    : viewModel.sortByTextController.text,
                onSelected: (value) {
                  viewModel.sortByTextController.text = value?.name ?? '';
                  filter.sortByPrice =
                      value?.name == StringHelper.priceLowToHigh
                          ? 'asc'
                          : 'desc';
                },
                options: sortByList,
                listItemBuilder: (context, model, selected, fxn) {
                  return Text(model?.name ?? '');
                },
                headerBuilder: (context, selectedItem, enabled) {
                  return Text(selectedItem?.name ?? "");
                },
                // readOnly: true,
                // suffix: PopupMenuButton(
                //   icon: const Icon(Icons.arrow_drop_down),
                //   onSelected: (value) {
                //     viewModel.sortByTextController.text = value.name ?? '';
                //     filter.sortByPrice =
                //         value.name == StringHelper.priceLowToHigh
                //             ? 'asc'
                //             : 'desc';
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return sortByList.map((option) {
                //       return PopupMenuItem(
                //         value: option,
                //         child: Text(option.name ?? ''),
                //       );
                //     }).toList();
                //   },
                // ),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonDropdown<CategoryModel?>(
                title: StringHelper.postedWithin,
                hint: viewModel.postedWithinTextController.text.isEmpty
                    ? StringHelper.postedWithin
                    : viewModel.postedWithinTextController.text,
                onSelected: (value) {
                  viewModel.postedWithinTextController.text = value?.name ?? '';
                  setDatePosted(value: value);
                },
                options: postedWithinList,
                listItemBuilder: (context, model, selected, fxn) {
                  return Text(model?.name ?? '');
                },
                headerBuilder: (context, selectedItem, enabled) {
                  return Text(selectedItem?.name ?? "");
                },
                // controller: viewModel.postedWithinTextController,
                // readOnly: true,
                // suffix: PopupMenuButton(
                //   icon: const Icon(Icons.arrow_drop_down),
                //   onSelected: (value) {
                //     viewModel.postedWithinTextController.text =
                //         value.name ?? '';
                //     setDatePosted(value: value);
                //   },
                //   itemBuilder: (BuildContext context) {
                //     return postedWithinList.map((option) {
                //       return PopupMenuItem(
                //         value: option,
                //         child: Text(option.name ?? ''),
                //       );
                //     }).toList();
                //   },
                // ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              AppElevatedButton(
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onTap: () {
                  if (viewModel.itemCondition != 0 &&
                      filter.categoryId != "8" &&
                      filter.categoryId != "9") {
                    filter.itemCondition = viewModel.itemCondition == 1
                        ? StringHelper.newText
                        : StringHelper.used;
                  }

                  if ((filter.categoryId ?? "").isNotEmpty &&
                      filter.categoryId != '9') {
                   // if (values.start >= 0 && values.end <= 100000) {
                    if (viewModel.startPriceTextController.text.trim().isNotEmpty && viewModel.endPriceTextController.text.trim().isNotEmpty) {
                      filter.minPrice =
                          viewModel.startPriceTextController.text.trim();
                      filter.maxPrice =
                          viewModel.endPriceTextController.text.trim();
                    }
                  }
                  // if (viewModel.sizesTextController.text.trim().isNotEmpty) {
                  //   filter.sizeId = viewModel.sizesTextController.text.trim();
                  // }
                 // if (filter.categoryId == '9' && salaryFromTo.start >= 0 && salaryFromTo.end <= 100000) {
                  if (filter.categoryId == '9' && viewModel.jobSalaryFromController.text.trim().isNotEmpty&& viewModel.jobSalaryToController.text.trim().isNotEmpty) {
                    filter.salleryFrom =
                        viewModel.jobSalaryFromController.text.trim();
                    filter.salleryTo =
                        viewModel.jobSalaryToController.text.trim();
                  }

                  if ("${viewModel.latitude}" != "0.0" &&
                      "${viewModel.longitude}" != "0.0") {
                    filter.latitude = viewModel.latitude.toString();
                    filter.longitude = viewModel.longitude.toString();
                  }

                  if (viewModel.yearTextController.text.trim().isNotEmpty) {
                    filter.year = viewModel.yearTextController.text.trim();
                  }
                  if (viewModel.carRentalTermController.text
                      .trim()
                      .isNotEmpty) {
                    filter.carRentalTerm =
                        viewModel.carRentalTermController.text.trim();
                  }
                  if (viewModel.fuelTextController.text.trim().isNotEmpty) {
                    filter.fuel = viewModel.fuelTextController.text.trim();
                  }
                  if (viewModel.carColorTextController.text.trim().isNotEmpty) {
                    // Added
                    filter.carColor =
                        viewModel.carColorTextController.text.trim();
                  }
                  if (viewModel.horsePowerTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.horsePower =
                        viewModel.horsePowerTextController.text.trim();
                  }
                  if (viewModel.engineCapacityTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.engineCapacity =
                        viewModel.engineCapacityTextController.text.trim();
                  }
                  if (viewModel.screenSizeTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.screenSize =
                        viewModel.screenSizeTextController.text.trim();
                  }
                  if (viewModel.interiorColorTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.interiorColor =
                        viewModel.interiorColorTextController.text.trim();
                  }
                  if (viewModel.numbCylindersTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.numbCylinders =
                        viewModel.numbCylindersTextController.text.trim();
                  }
                  if (viewModel.numbDoorsTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.numbDoors =
                        viewModel.numbDoorsTextController.text.trim();
                  }
                  if (viewModel.bodyTypeTextController.text.trim().isNotEmpty) {
                    filter.bodyType =
                        viewModel.bodyTypeTextController.text.trim();
                  }
                  if (viewModel.workSettingTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.workSetting =
                        viewModel.workSettingTextController.text.trim();
                  }
                  if (viewModel.workExperienceTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.workExperience =
                        viewModel.workExperienceTextController.text.trim();
                  }
                  if (viewModel.workEducationTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.workEducation =
                        viewModel.workEducationTextController.text.trim();
                  }
                  if (viewModel.propertyForTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.propertyFor =
                        viewModel.propertyForTextController.text.trim();
                  }

                  if (viewModel.noOfBedroomsTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.bedrooms =
                        viewModel.noOfBedroomsTextController.text.trim();
                  }

                  if (viewModel.noOfBathroomsTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.bathrooms =
                        viewModel.noOfBathroomsTextController.text.trim();
                  }

                  if (viewModel.furnishingStatusTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.furnishedType =
                        viewModel.furnishingStatusTextController.text.trim();
                  }

                  if (viewModel.ownershipStatusTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.ownership =
                        viewModel.ownershipStatusTextController.text.trim();
                  }

                  if (viewModel.paymentTypeTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.paymentType =
                        viewModel.paymentTypeTextController.text.trim();
                  }

                  if (viewModel.completionStatusTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.completionStatus =
                        viewModel.completionStatusTextController.text.trim();
                  }

                  if (viewModel.deliveryTermTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.deliveryTerm =
                        viewModel.deliveryTermTextController.text.trim();
                  }

                  if (viewModel.propertyForTypeTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.type =
                        viewModel.propertyForTypeTextController.text.trim();
                  }

                  if (viewModel.levelTextController.text.trim().isNotEmpty) {
                    filter.level = viewModel.levelTextController.text.trim();
                  }

                  if (viewModel.listedByTextController.text.trim().isNotEmpty) {
                    filter.listedBy =
                        viewModel.listedByTextController.text.trim();
                  }

                  if (viewModel.rentalTermsTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.rentalTerm =
                        viewModel.rentalTermsTextController.text.trim();
                  }

                  if (viewModel.accessToUtilitiesTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.accessToUtilities =
                        viewModel.accessToUtilitiesTextController.text.trim();
                  }
                  if (filter.categoryId == "11" &&
                      ["83", "84", "87"].contains(filter.subcategoryId)) {
                    //if (downValues.start >= 0 && downValues.end <= 100000) {
                    if (viewModel.startDownPriceTextController.text.trim().isNotEmpty && viewModel.endDownPriceTextController.text.trim().isNotEmpty) {
                      filter.minDownPrice =
                          viewModel.startDownPriceTextController.text.trim();
                      filter.maxDownPrice =
                          viewModel.endDownPriceTextController.text.trim();
                    }
                  }
                  if (viewModel.ramTextController.text.trim().isNotEmpty) {
                    filter.ram = viewModel.ramTextController.text.trim();
                  }
                  if (viewModel.storageTextController.text.trim().isNotEmpty) {
                    filter.storage =
                        viewModel.storageTextController.text.trim();
                  }

                 // if (filter.categoryId == "11" && areaValues.start >= 0 && areaValues.end <= 100000) {
                  if (filter.categoryId == "11" && viewModel.startAreaTextController.text.trim().isNotEmpty && viewModel.endAreaTextController.text.trim().isNotEmpty) {
                    filter.minAreaSize =
                        viewModel.startAreaTextController.text.trim();
                    filter.maxAreaSize =
                        viewModel.endAreaTextController.text.trim();
                  }
                  // if (filter.categoryId == "4" &&
                  //     kmDrivenValues.start >= 0 &&
                  //     kmDrivenValues.end <= 1000000) {
                  //   filter.minKmDriven =
                  //       viewModel.minKmDrivenTextController.text.trim();
                  //   filter.maxKmDriven =
                  //       viewModel.maxKmDrivenTextController.text.trim();
                  // }

                  // if (viewModel.kmDrivenTextController.text.trim().isNotEmpty) {
                  //   filter.minKmDriven =
                  //       viewModel.kmDrivenTextController.text.trim();
                  // }
                  if (filter.categoryId == "4" &&
                      //(filter.subcategoryId == "13" || filter.subcategoryId == "26") && kmDrivenValues.start >= 0 && kmDrivenValues.end <= 1000000) {
                      (filter.subcategoryId == "13" || filter.subcategoryId == "26") && viewModel.minKmDrivenTextController.text.trim().isNotEmpty && viewModel.maxKmDrivenTextController.text.trim().isNotEmpty) {
                    filter.minKmDriven =
                        viewModel.minKmDrivenTextController.text.trim();
                    filter.maxKmDriven =
                        viewModel.maxKmDrivenTextController.text.trim();
                  }
                  if (viewModel.mileageTextController.text.trim().isNotEmpty) {
                    filter.milleage =
                        viewModel.mileageTextController.text.trim();
                  }

                  // filter.minPrice =
                  //     viewModel.startPriceTextController.text.trim();
                  // filter.maxPrice =
                  //     viewModel.endPriceTextController.text.trim();
                  // filter.latitude = viewModel.latitude.toString();
                  // filter.longitude = viewModel.longitude.toString();
                  // filter.year = viewModel.yearTextController.text.trim();
                  // filter.fuel = viewModel.fuelTextController.text.trim();
                  //
                  // filter.propertyFor = viewModel.propertyForTextController.text.trim();
                  // filter.bedrooms = viewModel.noOfBedroomsTextController.text.trim();
                  // filter.bathrooms = viewModel.noOfBathroomsTextController.text.trim();
                  // filter.furnishedType = viewModel.furnishingStatusTextController.text.trim();
                  // filter.ownership = viewModel.ownershipStatusTextController.text.trim();
                  // filter.paymentType = viewModel.paymentTypeTextController.text.trim();
                  // filter.completionStatus = viewModel.completionStatusTextController.text.trim();
                  // filter.deliveryTerm = viewModel.deliveryTermTextController.text.trim();
                  // filter.type = viewModel.propertyForTypeTextController.text.trim();
                  // filter.level = viewModel.levelTextController.text.trim();
                  // filter.listedBy = viewModel.listedByTextController.text.trim();
                  // filter.rentalTerm = viewModel.rentalTermsTextController.text.trim();
                  // filter.accessToUtilities = viewModel.accessToUtilitiesTextController.text.trim();
                  // filter.minDownPrice = viewModel.startDownPriceTextController.text.trim();
                  // filter.maxDownPrice = viewModel.endDownPriceTextController.text.trim();
                  // filter.maxAreaSize = viewModel.startAreaTextController.text.trim();
                  // filter.minAreaSize = viewModel.endAreaTextController.text.trim();
                  //
                  // filter.minKmDriven =
                  //     viewModel.kmDrivenTextController.text.trim();
                  context.pop();
                  if (widget.filters?.screenFrom == "home") {
                    context.push(Routes.filterDetails, extra: filter);
                  } else {
                    context.pushReplacement(Routes.filterDetails,
                        extra: filter);
                  }
                },
                title: StringHelper.apply,
              ),
              const Gap(10),
              AppOutlineButton(
                title: StringHelper.reset,
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onTap: () {
                  resetFilters();
                  context.pop();
                  // context.push(Routes.filterDetails, extra: filter);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  void updateFilter({required HomeVM vm}) async {
    categoriesList = vm.categories;
    resetFilters();
    if (widget.filters != null) {
      brands.clear();
      fashionSizes.clear();
      filter = widget.filters!;
      vm.currentPropertyType = filter.propertyFor ?? "";
      vm.itemCondition = (filter.itemCondition ?? "").isEmpty
          ? 0
          : (filter.itemCondition?.toLowerCase().contains('used') ?? false)
              ? 2
              : 1;
      debugPrint("vm.itemCondition ${vm.itemCondition}");
      vm.latitude = double.parse(filter.latitude ?? '0.0');
      vm.longitude = double.parse(filter.longitude ?? '0.0');
      vm.startPriceTextController.text = filter.minPrice ?? '0';
      vm.endPriceTextController.text =
          filter.maxPrice != '0' ? filter.maxPrice ?? '100000' : '100000';

      vm.jobSalaryFromController.text = filter.salleryFrom ?? '0';
      vm.jobSalaryToController.text =
          filter.salleryTo != '0' ? filter.salleryTo ?? '100000' : '100000';

      // vm.kmDrivenTextController.text = filter.minKmDriven ?? '';
      vm.yearTextController.text = filter.year ?? '';
      vm.fuelTextController.text = filter.fuel ?? '';
      vm.carColorTextController.text = filter.carColor ?? '';
      vm.horsePowerTextController.text = filter.horsePower ?? '';
      vm.ramTextController.text = filter.ram ?? "";
      vm.storageTextController.text = filter.storage ?? "";
      vm.bodyTypeTextController.text = filter.bodyType ?? "";
      vm.engineCapacityTextController.text = filter.engineCapacity ?? '';
      vm.interiorColorTextController.text = filter.interiorColor ?? '';
      vm.numbCylindersTextController.text = filter.numbCylinders ?? '';
      vm.numbDoorsTextController.text = filter.numbDoors ?? '';
      vm.carRentalTermController.text = filter.carRentalTerm ?? '';
      vm.mileageTextController.text = filter.milleage ?? '';
      vm.screenSizeTextController.text = filter.screenSize ?? '';
      vm.propertyForTextController.text = filter.propertyFor ?? '';
      vm.workSettingTextController.text = filter.workSetting ?? '';
      vm.workExperienceTextController.text = filter.workExperience ?? '';
      vm.workEducationTextController.text = filter.workEducation ?? '';
      filter.ram = "";
      filter.storage = "";

      // vm.currentLocation = await LocationHelper.getAddressFromCoordinates(
      //     vm.latitude, vm.longitude);
      vm.categoryTextController.text = getCategoryName(id: filter.categoryId);
      if ((filter.categoryId ?? "").isNotEmpty && filter.categoryId != '0') {
        await getSubCategory(id: filter.categoryId);
      }
      if ((filter.subcategoryId ?? "").isNotEmpty) {
        await getBrands(id: filter.subcategoryId);
        vm.subCategoryTextController.text =
            getSubCategoryName(id: filter.subcategoryId);
        await getSubSubCategories(id: filter.subcategoryId);
      }

      // if ((filter.sizeId ?? "").isNotEmpty) {
      //   vm.sizesTextController.text = getFashionSizeName(id: filter.sizeId);
      // }
      if ((filter.subSubCategoryId ?? "").isNotEmpty) {
        // Maybe update UI or fetch additional data based on sub-subcategory
        await getFashionSizes(id: filter.subSubCategoryId);
      }

      // if (filter.categoryId == "4") {
      //   vm.minKmDrivenTextController.text = widget.filters?.minKmDriven ?? '0';
      //   vm.maxKmDrivenTextController.text =
      //       widget.filters?.maxKmDriven ?? '1000000';
      //   setState(() {
      //     kmDrivenValues = SfRangeValues(
      //       double.tryParse(vm.minKmDrivenTextController.text) ?? 0,
      //       double.tryParse(vm.maxKmDrivenTextController.text) ?? 1000000,
      //     );
      //   });
      // }
      if (filter.categoryId == '4' &&
          (filter.subcategoryId == '13' || filter.subcategoryId == '26')) {
        // Only set KM driven for cars for sale and motorcycles
        //vm.minKmDrivenTextController.text = widget.filters?.minKmDriven ?? '0';
        //vm.maxKmDrivenTextController.text = widget.filters?.maxKmDriven ?? '1000000';
        vm.minKmDrivenTextController.text = widget.filters?.minKmDriven ?? '';
        vm.maxKmDrivenTextController.text = widget.filters?.maxKmDriven ?? '';
        // setState(() {
        //   kmDrivenValues = SfRangeValues(
        //     double.tryParse(vm.minKmDrivenTextController.text) ?? 0,
        //     double.tryParse(vm.maxKmDrivenTextController.text) ?? 1000000,
        //   );
        // });
      } else {
        // For other subcategories, don't set KM driven values
        vm.minKmDrivenTextController.clear();
        vm.maxKmDrivenTextController.clear();
        // vm.minKmDrivenTextController.text = '0';
        // vm.maxKmDrivenTextController.text = '1000000';
        // kmDrivenValues = SfRangeValues(0, 1000000);
      }
      // vm.brandsTextController.clear();
      if ((filter.brandId ?? "").isNotEmpty) {
        vm.brandsTextController.text = getBrandName(id: filter.brandId);
      }
      vm.sizesTextController.clear();
      if ((filter.sizeId ?? "").isNotEmpty) {
        vm.sizesTextController.text = getFashionSizeName(id: filter.sizeId);
      }
      vm.minKmDrivenTextController.clear();
      vm.maxKmDrivenTextController.clear();
      // vm.minKmDrivenTextController.text = '0';
      // vm.maxKmDrivenTextController.text = '1000000';
      // kmDrivenValues = SfRangeValues(
      //   double.tryParse(vm.minKmDrivenTextController.text) ?? 0,
      //   double.tryParse(vm.maxKmDrivenTextController.text) ?? 1000000,
      // );

      // values = SfRangeValues(
      //     int.parse(vm.startPriceTextController.text.isEmpty
      //         ? '0'
      //         : vm.startPriceTextController.text),
      //     int.parse(vm.endPriceTextController.text));
      if ((filter.selectedAmnities ?? "").isNotEmpty) {
        selectedAmenities = (filter.selectedAmnities ?? "")
            .split(',')
            .map((e) => int.parse(e))
            .toList();
      }
      //vm.locationTextController.text = vm.currentLocation;
    }
    log("${categoriesList.map((element) => element.toJson()).toList()}",
        name: "BASEX");
    setState(() {});
  }

  void resetFilters() {
    HomeVM vm = context.read<HomeVM>();
    filter = FilterModel();
    vm.itemCondition = 0;
    //vm.latitude = LocationHelper.cairoLatitude;
    //vm.longitude = LocationHelper.cairoLongitude;
    vm.latitude = 0.0;
    vm.longitude = 0.0;
    vm.locationTextController.text = "Cairo, Egypt";
    //vm.startPriceTextController.text = '0';
    vm.startPriceTextController.clear();
    //vm.endPriceTextController.text = '100000';
    vm.endPriceTextController.clear();
    // values = SfRangeValues(
    //     int.parse(vm.startPriceTextController.text.isEmpty
    //         ? '0'
    //         : vm.startPriceTextController.text),
    //     int.parse(vm.endPriceTextController.text.isEmpty
    //         ? '100000'
    //         : vm.endPriceTextController.text));
    brands.clear();
    fashionSizes.clear();
    selectedAmenities.clear();
    subCategoriesList.clear();
    filter.categoryId = "";
    vm.categoryTextController.clear();
    vm.subCategoryTextController.clear();
    vm.sortByTextController.clear();
    vm.postedWithinTextController.clear();
    vm.brandsTextController.clear();
    vm.propertyForTextController.clear();
    vm.currentPropertyType = "Sell";
    vm.carColorTextController.clear();
    vm.horsePowerTextController.clear();
    vm.engineCapacityTextController.clear();
    vm.interiorColorTextController.clear();
    vm.numbCylindersTextController.clear();
    vm.screenSizeTextController.clear();
    vm.numbDoorsTextController.clear();
    vm.sizesTextController.clear();
    vm.ramTextController.clear();
    vm.storageTextController.clear();
    vm.carRentalTermController.clear();
    vm.workSettingTextController.clear();
    vm.workExperienceTextController.clear();
    vm.workEducationTextController.clear();
    vm.bodyTypeTextController.clear();
    vm.noOfBathroomsTextController.clear();
    vm.noOfBedroomsTextController.clear();
    vm.furnishingStatusTextController.clear();
    vm.accessToUtilitiesTextController.clear();
    vm.ownershipStatusTextController.clear();
    vm.propertyForTypeTextController.clear();
    vm.paymentTypeTextController.clear();
    vm.listedByTextController.clear();
    vm.rentalTermsTextController.clear();
    vm.completionStatusTextController.clear();
    vm.deliveryTermTextController.clear();
    vm.levelTextController.clear();
    vm.mileageTextController.clear();
    // downValues = SfRangeValues(
    //     int.parse(vm.startDownPriceTextController.text.isEmpty
    //         ? '0'
    //         : vm.startDownPriceTextController.text),
    //     int.parse(vm.endDownPriceTextController.text.isEmpty
    //         ? '100000'
    //         : vm.endDownPriceTextController.text));
    // vm.startDownPriceTextController.text = '0';
    // vm.endDownPriceTextController.text = '100000';
    vm.startDownPriceTextController.clear();
    vm.endDownPriceTextController.clear();
    //areaValues = SfRangeValues(
    //     int.parse(vm.startAreaTextController.text.isEmpty
    //         ? '0'
    //         : vm.startAreaTextController.text),
    //     int.parse(vm.endAreaTextController.text.isEmpty
    //         ? '100000'
    //         : vm.endAreaTextController.text));
    // vm.startAreaTextController.text = '0';
    // vm.endAreaTextController.text = '100000';
    vm.startAreaTextController.clear();
    vm.endAreaTextController.clear();
    // salaryFromTo = SfRangeValues(
    //     int.parse(vm.jobSalaryFromController.text.isEmpty
    //         ? '0'
    //         : vm.jobSalaryFromController.text),
    //     int.parse(vm.jobSalaryToController.text.isEmpty
    //         ? '100000'
    //         : vm.jobSalaryToController.text));
    // vm.jobSalaryFromController.text = '0';
    // vm.jobSalaryToController.text = '100000';
    vm.jobSalaryFromController.clear();
    vm.jobSalaryToController.clear();
    setState(() {});
  }

  String getCategoryName({String? id}) {
    if (id == null) return '';

    for (var category in categoriesList) {
      if (category.id.toString() == id) {
        return category.name ?? '';
      }
    }
    return ''; // Return empty string if category not found
  }

  String getSubCategoryName({String? id}) {
    if (id == null) return '';

    for (var subCategories in subCategoriesList) {
      if (subCategories.id.toString() == id) {
        return subCategories.name ?? '';
      }
    }

    return ''; // Return empty string if category not found
  }

  String getSubSubCategoryName({String? id}) {
    if (id == null || id.isEmpty) return '';
    for (var subSub in subSubCategories) {
      if (subSub.id.toString() == id) return subSub.name ?? '';
    }
    return '';
  }

  String getBrandName({String? id}) {
    if (id == null) return '';

    for (var brand in brands) {
      if (brand.id.toString() == id) {
        return brand.name ?? '';
      }
    }

    return ''; // Return empty string if category not found
  }

  String getFashionSizeName({String? id}) {
    if (id == null) return '';

    for (var size in fashionSizes) {
      if (size.id.toString() == id) {
        return size.name ?? '';
      }
    }

    return ''; // Return empty string if size not found
  }

  Future<void> getSubCategory({String? id}) async {
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "$id"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    subCategoriesList = model.body ?? [];
    DialogHelper.hideLoading();
    setState(() {});
  }

  Future<void> getBrands({String? id}) async {
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getBrandsUrl(id: "$id"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    brands = model.body ?? [];
    DialogHelper.hideLoading();
    setState(() {});
  }

  Future<void> getSubSubCategories({String? id}) async {
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubSubCategoriesUrl(id: "$id"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    subSubCategories = model.body ?? [];
    DialogHelper.hideLoading();
    setState(() {});
  }

  Future<void> getFashionSizes({String? id}) async {
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getFashionSizeUrl(id: "$id"),
      requestType: RequestType.get,
    );
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    fashionSizes = model.body ?? [];
    DialogHelper.hideLoading();
    setState(() {});
  }

  void setDatePosted({CategoryModel? value}) {
    var now = DateTime.now();
    switch (value?.id) {
      case 1:
        filter.startDate = DateFormat('yyyy-MM-dd').format(now);
        filter.endDate =
            DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));
        break;
      case 2:
        filter.startDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 1)));
        filter.endDate = DateFormat('yyyy-MM-dd').format(now);
        break;
      case 3:
        filter.endDate = DateFormat('yyyy-MM-dd').format(now);
        //filter.startDate = DateFormat('yyyy-MM-dd').format(now);
        filter.startDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 7)));
        break;
      case 4:
        filter.endDate = DateFormat('yyyy-MM-dd').format(now);
        filter.startDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 30)));
        break;
    }
  }

  Widget commonWidget(
      BuildContext context, String? subcategoryId, HomeVM viewModel) {
    if (filter.categoryId == '4') {
      // Vehicles
      switch (subcategoryId) {
        case '13': // Cars for Sale
          return carsForSaleWidget(viewModel);
        case '25': // Cars for Rent
          return carsForRentWidget(viewModel);
        case '26': // Motorcycles
          return motorcyclesWidget(viewModel);
        case '98': // Trucks
          return trucksWidget(viewModel);
        default:
          return const SizedBox.shrink(); // Empty widget if no match
      }
    }
    if (filter.categoryId == '11') {
      // Properties
      switch (subcategoryId) {
        case '83': // Apartments
          return apartmentWidget(
              viewModel); // You’ll need to define this if not already
        case '84': // Villas
          return villaWidget(viewModel); // Already defined in your code
        case '85': // Businesses
          return businessWidget(viewModel); // Already defined
        case '86': // Lands
          return landWidget(viewModel); // Already defined
        default:
          return const SizedBox.shrink();
      }
    }
    return const SizedBox.shrink(); // Default empty widget
  }

  Widget carsForSaleWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.year,
          hint: viewModel.yearTextController.text.isEmpty
              ? StringHelper.selectYear
              : viewModel.yearTextController.text,
          onSelected: (value) {
            viewModel.yearTextController.text = value ?? '';
            filter.year = value;
          },
          options: yearsType,
        ),
        const SizedBox(height: 10),
        CommonDropdown(
          title: StringHelper.fuel,
          hint: viewModel.fuelTextController.text,
          onSelected: (value) {
            viewModel.fuelTextController.text = value ?? '';
            filter.fuel = value;
          },
          options: fuelsType,
        ),
        const SizedBox(height: 10),
        AppTextField(
          title: StringHelper.mileage,
          controller: viewModel.mileageTextController,
          hint: StringHelper.mileage,
          maxLength: 6,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(6),
            FilteringTextInputFormatter.deny(
                RegExp(viewModel.regexToRemoveEmoji)),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.carColorTitle,
          titleColor: Colors.black,
          hint: viewModel.carColorTextController.text,
          onSelected: (String? value) {
            viewModel.carColorTextController.text = value ?? '';
          },
          options: StringHelper.carColorOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.horsepowerTitle,
          titleColor: Colors.black,
          hint: viewModel.horsePowerTextController.text.isEmpty
              ? ""
              : viewModel.horsePowerTextController.text,
          onSelected: (String? value) {
            viewModel.horsePowerTextController.text = value ?? '';
          },
          options: viewModel.horsepowerOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.engineCapacityTitle,
          titleColor: Colors.black,
          hint: viewModel.engineCapacityTextController.text.isEmpty
              ? ""
              : viewModel.engineCapacityTextController.text,
          onSelected: (String? value) {
            viewModel.engineCapacityTextController.text = value ?? '';
          },
          options: viewModel.engineCapacityOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.interiorColorTitle,
          titleColor: Colors.black,
          hint: viewModel.interiorColorTextController.text.isEmpty
              ? ""
              : viewModel.interiorColorTextController.text,
          onSelected: (String? value) {
            viewModel.interiorColorTextController.text = value ?? '';
          },
          options: StringHelper.carColorOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.numbDoorsTitle,
          titleColor: Colors.black,
          hint: viewModel.numbDoorsTextController.text.isEmpty
              ? ""
              : viewModel.numbDoorsTextController.text,
          onSelected: (String? value) {
            viewModel.numbDoorsTextController.text = value ?? '';
          },
          options: viewModel.numbDoorsOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.bodyTypeTitle,
          titleColor: Colors.black,
          hint: viewModel.bodyTypeTextController.text.isEmpty
              ? ""
              : viewModel.bodyTypeTextController.text,
          onSelected: (String? value) {
            viewModel.bodyTypeTextController.text = value ?? '';
          },
          options: StringHelper.bodyTypeOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown(
          title: StringHelper.transmission,
          hint: viewModel.transmissionTextController.text.isEmpty
              ? StringHelper.selectTransmission
              : viewModel.transmissionTextController.text,
          onSelected: (value) {
            viewModel.transmissionTextController.text = value ?? "";
            filter.transmission = value?.toLowerCase();
          },
          options: transmissionType,
        ),
        const SizedBox(height: 10),
        Text(StringHelper.kmDriven, style: context.textTheme.titleSmall),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.minKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
                  //readOnly: true,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minKm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(StringHelper.to, style: context.textTheme.titleSmall),
            const SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.maxKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
                  //readOnly: true,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxKm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 15),
        // StatefulBuilder(
        //   builder: (context, setState) {
        //     return SfRangeSlider(
        //       min: 0,
        //       max: 1000000,
        //       values: kmDrivenValues,
        //       inactiveColor: Colors.grey,
        //       activeColor: const Color(0xffFF385C),
        //       showLabels: false,
        //       interval: 100000,
        //       stepSize: 1000,
        //       labelFormatterCallback:
        //           (dynamic actualValue, String formattedText) {
        //         return actualValue == 1000000 ? '1,000,000+' : formattedText;
        //       },
        //       onChanged: (SfRangeValues newValues) {
        //         if ((newValues.end - newValues.start) >= 1000) {
        //           viewModel.minKmDrivenTextController.text =
        //               "${newValues.start.round()}";
        //           viewModel.maxKmDrivenTextController.text =
        //               "${newValues.end.round()}";
        //           setState(() {
        //             kmDrivenValues = newValues;
        //           });
        //         }
        //       },
        //     );
        //   },
        // ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget carsForRentWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown<String>(
          title: StringHelper.rentalCarTerm,
          titleColor: Colors.black,
          hint: viewModel.carRentalTermController.text.isEmpty
              ? ""
              : viewModel.carRentalTermController.text,
          onSelected: (String? value) {
            viewModel.carRentalTermController.text = value ?? "";
            filter.carRentalTerm = value;
          },
          options: viewModel.carRentalTermOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown(
          title: StringHelper.fuel,
          hint: viewModel.fuelTextController.text,
          onSelected: (value) {
            viewModel.fuelTextController.text = value ?? '';
            filter.fuel = value;
          },
          options: fuelsType,
        ),
        const SizedBox(height: 10),
        CommonDropdown<String>(
          title: StringHelper.bodyTypeTitle,
          titleColor: Colors.black,
          hint: viewModel.bodyTypeTextController.text.isEmpty
              ? ""
              : viewModel.bodyTypeTextController.text,
          onSelected: (String? value) {
            viewModel.bodyTypeTextController.text = value ?? '';
          },
          options: StringHelper.bodyTypeOptions,
        ),
        const SizedBox(height: 10),
        CommonDropdown(
          title: StringHelper.transmission,
          hint: viewModel.transmissionTextController.text.isEmpty
              ? StringHelper.selectTransmission
              : viewModel.transmissionTextController.text,
          onSelected: (value) {
            viewModel.transmissionTextController.text = value ?? "";
            filter.transmission = value?.toLowerCase();
          },
          options: transmissionType,
        ),
      ],
    );
  }

  Widget trucksWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.year,
          hint: viewModel.yearTextController.text.isEmpty
              ? StringHelper.selectYear
              : viewModel.yearTextController.text,
          onSelected: (value) {
            viewModel.yearTextController.text = value ?? '';
            filter.year = value;
          },
          options: yearsType,
        ),
        const SizedBox(height: 10),
        Text(StringHelper.kmDriven, style: context.textTheme.titleSmall),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.minKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
                  //readOnly: true,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minKm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(StringHelper.to, style: context.textTheme.titleSmall),
            const SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.maxKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
                  //readOnly: true,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxKm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 15),
        // StatefulBuilder(
        //   builder: (context, setState) {
        //     return SfRangeSlider(
        //       min: 0,
        //       max: 1000000,
        //       values: kmDrivenValues,
        //       inactiveColor: Colors.grey,
        //       activeColor: const Color(0xffFF385C),
        //       showLabels: false,
        //       interval: 100000,
        //       stepSize: 1000,
        //       labelFormatterCallback:
        //           (dynamic actualValue, String formattedText) {
        //         return actualValue == 1000000 ? '1,000,000+' : formattedText;
        //       },
        //       onChanged: (SfRangeValues newValues) {
        //         if ((newValues.end - newValues.start) >= 1000) {
        //           viewModel.minKmDrivenTextController.text =
        //               "${newValues.start.round()}";
        //           viewModel.maxKmDrivenTextController.text =
        //               "${newValues.end.round()}";
        //           setState(() {
        //             kmDrivenValues = newValues;
        //           });
        //         }
        //       },
        //     );
        //   },
        // ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget motorcyclesWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.year,
          hint: viewModel.yearTextController.text.isEmpty
              ? StringHelper.selectYear
              : viewModel.yearTextController.text,
          onSelected: (value) {
            viewModel.yearTextController.text = value ?? '';
            filter.year = value;
          },
          options: yearsType,
        ),
        const SizedBox(height: 10),
        Text(StringHelper.kmDriven, style: context.textTheme.titleSmall),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.minKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
                  //readOnly: true,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minKm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(StringHelper.to, style: context.textTheme.titleSmall),
            const SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.maxKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
                  //readOnly: true,
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxKm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 15),
        // StatefulBuilder(
        //   builder: (context, setState) {
        //     return SfRangeSlider(
        //       min: 0,
        //       max: 1000000,
        //       values: kmDrivenValues,
        //       inactiveColor: Colors.grey,
        //       activeColor: const Color(0xffFF385C),
        //       showLabels: false,
        //       interval: 100000,
        //       stepSize: 1000,
        //       labelFormatterCallback:
        //           (dynamic actualValue, String formattedText) {
        //         return actualValue == 1000000 ? '1,000,000+' : formattedText;
        //       },
        //       onChanged: (SfRangeValues newValues) {
        //         if ((newValues.end - newValues.start) >= 1000) {
        //           viewModel.minKmDrivenTextController.text =
        //               "${newValues.start.round()}";
        //           viewModel.maxKmDrivenTextController.text =
        //               "${newValues.end.round()}";
        //           setState(() {
        //             kmDrivenValues = newValues;
        //           });
        //         }
        //       },
        //     );
        //   },
        // ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget apartmentWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.propertyType,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTextController.text,
          onSelected: (String? value) {
            viewModel.currentPropertyType = value ?? "";
            viewModel.propertyForTextController.text = value ?? "";
          },
          options: ['Sell', 'Rent'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.currentPropertyType = value;
          //     viewModel.propertyForTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Sell', 'Rent'].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.type,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTypeTextController.text,
          options: [
            "Apartment",
            "Duplex",
            "Penthouse",
            "Studio",
            "Hotel" "Apartment",
            "Roof"
          ],
          onSelected: (String? value) {
            viewModel.propertyForTypeTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.propertyForTypeTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Apartment", "Duplex", "Penthouse", "Studio", "Hotel" "Apartment", "Roof"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.owner,
            //hint: StringHelper.select,
            hint: viewModel.ownershipStatusTextController.text,
            onSelected: (String? value) {
              viewModel.ownershipStatusTextController.text = value ?? "";
            },
            options: [StringHelper.primary, StringHelper.resell],
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.ownershipStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Primary', 'Resell'].map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        if (viewModel.currentPropertyType.toLowerCase() != "rent") ...{
          Text(
            //StringHelper.downPayment,
            StringHelper.deposit,
            style: context.textTheme.titleSmall,
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: viewModel.startDownPriceTextController,
                      cursorColor: Colors.black,
                      //readOnly: true,
                      // onChanged: (value) {
                      //   setState(() {
                      //     if (value.isEmpty) {
                      //       downValues = SfRangeValues(
                      //           0,
                      //           int.parse(
                      //               viewModel.endDownPriceTextController.text));
                      //       return;
                      //     }
                      //
                      //     downValues = SfRangeValues(
                      //         int.parse(
                      //             viewModel.startDownPriceTextController.text),
                      //         int.parse(
                      //             viewModel.endDownPriceTextController.text));
                      //   });
                      // },
                      decoration: InputDecoration(
                          counterText: "",
                          fillColor: const Color(0xffFCFCFD),
                          hintText: StringHelper.minPrice,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xffEFEFEF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xffEFEFEF)),
                          ))),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.endDownPriceTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       downValues = SfRangeValues(
                    //           int.parse(
                    //               viewModel.startDownPriceTextController.text),
                    //           100000);
                    //       return;
                    //     }
                    //
                    //     downValues = SfRangeValues(
                    //         int.parse(
                    //             viewModel.startDownPriceTextController.text),
                    //         int.parse(
                    //             viewModel.endDownPriceTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.maxPrice,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xffEFEFEF))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xffEFEFEF)))),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          // StatefulBuilder(builder: (context, setState) {
          //   return SfRangeSlider(
          //     min: 0,
          //     max: 100000,
          //     values: downValues,
          //     inactiveColor: Colors.grey,
          //     activeColor: const Color(0xffFF385C),
          //     showLabels: false,
          //     interval: 1000, // Controls label intervals
          //     stepSize: 1000, // Ensures the slider moves in steps of 1000
          //     labelFormatterCallback:
          //         (dynamic actualValue, String formattedText) {
          //       return actualValue == 99999
          //           ? ' $formattedText+'
          //           : ' $formattedText';
          //     },
          //     onChanged: (SfRangeValues newValues) {
          //       if ((newValues.end - newValues.start) >= 1000) {
          //         viewModel.startDownPriceTextController.text =
          //             "${newValues.start.round()}";
          //         viewModel.endDownPriceTextController.text =
          //             "${newValues.end.round()}";
          //         setState(() {
          //           downValues = newValues;
          //         });
          //       }
          //     },
          //   );
          // }),
          Gap(10),
        },
        Text(
          StringHelper.areaSize,
          style: context.textTheme.titleSmall,
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.startAreaTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       areaValues = SfRangeValues(0,
                    //           int.parse(viewModel.endAreaTextController.text));
                    //       return;
                    //     }
                    //
                    //     areaValues = SfRangeValues(
                    //         int.parse(viewModel.startAreaTextController.text),
                    //         int.parse(viewModel.endAreaTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.minArea,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xffEFEFEF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xffEFEFEF)),
                        ))),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  maxLength: 7,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.endAreaTextController,
                  cursorColor: Colors.black,
                  // readOnly: true,
                  // onChanged: (value) {
                  //   setState(() {
                  //     if (value.isEmpty) {
                  //       areaValues = SfRangeValues(
                  //           int.parse(viewModel.startAreaTextController.text),
                  //           100000);
                  //       return;
                  //     }
                  //
                  //     areaValues = SfRangeValues(
                  //         int.parse(viewModel.startAreaTextController.text),
                  //         int.parse(viewModel.endAreaTextController.text));
                  //   });
                  // },
                  decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxArea,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xffEFEFEF))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xffEFEFEF)))),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 15,
        // ),
        // StatefulBuilder(builder: (context, setState) {
        //   return SfRangeSlider(
        //     min: 0,
        //     max: 100000,
        //     values: areaValues,
        //     inactiveColor: Colors.grey,
        //     activeColor: const Color(0xffFF385C),
        //     showLabels: false,
        //     interval: 1000, // Controls label intervals
        //     stepSize: 1000, // Ensures the slider moves in steps of 1000
        //     labelFormatterCallback:
        //         (dynamic actualValue, String formattedText) {
        //       return actualValue == 99999
        //           ? ' $formattedText+'
        //           : ' $formattedText';
        //     },
        //     onChanged: (SfRangeValues newValues) {
        //       if ((newValues.end - newValues.start) >= 1000) {
        //         viewModel.startAreaTextController.text =
        //             "${newValues.start.round()}";
        //         viewModel.endAreaTextController.text =
        //             "${newValues.end.round()}";
        //         setState(() {
        //           areaValues = newValues;
        //         });
        //       }
        //     },
        //   );
        // }),
        Gap(10),
        CommonDropdown(
          title: StringHelper.noOfBedrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBedroomsTextController.text,
          options: ["Studio", "1", "2", "3", "4", "5", "6+"],
          onSelected: (String? value) {
            viewModel.noOfBedroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBedroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Studio", "1", "2", "3", "4", "5", "6+"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.noOfBathrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBathroomsTextController.text,
          options: ['1', '2', '3', '4', '5', '6', '7', '7+'],
          onSelected: (String? value) {
            viewModel.noOfBathroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBathroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['1', '2', '3', '4', '5', '6', '7', '7+']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text('$option Bathrooms'),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.furnishing,
          //hint: StringHelper.select,
          hint: viewModel.furnishingStatusTextController.text,
          options: [
            StringHelper.furnished,
            StringHelper.unfurnished,
            StringHelper.semiFurnished
          ],
          onSelected: (String? value) {
            viewModel.furnishingStatusTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.furnishingStatusTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Furnished', 'Unfurnished', 'Semi Furnished']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.level,
          //hint: StringHelper.select,
          hint: viewModel.levelTextController.text,
          options: [
            StringHelper.ground,
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10+",
            "Last Floor"
          ],
          onSelected: (String? value) {
            viewModel.levelTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.levelTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Ground", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "Last Floor"]
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.completionStatus,
            //hint: StringHelper.select,
            hint: viewModel.completionStatusTextController.text,
            options: [StringHelper.ready, StringHelper.offPlan],
            onSelected: (String? value) {
              viewModel.completionStatusTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.completionStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Ready', 'Off Plan'].map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.paymentType,
            //hint: StringHelper.select,
            hint: viewModel.paymentTypeTextController.text,
            options: [
              StringHelper.installment,
              StringHelper.cashOrInstallment,
              StringHelper.cash
            ],
            onSelected: (String? value) {
              viewModel.paymentTypeTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.paymentTypeTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Installment', 'Cash or Installment', 'cash']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.listedBy,
            //hint: StringHelper.select,
            hint: viewModel.listedByTextController.text,
            options: [StringHelper.agent, StringHelper.landlord],
            onSelected: (String? value) {
              viewModel.listedByTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.listedByTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Agent', 'Landlord']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
      ],
    );
  }

  Widget vacationWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.propertyType,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTextController.text,
          onSelected: (String? value) {
            viewModel.currentPropertyType = value ?? "";
            viewModel.propertyForTextController.text = value ?? "";
          },
          options: ['Sell', 'Rent'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.currentPropertyType = value;
          //     viewModel.propertyForTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Sell', 'Rent'].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.type,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTypeTextController.text,
          options: [
            "Chalet",
            "Duplex",
            "Penthouse",
            "Standalone Villa",
            "Studio",
            "Townhouse Twin house",
            "Cabin"
          ],
          onSelected: (String? value) {
            viewModel.propertyForTypeTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.propertyForTypeTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Chalet", "Duplex", "Penthouse", "Standalone Villa", "Studio", "Townhouse Twin house", "Cabin"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.owner,
            //hint: StringHelper.select,
            hint: viewModel.ownershipStatusTextController.text,
            onSelected: (String? value) {
              viewModel.ownershipStatusTextController.text = value ?? "";
            },
            options: [StringHelper.primary, StringHelper.resell],
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.ownershipStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Primary', 'Resell'].map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        if (viewModel.currentPropertyType.toLowerCase() != "rent") ...{
          Text(
            //StringHelper.downPayment,
            StringHelper.deposit,
            style: context.textTheme.titleSmall,
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: viewModel.startDownPriceTextController,
                      cursorColor: Colors.black,
                      //readOnly: true,
                      // onChanged: (value) {
                      //   setState(() {
                      //     if (value.isEmpty) {
                      //       downValues = SfRangeValues(
                      //           0,
                      //           int.parse(
                      //               viewModel.endDownPriceTextController.text));
                      //       return;
                      //     }
                      //
                      //     downValues = SfRangeValues(
                      //         int.parse(
                      //             viewModel.startDownPriceTextController.text),
                      //         int.parse(
                      //             viewModel.endDownPriceTextController.text));
                      //   });
                      // },
                      decoration: InputDecoration(
                          counterText: "",
                          fillColor: const Color(0xffFCFCFD),
                          hintText: StringHelper.minPrice,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF)),
                          ))),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.endDownPriceTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       downValues = SfRangeValues(
                    //           int.parse(
                    //               viewModel.startDownPriceTextController.text),
                    //           100000);
                    //       return;
                    //     }
                    //
                    //     downValues = SfRangeValues(
                    //         int.parse(
                    //             viewModel.startDownPriceTextController.text),
                    //         int.parse(
                    //             viewModel.endDownPriceTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.maxPrice,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF)))),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          // StatefulBuilder(builder: (context, setState) {
          //   return SfRangeSlider(
          //     min: 0,
          //     max: 100000,
          //     values: downValues,
          //     inactiveColor: Colors.grey,
          //     activeColor: const Color(0xffFF385C),
          //     showLabels: false,
          //     interval: 1000, // Controls label intervals
          //     stepSize: 1000, // Ensures the slider moves in steps of 1000
          //     labelFormatterCallback:
          //         (dynamic actualValue, String formattedText) {
          //       return actualValue == 99999
          //           ? ' $formattedText+'
          //           : ' $formattedText';
          //     },
          //     onChanged: (SfRangeValues newValues) {
          //       if ((newValues.end - newValues.start) >= 1000) {
          //         viewModel.startDownPriceTextController.text =
          //             "${newValues.start.round()}";
          //         viewModel.endDownPriceTextController.text =
          //             "${newValues.end.round()}";
          //         setState(() {
          //           downValues = newValues;
          //         });
          //       }
          //     },
          //   );
          // }),
          Gap(10),
        },
        Text(
          StringHelper.areaSize,
          style: context.textTheme.titleSmall,
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.startAreaTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       areaValues = SfRangeValues(0,
                    //           int.parse(viewModel.endAreaTextController.text));
                    //       return;
                    //     }
                    //
                    //     areaValues = SfRangeValues(
                    //         int.parse(viewModel.startAreaTextController.text),
                    //         int.parse(viewModel.endAreaTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.minArea,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ))),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  maxLength: 7,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.endAreaTextController,
                  cursorColor: Colors.black,
                  // readOnly: true,
                  // onChanged: (value) {
                  //   setState(() {
                  //     if (value.isEmpty) {
                  //       areaValues = SfRangeValues(
                  //           int.parse(viewModel.startAreaTextController.text),
                  //           100000);
                  //       return;
                  //     }
                  //
                  //     areaValues = SfRangeValues(
                  //         int.parse(viewModel.startAreaTextController.text),
                  //         int.parse(viewModel.endAreaTextController.text));
                  //   });
                  // },
                  decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxArea,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)))),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 15,
        // ),
        // StatefulBuilder(builder: (context, setState) {
        //   return SfRangeSlider(
        //     min: 0,
        //     max: 100000,
        //     values: areaValues,
        //     inactiveColor: Colors.grey,
        //     activeColor: const Color(0xffFF385C),
        //     showLabels: false,
        //     interval: 1000, // Controls label intervals
        //     stepSize: 1000, // Ensures the slider moves in steps of 1000
        //     labelFormatterCallback:
        //         (dynamic actualValue, String formattedText) {
        //       return actualValue == 99999
        //           ? ' $formattedText+'
        //           : ' $formattedText';
        //     },
        //     onChanged: (SfRangeValues newValues) {
        //       if ((newValues.end - newValues.start) >= 1000) {
        //         viewModel.startAreaTextController.text =
        //             "${newValues.start.round()}";
        //         viewModel.endAreaTextController.text =
        //             "${newValues.end.round()}";
        //         setState(() {
        //           areaValues = newValues;
        //         });
        //       }
        //     },
        //   );
        // }),
        Gap(10),
        CommonDropdown(
          title: StringHelper.noOfBedrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBedroomsTextController.text,
          options: ["Studio", "1", "2", "3", "4", "5", "6+"],
          onSelected: (String? value) {
            viewModel.noOfBedroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBedroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Studio", "1", "2", "3", "4", "5", "6+"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.noOfBathrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBathroomsTextController.text,
          options: ['1', '2', '3', '4', '5', '6', '7', '7+'],
          onSelected: (String? value) {
            viewModel.noOfBathroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBathroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['1', '2', '3', '4', '5', '6', '7', '7+']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text('$option Bathrooms'),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.furnishing,
          //hint: StringHelper.select,
          hint: viewModel.furnishingStatusTextController.text,
          options: [StringHelper.yes, StringHelper.no],
          onSelected: (String? value) {
            viewModel.furnishingStatusTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.furnishingStatusTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Yes','No']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.level,
          //hint: StringHelper.select,
          hint: viewModel.levelTextController.text,
          options: [
            StringHelper.ground,
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10+",
            "Last Floor"
          ],
          onSelected: (String? value) {
            viewModel.levelTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.levelTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Ground", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "Last Floor"]
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.completionStatus,
            //hint: StringHelper.select,
            hint: viewModel.completionStatusTextController.text,
            options: [StringHelper.ready, StringHelper.offPlan],
            onSelected: (String? value) {
              viewModel.completionStatusTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.completionStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Ready', 'Off Plan'].map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.paymentType,
            //hint: StringHelper.select,
            hint: viewModel.paymentTypeTextController.text,
            options: [
              StringHelper.installment,
              StringHelper.cashOrInstallment,
              StringHelper.cash
            ],
            onSelected: (String? value) {
              viewModel.paymentTypeTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.paymentTypeTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Installment', 'Cash or Installment', 'cash']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.deliveryTerms,
            //hint: StringHelper.select,
            hint: viewModel.deliveryTermTextController.text,
            options: [
              StringHelper.moveInReady,
              StringHelper.underConstruction,
              StringHelper.shellAndCore,
              StringHelper.semiFurnished
            ],
            onSelected: (String? value) {
              viewModel.deliveryTermTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.deliveryTermTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Move-in Ready','Under Construction','Shell and Core','Semi-Finished']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: StringHelper.rentalTerm,
            //hint: StringHelper.select,
            hint: viewModel.rentalTermsTextController.text,
            options: [
              StringHelper.daily,
              StringHelper.weekly,
              StringHelper.monthly,
              StringHelper.yearly
            ],
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.rentalTermsTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Daily', 'Weekly', 'Monthly', 'Yearly']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
      ],
    );
  }

  Widget villaWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.propertyType,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTextController.text,
          onSelected: (String? value) {
            viewModel.currentPropertyType = value ?? "";
            viewModel.propertyForTextController.text = value ?? "";
          },
          options: ['Sell', 'Rent'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.currentPropertyType = value;
          //     viewModel.propertyForTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Sell', 'Rent'].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.type,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTypeTextController.text,
          options: [
            "Stand Alone",
            "Townhouse",
            "Twin House",
            "I-Villa",
            "Mansion"
          ],
          onSelected: (String? value) {
            viewModel.propertyForTypeTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.propertyForTypeTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Stand Alone","Townhouse","Twin House","I-Villa","Mansion"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        if (viewModel.currentPropertyType.toLowerCase() != "rent") ...{
          Text(
            //StringHelper.downPayment,
            StringHelper.deposit,
            style: context.textTheme.titleSmall,
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: viewModel.startDownPriceTextController,
                      cursorColor: Colors.black,
                      //readOnly: true,
                      // onChanged: (value) {
                      //   setState(() {
                      //     if (value.isEmpty) {
                      //       downValues = SfRangeValues(
                      //           0,
                      //           int.parse(
                      //               viewModel.endDownPriceTextController.text));
                      //       return;
                      //     }
                      //
                      //     downValues = SfRangeValues(
                      //         int.parse(
                      //             viewModel.startDownPriceTextController.text),
                      //         int.parse(
                      //             viewModel.endDownPriceTextController.text));
                      //   });
                      // },
                      decoration: InputDecoration(
                          counterText: "",
                          fillColor: const Color(0xffFCFCFD),
                          hintText: StringHelper.minPrice,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF)),
                          ))),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.endDownPriceTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       downValues = SfRangeValues(
                    //           int.parse(
                    //               viewModel.startDownPriceTextController.text),
                    //           100000);
                    //       return;
                    //     }
                    //
                    //     downValues = SfRangeValues(
                    //         int.parse(
                    //             viewModel.startDownPriceTextController.text),
                    //         int.parse(
                    //             viewModel.endDownPriceTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.maxPrice,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Color(0xffEFEFEF)))),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          // StatefulBuilder(builder: (context, setState) {
          //   return SfRangeSlider(
          //     min: 0,
          //     max: 100000,
          //     values: downValues,
          //     inactiveColor: Colors.grey,
          //     activeColor: const Color(0xffFF385C),
          //     showLabels: false,
          //     interval: 1000, // Controls label intervals
          //     stepSize: 1000, // Ensures the slider moves in steps of 1000
          //     labelFormatterCallback:
          //         (dynamic actualValue, String formattedText) {
          //       return actualValue == 99999
          //           ? ' $formattedText+'
          //           : ' $formattedText';
          //     },
          //     onChanged: (SfRangeValues newValues) {
          //       if ((newValues.end - newValues.start) >= 1000) {
          //         viewModel.startDownPriceTextController.text =
          //             "${newValues.start.round()}";
          //         viewModel.endDownPriceTextController.text =
          //             "${newValues.end.round()}";
          //         setState(() {
          //           downValues = newValues;
          //         });
          //       }
          //     },
          //   );
          // }),
          Gap(10),
        },
        Text(
          StringHelper.areaSize,
          style: context.textTheme.titleSmall,
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.startAreaTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       areaValues = SfRangeValues(0,
                    //           int.parse(viewModel.endAreaTextController.text));
                    //       return;
                    //     }
                    //
                    //     areaValues = SfRangeValues(
                    //         int.parse(viewModel.startAreaTextController.text),
                    //         int.parse(viewModel.endAreaTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.minArea,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ))),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  maxLength: 7,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.endAreaTextController,
                  cursorColor: Colors.black,
                  // readOnly: true,
                  // onChanged: (value) {
                  //   setState(() {
                  //     if (value.isEmpty) {
                  //       areaValues = SfRangeValues(
                  //           int.parse(viewModel.startAreaTextController.text),
                  //           100000);
                  //       return;
                  //     }
                  //
                  //     areaValues = SfRangeValues(
                  //         int.parse(viewModel.startAreaTextController.text),
                  //         int.parse(viewModel.endAreaTextController.text));
                  //   });
                  // },
                  decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxArea,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)))),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 15,
        // ),
        // StatefulBuilder(builder: (context, setState) {
        //   return SfRangeSlider(
        //     min: 0,
        //     max: 100000,
        //     values: areaValues,
        //     inactiveColor: Colors.grey,
        //     activeColor: const Color(0xffFF385C),
        //     showLabels: false,
        //     interval: 1000, // Controls label intervals
        //     stepSize: 1000, // Ensures the slider moves in steps of 1000
        //     labelFormatterCallback:
        //         (dynamic actualValue, String formattedText) {
        //       return actualValue == 99999
        //           ? ' $formattedText+'
        //           : ' $formattedText';
        //     },
        //     onChanged: (SfRangeValues newValues) {
        //       if ((newValues.end - newValues.start) >= 1000) {
        //         viewModel.startAreaTextController.text =
        //             "${newValues.start.round()}";
        //         viewModel.endAreaTextController.text =
        //             "${newValues.end.round()}";
        //         setState(() {
        //           areaValues = newValues;
        //         });
        //       }
        //     },
        //   );
        // }),
        Gap(10),
        CommonDropdown(
          title: StringHelper.noOfBedrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBedroomsTextController.text,
          options: ["Studio", "1", "2", "3", "4", "5", "6+"],
          onSelected: (String? value) {
            viewModel.noOfBedroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBedroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Studio", "1", "2", "3", "4", "5", "6+"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.noOfBathrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBathroomsTextController.text,
          options: ['1', '2', '3', '4', '5', '6', '7', '7+'],
          onSelected: (String? value) {
            viewModel.noOfBathroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBathroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['1', '2', '3', '4', '5', '6', '7', '7+']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text('$option Bathrooms'),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.furnishing,
          //hint: StringHelper.select,
          hint: viewModel.furnishingStatusTextController.text,
          options: [
            StringHelper.furnished,
            StringHelper.unfurnished,
            StringHelper.semiFurnished
          ],
          onSelected: (String? value) {
            viewModel.furnishingStatusTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.furnishingStatusTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Furnished', 'Unfurnished', 'Semi Furnished']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.completionStatus,
            //hint: StringHelper.select,
            hint: viewModel.completionStatusTextController.text,
            options: [StringHelper.ready, StringHelper.offPlan],
            onSelected: (String? value) {
              viewModel.completionStatusTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.completionStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Ready', 'Off Plan'].map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.paymentType,
            //hint: StringHelper.select,
            hint: viewModel.paymentTypeTextController.text,
            options: [
              StringHelper.installment,
              StringHelper.cashOrInstallment,
              StringHelper.cash
            ],
            onSelected: (String? value) {
              viewModel.paymentTypeTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.paymentTypeTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Installment', 'Cash or Installment', 'cash']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.deliveryTerms,
            //hint: StringHelper.select,
            hint: viewModel.deliveryTermTextController.text,
            options: [
              StringHelper.moveInReady,
              StringHelper.underConstruction,
              StringHelper.shellAndCore,
              StringHelper.semiFinished
            ],
            onSelected: (String? value) {
              viewModel.deliveryTermTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.deliveryTermTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Move-in Ready','Under Construction','Shell and Core','Semi-Finished']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: StringHelper.rentalTerm,
            //hint: StringHelper.select,
            hint: viewModel.rentalTermsTextController.text,
            options: [
              StringHelper.daily,
              StringHelper.weekly,
              StringHelper.monthly,
              StringHelper.yearly
            ],
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.rentalTermsTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Daily', 'Weekly', 'Monthly', 'Yearly']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
      ],
    );
  }

  Widget businessWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.propertyType,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTextController.text,
          onSelected: (String? value) {
            viewModel.currentPropertyType = value ?? "";
            viewModel.propertyForTextController.text = value ?? "";
          },
          options: ['Sell', 'Rent'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.currentPropertyType = value;
          //     viewModel.propertyForTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Sell', 'Rent'].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.type,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTypeTextController.text,
          options: [
            "Factory",
            "Full building",
            "Garage",
            "Warehouse",
            "Clinic",
            "Restraunt/ cafe",
            "Offices",
            "Factory",
            "Pharmacy",
            "Medical facility",
            "Showroom",
            "Hotel/ motel",
            "Gas station",
            "Storage facility",
            "other"
          ],
          onSelected: (String? value) {
            viewModel.propertyForTypeTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.propertyForTypeTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Factory", "Full building", "Garage", "Warehouse", "Clinic", "Restraunt/ cafe", "Offices", "Factory", "Pharmacy", "Medical facility", "Showroom", "Hotel/ motel", "Gas station", "Storage facility", "other"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Text(
          StringHelper.areaSize,
          style: context.textTheme.titleSmall,
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.startAreaTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       areaValues = SfRangeValues(0,
                    //           int.parse(viewModel.endAreaTextController.text));
                    //       return;
                    //     }
                    //
                    //     areaValues = SfRangeValues(
                    //         int.parse(viewModel.startAreaTextController.text),
                    //         int.parse(viewModel.endAreaTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.minArea,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ))),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  maxLength: 7,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.endAreaTextController,
                  cursorColor: Colors.black,
                  // readOnly: true,
                  // onChanged: (value) {
                  //   setState(() {
                  //     if (value.isEmpty) {
                  //       areaValues = SfRangeValues(
                  //           int.parse(viewModel.startAreaTextController.text),
                  //           100000);
                  //       return;
                  //     }
                  //
                  //     areaValues = SfRangeValues(
                  //         int.parse(viewModel.startAreaTextController.text),
                  //         int.parse(viewModel.endAreaTextController.text));
                  //   });
                  // },
                  decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxArea,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)))),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 15,
        // ),
        // StatefulBuilder(builder: (context, setState) {
        //   return SfRangeSlider(
        //     min: 0,
        //     max: 100000,
        //     values: areaValues,
        //     inactiveColor: Colors.grey,
        //     activeColor: const Color(0xffFF385C),
        //     showLabels: false,
        //     interval: 1000, // Controls label intervals
        //     stepSize: 1000, // Ensures the slider moves in steps of 1000
        //     labelFormatterCallback:
        //         (dynamic actualValue, String formattedText) {
        //       return actualValue == 99999
        //           ? ' $formattedText+'
        //           : ' $formattedText';
        //     },
        //     onChanged: (SfRangeValues newValues) {
        //       if ((newValues.end - newValues.start) >= 1000) {
        //         viewModel.startAreaTextController.text =
        //             "${newValues.start.round()}";
        //         viewModel.endAreaTextController.text =
        //             "${newValues.end.round()}";
        //         setState(() {
        //           areaValues = newValues;
        //         });
        //       }
        //     },
        //   );
        // }),
        Gap(10),
        CommonDropdown(
          title: StringHelper.noOfBedrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBedroomsTextController.text,
          options: ["Studio", "1", "2", "3", "4", "5", "6+"],
          onSelected: (String? value) {
            viewModel.noOfBedroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBedroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Studio", "1", "2", "3", "4", "5", "6+"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.noOfBathrooms,
          //hint: StringHelper.select,
          hint: viewModel.noOfBathroomsTextController.text,
          options: ['1', '2', '3', '4', '5', '6', '7', '7+'],
          onSelected: (String? value) {
            viewModel.noOfBathroomsTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.noOfBathroomsTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['1', '2', '3', '4', '5', '6', '7', '7+']
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text('$option Bathrooms'),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.level,
          //hint: StringHelper.select,
          hint: viewModel.levelTextController.text,
          options: [
            StringHelper.ground,
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
            "10+",
            "Last Floor"
          ],
          onSelected: (String? value) {
            viewModel.levelTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.levelTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Ground", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10+", "Last Floor"]
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.furnishing,
          //hint: StringHelper.select,
          hint: viewModel.furnishingStatusTextController.text,
          options: [StringHelper.yes, StringHelper.no],
          onSelected: (String? value) {
            viewModel.furnishingStatusTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.furnishingStatusTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Yes","No"]
          //         .map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.completionStatus,
            //hint: StringHelper.select,
            hint: viewModel.completionStatusTextController.text,
            options: [StringHelper.ready, StringHelper.offPlan],
            onSelected: (String? value) {
              viewModel.completionStatusTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.completionStatusTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Ready', 'Off Plan'].map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: CommonDropdown(
            title: StringHelper.paymentType,
            //hint: StringHelper.select,
            hint: viewModel.paymentTypeTextController.text,
            options: [
              StringHelper.installment,
              StringHelper.cashOrInstallment,
              StringHelper.cash
            ],
            onSelected: (String? value) {
              viewModel.paymentTypeTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.paymentTypeTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Installment', 'Cash or Installment', 'cash']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: StringHelper.rentalTerm,
            //hint: StringHelper.select,
            hint: viewModel.rentalTermsTextController.text,
            options: [
              StringHelper.daily,
              StringHelper.weekly,
              StringHelper.monthly,
              StringHelper.yearly
            ],
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.rentalTermsTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Daily', 'Weekly', 'Monthly', 'Yearly']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
      ],
    );
  }

  Widget landWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonDropdown(
          title: StringHelper.propertyType,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTextController.text,
          onSelected: (String? value) {
            viewModel.currentPropertyType = value ?? "";
            viewModel.propertyForTextController.text = value ?? "";
          },
          options: ['Sell', 'Rent'],
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.currentPropertyType = value;
          //     viewModel.propertyForTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Sell', 'Rent'].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        CommonDropdown(
          title: StringHelper.type,
          //hint: StringHelper.select,
          hint: viewModel.propertyForTypeTextController.text,
          options: [
            "Agricultural Land",
            "Commercial Land",
            "Residential Land",
            "Industrial Land",
            "Mixed-Use Land",
            "Farm Land"
          ],
          onSelected: (String? value) {
            viewModel.propertyForTypeTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.propertyForTypeTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ["Agricultural Land","Commercial Land","Residential Land","Industrial Land","Mixed-Use Land","Farm Land"].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Text(
          StringHelper.areaSize,
          style: context.textTheme.titleSmall,
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.startAreaTextController,
                    cursorColor: Colors.black,
                    // readOnly: true,
                    // onChanged: (value) {
                    //   setState(() {
                    //     if (value.isEmpty) {
                    //       areaValues = SfRangeValues(0,
                    //           int.parse(viewModel.endAreaTextController.text));
                    //       return;
                    //     }
                    //
                    //     areaValues = SfRangeValues(
                    //         int.parse(viewModel.startAreaTextController.text),
                    //         int.parse(viewModel.endAreaTextController.text));
                    //   });
                    // },
                    decoration: InputDecoration(
                        counterText: "",
                        fillColor: const Color(0xffFCFCFD),
                        hintText: StringHelper.minArea,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)),
                        ))),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: SizedBox(
                width: context.width,
                height: 50,
                child: TextFormField(
                  maxLength: 7,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.endAreaTextController,
                  cursorColor: Colors.black,
                  // readOnly: true,
                  // onChanged: (value) {
                  //   setState(() {
                  //     if (value.isEmpty) {
                  //       areaValues = SfRangeValues(
                  //           int.parse(viewModel.startAreaTextController.text),
                  //           100000);
                  //       return;
                  //     }
                  //
                  //     areaValues = SfRangeValues(
                  //         int.parse(viewModel.startAreaTextController.text),
                  //         int.parse(viewModel.endAreaTextController.text));
                  //   });
                  // },
                  decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxArea,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          const BorderSide(color: Color(0xffEFEFEF)))),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 15,
        // ),
        // StatefulBuilder(builder: (context, setState) {
        //   return SfRangeSlider(
        //     min: 0,
        //     max: 100000,
        //     values: areaValues,
        //     inactiveColor: Colors.grey,
        //     activeColor: const Color(0xffFF385C),
        //     showLabels: false,
        //     interval: 1000, // Controls label intervals
        //     stepSize: 1000, // Ensures the slider moves in steps of 1000
        //     labelFormatterCallback:
        //         (dynamic actualValue, String formattedText) {
        //       return actualValue == 99999
        //           ? ' $formattedText+'
        //           : ' $formattedText';
        //     },
        //     onChanged: (SfRangeValues newValues) {
        //       if ((newValues.end - newValues.start) >= 1000) {
        //         viewModel.startAreaTextController.text =
        //             "${newValues.start.round()}";
        //         viewModel.endAreaTextController.text =
        //             "${newValues.end.round()}";
        //         setState(() {
        //           areaValues = newValues;
        //         });
        //       }
        //     },
        //   );
        // }),
        Gap(10),
        CommonDropdown(
          title: StringHelper.accessToUtilities,
          //hint: StringHelper.select,
          hint: viewModel.accessToUtilitiesTextController.text,
          options: [
            StringHelper.waterSupply,
            StringHelper.electricity,
            StringHelper.gas,
            StringHelper.sewageSystem,
            StringHelper.roadAccess
          ],
          onSelected: (String? value) {
            viewModel.accessToUtilitiesTextController.text = value ?? "";
          },
          // readOnly: true,
          // suffix: PopupMenuButton<String>(
          //   clipBehavior: Clip.hardEdge,
          //   icon: const Icon(
          //     Icons.arrow_drop_down,
          //     color: Colors.black,
          //   ),
          //   onSelected: (String value) {
          //     viewModel.accessToUtilitiesTextController.text = value;
          //   },
          //   itemBuilder: (BuildContext context) {
          //     return ['Water Supply','Electricity','Gas','Sewage System','Road Access'].map((option) {
          //       return PopupMenuItem(
          //         value: option,
          //         child: Text(option),
          //       );
          //     }).toList();
          //   },
          // ),
          // contentPadding:
          // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          // inputFormatters: [
          //   FilteringTextInputFormatter.deny(
          //     RegExp(viewModel.regexToRemoveEmoji),
          //   ),
          // ],
          // keyboardType: TextInputType.text,
          // textInputAction: TextInputAction.done,
          // fillColor: Colors.white,
          // elevation: 6,
        ),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: CommonDropdown(
            title: StringHelper.rentalTerm,
            //hint: StringHelper.select,
            hint: viewModel.rentalTermsTextController.text,
            options: [
              StringHelper.daily,
              StringHelper.weekly,
              StringHelper.monthly,
              StringHelper.yearly
            ],
            onSelected: (String? value) {
              viewModel.rentalTermsTextController.text = value ?? "";
            },
            // readOnly: true,
            // suffix: PopupMenuButton<String>(
            //   clipBehavior: Clip.hardEdge,
            //   icon: const Icon(
            //     Icons.arrow_drop_down,
            //     color: Colors.black,
            //   ),
            //   onSelected: (String value) {
            //     viewModel.rentalTermsTextController.text = value;
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return ['Daily', 'Weekly', 'Monthly', 'Yearly']
            //         .map((option) {
            //       return PopupMenuItem(
            //         value: option,
            //         child: Text(option),
            //       );
            //     }).toList();
            //   },
            // ),
            // contentPadding:
            // const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            // inputFormatters: [
            //   FilteringTextInputFormatter.deny(
            //     RegExp(viewModel.regexToRemoveEmoji),
            //   ),
            // ],
            // keyboardType: TextInputType.text,
            // textInputAction: TextInputAction.done,
            // fillColor: Colors.white,
            // elevation: 6,
          ),
        ),
      ],
    );
  }
}
