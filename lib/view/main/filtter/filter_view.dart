import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:list_and_life/base/helpers/filter_cache_manager.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:list_and_life/view_model/car_brand_selection.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/amenities_widget.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/car_model_selection.dart';
import 'package:list_and_life/widgets/common_dropdown.dart';
import 'package:provider/provider.dart';
import "package:list_and_life/widgets/enhanced_location_screen.dart";
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
  bool _showAllScreenSizes = false;
  bool _showAllHorsepowers = false; // Add this
  bool _showAllEngineCapacities = false;
  bool _isLoadingModels = false;
  final FilterCacheManager _cacheManager = FilterCacheManager();

  List<int> selectedAmenities = [];
  List<String> selectedFuelTypes = [];
  List<String> selectedUtilities = [];
  List<String> yearsType = [];
  List<String> fuelsType = [
    StringHelper.petrol,
    StringHelper.diesel,
    StringHelper.electric,
    StringHelper.hybrid,
    // StringHelper.gas
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
  List<CategoryModel> userTypes = [
    CategoryModel(name: StringHelper.lookingJob),
    CategoryModel(name: StringHelper.hiringJob),
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
    "7",
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
  ];

  List<String> breedSubSubCategoryIds = [
    '69',
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
    if (brandId == null) {
      setState(() {
        allModels = [];
        _isLoadingModels = false;
      });
      return;
    }

    try {
      // Check cache first
      String cacheKey = _cacheManager.getModelsKey(brandId.toString());
      List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

      if (cachedData != null) {
        // Use cached data
        setState(() {
          allModels = cachedData;
          _isLoadingModels = false;
        });
        return;
      }

      // If not in cache, fetch from API
      setState(() {
        _isLoadingModels = true;
        allModels = [];
      });

      print("FilterView: Loading models for brandId: $brandId");

      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getModelsUrl(brandId: "$brandId"),
          requestType: RequestType.get);

      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<CategoryModel> model = ListResponse.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      print("FilterView: Received ${model.body?.length ?? 0} models");

      setState(() {
        allModels = model.body ?? [];
        _isLoadingModels = false;
      });

      // Save to cache
      _cacheManager.saveToCache(cacheKey, allModels);

      debugPrint(
          "FilterView models loaded successfully: ${allModels.length} models");
    } catch (e) {
      print("FilterView: Error fetching models: $e");
      setState(() {
        allModels = [];
        _isLoadingModels = false;
      });
    }
  }

  CityModel? _findCityByNameFromService(String englishName) {
    // Assuming LocationService is imported
    return LocationService.findCityByName(englishName);
  }

  DistrictModel? _findDistrictByNameFromService(
      CityModel city, String englishName) {
    // Assuming LocationService is imported
    return LocationService.findDistrictByName(city, englishName);
  }

  NeighborhoodModel? _findNeighborhoodByNameFromService(
      DistrictModel district, String englishName) {
    // Assuming LocationService is imported
    return LocationService.findNeighborhoodByName(district, englishName);
  }

  bool _isCurrentLanguageArabic(BuildContext context) {
    return Directionality.of(context) == TextDirection.RTL;
  }

  @override
  void initState() {
    var vm = context.read<HomeVM>();
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 20; i++) {
      yearsType.add((currentYear - i).toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((t) {
      vm.resetFilterControllers(); // Add this line to reset controllers before updating
      updateFilter(vm: vm);
    });
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
              Visibility(
                visible: !(filter.categoryId == "11" ||
                    filter.categoryId == "8" ||
                    filter.categoryId == "9" ||
                    filter.categoryId == "6" ||
                    filter.subcategoryId == "46" ||
                    filter.subcategoryId == "23" ||
                    filter.subcategoryId ==
                        "31"), // Hide for real estate category
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        viewModel.itemCondition = 1;
                      },
                      child: Container(
                        width: 105,
                        height: 42,
                        margin: const EdgeInsets.only(top: 10),
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
                    const SizedBox(
                        width:
                            20), // This provides consistent spacing in both LTR and RTL
                    GestureDetector(
                      onTap: () {
                        viewModel.itemCondition = 2;
                      },
                      child: Container(
                        width: 105,
                        height: 42,
                        margin: const EdgeInsets.only(top: 10),
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
                                maxLength: 10,
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
                              maxLength: 10,
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
                onSelected: (CategoryModel? value) async {
                  // Clear everything FIRST
                  viewModel.subCategoryTextController.clear();
                  viewModel.subSubCategoryTextController.clear();
                  viewModel.brandsTextController.clear();
                  viewModel.modelTextController.clear();
                  viewModel.sizesTextController.clear();

                  filter.subcategoryId = "";
                  filter.subSubCategoryId = "";
                  filter.brandId = "";
                  filter.modelId = "";
                  filter.sizeId = null;

                  subCategoriesList.clear();
                  subSubCategories.clear();
                  brands.clear();
                  allModels.clear();
                  fashionSizes.clear();

                  // Clear other field controllers
                  viewModel.propertyForTextController.clear();
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

                  // NOW set the new category
                  viewModel.categoryTextController.text = value?.name ?? '';
                  filter.categoryId = "${value?.id}";

                  if (filter.categoryId == "8" ||
                      filter.categoryId == "9" ||
                      filter.categoryId == "11" ||
                      filter.categoryId == "6") {
                    viewModel.itemCondition = 0;
                  }

                  viewModel.currentPropertyType = "Sell";

                  // Update the UI immediately to clear dropdowns

                  await getSubCategory(id: "${value?.id}");
                  viewModel.categoryTextController.text = value?.name ?? '';
                  filter.categoryId = "${value?.id}";
                  if (filter.categoryId == "8" ||
                      filter.categoryId == "9" ||
                      filter.categoryId == "11" ||
                      filter.categoryId == "6" ||
                      filter.subcategoryId == "46" ||
                      filter.subcategoryId == "23" ||
                      filter.subcategoryId == "31") {
                    viewModel.itemCondition = 0;
                  }
                  filter.subcategoryId = "";
                  viewModel.currentPropertyType = "Sell";
                  brands.clear();
                  allModels.clear();

                  viewModel.brandsTextController.clear();
                  viewModel.modelTextController.clear();
                  viewModel.subCategoryTextController.clear();
                },
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              if (subCategoriesList.isNotEmpty) ...{
                CommonDropdown<CategoryModel?>(
                  key: ValueKey(
                      'subcategory_${filter.categoryId}_${subCategoriesList.length}'),
                  title: filter.categoryId == '8'
                      ? StringHelper.selectServices
                      : filter.categoryId == '9'
                          ? StringHelper.jobType
                          : StringHelper.subCategory,
                  hint: (() {
                    String controllerText =
                        viewModel.subCategoryTextController.text.trim();

                    // If controller has text, use it directly
                    if (controllerText.isNotEmpty) {
                      return controllerText;
                    }

                    // Otherwise return the appropriate hint based on category
                    return filter.categoryId == '8'
                        ? StringHelper.selectServices
                        : filter.categoryId == '9'
                            ? StringHelper.selectJobType
                            : StringHelper.selectSubCategory;
                  })(),
                  onSelected: (CategoryModel? value) async {
                    // Clear sub-subcategory first
                    viewModel.subSubCategoryTextController.clear();
                    filter.subSubCategoryId = '';
                    subSubCategories.clear();

                    // Set new subcategory
                    viewModel.subCategoryTextController.text =
                        value?.name ?? '';
                    filter.subcategoryId = "${value?.id}";
                    viewModel.currentPropertyType = "Sell";

                    DialogHelper.showLoading();
                    brands.clear();
                    allModels.clear();
                    selectedAmenities.clear();
                    fashionSizes.clear();

                    // Clear all the other controllers
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
                ),
                // const SizedBox(height: 20),
                if (subSubCategories.isNotEmpty) ...[
                  CommonDropdown<CategoryModel?>(
                    key: ValueKey(
                        'subsubcategory_${filter.subcategoryId}_${subSubCategories.length}'),
                    title: StringHelper.subCategory,
                    hint: (() {
                      String controllerText =
                          viewModel.subSubCategoryTextController.text.trim();

                      if (controllerText.isEmpty) {
                        return "Select Sub-Subcategory";
                      }

                      // Validate text exists in current list
                      bool isValid = subSubCategories
                          .any((item) => item.name == controllerText);

                      if (!isValid) {
                        return "Select Sub-Subcategory";
                      }

                      return controllerText;
                    })(),
                    onSelected: (CategoryModel? value) async {
                      viewModel.subSubCategoryTextController.text =
                          value?.name ?? '';
                      filter.subSubCategoryId = "${value?.id}";
                      fashionSizes.clear();
                      viewModel.sizesTextController.clear();
                      filter.sizeId = null;
                      setState(() {
                        fashionSizes.clear();
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
              if (brands.isNotEmpty && filter.subcategoryId != '13') ...[
                CommonDropdown<CategoryModel?>(
                  title: (filter.subcategoryId ?? '') == '26' ||
                          (filter.subcategoryId ?? '') == '27' ||
                          (filter.subcategoryId ?? '') == '95' ||
                          (filter.subcategoryId ?? '') == '97' ||
                          (filter.subcategoryId ?? '') == '40' ||
                          (filter.subcategoryId ?? '') == '99' ||
                          (filter.subcategoryId ?? '') == '22' ||
                          (filter.categoryId ?? '') == '5' ||
                          (filter.categoryId ?? '') == '7' ||
                          (filter.categoryId ?? '') == '8'
                      ? StringHelper.type
                      : (filter.subcategoryId ?? '') == '23'
                          ? StringHelper.telecom
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
                                      ? StringHelper.select
                                      : StringHelper.select
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
                ),
              ],
              if (filter.subSubCategoryId == '7') ...[
                if (filter.subSubCategoryId == '7') ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringHelper.screenSize,
                        style: context.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      // Remove StatefulBuilder and use the main widget's setState instead
                      (() {
                        List<String> allSizes = [
                          '24',
                          '28',
                          '32',
                          '40',
                          '43',
                          '48',
                          '50',
                          '55',
                          '58',
                          '65',
                          '70',
                          '75',
                          '85',
                          StringHelper.other
                        ];

                        // Show only first 6 sizes initially, or all if showAllSizes is true
                        List<String> displayedSizes = _showAllScreenSizes
                            ? allSizes
                            : allSizes.take(6).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: displayedSizes.map((size) {
                                List<String> selectedSizes = viewModel
                                        .screenSizeTextController.text.isEmpty
                                    ? []
                                    : viewModel.screenSizeTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();
                                bool isSelected = selectedSizes.contains(size);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedSizes.remove(size);
                                      } else {
                                        selectedSizes.add(size);
                                      }
                                      if (selectedSizes.isEmpty) {
                                        viewModel.screenSizeTextController
                                            .clear();
                                      } else {
                                        viewModel.screenSizeTextController
                                            .text = selectedSizes.join(',');
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.black.withOpacity(0.1)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey.shade300,
                                        width: isSelected ? 2 : 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (allSizes.length > 6) ...[
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showAllScreenSizes = !_showAllScreenSizes;
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _showAllScreenSizes
                                          ? StringHelper.seeLess
                                          : StringHelper.seeMore,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 42, 46, 50),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Icon(
                                      _showAllScreenSizes
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 18,
                                      color:
                                          const Color.fromARGB(255, 30, 34, 38),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        );
                      })(),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ],
              const SizedBox(height: 12),
              if (fashionSizes.isNotEmpty) ...[
                CommonDropdown<CategoryModel?>(
                  title: _getSizeTitle(filter.subSubCategoryId),
                  hint: viewModel.sizesTextController.text.trim().isEmpty
                      ? StringHelper.select
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
              ],
              // HIDE: The old model dropdown is removed from here.
              // It is now inside the carsForSaleWidget.
              // The model dropdown is handled inside category-specific widgets for vehicles
// For non-vehicle categories, show the regular model dropdown with multi-select
              if ((allModels.isNotEmpty || _isLoadingModels) &&
                  filter.categoryId != '4') ...{
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.models,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Show loading indicator when loading models
                    if (_isLoadingModels) ...[
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey.shade600),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                StringHelper.loadingModels ??
                                    "Loading models...",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Show selected models as chips
                      if (viewModel.modelTextController.text.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: viewModel.modelTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .map((modelName) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    modelName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      // Remove this model from selection
                                      List<String> selectedModels = viewModel
                                          .modelTextController.text
                                          .split(',')
                                          .map((e) => e.trim())
                                          .where((e) =>
                                              e.isNotEmpty && e != modelName)
                                          .toList();

                                      viewModel.modelTextController.text =
                                          selectedModels.join(',');

                                      // Update filter.modelId
                                      List<String> modelIds = [];
                                      for (String selectedModelName
                                          in selectedModels) {
                                        for (var model in allModels) {
                                          if (model.name == selectedModelName) {
                                            modelIds.add(model.id.toString());
                                            break;
                                          }
                                        }
                                      }
                                      filter.modelId = modelIds.join(',');

                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Add model button
                      GestureDetector(
                        onTap: (allModels.isNotEmpty)
                            ? () async {
                                // Get currently selected model names
                                List<String> currentlySelected =
                                    viewModel.modelTextController.text.isEmpty
                                        ? []
                                        : viewModel.modelTextController.text
                                            .split(',')
                                            .map((e) => e.trim())
                                            .toList();

                                // Convert current model names to CategoryModel objects
                                List<CategoryModel> currentSelectedModels = [];
                                for (String modelName in currentlySelected) {
                                  for (var model in allModels) {
                                    if (model.name == modelName) {
                                      currentSelectedModels.add(model);
                                      break;
                                    }
                                  }
                                }

                                final List<CategoryModel>? selectedModels =
                                    await Navigator.push<List<CategoryModel>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CarModelSelectionScreen(
                                      models: allModels,
                                      showIcon: false,
                                      selectedModels: currentSelectedModels,
                                      title: StringHelper.models ??
                                          "Select Models",
                                      brandName:
                                          viewModel.brandsTextController.text,
                                      isMultiSelect:
                                          true, // Enable multi-select mode
                                    ),
                                  ),
                                );

                                if (selectedModels != null) {
                                  // Update the controller with selected model names
                                  List<String> modelNames = selectedModels
                                      .map((model) => model.name ?? '')
                                      .where((name) => name.isNotEmpty)
                                      .toList();

                                  viewModel.modelTextController.text =
                                      modelNames.join(',');

                                  // Update filter.modelId with selected model IDs
                                  List<String> modelIds = selectedModels
                                      .map((model) => model.id.toString())
                                      .toList();

                                  filter.modelId = modelIds.join(',');

                                  setState(() {});
                                }
                              }
                            : null,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: allModels.isEmpty
                                ? Colors.grey.shade50
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  allModels.isEmpty
                                      ? (StringHelper.selectBrands ??
                                          "Select a brand first")
                                      : "${StringHelper.add ?? "Add"} ${StringHelper.models ?? "Models"}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.grey.shade600,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Clear all models button (only show if models are selected)
                      if (viewModel.modelTextController.text.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            viewModel.modelTextController.clear();
                            filter.modelId = "";
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.red.shade200, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.clear_all,
                                  size: 16,
                                  color: Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  StringHelper.clearAll ?? "Clear All",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
                const SizedBox(height: 24),
              },
              const Gap(10),
              if (filter.categoryId == '10' &&
                  filter.subcategoryId == '20') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.ram,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StringHelper.lessThan1GB,
                        StringHelper.gb1,
                        StringHelper.gb2,
                        StringHelper.gb3,
                        StringHelper.gb4,
                        StringHelper.gb6,
                        StringHelper.gb8,
                        StringHelper.gb12,
                        StringHelper.gb16,
                        StringHelper.gb16Plus,
                      ].map((ram) {
                        List<String> selectedRam =
                            viewModel.ramTextController.text.isEmpty
                                ? []
                                : viewModel.ramTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();
                        bool isSelected = selectedRam.contains(ram);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedRam.remove(ram);
                              } else {
                                selectedRam.add(ram);
                              }
                              if (selectedRam.isEmpty) {
                                viewModel.ramTextController.clear();
                                filter.ram = "";
                              } else {
                                viewModel.ramTextController.text =
                                    selectedRam.join(',');
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: Text(
                              ram,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.strong,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StringHelper.lessThan8GB,
                        StringHelper.gb8,
                        StringHelper.gb16,
                        StringHelper.gb32,
                        StringHelper.gb64,
                        StringHelper.gb128,
                        StringHelper.gb256,
                        StringHelper.gb512,
                        StringHelper.tb1,
                        StringHelper.tb1Plus,
                      ].map((storage) {
                        List<String> selectedStorage =
                            viewModel.storageTextController.text.isEmpty
                                ? []
                                : viewModel.storageTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();
                        bool isSelected = selectedStorage.contains(storage);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedStorage.remove(storage);
                              } else {
                                selectedStorage.add(storage);
                              }
                              if (selectedStorage.isEmpty) {
                                viewModel.storageTextController.clear();
                                filter.storage = "";
                              } else {
                                viewModel.storageTextController.text =
                                    selectedStorage.join(',');
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: Text(
                              storage,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
              if (filter.categoryId == '1' &&
                  (filter.subSubCategoryId == '1' ||
                      filter.subSubCategoryId == '2')) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.ram,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StringHelper.lessThan4GB,
                        StringHelper.gb4,
                        StringHelper.gb8,
                        StringHelper.gb16,
                        StringHelper.gb32,
                        StringHelper.gb64,
                        StringHelper.gb64Plus,
                      ].map((ram) {
                        List<String> selectedRam =
                            viewModel.ramTextController.text.isEmpty
                                ? []
                                : viewModel.ramTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();
                        bool isSelected = selectedRam.contains(ram);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedRam.remove(ram);
                              } else {
                                selectedRam.add(ram);
                              }
                              if (selectedRam.isEmpty) {
                                viewModel.ramTextController.clear();
                                filter.ram = "";
                              } else {
                                viewModel.ramTextController.text =
                                    selectedRam.join(',');
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: Text(
                              ram,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.strong,
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StringHelper.gb1,
                        StringHelper.gb2,
                        StringHelper.gb4,
                        StringHelper.gb8,
                        StringHelper.gb64,
                        StringHelper.gb128,
                        StringHelper.gb256,
                        StringHelper.gb512,
                        StringHelper.tb1,
                        StringHelper.tb1Plus,
                      ].map((storage) {
                        List<String> selectedStorage =
                            viewModel.storageTextController.text.isEmpty
                                ? []
                                : viewModel.storageTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();
                        bool isSelected = selectedStorage.contains(storage);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedStorage.remove(storage);
                              } else {
                                selectedStorage.add(storage);
                              }
                              if (selectedStorage.isEmpty) {
                                viewModel.storageTextController.clear();
                                filter.storage = "";
                              } else {
                                viewModel.storageTextController.text =
                                    selectedStorage.join(',');
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1.5,
                              ),
                            ),
                            child: Text(
                              storage,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
              const SizedBox(height: 20),
              if (filter.categoryId == '9' &&
                  (filter.subcategoryId ?? '').isNotEmpty) ...[
                if (filter.categoryId == '9' &&
                    (filter.subcategoryId ?? '').isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            StringHelper.usertype,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  _isCurrentLanguageArabic(context) ? 18 : 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildUserTypeOption(
                            context: context,
                            title: StringHelper.lookingJob,
                            icon: Icons.work_outline,
                            isSelected:
                                viewModel.lookingForTextController.text ==
                                    Utils.setCommon(StringHelper.lookingJob),
                            onTap: () {
                              // Toggle selection - if already selected, clear it
                              if (viewModel.lookingForTextController.text ==
                                  Utils.setCommon(StringHelper.lookingJob)) {
                                viewModel.lookingForTextController.clear();
                                filter.lookingFor = null;
                              } else {
                                viewModel.lookingForTextController.text =
                                    Utils.setCommon(StringHelper.lookingJob);
                                filter.lookingFor =
                                    Utils.setCommon(StringHelper.lookingJob);
                              }
                              setState(() {});
                            },
                          ),
                          _buildUserTypeOption(
                            context: context,
                            title: StringHelper.hiringJob,
                            icon: Icons.business_center_outlined,
                            isSelected:
                                viewModel.lookingForTextController.text ==
                                    Utils.setCommon(StringHelper.hiringJob),
                            onTap: () {
                              // Toggle selection - if already selected, clear it
                              if (viewModel.lookingForTextController.text ==
                                  Utils.setCommon(StringHelper.hiringJob)) {
                                viewModel.lookingForTextController.clear();
                                filter.lookingFor = null;
                              } else {
                                viewModel.lookingForTextController.text =
                                    Utils.setCommon(StringHelper.hiringJob);
                                filter.lookingFor =
                                    Utils.setCommon(StringHelper.hiringJob);
                              }
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.positionType,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                _isCurrentLanguageArabic(context) ? 18 : 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.contract,
                          value: Utils.setCommon(StringHelper.contract),
                          icon: Icons.description_outlined,
                          isSelected: viewModel.jobPositionTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(Utils.setCommon(StringHelper.contract)),
                          onTap: () {
                            List<String> selectedPositions =
                                viewModel.jobPositionTextController.text.isEmpty
                                    ? []
                                    : viewModel.jobPositionTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedPositions.contains(
                                Utils.setCommon(StringHelper.contract))) {
                              selectedPositions.remove(
                                  Utils.setCommon(StringHelper.contract));
                            } else {
                              selectedPositions
                                  .add(Utils.setCommon(StringHelper.contract));
                            }

                            viewModel.jobPositionTextController.text =
                                selectedPositions.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.fullTime,
                          value: Utils.setCommon(StringHelper.fullTime),
                          icon: Icons.schedule,
                          isSelected: viewModel.jobPositionTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(Utils.setCommon(StringHelper.fullTime)),
                          onTap: () {
                            List<String> selectedPositions =
                                viewModel.jobPositionTextController.text.isEmpty
                                    ? []
                                    : viewModel.jobPositionTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedPositions.contains(
                                Utils.setCommon(StringHelper.fullTime))) {
                              selectedPositions.remove(
                                  Utils.setCommon(StringHelper.fullTime));
                            } else {
                              selectedPositions
                                  .add(Utils.setCommon(StringHelper.fullTime));
                            }

                            viewModel.jobPositionTextController.text =
                                selectedPositions.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.partTime,
                          value: Utils.setCommon(StringHelper.partTime),
                          icon: Icons.timelapse,
                          isSelected: viewModel.jobPositionTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(Utils.setCommon(StringHelper.partTime)),
                          onTap: () {
                            List<String> selectedPositions =
                                viewModel.jobPositionTextController.text.isEmpty
                                    ? []
                                    : viewModel.jobPositionTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedPositions.contains(
                                Utils.setCommon(StringHelper.partTime))) {
                              selectedPositions.remove(
                                  Utils.setCommon(StringHelper.partTime));
                            } else {
                              selectedPositions
                                  .add(Utils.setCommon(StringHelper.partTime));
                            }

                            viewModel.jobPositionTextController.text =
                                selectedPositions.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.temporary,
                          value: Utils.setCommon(StringHelper.temporary),
                          icon: Icons.access_time,
                          isSelected: viewModel.jobPositionTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(
                                  Utils.setCommon(StringHelper.temporary)),
                          onTap: () {
                            List<String> selectedPositions =
                                viewModel.jobPositionTextController.text.isEmpty
                                    ? []
                                    : viewModel.jobPositionTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedPositions.contains(
                                Utils.setCommon(StringHelper.temporary))) {
                              selectedPositions.remove(
                                  Utils.setCommon(StringHelper.temporary));
                            } else {
                              selectedPositions
                                  .add(Utils.setCommon(StringHelper.temporary));
                            }

                            viewModel.jobPositionTextController.text =
                                selectedPositions.join(',');
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringHelper.workSetting,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: _isCurrentLanguageArabic(context) ? 18 : 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.remote,
                          value: Utils.setCommon(StringHelper.remote),
                          icon: Icons.home_work_outlined,
                          isSelected: viewModel.workSettingTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(Utils.setCommon(StringHelper.remote)),
                          onTap: () {
                            List<String> selectedSettings =
                                viewModel.workSettingTextController.text.isEmpty
                                    ? []
                                    : viewModel.workSettingTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedSettings.contains(
                                Utils.setCommon(StringHelper.remote))) {
                              selectedSettings
                                  .remove(Utils.setCommon(StringHelper.remote));
                            } else {
                              selectedSettings
                                  .add(Utils.setCommon(StringHelper.remote));
                            }

                            viewModel.workSettingTextController.text =
                                selectedSettings.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.officeBased,
                          value: Utils.setCommon(StringHelper.officeBased),
                          icon: Icons.business_outlined,
                          isSelected: viewModel.workSettingTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(
                                  Utils.setCommon(StringHelper.officeBased)),
                          onTap: () {
                            List<String> selectedSettings =
                                viewModel.workSettingTextController.text.isEmpty
                                    ? []
                                    : viewModel.workSettingTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedSettings.contains(
                                Utils.setCommon(StringHelper.officeBased))) {
                              selectedSettings.remove(
                                  Utils.setCommon(StringHelper.officeBased));
                            } else {
                              selectedSettings.add(
                                  Utils.setCommon(StringHelper.officeBased));
                            }

                            viewModel.workSettingTextController.text =
                                selectedSettings.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.mixOfficeBased,
                          value: Utils.setCommon(StringHelper.mixOfficeBased),
                          icon: Icons.sync_alt,
                          isSelected: viewModel.workSettingTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(
                                  Utils.setCommon(StringHelper.mixOfficeBased)),
                          onTap: () {
                            List<String> selectedSettings =
                                viewModel.workSettingTextController.text.isEmpty
                                    ? []
                                    : viewModel.workSettingTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedSettings.contains(
                                Utils.setCommon(StringHelper.mixOfficeBased))) {
                              selectedSettings.remove(
                                  Utils.setCommon(StringHelper.mixOfficeBased));
                            } else {
                              selectedSettings.add(
                                  Utils.setCommon(StringHelper.mixOfficeBased));
                            }

                            viewModel.workSettingTextController.text =
                                selectedSettings.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.fieldBased,
                          value: Utils.setCommon(StringHelper.fieldBased),
                          icon: Icons.explore_outlined,
                          isSelected: viewModel.workSettingTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(
                                  Utils.setCommon(StringHelper.fieldBased)),
                          onTap: () {
                            List<String> selectedSettings =
                                viewModel.workSettingTextController.text.isEmpty
                                    ? []
                                    : viewModel.workSettingTextController.text
                                        .split(',')
                                        .map((e) => e.trim())
                                        .toList();

                            if (selectedSettings.contains(
                                Utils.setCommon(StringHelper.fieldBased))) {
                              selectedSettings.remove(
                                  Utils.setCommon(StringHelper.fieldBased));
                            } else {
                              selectedSettings.add(
                                  Utils.setCommon(StringHelper.fieldBased));
                            }

                            viewModel.workSettingTextController.text =
                                selectedSettings.join(',');
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.workEducation,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                _isCurrentLanguageArabic(context) ? 18 : 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.noEducation,
                          value: Utils.setCommon(StringHelper.noEducation),
                          icon: Icons.not_interested,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.noEducation),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation
                                .contains(StringHelper.noEducation)) {
                              selectedEducation
                                  .remove(StringHelper.noEducation);
                            } else {
                              selectedEducation.add(StringHelper.noEducation);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.student,
                          value: Utils.setCommon(StringHelper.student),
                          icon: Icons.person_outline,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.student),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation
                                .contains(StringHelper.student)) {
                              selectedEducation.remove(StringHelper.student);
                            } else {
                              selectedEducation.add(StringHelper.student);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.highSchool,
                          value: Utils.setCommon(StringHelper.highSchool),
                          icon: Icons.school_outlined,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.highSchool),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation
                                .contains(StringHelper.highSchool)) {
                              selectedEducation.remove(StringHelper.highSchool);
                            } else {
                              selectedEducation.add(StringHelper.highSchool);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.diploma,
                          value: Utils.setCommon(StringHelper.diploma),
                          icon: Icons.card_membership,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.diploma),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation
                                .contains(StringHelper.diploma)) {
                              selectedEducation.remove(StringHelper.diploma);
                            } else {
                              selectedEducation.add(StringHelper.diploma);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.bDegree,
                          value: Utils.setCommon(StringHelper.bDegree),
                          icon: Icons.school,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.bDegree),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation
                                .contains(StringHelper.bDegree)) {
                              selectedEducation.remove(StringHelper.bDegree);
                            } else {
                              selectedEducation.add(StringHelper.bDegree);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.mDegree,
                          value: Utils.setCommon(StringHelper.mDegree),
                          icon: Icons.account_balance,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.mDegree),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation
                                .contains(StringHelper.mDegree)) {
                              selectedEducation.remove(StringHelper.mDegree);
                            } else {
                              selectedEducation.add(StringHelper.mDegree);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.phd,
                          value: Utils.setCommon(StringHelper.phd),
                          icon: Icons.workspace_premium,
                          isSelected: viewModel.workEducationTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.phd),
                          onTap: () {
                            List<String> selectedEducation = viewModel
                                    .workEducationTextController.text.isEmpty
                                ? []
                                : viewModel.workEducationTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedEducation.contains(StringHelper.phd)) {
                              selectedEducation.remove(StringHelper.phd);
                            } else {
                              selectedEducation.add(StringHelper.phd);
                            }

                            viewModel.workEducationTextController.text =
                                selectedEducation.join(',');
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringHelper.workExperience,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                _isCurrentLanguageArabic(context) ? 18 : 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.noExperience,
                          value: Utils.setCommon(StringHelper.noExperience),
                          isSelected: viewModel
                              .workExperienceTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.noExperience),
                          onTap: () {
                            List<String> selectedExperience = viewModel
                                    .workExperienceTextController.text.isEmpty
                                ? []
                                : viewModel.workExperienceTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedExperience
                                .contains(StringHelper.noExperience)) {
                              selectedExperience
                                  .remove(StringHelper.noExperience);
                            } else {
                              selectedExperience.add(StringHelper.noExperience);
                            }

                            viewModel.workExperienceTextController.text =
                                selectedExperience.join(',');
                            setState(() {});
                          },
                          fontSize: _isCurrentLanguageArabic(context) ? 14 : 12,
                          useEllipsis: true,
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.oneToThreeYears,
                          value: Utils.setCommon(StringHelper.oneToThreeYears),
                          isSelected: viewModel
                              .workExperienceTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.oneToThreeYears),
                          onTap: () {
                            List<String> selectedExperience = viewModel
                                    .workExperienceTextController.text.isEmpty
                                ? []
                                : viewModel.workExperienceTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedExperience
                                .contains(StringHelper.oneToThreeYears)) {
                              selectedExperience
                                  .remove(StringHelper.oneToThreeYears);
                            } else {
                              selectedExperience
                                  .add(StringHelper.oneToThreeYears);
                            }

                            viewModel.workExperienceTextController.text =
                                selectedExperience.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.threeToFiveYears,
                          value: Utils.setCommon(StringHelper.threeToFiveYears),
                          isSelected: viewModel
                              .workExperienceTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.threeToFiveYears),
                          onTap: () {
                            List<String> selectedExperience = viewModel
                                    .workExperienceTextController.text.isEmpty
                                ? []
                                : viewModel.workExperienceTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedExperience
                                .contains(StringHelper.threeToFiveYears)) {
                              selectedExperience
                                  .remove(StringHelper.threeToFiveYears);
                            } else {
                              selectedExperience
                                  .add(StringHelper.threeToFiveYears);
                            }

                            viewModel.workExperienceTextController.text =
                                selectedExperience.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.fiveToTenYears,
                          value: Utils.setCommon(StringHelper.fiveToTenYears),
                          isSelected: viewModel
                              .workExperienceTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.fiveToTenYears),
                          onTap: () {
                            List<String> selectedExperience = viewModel
                                    .workExperienceTextController.text.isEmpty
                                ? []
                                : viewModel.workExperienceTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedExperience
                                .contains(StringHelper.fiveToTenYears)) {
                              selectedExperience
                                  .remove(StringHelper.fiveToTenYears);
                            } else {
                              selectedExperience
                                  .add(StringHelper.fiveToTenYears);
                            }

                            viewModel.workExperienceTextController.text =
                                selectedExperience.join(',');
                            setState(() {});
                          },
                        ),
                        _buildMultiFilterSelectionOption(
                          context: context,
                          title: StringHelper.tenPlusYears,
                          value: Utils.setCommon(StringHelper.tenPlusYears),
                          isSelected: viewModel
                              .workExperienceTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .contains(StringHelper.tenPlusYears),
                          onTap: () {
                            List<String> selectedExperience = viewModel
                                    .workExperienceTextController.text.isEmpty
                                ? []
                                : viewModel.workExperienceTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                            if (selectedExperience
                                .contains(StringHelper.tenPlusYears)) {
                              selectedExperience
                                  .remove(StringHelper.tenPlusYears);
                            } else {
                              selectedExperience.add(StringHelper.tenPlusYears);
                            }

                            viewModel.workExperienceTextController.text =
                                selectedExperience.join(',');
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  StringHelper.salary,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: _isCurrentLanguageArabic(context) ? 18 : 16,
                  ),
                ),
                const Gap(16),
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
                            decoration: InputDecoration(
                                counterText: "",
                                fillColor: const Color(0xffFCFCFD),
                                hintText: StringHelper.salaryFrom,
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
                    const SizedBox(width: 5),
                    Text(StringHelper.to,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontSize: _isCurrentLanguageArabic(context) ? 18 : 16,
                        )),
                    const SizedBox(width: 5),
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
                          decoration: InputDecoration(
                              counterText: "",
                              fillColor: const Color(0xffFCFCFD),
                              hintText: StringHelper.salaryTo,
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
                const SizedBox(height: 5),
              ],
              Visibility(
                visible: widget.filters?.screenFrom != "home",
                child: Column(
                  children: [
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
                              builder: (context) =>
                                  EnhancedLocationSelectionScreen(
                                      viewModel: viewModel),
                            ));
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
                          viewModel.longitude =
                              double.parse(value['longitude']);
                        }
                      },
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
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

                // ),
              ),
              const SizedBox(
                height: 20,
              ),
              // ),
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
                  filter.locationType = viewModel.selectedLocationType;

                  // Use ENGLISH names from HomeVM's selected models for the API
                  filter.city = viewModel.selectedCity?.name; // English name
                  filter.districtName =
                      viewModel.selectedDistrict?.name; // English name
                  filter.neighborhoodName =
                      viewModel.selectedNeighborhood?.name; // English name

                  // Use precise latitude and longitude from HomeVM, formatted as strings
                  filter.latitude = viewModel.latitude.toStringAsFixed(6);
                  filter.longitude = viewModel.longitude.toStringAsFixed(6);
                  if (viewModel.itemCondition != 0 &&
                      filter.categoryId != "8" &&
                      filter.categoryId != "9" &&
                      filter.categoryId != "11" &&
                      filter.categoryId != "6" &&
                      filter.subcategoryId != "46" &&
                      filter.subcategoryId != "23" &&
                      filter.subcategoryId != "31") {
                    filter.itemCondition = viewModel.itemCondition == 1
                        ? StringHelper.newText
                        : StringHelper.used;
                  }

                  if ((filter.categoryId ?? "").isNotEmpty &&
                      filter.categoryId != '9') {
                    // Handle min price (minimum)
                    if (viewModel.startPriceTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.minPrice =
                          viewModel.startPriceTextController.text.trim();
                    }

                    // Handle max price (maximum)
                    if (viewModel.endPriceTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.maxPrice =
                          viewModel.endPriceTextController.text.trim();
                    }
                  }
                  if (viewModel.lookingForTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.lookingFor = Utils.setCommon(
                        viewModel.lookingForTextController.text);
                  }
                  // if (viewModel.sizesTextController.text.trim().isNotEmpty) {
                  //   filter.sizeId = viewModel.sizesTextController.text.trim();
                  // }
                  // if (filter.categoryId == '9' && salaryFromTo.start >= 0 && salaryFromTo.end <= 100000) {
                  if (filter.categoryId == '9') {
                    // Handle salary from (minimum)
                    if (viewModel.jobSalaryFromController.text
                        .trim()
                        .isNotEmpty) {
                      filter.salleryFrom =
                          viewModel.jobSalaryFromController.text.trim();
                    }

                    // Handle salary to (maximum)
                    if (viewModel.jobSalaryToController.text
                        .trim()
                        .isNotEmpty) {
                      filter.salleryTo =
                          viewModel.jobSalaryToController.text.trim();
                    }
                  }

                  if ("${viewModel.latitude}" != "0.0" &&
                      "${viewModel.longitude}" != "0.0") {
                    filter.latitude = viewModel.latitude.toString();
                    filter.longitude = viewModel.longitude.toString();
                  }

                  if (viewModel.yearTextController.text.trim().isNotEmpty) {
                    filter.year = viewModel.yearTextController.text.trim();
                  }
                  if (viewModel.transmissionTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple transmissions
                    List<String> transmissions = viewModel
                        .transmissionTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    transmissions =
                        transmissions.where((t) => t.isNotEmpty).toList();
                    if (transmissions.isNotEmpty) {
                      filter.transmission = transmissions
                          .map((t) => Utils.setCommon(t))
                          .join(',');
                    } else {
                      filter.transmission = null;
                      viewModel.transmissionTextController.clear();
                    }
                  } else {
                    // Empty means "All" - don't set filter
                    filter.transmission = null;
                  }
                  if (viewModel.jobPositionTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple position types
                    List<String> positions = viewModel
                        .jobPositionTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    positions = positions.where((p) => p.isNotEmpty).toList();
                    if (positions.isNotEmpty) {
                      filter.positionType =
                          positions.map((p) => Utils.setCommon(p)).join(',');
                    } else {
                      filter.positionType = null;
                      viewModel.jobPositionTextController.clear();
                    }
                  } else {
                    filter.positionType = null;
                  }
                  if (viewModel.carRentalTermController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple rental terms
                    List<String> terms = viewModel.carRentalTermController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    terms = terms.where((t) => t.isNotEmpty).toList();
                    if (terms.isNotEmpty) {
                      filter.carRentalTerm =
                          terms.map((t) => Utils.setCarRentalTerm(t)).join(',');
                    } else {
                      filter.carRentalTerm = null;
                      viewModel.carRentalTermController.clear();
                    }
                  } else {
                    filter.carRentalTerm = null;
                  }
                  if (viewModel.fuelTextController.text.trim().isNotEmpty) {
                    // Handle multiple fuel types
                    List<String> fuels = viewModel.fuelTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    fuels = fuels.where((f) => f.isNotEmpty).toList();
                    if (fuels.isNotEmpty) {
                      filter.fuel =
                          fuels.map((f) => Utils.setFuel(f)).join(',');
                    } else {
                      filter.fuel = null;
                      viewModel.fuelTextController.clear();
                    }
                  } else {
                    filter.fuel = null;
                  }
                  if (viewModel.carColorTextController.text.trim().isNotEmpty) {
                    // Handle multiple car colors
                    List<String> colors = viewModel.carColorTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    // Filter out empty strings
                    colors = colors.where((c) => c.isNotEmpty).toList();
                    if (colors.isNotEmpty) {
                      filter.carColor =
                          colors.map((c) => Utils.setColor(c)).join(',');
                    } else {
                      filter.carColor = null; // Clear the filter
                      viewModel.carColorTextController
                          .clear(); // Clear the controller
                    }
                  } else {
                    filter.carColor =
                        null; // Clear the filter when text is empty
                  }
                  if (viewModel.horsePowerTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple horsepowers
                    List<String> horsepowers = viewModel
                        .horsePowerTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    horsepowers =
                        horsepowers.where((h) => h.isNotEmpty).toList();
                    if (horsepowers.isNotEmpty) {
                      filter.horsePower = horsepowers
                          .map((h) => Utils.setHorsePower(h))
                          .join(',');
                    } else {
                      filter.horsePower = null;
                      viewModel.horsePowerTextController.clear();
                    }
                  } else {
                    filter.horsePower = null;
                  }

                  if (viewModel.engineCapacityTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple engine capacities
                    List<String> capacities = viewModel
                        .engineCapacityTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    capacities = capacities.where((c) => c.isNotEmpty).toList();
                    if (capacities.isNotEmpty) {
                      filter.engineCapacity = capacities
                          .map((c) => Utils.setEngineCapacity(c))
                          .join(',');
                    } else {
                      filter.engineCapacity = null;
                      viewModel.engineCapacityTextController.clear();
                    }
                  } else {
                    filter.engineCapacity = null;
                  }
                  if (viewModel.screenSizeTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.screenSize = Utils.setCommon(
                        viewModel.screenSizeTextController.text.trim());
                  }
                  if (viewModel.interiorColorTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple interior colors
                    List<String> colors = viewModel
                        .interiorColorTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    // Filter out empty strings
                    colors = colors.where((c) => c.isNotEmpty).toList();
                    if (colors.isNotEmpty) {
                      filter.interiorColor =
                          colors.map((c) => Utils.setColor(c)).join(',');
                    } else {
                      filter.interiorColor = null; // Clear the filter
                      viewModel.interiorColorTextController
                          .clear(); // Clear the controller
                    }
                  } else {
                    filter.interiorColor =
                        null; // Clear the filter when text is empty
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
                    // Handle multiple door selections
                    List<String> doors = viewModel.numbDoorsTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    doors = doors.where((d) => d.isNotEmpty).toList();
                    if (doors.isNotEmpty) {
                      filter.numbDoors =
                          doors.map((d) => Utils.setDoorsText(d)).join(',');
                    } else {
                      filter.numbDoors = null;
                      viewModel.numbDoorsTextController.clear();
                    }
                  } else {
                    filter.numbDoors = null;
                  }
                  if (viewModel.bodyTypeTextController.text.trim().isNotEmpty) {
                    // Handle multiple body types
                    List<String> bodyTypes = viewModel
                        .bodyTypeTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    bodyTypes = bodyTypes.where((b) => b.isNotEmpty).toList();
                    if (bodyTypes.isNotEmpty) {
                      filter.bodyType =
                          bodyTypes.map((b) => Utils.setBodyType(b)).join(',');
                    } else {
                      filter.bodyType = null;
                      viewModel.bodyTypeTextController.clear();
                    }
                  } else {
                    filter.bodyType = null;
                  }
                  if (viewModel.workSettingTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple work settings
                    List<String> settings = viewModel
                        .workSettingTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    settings = settings.where((s) => s.isNotEmpty).toList();
                    if (settings.isNotEmpty) {
                      filter.workSetting =
                          settings.map((s) => Utils.setCommon(s)).join(',');
                    } else {
                      filter.workSetting = null;
                      viewModel.workSettingTextController.clear();
                    }
                  } else {
                    filter.workSetting = null;
                  }
                  if (viewModel.workExperienceTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple work experiences
                    List<String> experiences = viewModel
                        .workExperienceTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    experiences =
                        experiences.where((exp) => exp.isNotEmpty).toList();
                    if (experiences.isNotEmpty) {
                      filter.workExperience = experiences
                          .map((exp) => Utils.setWorkExperience(exp))
                          .join(',');
                    } else {
                      filter.workExperience = null;
                      viewModel.workExperienceTextController.clear();
                    }
                  } else {
                    filter.workExperience = null;
                  }

                  if (viewModel.workEducationTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple education levels
                    List<String> educationLevels = viewModel
                        .workEducationTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    educationLevels =
                        educationLevels.where((edu) => edu.isNotEmpty).toList();
                    if (educationLevels.isNotEmpty) {
                      filter.workEducation = educationLevels
                          .map((edu) => Utils.setEducationOptions(edu))
                          .join(',');
                    } else {
                      filter.workEducation = null;
                      viewModel.workEducationTextController.clear();
                    }
                  } else {
                    filter.workEducation = null;
                  }
                  if (viewModel.propertyForTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.propertyFor = Utils.setProperty(
                        viewModel.propertyForTextController.text.trim());
                  }

                  if (viewModel.noOfBedroomsTextController.text
                      .trim()
                      .isNotEmpty) {
                    List<String> bedrooms = viewModel
                        .noOfBedroomsTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    bedrooms = bedrooms.where((b) => b.isNotEmpty).toList();
                    if (bedrooms.isNotEmpty) {
                      filter.bedrooms = bedrooms
                          .map((b) => Utils.setBedroomsText(b))
                          .join(',');
                    } else {
                      filter.bedrooms = null;
                      viewModel.noOfBedroomsTextController.clear();
                    }
                  } else {
                    filter.bedrooms = null;
                  }

                  if (viewModel.noOfBathroomsTextController.text
                      .trim()
                      .isNotEmpty) {
                    List<String> bathrooms = viewModel
                        .noOfBathroomsTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    bathrooms = bathrooms.where((b) => b.isNotEmpty).toList();
                    if (bathrooms.isNotEmpty) {
                      filter.bathrooms = bathrooms
                          .map((b) => Utils.setBathroomsText(b))
                          .join(',');
                    } else {
                      filter.bathrooms = null;
                      viewModel.noOfBathroomsTextController.clear();
                    }
                  } else {
                    filter.bathrooms = null;
                  }
                  if (viewModel.furnishingStatusTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.furnishedType = Utils.setFurnished(
                        viewModel.furnishingStatusTextController.text.trim());
                  }

                  if (viewModel.ownershipStatusTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.ownership = Utils.setCommon(
                        viewModel.ownershipStatusTextController.text.trim());
                  }

                  if (viewModel.paymentTypeTextController.text
                      .trim()
                      .isNotEmpty) {
                    List<String> paymentTypes = viewModel
                        .paymentTypeTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    paymentTypes =
                        paymentTypes.where((p) => p.isNotEmpty).toList();
                    if (paymentTypes.isNotEmpty) {
                      filter.paymentType = paymentTypes
                          .map((p) => Utils.setPaymentTyp(p))
                          .join(',');
                    } else {
                      filter.paymentType = null;
                      viewModel.paymentTypeTextController.clear();
                    }
                  } else {
                    filter.paymentType = null;
                  }

                  if (viewModel.completionStatusTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.completionStatus = Utils.setUtilityTyp(
                        viewModel.completionStatusTextController.text.trim());
                  }

                  if (viewModel.deliveryTermTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple delivery terms
                    List<String> deliveryTerms = viewModel
                        .deliveryTermTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    deliveryTerms =
                        deliveryTerms.where((d) => d.isNotEmpty).toList();
                    if (deliveryTerms.isNotEmpty) {
                      filter.deliveryTerm = deliveryTerms
                          .map((d) => Utils.setCommon(d))
                          .join(',');
                    } else {
                      filter.deliveryTerm = null;
                      viewModel.deliveryTermTextController.clear();
                    }
                  } else {
                    // Empty means "All" - don't set filter
                    filter.deliveryTerm = null;
                  }
                  if (viewModel.propertyForTypeTextController.text
                      .trim()
                      .isNotEmpty) {
                    filter.type = Utils.setProperty(
                        viewModel.propertyForTypeTextController.text.trim());
                  }

                  if (viewModel.levelTextController.text.trim().isNotEmpty) {
                    // Handle multiple levels
                    List<String> levels = viewModel.levelTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    levels = levels.where((l) => l.isNotEmpty).toList();
                    if (levels.isNotEmpty) {
                      filter.level =
                          levels.map((l) => Utils.setCommon(l)).join(',');
                    } else {
                      filter.level = null;
                      viewModel.levelTextController.clear();
                    }
                  } else {
                    filter.level = null;
                  }

                  if (viewModel.listedByTextController.text.trim().isNotEmpty) {
                    filter.listedBy =
                        viewModel.listedByTextController.text.trim();
                  }

                  if (viewModel.rentalTermsTextController.text
                      .trim()
                      .isNotEmpty) {
                    // Handle multiple rental terms
                    List<String> terms = viewModel
                        .rentalTermsTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    terms = terms.where((t) => t.isNotEmpty).toList();
                    if (terms.isNotEmpty) {
                      filter.rentalTerm =
                          terms.map((t) => Utils.setCarRentalTerm(t)).join(',');
                    } else {
                      filter.rentalTerm = null;
                      viewModel.rentalTermsTextController.clear();
                    }
                  } else {
                    // Empty means "All" - don't set filter
                    filter.rentalTerm = null;
                  }
                  if (viewModel
                      .accessToUtilitiesTextController.text.isNotEmpty) {
                    // This ensures ALL selected utilities are included
                    String utilitiesText =
                        viewModel.accessToUtilitiesTextController.text.trim();
                    // Use the utility transformer to get the backend-compatible value
                    filter.accessToUtilities =
                        Utils.setUtilityTyp(utilitiesText);

                    // Add debug print
                    print(
                        "Modified - Access to Utilities: ${filter.accessToUtilities}");
                  }
                  if (filter.categoryId == "11" &&
                      ["83", "84", "87"].contains(filter.subcategoryId)) {
                    // Handle min down price
                    if (viewModel.startDownPriceTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.minDownPrice =
                          viewModel.startDownPriceTextController.text.trim();
                    }

                    // Handle max down price
                    if (viewModel.endDownPriceTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.maxDownPrice =
                          viewModel.endDownPriceTextController.text.trim();
                    }
                  }
                  if (viewModel.ramTextController.text.trim().isNotEmpty) {
                    // Handle multiple RAM selections
                    List<String> ramSizes = viewModel.ramTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    ramSizes = ramSizes.where((r) => r.isNotEmpty).toList();
                    if (ramSizes.isNotEmpty) {
                      filter.ram =
                          ramSizes.map((r) => Utils.setRam(r)).join(',');
                    } else {
                      filter.ram = "";
                      viewModel.ramTextController.clear();
                    }
                  } else {
                    filter.ram = "";
                  }
                  if (viewModel.storageTextController.text.trim().isNotEmpty) {
                    // Handle multiple storage selections
                    List<String> storageSizes = viewModel
                        .storageTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
                    storageSizes =
                        storageSizes.where((s) => s.isNotEmpty).toList();
                    if (storageSizes.isNotEmpty) {
                      filter.storage = storageSizes
                          .map((s) => Utils.setStorage(s))
                          .join(',');
                    } else {
                      filter.storage = "";
                      viewModel.storageTextController.clear();
                    }
                  } else {
                    filter.storage = "";
                  }
                  filter.minPrice =
                      viewModel.startPriceTextController.text.trim().isNotEmpty
                          ? viewModel.startPriceTextController.text
                          : null;
                  filter.maxPrice =
                      viewModel.endPriceTextController.text.trim().isNotEmpty
                          ? viewModel.endPriceTextController.text
                          : null;
                  // if (filter.categoryId == "11" && areaValues.start >= 0 && areaValues.end <= 100000) {
                  if (filter.categoryId == "11") {
                    // Handle min area size
                    if (viewModel.startAreaTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.minAreaSize =
                          viewModel.startAreaTextController.text.trim();
                    }

                    // Handle max area size
                    if (viewModel.endAreaTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.maxAreaSize =
                          viewModel.endAreaTextController.text.trim();
                    }
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
                      (filter.subcategoryId == "13" ||
                          filter.subcategoryId == "98" ||
                          filter.subcategoryId == '26')) {
                    // Handle min KM driven
                    if (viewModel.minKmDrivenTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.minKmDriven =
                          viewModel.minKmDrivenTextController.text.trim();
                    }

                    // Handle max KM driven
                    if (viewModel.maxKmDrivenTextController.text
                        .trim()
                        .isNotEmpty) {
                      filter.maxKmDriven =
                          viewModel.maxKmDrivenTextController.text.trim();
                    }
                  }
                  if (viewModel.mileageTextController.text.trim().isNotEmpty) {
                    filter.milleage =
                        viewModel.mileageTextController.text.trim();
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
                onTap: () async {
                  // keep whatever the user had picked
                  String currentCategoryId = filter.categoryId ?? "";
                  String currentSubcategoryId = filter.subcategoryId ?? "";
                  String currentSubSubCategoryId =
                      filter.subSubCategoryId ?? "";

                  // wipe everything
                  resetFilters();

                  /* ---------- put things back in the right order ---------- */

                  // 1. category
                  if (currentCategoryId.isNotEmpty) {
                    filter.categoryId = currentCategoryId;
                    viewModel.categoryTextController.text =
                        getCategoryName(id: currentCategoryId);

                    await getSubCategory(
                        id: currentCategoryId); // repopulate list
                  }

                  // 2. sub-category
                  if (currentSubcategoryId.isNotEmpty) {
                    filter.subcategoryId = currentSubcategoryId;
                    viewModel.subCategoryTextController.text =
                        getSubCategoryName(id: currentSubcategoryId);

                    await getBrands(id: currentSubcategoryId);
                    await getSubSubCategories(
                        id: currentSubcategoryId); // repopulate list
                  }

                  // 3. sub-sub-category
                  if (currentSubSubCategoryId.isNotEmpty &&
                      subSubCategories.isNotEmpty) {
                    filter.subSubCategoryId = currentSubSubCategoryId;

                    // IMPORTANT: Populate the text controller with the sub-subcategory name
                    viewModel.subSubCategoryTextController.text =
                        getSubSubCategoryName(id: currentSubSubCategoryId);

                    await getFashionSizes(
                        id: currentSubSubCategoryId); // if you use sizes
                  }

                  /* ---------- refresh UI ---------- */
                  setState(() {});
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  void updateFilter({required HomeVM vm}) async {
    DialogHelper.showLoading(); // Show loading at the start

    try {
      categoriesList = vm.categories;
      // vm.locationTextController.text = "Egypt";

      // Only reset filters if we don't have filters from widget
      if (widget.filters == null) {
        resetFilters();
        setState(() {});
        return;
      }
      final incomingFilter = widget.filters!; // Same as 'filter' at this point.

      vm.selectedLocationType = incomingFilter.locationType ?? "all";
      vm.latitude = double.tryParse(incomingFilter.latitude ?? "0.0") ?? 0.0;
      vm.longitude = double.tryParse(incomingFilter.longitude ?? "0.0") ?? 0.0;

      // Clear previous selections in HomeVM before setting new ones.
      vm.selectedCity = null;
      vm.selectedDistrict = null;
      vm.selectedNeighborhood = null;

      if (vm.selectedLocationType == "city" &&
          incomingFilter.city != null &&
          incomingFilter.city!.isNotEmpty) {
        vm.selectedCity = _findCityByNameFromService(incomingFilter.city!);
        if (vm.selectedCity != null) {
          // If city found, use its precise coordinates.
          vm.latitude = vm.selectedCity!.latitude;
          vm.longitude = vm.selectedCity!.longitude;
        }
      } else if (vm.selectedLocationType == "district" &&
          incomingFilter.city != null &&
          incomingFilter.city!.isNotEmpty &&
          incomingFilter.districtName != null &&
          incomingFilter.districtName!.isNotEmpty) {
        vm.selectedCity = _findCityByNameFromService(incomingFilter.city!);
        if (vm.selectedCity != null) {
          vm.selectedDistrict = _findDistrictByNameFromService(
              vm.selectedCity!, incomingFilter.districtName!);
          if (vm.selectedDistrict != null) {
            // If district found, use its precise coordinates.
            vm.latitude = vm.selectedDistrict!.latitude;
            vm.longitude = vm.selectedDistrict!.longitude;
          }
        }
      } else if (vm.selectedLocationType == "neighborhood" &&
          incomingFilter.city != null &&
          incomingFilter.city!.isNotEmpty &&
          incomingFilter.districtName != null &&
          incomingFilter.districtName!.isNotEmpty &&
          incomingFilter.neighborhoodName != null &&
          incomingFilter.neighborhoodName!.isNotEmpty) {
        vm.selectedCity = _findCityByNameFromService(incomingFilter.city!);
        if (vm.selectedCity != null) {
          vm.selectedDistrict = _findDistrictByNameFromService(
              vm.selectedCity!, incomingFilter.districtName!);
          if (vm.selectedDistrict != null) {
            vm.selectedNeighborhood = _findNeighborhoodByNameFromService(
                vm.selectedDistrict!, incomingFilter.neighborhoodName!);
            if (vm.selectedNeighborhood != null) {
              // If neighborhood found, use its precise coordinates.
              vm.latitude = vm.selectedNeighborhood!.latitude;
              vm.longitude = vm.selectedNeighborhood!.longitude;
            }
          }
        }
      } else if (vm.selectedLocationType == "all") {
        // For "all", ensure HomeVM's lat/lng are reset (or set to your app's default for "All Egypt")
        vm.latitude = 0.0;
        vm.longitude = 0.0;
      }
      // For "coordinates" or "nearby", vm.latitude and vm.longitude are already correctly set
      // from incomingFilter.latitude and incomingFilter.longitude earlier.

      // Update the location text field in HomeVM so FilterView's UI displays the correct localized name.
      vm.locationTextController.text = vm.getLocalizedLocationName();
      // Otherwise, restore from widget.filters
      filter = widget.filters!;

      // Basic filter properties
      vm.currentPropertyType = filter.propertyFor ?? "";
      vm.itemCondition = (filter.itemCondition ?? "").isEmpty
          ? 0
          : (filter.itemCondition?.toLowerCase().contains('used') ?? false)
              ? 2
              : 1;

      // Price range
      vm.startPriceTextController.text = filter.minPrice ?? '';
      vm.endPriceTextController.text = filter.maxPrice ?? '';

      // Salary range
      vm.jobSalaryFromController.text = filter.salleryFrom ?? '';
      vm.jobSalaryToController.text = filter.salleryTo ?? '';

      // Carefully restore each filter field with proper nullability checks
      vm.yearTextController.text = filter.year ?? '';
      vm.jobPositionTextController.text =
          Utils.getCommon(filter.positionType ?? '');
      vm.fuelTextController.text = Utils.getFuel(filter.fuel ?? '');
      vm.carColorTextController.text = Utils.getColor(filter.carColor ?? '');
      vm.horsePowerTextController.text =
          Utils.getHorsePower(filter.horsePower ?? '');
      vm.ramTextController.text = filter.ram ?? "";
      vm.storageTextController.text = filter.storage ?? "";
      vm.transmissionTextController.text =
          Utils.getCommon(filter.transmission ?? '');
      vm.propertyForTypeTextController.text =
          Utils.getProperty(filter.type ?? '');
      vm.lookingForTextController.text =
          Utils.getCommon(filter.lookingFor ?? '');

      // Additional properties
      vm.bodyTypeTextController.text = Utils.getBodyType(filter.bodyType ?? '');
      vm.engineCapacityTextController.text =
          Utils.getEngineCapacity(filter.engineCapacity ?? '');
      vm.interiorColorTextController.text =
          Utils.getColor(filter.interiorColor ?? '');
      vm.numbCylindersTextController.text = filter.numbCylinders ?? '';
      vm.numbDoorsTextController.text =
          Utils.getDoorsText(filter.numbDoors ?? '');
      vm.carRentalTermController.text =
          Utils.carRentalTerm(filter.carRentalTerm ?? '');
      vm.mileageTextController.text = filter.milleage ?? '';
      vm.screenSizeTextController.text =
          Utils.getCommon(filter.screenSize ?? '');

      // Property-specific fields
      vm.propertyForTextController.text =
          Utils.getProperty(filter.propertyFor ?? '');
      vm.workSettingTextController.text =
          Utils.getCommon(filter.workSetting ?? '');
      vm.workExperienceTextController.text =
          Utils.getWorkExperience(filter.workExperience ?? '');
      vm.workEducationTextController.text =
          Utils.getEducationOptions(filter.workEducation ?? '');
      vm.noOfBedroomsTextController.text =
          Utils.getBedroomsText(filter.bedrooms ?? '');
      vm.noOfBathroomsTextController.text =
          Utils.getBathroomsText(filter.bathrooms ?? '');
      vm.furnishingStatusTextController.text =
          Utils.getFurnished(filter.furnishedType ?? '');
      vm.ownershipStatusTextController.text =
          Utils.getCommon(filter.ownership ?? '');

      // Payment and property details
      vm.completionStatusTextController.text =
          Utils.getUtilityTyp(filter.completionStatus ?? '');
      vm.paymentTypeTextController.text =
          Utils.getPaymentTyp(filter.paymentType ?? '');
      vm.deliveryTermTextController.text =
          Utils.getCommon(filter.deliveryTerm ?? '');
      vm.rentalTermsTextController.text =
          Utils.carRentalTerm(filter.rentalTerm ?? '');
      vm.levelTextController.text = Utils.getCommon(filter.level ?? '');
      vm.accessToUtilitiesTextController.text =
          Utils.getUtilityTyp(filter.accessToUtilities ?? '');

      // Handle KM driven, area, and deposit ranges
      if (filter.categoryId == '4' &&
          (filter.subcategoryId == '13' ||
              filter.subcategoryId == '98' ||
              filter.subcategoryId == '26')) {
        vm.minKmDrivenTextController.text = filter.minKmDriven ?? '';
        vm.maxKmDrivenTextController.text = filter.maxKmDriven ?? '';
      }
      vm.minYearTextController.text = filter.minYear ?? '';
      vm.maxYearTextController.text = filter.maxYear ?? '';

      if (filter.categoryId == "11") {
        vm.startAreaTextController.text = filter.minAreaSize ?? '';
        vm.endAreaTextController.text = filter.maxAreaSize ?? '';
      }
      if (filter.latitude != null &&
          filter.longitude != null &&
          filter.latitude != "0.0" &&
          filter.longitude != "0.0") {
        vm.latitude = double.tryParse(filter.latitude ?? "0.0") ?? 0.0;
        vm.longitude = double.tryParse(filter.longitude ?? "0.0") ?? 0.0;
      }
      if (filter.categoryId == "11" &&
          ["83", "84", "87"].contains(filter.subcategoryId)) {
        vm.startDownPriceTextController.text = filter.minDownPrice ?? '';
        vm.endDownPriceTextController.text = filter.maxDownPrice ?? '';
      }
      vm.ramTextController.text =
          filter.ram?.isNotEmpty == true ? Utils.getRam(filter.ram!) : "";

      vm.storageTextController.text = filter.storage?.isNotEmpty == true
          ? Utils.getStorage(filter.storage!)
          : "";

      // Set category hierarchy
      vm.categoryTextController.text = getCategoryName(id: filter.categoryId);
      if ((filter.categoryId ?? "").isNotEmpty && filter.categoryId != '0') {
        await getSubCategory(id: filter.categoryId);
      }

      if ((filter.subcategoryId ?? "").isNotEmpty) {
        vm.subCategoryTextController.text =
            getSubCategoryName(id: filter.subcategoryId);
        await getBrands(id: filter.subcategoryId);
        await getSubSubCategories(id: filter.subcategoryId);
      }

      if ((filter.subSubCategoryId ?? "").isNotEmpty) {
        await getFashionSizes(id: filter.subSubCategoryId);
        vm.subSubCategoryTextController.text =
            getSubSubCategoryName(id: filter.subSubCategoryId);
      }

      // Brand, model and sizes
      if ((filter.brandId ?? "").isNotEmpty) {
        vm.brandsTextController.text = getBrandName(id: filter.brandId);
        // Always load models when brand is selected, regardless of whether model is selected
        await getModels(brandId: int.parse(filter.brandId ?? "0"));
      }

      if ((filter.modelId ?? "").isNotEmpty && allModels.isNotEmpty) {
        // Check if multiple models are selected (comma-separated)
        if (filter.modelId!.contains(',')) {
          // Multiple models selected
          List<String> modelIds =
              filter.modelId!.split(',').map((e) => e.trim()).toList();
          List<String> modelNames = [];

          // Get model names for each ID
          for (String modelId in modelIds) {
            for (var model in allModels) {
              if (model.id.toString() == modelId) {
                modelNames.add(model.name ?? '');
                break;
              }
            }
          }

          // Set the controller with comma-separated model names
          vm.modelTextController.text = modelNames.join(',');
        } else {
          // Single model selected (backward compatibility)
          String modelName = "";
          for (var model in allModels) {
            if (model.id.toString() == filter.modelId) {
              modelName = model.name ?? '';
              break;
            }
          }
          vm.modelTextController.text = modelName;
        }
      }

      if ((filter.sizeId ?? "").isNotEmpty) {
        vm.sizesTextController.text = getFashionSizeName(id: filter.sizeId);
      }

      // Restore selected amenities if any
      if ((filter.selectedAmnities ?? "").isNotEmpty) {
        selectedAmenities = (filter.selectedAmnities ?? "")
            .split(',')
            .map((e) => int.parse(e))
            .toList();
      }

      setState(() {});
    } catch (e) {
      print("Error in updateFilter: $e");
    } finally {
      DialogHelper.hideLoading();
    }
  }

  void resetFilters() {
    HomeVM vm = context.read<HomeVM>();

    // Save current property type if needed
    String currentPropertyType = vm.currentPropertyType;

    // Create a new filter
    filter = FilterModel();

    vm.selectedLocationType = "all";
    vm.selectedCity = null;
    vm.selectedDistrict = null;
    vm.selectedNeighborhood = null;
    vm.latitude = 0.0; // Or your app's default latitude for "All Egypt"
    vm.longitude = 0.0; // Or your app's default longitude for "All Egypt"
    // This will update the text field in FilterView to "All Egypt" (or its localized version)
    vm.locationTextController.text = vm.getLocalizedLocationName();

    // 2. Reset the local 'filter' object in _FilterViewState
    // Preserve screenFrom if it's important for navigation logic
    String? currentScreenFrom = filter.screenFrom;
    filter = FilterModel(
      locationType: "all",
      latitude: "0.0", // FilterModel expects strings for lat/lng
      longitude: "0.0",
      city: null,
      districtName: null,
      neighborhoodName: null,
      screenFrom: currentScreenFrom,
    );

    // Clear all text controllers with a single loop
    List<TextEditingController> controllers = [
      vm.startPriceTextController,
      vm.endPriceTextController,
      vm.categoryTextController,
      vm.jobPositionTextController,
      vm.subCategoryTextController,
      vm.sortByTextController,
      vm.postedWithinTextController,
      vm.brandsTextController,
      vm.propertyForTextController,
      vm.carColorTextController,
      vm.horsePowerTextController,
      vm.subSubCategoryTextController,
      vm.engineCapacityTextController,
      vm.interiorColorTextController,
      vm.numbCylindersTextController,
      vm.screenSizeTextController,
      vm.numbDoorsTextController,
      vm.fuelTextController,
      vm.sizesTextController,
      vm.ramTextController,
      vm.storageTextController,
      vm.jobPositionTextController,
      vm.carRentalTermController,
      vm.workSettingTextController,
      vm.workExperienceTextController,
      vm.workEducationTextController,
      vm.bodyTypeTextController,
      vm.noOfBathroomsTextController,
      vm.noOfBedroomsTextController,
      vm.lookingForTextController,
      vm.furnishingStatusTextController,
      vm.accessToUtilitiesTextController,
      vm.ownershipStatusTextController,
      vm.propertyForTypeTextController,
      vm.paymentTypeTextController,
      vm.rentalTermsTextController,
      vm.listedByTextController,
      vm.completionStatusTextController,
      vm.deliveryTermTextController,
      vm.levelTextController,
      vm.mileageTextController,
      vm.minKmDrivenTextController,
      vm.maxKmDrivenTextController,
      vm.transmissionTextController,
      vm.startDownPriceTextController,
      vm.endDownPriceTextController,
      vm.startAreaTextController,
      vm.endAreaTextController,
      vm.jobSalaryFromController,
      vm.minYearTextController,
      vm.maxYearTextController,
      vm.jobSalaryToController,
      vm.modelTextController,
    ];

    for (var controller in controllers) {
      controller.clear();
    }

    // Reset other state variables
    brands.clear();
    fashionSizes.clear();
    selectedAmenities.clear();
    subCategoriesList.clear();
    subSubCategories.clear();
    allModels.clear();

    // Reset specific filter properties to null/empty
    filter.minKmDriven = null;
    filter.maxKmDriven = null;
    filter.ram = "";
    filter.storage = "";
    filter.minYear = null;
    filter.maxYear = null;

    // Restore property type if needed
    vm.propertyForTextController.text = currentPropertyType;
    vm.currentPropertyType = currentPropertyType;
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
    try {
      // Check cache first
      String cacheKey = _cacheManager.getSubCategoriesKey(id ?? '');
      List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

      if (cachedData != null) {
        // Use cached data
        setState(() {
          subCategoriesList = cachedData;
        });
        return;
      }

      // If not in cache, show loading and fetch from API
      DialogHelper.showLoading();

      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getSubCategoriesUrl(id: "$id"),
          requestType: RequestType.get);

      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      subCategoriesList = model.body ?? [];

      // Save to cache
      _cacheManager.saveToCache(cacheKey, subCategoriesList);
    } catch (e) {
      print("Error fetching subcategories: $e");
    } finally {
      DialogHelper.hideLoading();
      setState(() {});
    }
  }

  Future<void> getBrands({String? id}) async {
    try {
      // Check cache first
      String cacheKey = _cacheManager.getBrandsKey(id ?? '');
      List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

      if (cachedData != null) {
        // Use cached data - no loading dialog needed
        brands = cachedData;
        setState(() {});
        return;
      }

      // If not in cache, show loading and fetch from API
      DialogHelper.showLoading();

      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getBrandsUrl(id: "$id"),
          requestType: RequestType.get);

      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<CategoryModel> model = ListResponse.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      brands = model.body ?? [];

      // Save to cache
      _cacheManager.saveToCache(cacheKey, brands);
    } catch (e) {
      print("Error fetching brands: $e");
    } finally {
      DialogHelper.hideLoading();
      setState(() {});
    }
  }

  Future<void> getSubSubCategories({String? id}) async {
    try {
      // Check cache first
      String cacheKey = _cacheManager.getSubSubCategoriesKey(id ?? '');
      List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

      if (cachedData != null) {
        // Use cached data - no loading dialog needed
        subSubCategories = cachedData;
        setState(() {});
        return;
      }

      // If not in cache, show loading and fetch from API
      DialogHelper.showLoading();

      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getSubSubCategoriesUrl(id: "$id"),
          requestType: RequestType.get);

      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      subSubCategories = model.body ?? [];

      // Save to cache
      _cacheManager.saveToCache(cacheKey, subSubCategories);
    } catch (e) {
      print("Error fetching sub-subcategories: $e");
    } finally {
      DialogHelper.hideLoading();
      setState(() {});
    }
  }

  Future<void> getFashionSizes({String? id}) async {
    try {
      // Check cache first
      String cacheKey = _cacheManager.getSizesKey(id ?? '');
      List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

      if (cachedData != null) {
        // Use cached data - no loading dialog needed
        fashionSizes = cachedData;
        setState(() {});
        return;
      }

      // If not in cache, show loading and fetch from API
      DialogHelper.showLoading();

      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getFashionSizeUrl(id: "$id"),
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      fashionSizes = model.body ?? [];

      // Save to cache
      _cacheManager.saveToCache(cacheKey, fashionSizes);
    } catch (e) {
      print("Error fetching fashion sizes: $e");
    } finally {
      DialogHelper.hideLoading();
      setState(() {});
    }
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
        case '98': // Motorcycles
          return motorcyclesWidget(viewModel);
        case '26': // Trucks
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
        case '87': // Businesses
          return businessWidget(viewModel); // Already defined
        case '90': // Lands
          return landWidget(viewModel);
        case '88': // Vacation homes - New case
          return vacationWidget(viewModel); // Already defined
        default:
          return const SizedBox.shrink();
      }
    }
    return const SizedBox.shrink(); // Default empty widget
  }

  Widget carsForSaleWidget(HomeVM viewModel) {
    // Helper to get the currently selected brand object
    CategoryModel? getSelectedBrand() {
      if (filter.brandId == null || filter.brandId!.isEmpty || brands.isEmpty) {
        return null;
      }
      try {
        return brands.firstWhere((b) => b.id.toString() == filter.brandId);
      } catch (e) {
        return null;
      }
    }

    // Helper to get the currently selected model object
    CategoryModel? getSelectedModel() {
      if (filter.modelId == null ||
          filter.modelId!.isEmpty ||
          allModels.isEmpty) {
        return null;
      }
      try {
        return allModels.firstWhere((m) => m.id.toString() == filter.modelId);
      } catch (e) {
        return null;
      }
    }

    final selectedBrand = getSelectedBrand();
    final selectedModel = getSelectedModel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- START: New Brand Selection Widget ---
        if (brands.isNotEmpty) ...[
          GestureDetector(
            onTap: () async {
              final CategoryModel? brand = await Navigator.push<CategoryModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => CarBrandSelectionScreen(
                    brands: brands,
                    selectedBrand: selectedBrand,
                    title: StringHelper.brand ?? "Select Brand",
                  ),
                ),
              );

              if (brand != null) {
                // When a new brand is selected
                DialogHelper.showLoading();
                // Clear old model selection
                allModels.clear();
                filter.modelId = "";
                viewModel.modelTextController.clear();
                // Set new brand
                filter.brandId = brand.id.toString();
                viewModel.brandsTextController.text = brand.name ?? '';
                // Fetch models for the new brand
                await getModels(brandId: brand.id);
                DialogHelper
                    .hideLoading(); // Ensure loading is hidden after models are fetched
                setState(() {}); // Rebuild to reflect changes
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringHelper.brand, // Not mandatory in filters, so no "*"
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (selectedBrand != null) ...[
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: SvgPicture.asset(
                            _getBrandLogoPath(selectedBrand.name),
                            fit: BoxFit.contain,
                            placeholderBuilder: (context) => Icon(
                              Icons.directions_car,
                              color: Colors.grey.shade600,
                              size: 60,
                            ),
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.directions_car,
                              color: Colors.grey.shade600,
                              size: 60,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          selectedBrand?.name ?? StringHelper.select,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selectedBrand != null
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: selectedBrand != null
                                ? Colors.black
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // --- END: New Brand Selection Widget ---

        // --- START: New Model Selection Widget ---
        if (selectedBrand != null) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringHelper.models,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Show selected models as chips
              if (viewModel.modelTextController.text.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: viewModel.modelTextController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .map((modelName) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            modelName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              // Remove this model from selection
                              List<String> selectedModels = viewModel
                                  .modelTextController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty && e != modelName)
                                  .toList();

                              viewModel.modelTextController.text =
                                  selectedModels.join(',');

                              // Update filter.modelId
                              List<String> modelIds = [];
                              for (String selectedModelName in selectedModels) {
                                for (var model in allModels) {
                                  if (model.name == selectedModelName) {
                                    modelIds.add(model.id.toString());
                                    break;
                                  }
                                }
                              }
                              filter.modelId = modelIds.join(',');

                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Add model button
              GestureDetector(
                onTap: (allModels.isNotEmpty)
                    ? () async {
                        // Get currently selected model names
                        List<String> currentlySelected =
                            viewModel.modelTextController.text.isEmpty
                                ? []
                                : viewModel.modelTextController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList();

                        // Convert current model names to CategoryModel objects
                        List<CategoryModel> currentSelectedModels = [];
                        for (String modelName in currentlySelected) {
                          for (var model in allModels) {
                            if (model.name == modelName) {
                              currentSelectedModels.add(model);
                              break;
                            }
                          }
                        }

                        final List<CategoryModel>? selectedModels =
                            await Navigator.push<List<CategoryModel>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarModelSelectionScreen(
                              models: allModels,
                              selectedModels: currentSelectedModels,
                              title: StringHelper.models ?? "Select Models",
                              brandName: selectedBrand.name,
                              isMultiSelect: true, // Enable multi-select mode
                            ),
                          ),
                        );

                        if (selectedModels != null) {
                          // Update the controller with selected model names
                          List<String> modelNames = selectedModels
                              .map((model) => model.name ?? '')
                              .where((name) => name.isNotEmpty)
                              .toList();

                          viewModel.modelTextController.text =
                              modelNames.join(',');

                          // Update filter.modelId with selected model IDs
                          List<String> modelIds = selectedModels
                              .map((model) => model.id.toString())
                              .toList();

                          filter.modelId = modelIds.join(',');

                          setState(() {});
                        }
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        allModels.isEmpty ? Colors.grey.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          allModels.isEmpty
                              ? (StringHelper.loadingModels ??
                                  "Loading models...")
                              : "${StringHelper.add ?? "Add"} ${StringHelper.models ?? "Models"}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      allModels.isEmpty &&
                              filter.brandId != null &&
                              filter.brandId!.isNotEmpty
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey.shade600),
                              ),
                            )
                          : Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey.shade600,
                              size: 24,
                            ),
                    ],
                  ),
                ),
              ),

              // Clear all models button (only show if models are selected)
              if (viewModel.modelTextController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    viewModel.modelTextController.clear();
                    filter.modelId = "";
                    setState(() {});
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red.shade200, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.clear_all,
                          size: 16,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          StringHelper.clearAll ?? "Clear All",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
        ],
        // --- END: New Model Selection Widget ---

        // Year Range
        Text(
          StringHelper.year,
          style: context.textTheme.titleSmall,
        ),
        const Gap(5),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.minYearTextController,
                  cursorColor: Colors.black,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: "${StringHelper.minYear}",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                  onChanged: (value) {
                    filter.minYear = value.isNotEmpty ? value : null;
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(StringHelper.to, style: context.textTheme.titleSmall),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.maxYearTextController,
                  cursorColor: Colors.black,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: '${StringHelper.maxYear}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                  onChanged: (value) {
                    filter.maxYear = value.isNotEmpty ? value : null;
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Fuel Type
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.fuel,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: fuelsType.map((fuel) {
                  // Parse selected fuels from the controller
                  List<String> selectedFuels =
                      viewModel.fuelTextController.text.isEmpty
                          ? []
                          : viewModel.fuelTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedFuels.contains(fuel);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // Remove if already selected
                          selectedFuels.remove(fuel);
                        } else {
                          // Add if not selected
                          selectedFuels.add(fuel);
                        }
                        // Update the controller with comma-separated values
                        viewModel.fuelTextController.text =
                            selectedFuels.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      width: 130,
                      height: 110,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            _getFuelSvgPath(fuel),
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              isSelected ? Colors.black : Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              fuel,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Car Color
        // Car Color
        _ColorSelectionWidget(
          title: StringHelper.carColorTitle,
          allColors: StringHelper.carColorOptions,
          selectedColor: viewModel.carColorTextController.text,
          onColorSelected: (color) {
            // Parse existing selections
            List<String> selectedColors =
                viewModel.carColorTextController.text.isEmpty
                    ? []
                    : viewModel.carColorTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();

            if (selectedColors.contains(color)) {
              // Remove if already selected
              selectedColors.remove(color);
            } else {
              // Add if not selected
              selectedColors.add(color);
            }

            // Update the controller
            viewModel.carColorTextController.text = selectedColors.join(',');
            setState(() {});
          },
        ),
        const SizedBox(height: 24),

        // Interior Color
        // Interior Color
        _ColorSelectionWidget(
          title: StringHelper.interiorColorTitle,
          allColors: StringHelper.carColorOptions,
          selectedColor: viewModel.interiorColorTextController.text,
          onColorSelected: (color) {
            // Parse existing selections
            List<String> selectedColors =
                viewModel.interiorColorTextController.text.isEmpty
                    ? []
                    : viewModel.interiorColorTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();

            if (selectedColors.contains(color)) {
              // Remove if already selected
              selectedColors.remove(color);
            } else {
              // Add if not selected
              selectedColors.add(color);
            }

            // Update the controller
            viewModel.interiorColorTextController.text =
                selectedColors.join(',');
            setState(() {});
          },
        ),
        const SizedBox(height: 24),

        // Number of Doors
        _buildDoorsSelection(viewModel),
        const SizedBox(height: 24),

        // Body Type
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.bodyTypeTitle,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: StringHelper.bodyTypeOptions.map((bodyType) {
                  // Parse selected body types from the controller
                  List<String> selectedBodyTypes =
                      viewModel.bodyTypeTextController.text.isEmpty
                          ? []
                          : viewModel.bodyTypeTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedBodyTypes.contains(bodyType);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // Remove if already selected
                          selectedBodyTypes.remove(bodyType);
                        } else {
                          // Add if not selected
                          selectedBodyTypes.add(bodyType);
                        }
                        // Update the controller with comma-separated values
                        viewModel.bodyTypeTextController.text =
                            selectedBodyTypes.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      width: 130,
                      height: 110,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            _getBodyTypeSvgPath(bodyType),
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              isSelected ? Colors.black : Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              bodyType,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // KM Driven
        Text(StringHelper.kmDriven, style: context.textTheme.titleSmall),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.minKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
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
            const SizedBox(width: 10),
            Text(StringHelper.to, style: context.textTheme.titleSmall),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: viewModel.maxKmDrivenTextController,
                  cursorColor: Colors.black,
                  maxLength: 7,
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
        const SizedBox(height: 24),

        // Horsepower
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.horsepowerTitle,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            // Remove StatefulBuilder and use the main widget's setState instead
            (() {
              List<String> allHorsepowers = [
                StringHelper.lessThan100HP,
                StringHelper.hp100To200,
                StringHelper.hp200To300,
                StringHelper.hp300To400,
                StringHelper.hp400To500,
                StringHelper.hp500To600,
                StringHelper.hp600To700,
                StringHelper.hp700To800,
                StringHelper.hp800Plus,
              ];

              // Show only first 6 horsepowers initially, or all if showAll is true
              List<String> displayedHorsepowers = _showAllHorsepowers
                  ? allHorsepowers
                  : allHorsepowers.take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: displayedHorsepowers.map((horsepower) {
                      List<String> selectedHorsepowers =
                          viewModel.horsePowerTextController.text.isEmpty
                              ? []
                              : viewModel.horsePowerTextController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList();
                      bool isSelected =
                          selectedHorsepowers.contains(horsepower);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedHorsepowers.remove(horsepower);
                            } else {
                              selectedHorsepowers.add(horsepower);
                            }
                            if (selectedHorsepowers.isEmpty) {
                              viewModel.horsePowerTextController.clear();
                            } else {
                              viewModel.horsePowerTextController.text =
                                  selectedHorsepowers.join(',');
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1.5,
                            ),
                          ),
                          child: Text(
                            horsepower,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (allHorsepowers.length > 6) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showAllHorsepowers = !_showAllHorsepowers;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showAllHorsepowers
                                ? StringHelper.seeLess
                                : StringHelper.seeMore,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 42, 46, 50),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            _showAllHorsepowers
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: const Color.fromARGB(255, 30, 34, 38),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            })(),
          ],
        ),
        const SizedBox(height: 20),

        // Engine Capacity
        // Replace the current Engine Capacity section in carsForSaleWidget with this:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.engineCapacityTitle,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            // Remove StatefulBuilder and use the main widget's setState instead
            (() {
              List<String> allCapacities = [
                StringHelper.below500cc,
                StringHelper.cc500To999,
                StringHelper.cc1000To1499,
                StringHelper.cc1500To1999,
                StringHelper.cc2000To2499,
                StringHelper.cc2500To2999,
                StringHelper.cc3000To3499,
                StringHelper.cc3500To3999,
                StringHelper.cc4000Plus,
              ];

              // Show only first 6 capacities initially, or all if showAll is true
              List<String> displayedCapacities = _showAllEngineCapacities
                  ? allCapacities
                  : allCapacities.take(6).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: displayedCapacities.map((capacity) {
                      List<String> selectedCapacities =
                          viewModel.engineCapacityTextController.text.isEmpty
                              ? []
                              : viewModel.engineCapacityTextController.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList();
                      bool isSelected = selectedCapacities.contains(capacity);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedCapacities.remove(capacity);
                            } else {
                              selectedCapacities.add(capacity);
                            }
                            if (selectedCapacities.isEmpty) {
                              viewModel.engineCapacityTextController.clear();
                            } else {
                              viewModel.engineCapacityTextController.text =
                                  selectedCapacities.join(',');
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1.5,
                            ),
                          ),
                          child: Text(
                            capacity,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (allCapacities.length > 6) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showAllEngineCapacities = !_showAllEngineCapacities;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showAllEngineCapacities
                                ? StringHelper.seeLess
                                : StringHelper.seeMore,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 42, 46, 50),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            _showAllEngineCapacities
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: const Color.fromARGB(255, 30, 34, 38),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            })(),
          ],
        ),

        const SizedBox(height: 20),

        // Transmission
        // Transmission Multi-Select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.transmission,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children:
                  [StringHelper.all, ...transmissionType].map((transmission) {
                // Check if "All" is selected (empty controller means all)
                bool isAllSelected =
                    viewModel.transmissionTextController.text.isEmpty;

                if (transmission == StringHelper.all) {
                  // Handle "All" option
                  bool isSelected = isAllSelected;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Clear the controller to represent "All"
                        viewModel.transmissionTextController.clear();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        transmission,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.black : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                } else {
                  // Handle Manual and Automatic options
                  List<String> selectedTransmissions = isAllSelected
                      ? []
                      : viewModel.transmissionTextController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList();

                  bool isSelected =
                      selectedTransmissions.contains(transmission);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTransmissions.remove(transmission);
                        } else {
                          selectedTransmissions.add(transmission);
                        }

                        // Update the controller
                        if (selectedTransmissions.isEmpty) {
                          viewModel.transmissionTextController
                              .clear(); // Back to "All"
                        } else {
                          viewModel.transmissionTextController.text =
                              selectedTransmissions.join(',');
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        transmission,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.black : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // +++ START: Helper function to get brand logo path (copied from cars_sell_form)
  String _getBrandLogoPath(String? brandName) {
    if (brandName == null) return 'assets/icons/car_brands/default.svg';

    // Map Arabic names to English equivalents first
    Map<String, String> arabicToEnglish = {
      'ألفا روميو': 'Alfa Romeo',
      'أستون مارتن': 'Aston Martin',
      'أودي': 'Audi',
      'أفاتار': 'Avatr',
      'بي إم دبليو': 'BMW',
      'بي واي دي': 'BYD',
      'بايك': 'Baic',
      'بنتلي': 'Bentley',
      'بيستون': 'Bestune',
      'بريليانس': 'Brilliance',
      'بوغاتي': 'Bugatti',
      'بيوك': 'Buick',
      'كاديلاك': 'Cadillac',
      'شانا': 'Chana',
      'شانجان': 'Changan',
      'شانغي': 'Changhe',
      'شيري': 'Chery',
      'شيفروليه': 'Chevrolet',
      'كرايسلر': 'Chrysler',
      'ستروين': 'Citroen',
      'كوبرا': 'Cupra',
      'دي إف إس كي': 'DFSK',
      'دايو': 'Daewoo',
      'دايهاتسو': 'Daihatsu',
      'دودج': 'Dodge',
      'فاو': 'Faw',
      'فيراري': 'Ferrari',
      'فيات': 'Fiat',
      'فورد': 'Ford',
      'جي إيه سي': 'GAC',
      'جي إم سي': 'GMC',
      'جيلي': 'Geely',
      'جريت وول': 'Great Wall',
      'هافال': 'Haval',
      'هوندا': 'Honda',
      'هامر': 'Hummer',
      'هيونداي': 'Hyundai',
      'إنفينيتي': 'Infiniti',
      'إيسوزو': 'Isuzu',
      'جاك': 'Jac',
      'جاكوار': 'Jaguar',
      'جيتور': 'Jetour',
      'جيب': 'Jeep',
      'كيا': 'Kia',
      'كينغ لونغ': 'King Long',
      'لادا': 'Lada',
      'لامبورغيني': 'Lamborghini',
      'لاند روفر': 'Land Rover',
      'لكزس': 'Lexus',
      'ليفان': 'Lifan',
      'لينكون': 'Lincoln',
      'لوتس': 'Lotus',
      'إم جي': 'MG',
      'ميني': 'MINI',
      'مازيراتي': 'Maserati',
      'مازدا': 'Mazda',
      'مكلارين': 'McLaren',
      'مرسيدس بنز': 'Mercedes-Benz',
      'ميتسوبيشي': 'Mitsubishi',
      'نيسان': 'Nissan',
      'أوبل': 'Opel',
      'بيجو': 'Peugeot',
      'بورش': 'Porsche',
      'بروتون': 'Proton',
      'رينو': 'Renault',
      'رولز رويس': 'Rolls Royce',
      'سينوفا': 'Senova',
      'سكودا': 'Skoda',
      'سوايست': 'Soueast',
      'سبيرانزا': 'Speranza',
      'سانج يونغ': 'Ssang Yong',
      'سوبارو': 'Subaru',
      'سوزوكي': 'Suzuki',
      'سيات': 'seat',
      'تيسلا': 'Tesla',
      'تويوتا': 'Toyota',
      'فولكس فاجن': 'Volkswagen',
      'فولفو': 'Volvo',
      'إكس بينغ': 'XPeng',
      'شاومي': 'Xiaomi',
      'زيكر': 'Zeekr',
      'زوتي': 'Zotye',
      "صنع آخر": 'Other Make'
    };

    // Convert Arabic to English if needed
    String englishBrandName = arabicToEnglish[brandName] ?? brandName;

    // Convert brand name to lowercase and remove spaces/hyphens for file naming
    String normalizedName = englishBrandName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');

    return 'assets/icons/car_brands/$normalizedName.svg';
  }
  // +++ END: Helper function

  Widget carsForRentWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.rentalCarTerm,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.hourly,
                  StringHelper.daily,
                  StringHelper.weekly,
                  StringHelper.monthly,
                  StringHelper.yearly
                ].map((term) {
                  // Parse selected terms from the controller
                  List<String> selectedTerms =
                      viewModel.carRentalTermController.text.isEmpty
                          ? []
                          : viewModel.carRentalTermController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedTerms.contains(term);

                  return GestureDetector(
                    onTap: () {
                      if (isSelected) {
                        // Remove if already selected
                        selectedTerms.remove(term);
                      } else {
                        // Add if not selected
                        selectedTerms.add(term);
                      }
                      // Update the controller with comma-separated values
                      viewModel.carRentalTermController.text =
                          selectedTerms.join(',');
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        term,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.black : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.fuel,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: fuelsType.map((fuel) {
                  // Parse selected fuels from the controller
                  List<String> selectedFuels =
                      viewModel.fuelTextController.text.isEmpty
                          ? []
                          : viewModel.fuelTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedFuels.contains(fuel);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // Remove if already selected
                          selectedFuels.remove(fuel);
                        } else {
                          // Add if not selected
                          selectedFuels.add(fuel);
                        }
                        // Update the controller with comma-separated values
                        viewModel.fuelTextController.text =
                            selectedFuels.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      width: 130,
                      height: 110,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            _getFuelSvgPath(fuel),
                            width: 48,
                            height: 48,
                            colorFilter: ColorFilter.mode(
                              isSelected ? Colors.black : Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              fuel,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.transmission,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children:
                  [StringHelper.all, ...transmissionType].map((transmission) {
                // Check if "All" is selected (empty controller means all)
                bool isAllSelected =
                    viewModel.transmissionTextController.text.isEmpty;

                if (transmission == StringHelper.all) {
                  // Handle "All" option
                  bool isSelected = isAllSelected;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Clear the controller to represent "All"
                        viewModel.transmissionTextController.clear();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        transmission,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.black : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                } else {
                  // Handle Manual and Automatic options
                  List<String> selectedTransmissions = isAllSelected
                      ? []
                      : viewModel.transmissionTextController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList();

                  bool isSelected =
                      selectedTransmissions.contains(transmission);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTransmissions.remove(transmission);
                        } else {
                          selectedTransmissions.add(transmission);
                        }

                        // Update the controller
                        if (selectedTransmissions.isEmpty) {
                          viewModel.transmissionTextController
                              .clear(); // Back to "All"
                        } else {
                          viewModel.transmissionTextController.text =
                              selectedTransmissions.join(',');
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        transmission,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color:
                              isSelected ? Colors.black : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  );
                }
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget trucksWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringHelper.year, style: context.textTheme.titleSmall),
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
                  controller: viewModel.minYearTextController,
                  cursorColor: Colors.black,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minYear,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                  onChanged: (value) {
                    filter.minYear = value;
                  },
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
                  controller: viewModel.maxYearTextController,
                  cursorColor: Colors.black,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxArea,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                  onChanged: (value) {
                    filter.maxYear = value;
                  },
                ),
              ),
            ),
          ],
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
        const SizedBox(height: 10),
      ],
    );
  }

  Widget motorcyclesWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringHelper.year, style: context.textTheme.titleSmall),
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
                  controller: viewModel.minYearTextController,
                  cursorColor: Colors.black,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minYear,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                  onChanged: (value) {
                    filter.minYear = value;
                  },
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
                  controller: viewModel.maxYearTextController,
                  cursorColor: Colors.black,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxYear,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffEFEFEF)),
                    ),
                  ),
                  onChanged: (value) {
                    filter.maxYear = value;
                  },
                ),
              ),
            ),
          ],
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
        const SizedBox(height: 10),
      ],
    );
  }

  Widget apartmentWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Type Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.propertyType,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [StringHelper.sell, StringHelper.rent].map((status) {
                // Get the normalized English value for comparison
                var normalizedValue = Utils.setProperty(status);

                // Check if this option is selected by comparing with the stored English value
                bool isSelected = viewModel.propertyForTextController.text ==
                        normalizedValue ||
                    viewModel.currentPropertyType == normalizedValue ||
                    filter.propertyFor == normalizedValue;

                return GestureDetector(
                  onTap: () {
                    // Update all three values with the English normalized value
                    viewModel.propertyForTextController.text = normalizedValue;
                    filter.propertyFor = normalizedValue;
                    viewModel.currentPropertyType = normalizedValue;

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      status, // Display the localized text
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Type Section with Icons
        // Type Section with Icons - MULTI-SELECT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.type,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.apartment,
                  StringHelper.duplex,
                  StringHelper.penthouse,
                  StringHelper.hotelApartment,
                  StringHelper.roof,
                ].map((propertyType) {
                  // Parse selected types from the controller
                  List<String> selectedTypes =
                      viewModel.propertyForTypeTextController.text.isEmpty
                          ? []
                          : viewModel.propertyForTypeTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedTypes.contains(propertyType);

                  // Map property types to icons
                  IconData iconData = _getPropertyTypeIcon(propertyType);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTypes.remove(propertyType);
                        } else {
                          selectedTypes.add(propertyType);
                        }
                        viewModel.propertyForTypeTextController.text =
                            selectedTypes.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      width: 98,
                      height: 95,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            size: 30,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              propertyType,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: _getTextSize(context),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Ownership Status (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              ownershipStatusWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Deposit for Rent
        if (viewModel.currentPropertyType.toLowerCase() == "rent") ...[
          Text(
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
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.minPrice,
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
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                    maxLength: 9,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.endDownPriceTextController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxPrice,
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
          const Gap(16),
        ],

        // Area Size
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minArea,
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
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(width: 5),
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxArea,
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
        const Gap(16),

        // Number of Bedrooms with modern design
        // Number of Bedrooms with modern design and multi-select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.bedrooms,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.studio,
                  "1",
                  "2",
                  "3",
                  "4",
                  "5",
                  "6",
                  "7",
                  "8",
                  "9",
                  "10",
                  "10+"
                ].map((option) {
                  // Parse selected bedrooms from the controller
                  List<String> selectedBedrooms =
                      viewModel.noOfBedroomsTextController.text.isEmpty
                          ? []
                          : viewModel.noOfBedroomsTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedBedrooms.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBedrooms.remove(option);
                        } else {
                          selectedBedrooms.add(option);
                        }
                        viewModel.noOfBedroomsTextController.text =
                            selectedBedrooms.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.black, // Black text always
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Number of Bathrooms with modern design
        // Number of Bathrooms with modern design and multi-select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.bathrooms,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['1', '2', '3', '4', '5', '6', '7', '8', "8+"]
                    .map((option) {
                  // Parse selected bathrooms from the controller
                  List<String> selectedBathrooms =
                      viewModel.noOfBathroomsTextController.text.isEmpty
                          ? []
                          : viewModel.noOfBathroomsTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedBathrooms.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBathrooms.remove(option);
                        } else {
                          selectedBathrooms.add(option);
                        }
                        viewModel.noOfBathroomsTextController.text =
                            selectedBathrooms.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.black, // Black text always
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Furnished Widget
        villaFurnishedWidget(context, viewModel),
        const SizedBox(height: 16),

        // Level
        // Replace the existing Level CommonDropdown with this code:

// Level Multi-Select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.level,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
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
                  StringHelper.lastFloor
                ].map((level) {
                  // Parse selected levels from the controller
                  List<String> selectedLevels =
                      viewModel.levelTextController.text.isEmpty
                          ? []
                          : viewModel.levelTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedLevels.contains(level);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedLevels.remove(level);
                        } else {
                          selectedLevels.add(level);
                        }
                        viewModel.levelTextController.text =
                            selectedLevels.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Completion Status (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              completionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Payment Option (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: paymentOptionWidget(context, viewModel),
        ),
        const Gap(15),
      ],
    );
  }

  Widget vacationWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Type Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.propertyType,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [StringHelper.sell, StringHelper.rent].map((status) {
                // Get the normalized English value for comparison
                var normalizedValue = Utils.setProperty(status);

                // Check if this option is selected by comparing with the stored English value
                bool isSelected = viewModel.propertyForTextController.text ==
                        normalizedValue ||
                    viewModel.currentPropertyType == normalizedValue ||
                    filter.propertyFor == normalizedValue;

                return GestureDetector(
                  onTap: () {
                    // Update all three values with the English normalized value
                    viewModel.propertyForTextController.text = normalizedValue;
                    filter.propertyFor = normalizedValue;
                    viewModel.currentPropertyType = normalizedValue;

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      status, // Display the localized text
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Type Selection with Icons - BIGGER CARDS
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.type,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.chalet,
                  StringHelper.duplex,
                  StringHelper.penthouse,
                  StringHelper.standaloneVilla,
                  StringHelper.townhouse,
                  StringHelper.cabin,
                ].map((vacationType) {
                  // Parse selected types from the controller
                  List<String> selectedTypes =
                      viewModel.propertyForTypeTextController.text.isEmpty
                          ? []
                          : viewModel.propertyForTypeTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedTypes.contains(vacationType);

                  // Map vacation types to icons
                  IconData iconData = _getPropertyTypeIcon(vacationType);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTypes.remove(vacationType);
                        } else {
                          selectedTypes.add(vacationType);
                        }
                        viewModel.propertyForTypeTextController.text =
                            selectedTypes.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      width: 110, // Increased from 98 to 120
                      height: 100, // Increased from 95 to 100
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            size: 30,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              vacationType,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: _getTextSize(context),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Ownership Status (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              ownershipStatusWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Deposit for Rent
        if (viewModel.currentPropertyType.toLowerCase() == "rent") ...[
          Text(
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
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.minPrice,
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
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(width: 5),
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
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxPrice,
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
          const Gap(16),
        ],

        // Area Size
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minArea,
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
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(width: 5),
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxArea,
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
        const Gap(16),

        // Number of Bedrooms with modern design and multi-select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.bedrooms,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.studio, // Studio IS included for vacation homes
                  "1",
                  "2",
                  "3",
                  "4",
                  "5",
                  "6",
                  "7",
                  "8",
                  "9",
                  "10",
                  "10+"
                ].map((option) {
                  // Parse selected bedrooms from the controller
                  List<String> selectedBedrooms =
                      viewModel.noOfBedroomsTextController.text.isEmpty
                          ? []
                          : viewModel.noOfBedroomsTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedBedrooms.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBedrooms.remove(option);
                        } else {
                          selectedBedrooms.add(option);
                        }
                        viewModel.noOfBedroomsTextController.text =
                            selectedBedrooms.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.black, // Black text always
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Number of Bathrooms with modern design and multi-select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.bathrooms,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['1', '2', '3', '4', '5', '6', '7', '8', "8+"]
                    .map((option) {
                  // Parse selected bathrooms from the controller
                  List<String> selectedBathrooms =
                      viewModel.noOfBathroomsTextController.text.isEmpty
                          ? []
                          : viewModel.noOfBathroomsTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedBathrooms.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBathrooms.remove(option);
                        } else {
                          selectedBathrooms.add(option);
                        }
                        viewModel.noOfBathroomsTextController.text =
                            selectedBathrooms.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.black, // Black text always
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Furnished Widget
        villaFurnishedWidget(context, viewModel),
        const SizedBox(height: 16),

        // Level Multi-Select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.level,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
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
                  StringHelper.lastFloor
                ].map((level) {
                  // Parse selected levels from the controller
                  List<String> selectedLevels =
                      viewModel.levelTextController.text.isEmpty
                          ? []
                          : viewModel.levelTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedLevels.contains(level);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedLevels.remove(level);
                        } else {
                          selectedLevels.add(level);
                        }
                        viewModel.levelTextController.text =
                            selectedLevels.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        level,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Completion Status (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              completionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Payment Option (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              paymentOptionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Gap(15),
        // Delivery Terms (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StringHelper.deliveryTerms,
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StringHelper.all,
                      StringHelper.moveInReady,
                      StringHelper.underConstruction,
                      StringHelper.shellAndCore,
                      StringHelper.semiFurnished
                    ].map((deliveryTerm) {
                      // Check if "All" is selected (empty controller means all)
                      bool isAllSelected =
                          viewModel.deliveryTermTextController.text.isEmpty;

                      if (deliveryTerm == StringHelper.all) {
                        // Handle "All" option
                        bool isSelected = isAllSelected;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // Clear the controller to represent "All"
                              viewModel.deliveryTermTextController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                            child: Text(
                              deliveryTerm,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Handle other delivery term options
                        List<String> selectedDeliveryTerms = isAllSelected
                            ? []
                            : viewModel.deliveryTermTextController.text
                                .split(',')
                                .map((e) => e.trim())
                                .toList();
                        bool isSelected =
                            selectedDeliveryTerms.contains(deliveryTerm);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedDeliveryTerms.remove(deliveryTerm);
                              } else {
                                selectedDeliveryTerms.add(deliveryTerm);
                              }

                              // Update the controller
                              if (selectedDeliveryTerms.isEmpty) {
                                viewModel.deliveryTermTextController
                                    .clear(); // Back to "All"
                              } else {
                                viewModel.deliveryTermTextController.text =
                                    selectedDeliveryTerms.join(',');
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                            child: Text(
                              deliveryTerm,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Rental Term (only for rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringHelper.rentalTerm,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StringHelper.all,
                  StringHelper.daily,
                  StringHelper.weekly,
                  StringHelper.monthly,
                  StringHelper.yearly
                ].map((term) {
                  // Check if "All" is selected (empty controller means all)
                  bool isAllSelected =
                      viewModel.rentalTermsTextController.text.isEmpty;

                  if (term == StringHelper.all) {
                    // Handle "All" option
                    bool isSelected = isAllSelected;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Clear the controller to represent "All"
                          viewModel.rentalTermsTextController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Handle other options (Daily, Weekly, Monthly, Yearly)
                    List<String> selectedTerms = isAllSelected
                        ? []
                        : viewModel.rentalTermsTextController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList();
                    bool isSelected = selectedTerms.contains(term);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTerms.remove(term);
                          } else {
                            selectedTerms.add(term);
                          }

                          // Update the controller
                          if (selectedTerms.isEmpty) {
                            viewModel.rentalTermsTextController
                                .clear(); // Back to "All"
                          } else {
                            viewModel.rentalTermsTextController.text =
                                selectedTerms.join(',');
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget villaWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Type Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.propertyType,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [StringHelper.sell, StringHelper.rent].map((status) {
                // Get the normalized English value for comparison
                var normalizedValue = Utils.setProperty(status);

                // Check if this option is selected by comparing with the stored English value
                bool isSelected = viewModel.propertyForTextController.text ==
                        normalizedValue ||
                    viewModel.currentPropertyType == normalizedValue ||
                    filter.propertyFor == normalizedValue;

                return GestureDetector(
                  onTap: () {
                    // Update all three values with the English normalized value
                    viewModel.propertyForTextController.text = normalizedValue;
                    filter.propertyFor = normalizedValue;
                    viewModel.currentPropertyType = normalizedValue;

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      status, // Display the localized text
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Type Section with Icons
        // Type Section with Icons - MULTI-SELECT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.type,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.standaloneVilla,
                  StringHelper.townHouseText,
                  StringHelper.twinHouse,
                  StringHelper.iVilla,
                  StringHelper.mansion,
                ].map((villaType) {
                  // Parse selected types from the controller
                  List<String> selectedTypes =
                      viewModel.propertyForTypeTextController.text.isEmpty
                          ? []
                          : viewModel.propertyForTypeTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedTypes.contains(villaType);

                  // Map villa types to icons
                  IconData iconData = _getPropertyTypeIcon(villaType);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTypes.remove(villaType);
                        } else {
                          selectedTypes.add(villaType);
                        }
                        viewModel.propertyForTypeTextController.text =
                            selectedTypes.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      width: 98,
                      height: 95,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            size: 30,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              villaType,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: _getTextSize(context),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Deposit for Rent
        if (viewModel.currentPropertyType.toLowerCase() == "rent") ...[
          Text(
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
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.minPrice,
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
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(width: 5),
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
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxPrice,
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
          const Gap(16),
        ],

        // Area Size
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minArea,
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
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(width: 5),
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxArea,
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
        const Gap(16),

        // Number of Bedrooms with modern design
        // Number of Bedrooms with modern design and multi-select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.bedrooms,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // NO Studio for villas
                  "1",
                  "2",
                  "3",
                  "4",
                  "5",
                  "6",
                  "7",
                  "8",
                  "9",
                  "10",
                  "10+"
                ].map((option) {
                  // Parse selected bedrooms from the controller
                  List<String> selectedBedrooms =
                      viewModel.noOfBedroomsTextController.text.isEmpty
                          ? []
                          : viewModel.noOfBedroomsTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedBedrooms.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBedrooms.remove(option);
                        } else {
                          selectedBedrooms.add(option);
                        }
                        viewModel.noOfBedroomsTextController.text =
                            selectedBedrooms.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.black, // Black text always
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Number of Bathrooms with modern design
        // Number of Bathrooms with modern design and multi-select
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.bathrooms,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['1', '2', '3', '4', '5', '6', '7', '8', "8+"]
                    .map((option) {
                  // Parse selected bathrooms from the controller
                  List<String> selectedBathrooms =
                      viewModel.noOfBathroomsTextController.text.isEmpty
                          ? []
                          : viewModel.noOfBathroomsTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                  bool isSelected = selectedBathrooms.contains(option);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBathrooms.remove(option);
                        } else {
                          selectedBathrooms.add(option);
                        }
                        viewModel.noOfBathroomsTextController.text =
                            selectedBathrooms.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.black
                              : Colors.black, // Black text always
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Furnished Widget
        villaFurnishedWidget(context, viewModel),
        const SizedBox(height: 16),

        // Completion Status (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              completionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Payment Option (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              paymentOptionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Delivery Terms (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StringHelper.deliveryTerms,
                    style: context.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StringHelper.all,
                      StringHelper.moveInReady,
                      StringHelper.underConstruction,
                      StringHelper.shellAndCore,
                      StringHelper
                          .semiFurnished // or StringHelper.semiFinished depending on your strings
                    ].map((deliveryTerm) {
                      // Check if "All" is selected (empty controller means all)
                      bool isAllSelected =
                          viewModel.deliveryTermTextController.text.isEmpty;

                      if (deliveryTerm == StringHelper.all) {
                        // Handle "All" option
                        bool isSelected = isAllSelected;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // Clear the controller to represent "All"
                              viewModel.deliveryTermTextController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                            child: Text(
                              deliveryTerm,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Handle other delivery term options
                        List<String> selectedDeliveryTerms = isAllSelected
                            ? []
                            : viewModel.deliveryTermTextController.text
                                .split(',')
                                .map((e) => e.trim())
                                .toList();
                        bool isSelected =
                            selectedDeliveryTerms.contains(deliveryTerm);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedDeliveryTerms.remove(deliveryTerm);
                              } else {
                                selectedDeliveryTerms.add(deliveryTerm);
                              }

                              // Update the controller
                              if (selectedDeliveryTerms.isEmpty) {
                                viewModel.deliveryTermTextController
                                    .clear(); // Back to "All"
                              } else {
                                viewModel.deliveryTermTextController.text =
                                    selectedDeliveryTerms.join(',');
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey,
                              ),
                            ),
                            child: Text(
                              deliveryTerm,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Rental Term (only for rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringHelper.rentalTerm,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StringHelper.all,
                  StringHelper.daily,
                  StringHelper.weekly,
                  StringHelper.monthly,
                  StringHelper.yearly
                ].map((term) {
                  // Check if "All" is selected (empty controller means all)
                  bool isAllSelected =
                      viewModel.rentalTermsTextController.text.isEmpty;

                  if (term == StringHelper.all) {
                    // Handle "All" option
                    bool isSelected = isAllSelected;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Clear the controller to represent "All"
                          viewModel.rentalTermsTextController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Handle other options (Daily, Weekly, Monthly, Yearly)
                    List<String> selectedTerms = isAllSelected
                        ? []
                        : viewModel.rentalTermsTextController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList();
                    bool isSelected = selectedTerms.contains(term);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTerms.remove(term);
                          } else {
                            selectedTerms.add(term);
                          }

                          // Update the controller
                          if (selectedTerms.isEmpty) {
                            viewModel.rentalTermsTextController
                                .clear(); // Back to "All"
                          } else {
                            viewModel.rentalTermsTextController.text =
                                selectedTerms.join(',');
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget businessWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.propertyType,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [StringHelper.sell, StringHelper.rent].map((status) {
                // Get the normalized English value for comparison
                var normalizedValue = Utils.setProperty(status);

                // Check if this option is selected by comparing with the stored English value
                bool isSelected = viewModel.propertyForTextController.text ==
                        normalizedValue ||
                    viewModel.currentPropertyType == normalizedValue ||
                    filter.propertyFor == normalizedValue;

                return GestureDetector(
                  onTap: () {
                    // Update all three values with the English normalized value
                    viewModel.propertyForTextController.text = normalizedValue;
                    filter.propertyFor = normalizedValue;
                    viewModel.currentPropertyType = normalizedValue;

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      status, // Display the localized text
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Updated Type Selection with Modern Icons (matching the form)
        // Updated Type Selection with Modern Icons (matching the form) - MULTI-SELECT
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.type,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.factory,
                  StringHelper.fullBuilding,
                  StringHelper.garage,
                  StringHelper.warehouse,
                  StringHelper.restaurantCafe,
                  StringHelper.offices,
                  StringHelper.medicalFacility,
                  StringHelper.showroom,
                  StringHelper.hotelMotel,
                  StringHelper.gasStation,
                  StringHelper.storageFacility,
                  StringHelper.other,
                ].map((businessType) {
                  // Parse selected types from the controller
                  List<String> selectedTypes =
                      viewModel.propertyForTypeTextController.text.isEmpty
                          ? []
                          : viewModel.propertyForTypeTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedTypes.contains(businessType);

                  // Map business types to icons
                  IconData iconData = _getBusinessTypeIcon(businessType);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTypes.remove(businessType);
                        } else {
                          selectedTypes.add(businessType);
                        }
                        viewModel.propertyForTypeTextController.text =
                            selectedTypes.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      width: 110, // Slightly wider for business names
                      height: 95,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            size: 28,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 6),
                          Flexible(
                            child: Text(
                              businessType,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Area Size
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.minArea,
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
            Text(
              StringHelper.to,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(width: 5),
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
                  decoration: InputDecoration(
                    counterText: "",
                    fillColor: const Color(0xffFCFCFD),
                    hintText: StringHelper.maxArea,
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
        const Gap(16),

        // Furnished Widget (using the modern design)
        villaFurnishedWidget(context, viewModel),
        const SizedBox(height: 16),

        // Ownership Status (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              completionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Payment Option (only for non-rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() != "rent",
          child: Column(
            children: [
              paymentOptionWidget(context, viewModel),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Deposit for Rent
        if (viewModel.currentPropertyType.toLowerCase() == "rent") ...[
          Text(
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
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.minPrice,
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
              Text(
                StringHelper.to,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  width: context.width,
                  height: 50,
                  child: TextFormField(
                    maxLength: 9,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: viewModel.endDownPriceTextController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: const Color(0xffFCFCFD),
                      hintText: StringHelper.maxPrice,
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
          const Gap(16),
        ],

        // Rental Term (only for rent)
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringHelper.rentalTerm,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StringHelper.all,
                  StringHelper.daily,
                  StringHelper.weekly,
                  StringHelper.monthly,
                  StringHelper.yearly
                ].map((term) {
                  // Check if "All" is selected (empty controller means all)
                  bool isAllSelected =
                      viewModel.rentalTermsTextController.text.isEmpty;

                  if (term == StringHelper.all) {
                    // Handle "All" option
                    bool isSelected = isAllSelected;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Clear the controller to represent "All"
                          viewModel.rentalTermsTextController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Handle other options (Daily, Weekly, Monthly, Yearly)
                    List<String> selectedTerms = isAllSelected
                        ? []
                        : viewModel.rentalTermsTextController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList();
                    bool isSelected = selectedTerms.contains(term);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTerms.remove(term);
                          } else {
                            selectedTerms.add(term);
                          }

                          // Update the controller
                          if (selectedTerms.isEmpty) {
                            viewModel.rentalTermsTextController
                                .clear(); // Back to "All"
                          } else {
                            viewModel.rentalTermsTextController.text =
                                selectedTerms.join(',');
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget landWidget(HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.propertyType,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [StringHelper.sell, StringHelper.rent].map((status) {
                // Get the normalized English value for comparison
                var normalizedValue = Utils.setProperty(status);

                // Check if this option is selected by comparing with the stored English value
                bool isSelected = viewModel.propertyForTextController.text ==
                        normalizedValue ||
                    viewModel.currentPropertyType == normalizedValue ||
                    filter.propertyFor == normalizedValue;

                return GestureDetector(
                  onTap: () {
                    // Update all three values with the English normalized value
                    viewModel.propertyForTextController.text = normalizedValue;
                    filter.propertyFor = normalizedValue;
                    viewModel.currentPropertyType = normalizedValue;

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.black.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      status, // Display the localized text
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // UPDATED: Multi-select Type for Land with horizontal cards (same as apartment/villa)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringHelper.type,
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  StringHelper.agriculturalLand,
                  StringHelper.commercialLand,
                  StringHelper.residentialLand,
                  StringHelper.industrialLand,
                  StringHelper.mixedLand,
                  StringHelper.farmLand,
                ].map((landType) {
                  // Parse selected types from the controller
                  List<String> selectedTypes =
                      viewModel.propertyForTypeTextController.text.isEmpty
                          ? []
                          : viewModel.propertyForTypeTextController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();

                  bool isSelected = selectedTypes.contains(landType);

                  // Map land types to icons (same as the form)
                  IconData iconData = _getLandTypeIcon(landType);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTypes.remove(landType);
                        } else {
                          selectedTypes.add(landType);
                        }
                        viewModel.propertyForTypeTextController.text =
                            selectedTypes.join(',');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      width: 110, // Increased width for longer land type names
                      height: 95,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData,
                            size: 30,
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              landType,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize:
                                    _getTextSize(context), // Use custom method
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey.shade700,
                                height: 1.1, // Tighter line height
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
        Gap(10),
        accessToUtilitiesSelector(context, viewModel),
        Visibility(
          visible: viewModel.currentPropertyType.toLowerCase() == "rent",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringHelper.rentalTerm,
                style: context.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StringHelper.all,
                  StringHelper.daily,
                  StringHelper.weekly,
                  StringHelper.monthly,
                  StringHelper.yearly
                ].map((term) {
                  // Check if "All" is selected (empty controller means all)
                  bool isAllSelected =
                      viewModel.rentalTermsTextController.text.isEmpty;

                  if (term == StringHelper.all) {
                    // Handle "All" option
                    bool isSelected = isAllSelected;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Clear the controller to represent "All"
                          viewModel.rentalTermsTextController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Handle other options (Daily, Weekly, Monthly, Yearly)
                    List<String> selectedTerms = isAllSelected
                        ? []
                        : viewModel.rentalTermsTextController.text
                            .split(',')
                            .map((e) => e.trim())
                            .toList();
                    bool isSelected = selectedTerms.contains(term);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTerms.remove(term);
                          } else {
                            selectedTerms.add(term);
                          }

                          // Update the controller
                          if (selectedTerms.isEmpty) {
                            viewModel.rentalTermsTextController
                                .clear(); // Back to "All"
                          } else {
                            viewModel.rentalTermsTextController.text =
                                selectedTerms.join(',');
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.black.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        child: Text(
                          term,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getTextSize(BuildContext context) {
    // Check multiple ways to detect Arabic
    final locale = Localizations.localeOf(context);
    final direction = Directionality.of(context);

    // Check if locale is Arabic or direction is RTL
    if (locale.languageCode == 'ar' || direction == TextDirection.RTL) {
      return 13.0; // Bigger for Arabic
    }
    return 12.0; // Smaller for English
  }

  Widget accessToUtilitiesSelector(BuildContext context, HomeVM viewModel) {
    final Map<String, IconData> utilityIcons = {
      StringHelper.waterSupply: Icons.water_drop_outlined,
      StringHelper.electricity: Icons.electric_bolt_outlined,
      StringHelper.gas: Icons.local_fire_department_outlined,
      StringHelper.sewageSystem: Icons.plumbing_outlined,
      StringHelper.roadAccess: Icons.route_outlined,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringHelper.accessToUtilities,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        StatefulBuilder(
          builder: (context, setState) {
            // Parse existing utilities from the controller
            List<String> currentUtilities =
                viewModel.accessToUtilitiesTextController.text.isEmpty
                    ? []
                    : viewModel.accessToUtilitiesTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

            return Column(
              children: utilityIcons.keys.map((utility) {
                bool isSelected = currentUtilities.contains(utility);

                return ListTile(
                  leading: Icon(
                    utilityIcons[utility],
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(utility),
                  trailing: Checkbox(
                    value: isSelected,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!currentUtilities.contains(utility)) {
                            currentUtilities.add(utility);
                          }
                        } else {
                          currentUtilities.remove(utility);
                        }

                        // Update the controller with formatted string
                        viewModel.accessToUtilitiesTextController.text =
                            currentUtilities.join(', ');

                        // This is critical: update the filter.accessToUtilities value
                        // with backend-compatible values
                        selectedUtilities = currentUtilities;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      if (currentUtilities.contains(utility)) {
                        currentUtilities.remove(utility);
                      } else {
                        currentUtilities.add(utility);
                      }

                      viewModel.accessToUtilitiesTextController.text =
                          currentUtilities.join(', ');

                      selectedUtilities = currentUtilities;
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget furnishedWidget(BuildContext context, HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.furnishing,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            StringHelper.furnished,
            StringHelper.unfurnished,
            StringHelper.semiFurnished
          ].map((status) {
            bool isSelected =
                viewModel.furnishingStatusTextController.text == status;
            return GestureDetector(
              onTap: () {
                setState(() {
                  viewModel.furnishingStatusTextController.text = status;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color.fromARGB(255, 59, 130, 246)
                        : Colors.grey,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget villaFurnishedWidget(BuildContext context, HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.furnishing,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [StringHelper.all, StringHelper.yes, StringHelper.no]
              .map((option) {
            bool isSelected =
                viewModel.furnishingStatusTextController.text == option ||
                    (viewModel.furnishingStatusTextController.text.isEmpty &&
                        option == StringHelper.all);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (option == StringHelper.all) {
                    viewModel.furnishingStatusTextController.clear();
                  } else {
                    viewModel.furnishingStatusTextController.text = option;
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget completionWidget(BuildContext context, HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.completionStatus,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [StringHelper.all, StringHelper.ready, StringHelper.offPlan]
              .map((option) {
            bool isSelected =
                viewModel.completionStatusTextController.text == option ||
                    (viewModel.completionStatusTextController.text.isEmpty &&
                        option == StringHelper.all);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (option == StringHelper.all) {
                    viewModel.completionStatusTextController.clear();
                  } else {
                    viewModel.completionStatusTextController.text = option;
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget paymentOptionWidget(BuildContext context, HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.paymentType,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StringHelper.installment,
            StringHelper.cashOrInstallment,
            StringHelper.cash
          ].map((status) {
            // Parse selected payment types from the controller
            List<String> selectedPaymentTypes =
                viewModel.paymentTypeTextController.text.isEmpty
                    ? []
                    : viewModel.paymentTypeTextController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList();
            bool isSelected = selectedPaymentTypes.contains(status);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedPaymentTypes.remove(status);
                  } else {
                    selectedPaymentTypes.add(status);
                  }
                  viewModel.paymentTypeTextController.text =
                      selectedPaymentTypes.join(',');
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : Colors.black, // Keep black text for consistency
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget ownershipStatusWidget(BuildContext context, HomeVM viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StringHelper.owner,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            StringHelper.all,
            StringHelper.primary,
            StringHelper.resell
          ].map((option) {
            bool isSelected =
                viewModel.ownershipStatusTextController.text == option ||
                    (viewModel.ownershipStatusTextController.text.isEmpty &&
                        option == StringHelper.all);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (option == StringHelper.all) {
                    viewModel.ownershipStatusTextController.clear();
                    filter.ownership = null;
                  } else {
                    viewModel.ownershipStatusTextController.text = option;
                    filter.ownership = Utils.setCommon(option);
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPropertyTypeOption(
    BuildContext context,
    String propertyType,
    IconData iconData,
    HomeVM viewModel,
  ) {
    bool isSelected =
        viewModel.propertyForTypeTextController.text == propertyType;

    return GestureDetector(
      onTap: () {
        viewModel.propertyForTypeTextController.text = propertyType;
        filter.type = Utils.setProperty(propertyType);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        width: 98,
        height: 95,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 59, 130, 246).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 59, 130, 246)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 30,
              color: isSelected
                  ? const Color.fromARGB(255, 59, 130, 246)
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                propertyType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: _getTextSize(context),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.grey.shade700,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVillaTypeOption(
    BuildContext context,
    String propertyType,
    IconData iconData,
    HomeVM viewModel,
  ) {
    bool isSelected =
        viewModel.propertyForTypeTextController.text == propertyType;

    return GestureDetector(
      onTap: () {
        viewModel.propertyForTypeTextController.text = propertyType;
        filter.type = Utils.setProperty(propertyType);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        width: 98,
        height: 95,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 59, 130, 246).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 59, 130, 246)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 30,
              color: isSelected
                  ? const Color.fromARGB(255, 59, 130, 246)
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                propertyType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.grey.shade700,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVacationTypeOption(
    BuildContext context,
    String propertyType,
    IconData iconData,
    HomeVM viewModel,
  ) {
    bool isSelected =
        viewModel.propertyForTypeTextController.text == propertyType;

    return GestureDetector(
      onTap: () {
        viewModel.propertyForTypeTextController.text = propertyType;
        filter.type = Utils.setProperty(propertyType);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        width: 98,
        height: 95,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 59, 130, 246).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 59, 130, 246)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 30,
              color: isSelected
                  ? const Color.fromARGB(255, 59, 130, 246)
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                propertyType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.grey.shade700,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessTypeOption(
    BuildContext context,
    String businessType,
    IconData iconData,
    HomeVM viewModel,
  ) {
    bool isSelected =
        viewModel.propertyForTypeTextController.text == businessType;

    return GestureDetector(
      onTap: () {
        viewModel.propertyForTypeTextController.text = businessType;
        filter.type = Utils.setProperty(businessType);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        width: 110, // Slightly wider for business names
        height: 95,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 59, 130, 246).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 59, 130, 246)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 28,
              color: isSelected
                  ? const Color.fromARGB(255, 59, 130, 246)
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                businessType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color.fromARGB(255, 59, 130, 246)
                      : Colors.grey.shade700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyTypeOptionForFilter(
    BuildContext context,
    String bodyType,
    String svgAssetPath,
    HomeVM viewModel,
  ) {
    bool isSelected = viewModel.bodyTypeTextController.text == bodyType;

    return GestureDetector(
      onTap: () {
        viewModel.bodyTypeTextController.text = bodyType;
        filter.bodyType = bodyType; // Update FilterModel
        setState(() {}); // Refresh UI
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        width: 130,
        height: 110,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAssetPath,
              width: 48,
              height: 48,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                bodyType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBodyTypeSvgPath(String bodyType) {
    String normalizedBodyType = Utils.setBodyType(bodyType).toLowerCase();
    switch (normalizedBodyType) {
      case 'suv':
        return 'assets/icons/body_types/suv.svg';
      case 'hatchback':
        return 'assets/icons/body_types/hatchback.svg';
      case '4x4':
        return 'assets/icons/body_types/4x4.svg';
      case 'sedan':
        return 'assets/icons/body_types/sedan.svg';
      case 'coupe':
        return 'assets/icons/body_types/coupe.svg';
      case 'convertible':
        return 'assets/icons/body_types/convertible.svg';
      case 'estate':
        return 'assets/icons/body_types/estate.svg';
      case 'mpv':
        return 'assets/icons/body_types/mpv.svg';
      case 'pickup':
        return 'assets/icons/body_types/pickup.svg';
      case 'crossover':
        return 'assets/icons/body_types/crossover.svg';
      case 'van/bus':
        return 'assets/icons/body_types/van_bus.svg';
      case 'other':
        return 'assets/icons/body_types/other.svg';
      default:
        return 'assets/icons/body_types/sedan.svg';
    }
  }

  IconData _getPropertyTypeIcon(String propertyType) {
    // Normalize to English for consistent matching
    String normalizedType = Utils.setProperty(propertyType).toLowerCase();

    // Debug print to see what we're getting
    print("Property type: $propertyType -> Normalized: $normalizedType");

    switch (normalizedType) {
      case 'apartment':
        return Icons.apartment;
      case 'duplex':
        return Icons.home_work;
      case 'penthouse':
        return Icons.location_city;
      case 'hotel apartment': // Without underscore
      case 'hotel_apartment': // With underscore
        return Icons.hotel;
      case 'roof':
        return Icons.roofing;
      case 'standalone villa': // Without underscore
      case 'standalone_villa': // With underscore
        return Icons.house;
      case 'townhouse':
      case 'town house': // With space
        return Icons.location_city;
      case 'twin house': // Without underscore
      case 'twin_house': // With underscore
        return Icons.home_work;
      case 'i-villa': // With hyphen
      case 'i villa': // With space
      case 'i_villa': // With underscore
        return Icons.villa;
      case 'mansion':
        return Icons.castle;
      case 'chalet':
        return Icons.cabin;
      case 'studio':
        return Icons.weekend;
      case 'cabin':
        return Icons.cottage;
      default:
        return Icons.home;
    }
  }

  IconData _getBusinessTypeIcon(String businessType) {
    // Normalize to English for consistent matching
    String normalizedType = Utils.setProperty(businessType).toLowerCase();

    switch (normalizedType) {
      case 'factory':
        return Icons.factory;
      case 'full_building':
        return Icons.business;
      case 'garage':
        return Icons.garage;
      case 'warehouse':
        return Icons.warehouse;
      case 'restaurant_cafe':
        return Icons.restaurant;
      case 'offices':
        return Icons.business_center;
      case 'medical_facility':
        return Icons.local_hospital;
      case 'showroom':
        return Icons.store;
      case 'hotel_motel':
        return Icons.hotel;
      case 'gas_station':
        return Icons.local_gas_station;
      case 'storage_facility':
        return Icons.storage;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.business;
    }
  }

  IconData _getLandTypeIcon(String landType) {
    if (landType == StringHelper.agriculturalLand) {
      return Icons.agriculture;
    } else if (landType == StringHelper.commercialLand) {
      return Icons.business;
    } else if (landType == StringHelper.residentialLand) {
      return Icons.home_outlined;
    } else if (landType == StringHelper.industrialLand) {
      return Icons.factory;
    } else if (landType == StringHelper.mixedLand) {
      return Icons.landscape;
    } else if (landType == StringHelper.farmLand) {
      return Icons.grass;
    } else {
      return Icons.landscape;
    }
  }

  Widget _buildFuelTypeOptionForFilter(
    BuildContext context,
    String fuelType,
    String svgAssetPath,
    HomeVM viewModel,
  ) {
    bool isSelected = viewModel.fuelTextController.text == fuelType;

    return GestureDetector(
      onTap: () {
        viewModel.fuelTextController.text = fuelType;
        filter.fuel = fuelType; // Update FilterModel
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        width: 130,
        height: 110,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgAssetPath,
              width: 48,
              height: 48,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                fuelType,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFuelSvgPath(String fuelType) {
    String normalizedFuelType = Utils.setFuel(fuelType).toLowerCase();
    switch (normalizedFuelType) {
      case 'petrol':
        return 'assets/icons/fuel_types/petrol.svg';
      case 'diesel':
        return 'assets/icons/fuel_types/diesel.svg';
      case 'electric':
        return 'assets/icons/fuel_types/electric.svg';
      case 'hybrid':
        return 'assets/icons/fuel_types/hybrid.svg';
      default:
        return 'assets/icons/fuel_types/petrol.svg';
    }
  }
  // In _FilterViewState class of filter_view.dart

  Widget _buildDoorsSelection(HomeVM viewModel) {
    final List<String> doorOptions = [
      StringHelper.doors2,
      StringHelper.doors3,
      StringHelper.doors4,
      StringHelper.doors5Plus,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringHelper.numbDoorsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: doorOptions.map((doors) {
              // Parse selected doors from the controller
              List<String> selectedDoors =
                  viewModel.numbDoorsTextController.text.isEmpty
                      ? []
                      : viewModel.numbDoorsTextController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList();

              bool isSelected = selectedDoors.contains(doors);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    // Remove if already selected
                    selectedDoors.remove(doors);
                  } else {
                    // Add if not selected
                    selectedDoors.add(doors);
                  }

                  // Update the controller
                  viewModel.numbDoorsTextController.text =
                      selectedDoors.join(',');
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.black.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    doors,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSelectionOption({
    required BuildContext context,
    required String title,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
    double? fontSize,
    bool useEllipsis = false,
  }) {
    return SizedBox(
      width: (context.width - 52) / 2, // Matches JobSellForm spacing
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isSelected ? Colors.black : Colors.grey.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  Utils.getCommon(value),
                  style: TextStyle(
                    fontSize: fontSize ?? 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.grey.shade800,
                  ),
                  overflow: useEllipsis
                      ? TextOverflow.ellipsis
                      : TextOverflow.ellipsis,
                  textAlign: icon == null ? TextAlign.center : TextAlign.start,
                ),
              ),
              if (icon == null) const SizedBox(width: 8), // Balance spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: (context.width - 52) / 2, // Adjust for padding and spacing
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMultiFilterSelectionOption({
  required BuildContext context,
  required String title,
  required String value,
  required bool isSelected,
  required VoidCallback onTap,
  IconData? icon,
  double? fontSize,
  bool useEllipsis = false,
}) {
  return SizedBox(
    width: (context.width - 52) / 2,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 6), // Reduced from 8 to 6
            ],
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey.shade800,
                ),
                overflow:
                    useEllipsis ? TextOverflow.ellipsis : TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ColorSelectionWidget extends StatefulWidget {
  final String title;
  final List<String> allColors;
  final String selectedColor;
  final Function(String) onColorSelected;

  const _ColorSelectionWidget({
    required this.title,
    required this.allColors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<_ColorSelectionWidget> createState() => _ColorSelectionWidgetState();
}

class _ColorSelectionWidgetState extends State<_ColorSelectionWidget> {
  bool _showAll = false;
  final int _initialDisplayCount = 4;

  @override
  Widget build(BuildContext context) {
    final displayedColors = _showAll
        ? widget.allColors
        : widget.allColors.take(_initialDisplayCount).toList();
    final hasMoreToShow = widget.allColors.length > _initialDisplayCount;

    // Parse selected colors from comma-separated string
    List<String> selectedColors = widget.selectedColor.isEmpty
        ? []
        : widget.selectedColor.split(',').map((e) => e.trim()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: displayedColors.map((color) {
            bool isSelected = selectedColors
                .any((c) => c.toLowerCase() == color.toLowerCase());
            return GestureDetector(
              onTap: () => widget.onColorSelected(color),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      color,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.black : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getColorFromName(color),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (hasMoreToShow)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showAll ? StringHelper.seeLess : StringHelper.seeMore,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 42, 46, 50),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    _showAll
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color.fromARGB(255, 30, 34, 38),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    String normalizedColor = Utils.setColor(colorName).toLowerCase();
    switch (normalizedColor) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey.shade400;
      case 'gray':
        return Colors.grey.shade600;
      case 'red':
        return Colors.red.shade700;
      case 'blue':
        return Colors.blue.shade700;
      case 'green':
        return Colors.green.shade700;
      case 'yellow':
        return Colors.yellow.shade700;
      case 'orange':
        return Colors.orange.shade700;
      case 'brown':
        return Colors.brown.shade700;
      case 'beige':
        return const Color(0xFFF5DEB3);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'burgundy':
        return const Color(0xFF800020);
      case 'purple':
        return Colors.purple.shade700;
      case 'pink':
        return Colors.pink.shade300;
      case 'turquoise':
        return const Color(0xFF40E0D0);
      case 'navy':
        return const Color(0xFF000080);
      case 'other color':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
