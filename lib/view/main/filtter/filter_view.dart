import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
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
  SfRangeValues values = const SfRangeValues(00, 20000);
  FilterModel filter = FilterModel();
  List<CategoryModel> categoriesList = [];
  List<CategoryModel> subCategoriesList = [];
  List<CategoryModel> brands = [];
  List<CategoryModel> allModels = [];
  List<String> yearsType = [];
  List<String> fuelsType = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas'];
  List<String> transmissionType = [
    'Manual',
    'Automatic',
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
    CategoryModel(name: 'Male'),
    CategoryModel(name: 'Female')
  ];

  // Map of filters based on category ID
  Map<int, List<String>> filters = {
    // Vehicles// Services
    9: ['Job Type', 'Education', 'Salary Range', 'Experience'], // Jobs
  };
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
    print("response ~--> $response");
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
                      viewModel.selectedIndex = 0;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: viewModel.selectedIndex == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: Text(
                        StringHelper.newText,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: viewModel.selectedIndex == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      viewModel.selectedIndex = 1;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                        color: viewModel.selectedIndex == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(
                        StringHelper.used,
                        style: context.textTheme.titleMedium?.copyWith(
                            color: viewModel.selectedIndex == 1
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
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
                          textAlign: TextAlign.center,
                          controller: viewModel.startPriceTextController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                values = SfRangeValues(
                                    0,
                                    int.parse(
                                        viewModel.endPriceTextController.text));
                                return;
                              }

                              values = SfRangeValues(
                                  int.parse(
                                      viewModel.startPriceTextController.text),
                                  int.parse(
                                      viewModel.endPriceTextController.text));
                            });
                          },
                          decoration: InputDecoration(
                              fillColor: const Color(0xffFCFCFD),
                              hintText: StringHelper.egp0,
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
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        controller: viewModel.endPriceTextController,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              values = SfRangeValues(
                                  int.parse(
                                      viewModel.startPriceTextController.text),
                                  20000);
                              return;
                            }

                            values = SfRangeValues(
                                int.parse(
                                    viewModel.startPriceTextController.text),
                                int.parse(
                                    viewModel.endPriceTextController.text));
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: const Color(0xffFCFCFD),
                            hintText: "EGP0",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xffEFEFEF))),
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
                height: 15,
              ),
              StatefulBuilder(builder: (context, setState) {
                return SfRangeSlider(
                  min: 0,
                  max: 20000,
                  values: values,
                  inactiveColor: Colors.grey,
                  activeColor: const Color(0xffFF385C),
                  showLabels: true,
                  interval: 20000,
                  labelFormatterCallback:
                      (dynamic actualValue, String formattedText) {
                    return actualValue == 19999
                        ? ' $formattedText+'
                        : ' $formattedText';
                  },
                  onChanged: (SfRangeValues newValues) {
                    viewModel.startPriceTextController.text =
                        "${newValues.start.round()}";
                    viewModel.endPriceTextController.text =
                        "${newValues.end.round()}";
                    setState(() {
                      values = newValues;
                    });
                  },
                );
              }),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                title: StringHelper.category,
                hint: StringHelper.selectCategory,
                controller: viewModel.categoryTextController,
                readOnly: true,
                suffix: PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    setState(() {
                      filtersCat = getFiltersByCategory(value.id);
                    });

                    getSubCategory(id: "${value.id}");
                    viewModel.categoryTextController.text = value.name ?? '';
                    filter.categoryId = "${value.id}";
                    brands.clear();
                    allModels.clear();
                    viewModel.brandsTextController.clear();
                    viewModel.modelTextController.clear();
                    viewModel.subCategoryTextController.clear();
                  },
                  itemBuilder: (BuildContext context) {
                    return categoriesList.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option.name ?? ''),
                      );
                    }).toList();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (subCategoriesList.isNotEmpty) ...{
                AppTextField(
                  title: filter.categoryId == '8'
                      ? 'Select Services'
                      : filter.categoryId == '9'
                          ? 'Job Type'
                          : StringHelper.subCategory,
                  hint: filter.categoryId == '8'
                      ? 'Select Services'
                      : filter.categoryId == '9'
                          ? 'Select Job Type'
                          : StringHelper.selectSubCategory,
                  controller: viewModel.subCategoryTextController,
                  readOnly: true,
                  suffix: PopupMenuButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) async {
                      viewModel.subCategoryTextController.text =
                          value.name ?? '';
                      filter.subcategoryId = "${value.id}";
                      DialogHelper.showLoading();
                      brands.clear();
                      allModels.clear();
                      viewModel.brandsTextController.clear();
                      viewModel.modelTextController.clear();
                      await getBrands(id: "${filter.subcategoryId}");
                    },
                    itemBuilder: (BuildContext context) {
                      return subCategoriesList.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option.name ?? ''),
                        );
                      }).toList();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              },
              if (brands.isNotEmpty) ...{
                AppTextField(
                  title:
                      filter.categoryId == '6' ? 'Breed' : StringHelper.brand,
                  hint: filter.categoryId == '6'
                      ? 'Select Breeds'
                      : StringHelper.selectBrands,
                  controller: viewModel.brandsTextController,
                  readOnly: true,
                  suffix: PopupMenuButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) async {
                      viewModel.brandsTextController.text = value.name ?? '';
                      filter.brandId = "${value.id}";
                      viewModel.modelTextController.clear();
                      await getModels(brandId: int.parse("${filter.brandId}"));
                    },
                    itemBuilder: (BuildContext context) {
                      return brands.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option.name ?? ''),
                        );
                      }).toList();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                filter.categoryId == '6'
                    ? AppTextField(
                        title: 'Gender',
                        hint: 'Select Gender',
                        controller: viewModel.genderTextController,
                        readOnly: true,
                        suffix: PopupMenuButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onSelected: (value) {
                            viewModel.genderTextController.text =
                                value.name ?? '';
                          },
                          itemBuilder: (BuildContext context) {
                            return genders.map((option) {
                              return PopupMenuItem(
                                value: option,
                                child: Text(option.name ?? ''),
                              );
                            }).toList();
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                ),
              },
              if (allModels.isNotEmpty) ...{
                AppTextField(
                  title: StringHelper.models,
                  hint: 'Select Model',
                  readOnly: true,
                  controller: viewModel.modelTextController,
                  suffix: PopupMenuButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      viewModel.modelTextController.text = value.name ?? '';
                      filter.modelId = value.id.toString();
                    },
                    itemBuilder: (BuildContext context) {
                      return allModels.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option.name ?? ''),
                        );
                      }).toList();
                    },
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  inputType: TextInputType.number,
                  action: TextInputAction.done,
                ),
                const Gap(10),
              },
              if (filter.categoryId == '4') ...{
                AppTextField(
                  title: StringHelper.year,
                  hint: 'Select Year',
                  readOnly: true,
                  controller: viewModel.yearTextController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      viewModel.yearTextController.text = value ?? '';
                      filter.year = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return yearsType.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList();
                    },
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  inputType: TextInputType.number,
                  action: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  title: StringHelper.fuel,
                  hint: StringHelper.enter,
                  controller: viewModel.fuelTextController,
                  action: TextInputAction.done,
                  readOnly: true,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      viewModel.fuelTextController.text = value ?? '';
                      filter.fuel = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return fuelsType.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  title: StringHelper.mileage,
                  hint: StringHelper.select,
                  controller: viewModel.mileageTextController,
                  readOnly: true,
                  suffix: PopupMenuButton<String>(
                    clipBehavior: Clip.hardEdge,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    onSelected: (value) {
                      viewModel.mileageTextController.text = value;
                    },
                    itemBuilder: (BuildContext context) {
                      return viewModel.mileageRanges.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option ?? ''),
                        );
                      }).toList();
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  title: StringHelper.transmission,
                  hint: 'Select Transmission',
                  readOnly: true,
                  controller: viewModel.transmissionTextController,
                  suffix: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      viewModel.transmissionTextController.text = value ?? '';
                      filter.transmission = value.toLowerCase();
                    },
                    itemBuilder: (BuildContext context) {
                      return transmissionType.map((option) {
                        return PopupMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList();
                    },
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  inputType: TextInputType.number,
                  action: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppTextField(
                  title: StringHelper.kmDriven,
                  hint: StringHelper.enter,
                  controller: viewModel.kmDrivenTextController,
                  readOnly: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  inputType: TextInputType.number,
                  action: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10,
                ),
              },
              if (filter.categoryId == '9') ...{
                AppTextField(
                  title: StringHelper.positionType,
                  hint: StringHelper.select,
                  controller: viewModel.jobPositionTextController,
                  readOnly: true,
                  suffix: PopupMenuButton(
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
                const Gap(10),
                AppTextField(
                  title: StringHelper.salaryPeriod,
                  hint: StringHelper.select,
                  controller: viewModel.jobSalaryTextController,
                  readOnly: true,
                  suffix: PopupMenuButton(
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
                const Gap(10),
                AppTextField(
                  title: StringHelper.salaryFrom,
                  hint: StringHelper.enter,
                  controller: viewModel.jobSalaryFromController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
                const Gap(10),
                AppTextField(
                  title: StringHelper.salaryTo,
                  hint: StringHelper.enter,
                  controller: viewModel.jobSalaryToController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
                const Gap(10),
              },
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
                  print(value);
                  if (value != null && value.isNotEmpty) {
                    viewModel.locationTextController.text =
                        "${value['location']}, ${value['city']}, ${value['state']}";
                    viewModel.latitude = double.parse(value['latitude']);
                    viewModel.longitude = double.parse(value['longitude']);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                title: StringHelper.sortBy,
                hint: StringHelper.sortBy,
                controller: viewModel.sortByTextController,
                readOnly: true,
                suffix: PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    viewModel.sortByTextController.text = value.name ?? '';
                    filter.sortByPrice =
                        value.name == StringHelper.priceLowToHigh
                            ? 'asc'
                            : 'desc';
                  },
                  itemBuilder: (BuildContext context) {
                    return sortByList.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option.name ?? ''),
                      );
                    }).toList();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                title: StringHelper.postedWithin,
                hint: StringHelper.postedWithin,
                controller: viewModel.postedWithinTextController,
                readOnly: true,
                suffix: PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    viewModel.postedWithinTextController.text =
                        value.name ?? '';
                    setDatePosted(value: value);
                  },
                  itemBuilder: (BuildContext context) {
                    return postedWithinList.map((option) {
                      return PopupMenuItem(
                        value: option,
                        child: Text(option.name ?? ''),
                      );
                    }).toList();
                  },
                ),
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
                  filter.itemCondition = viewModel.selectedIndex == 0
                      ? StringHelper.newText
                      : StringHelper.used;
                  filter.minPrice =
                      viewModel.startPriceTextController.text.trim();
                  filter.maxPrice =
                      viewModel.endPriceTextController.text.trim();
                  filter.latitude = viewModel.latitude.toString();
                  filter.longitude = viewModel.longitude.toString();
                  filter.year = viewModel.yearTextController.text.trim();
                  filter.fuel = viewModel.fuelTextController.text.trim();

                  filter.minKmDriven =
                      viewModel.kmDrivenTextController.text.trim();
                  context.pushReplacement(Routes.filterDetails, extra: filter);
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
                  context.push(Routes.filterDetails, extra: filter);
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
    if (widget.filters != null) {
      filter = widget.filters!;

      vm.selectedIndex = filter.itemCondition == null
          ? 0
          : filter.itemCondition!.toLowerCase().contains('new')
              ? 0
              : 1;
      vm.latitude = double.parse(filter.latitude ?? '0.0');
      vm.longitude = double.parse(filter.longitude ?? '0.0');
      vm.startPriceTextController.text = filter.minPrice ?? '0';
      vm.endPriceTextController.text =
          filter.maxPrice != '0' ? filter.maxPrice ?? '20000' : '20000';
      vm.kmDrivenTextController.text = filter.minKmDriven ?? '';
      vm.yearTextController.text = filter.year ?? '';
      vm.fuelTextController.text = filter.fuel ?? '';

      vm.currentLocation = await LocationHelper.getAddressFromCoordinates(
          vm.latitude, vm.longitude);
      vm.categoryTextController.text = getCategoryName(id: filter.categoryId);
      if (filter.categoryId != null && filter.categoryId != '0') {
        await getSubCategory(id: filter.categoryId);
      }
      if (filter.subcategoryId != null) {
        await getBrands(id: filter.subcategoryId);
        vm.subCategoryTextController.text =
            getSubCategoryName(id: filter.subcategoryId);
      }

      if (filter.brandId != null) {
        vm.brandsTextController.text = getBrandName(id: filter.brandId);
      }

      values = SfRangeValues(
          int.parse(vm.startPriceTextController.text.isEmpty
              ? '0'
              : vm.startPriceTextController.text),
          int.parse(vm.endPriceTextController.text));
      vm.locationTextController.text = vm.currentLocation;
    }
    log("${categoriesList.map((element) => element.toJson()).toList()}",
        name: "BASEX");
  }

  void resetFilters() {
    HomeVM vm = context.read<HomeVM>();
    filter = FilterModel();
    vm.selectedIndex = 0;
    vm.latitude = LocationHelper.cairoLatitude;
    vm.longitude = LocationHelper.cairoLongitude;
    vm.locationTextController.text = "Cairo, Egypt";
    vm.startPriceTextController.text = '0';
    vm.endPriceTextController.text = '20000';
    values = SfRangeValues(
        int.parse(vm.startPriceTextController.text.isEmpty
            ? '0'
            : vm.startPriceTextController.text),
        int.parse(vm.endPriceTextController.text.isEmpty
            ? '20000'
            : vm.endPriceTextController.text));
    brands.clear();
    subCategoriesList.clear();
    vm.categoryTextController.clear();
    vm.subCategoryTextController.clear();
    vm.sortByTextController.clear();
    vm.postedWithinTextController.clear();
    vm.brandsTextController.clear();
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

  String getBrandName({String? id}) {
    if (id == null) return '';

    for (var brand in brands) {
      if (brand.id.toString() == id) {
        return brand.name ?? '';
      }
    }

    return ''; // Return empty string if category not found
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

  void setDatePosted({CategoryModel? value}) {
    var now = DateTime.now();
    switch (value?.id) {
      case 1:
        filter.startDate = DateFormat('yyyy-MM-dd').format(now);
        filter.endDate = DateFormat('yyyy-MM-dd').format(now);
        break;
      case 2:
        filter.startDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 1)));
        filter.endDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 1)));
        break;
      case 3:
        filter.startDate = DateFormat('yyyy-MM-dd').format(now);
        filter.endDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 7)));
        break;
      case 4:
        filter.startDate = DateFormat('yyyy-MM-dd').format(now);
        filter.endDate = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 30)));
        break;
    }
  }
}
