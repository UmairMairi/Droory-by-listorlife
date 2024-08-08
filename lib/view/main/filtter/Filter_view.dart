import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
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
import 'filter_item_view.dart';

class FilterView extends StatefulWidget {
  final FilterModel? filters;
  const FilterView({super.key, this.filters});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  SfRangeValues values = const SfRangeValues(00, 00);
  FilterModel filter = FilterModel();
  List<CategoryModel> categories = [];
  List<CategoryModel> subCategories = [];
  List<CategoryModel> subSubCategories = [];

  @override
  void initState() {
    var vm = context.read<HomeVM>();
    WidgetsBinding.instance.addPostFrameCallback((t) => updateFilter(vm: vm));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringHelper.filter),
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
                    getSubCategory(id: "${value.id}");
                    viewModel.categoryTextController.text = value.name ?? '';
                    filter.categoryId = "${value.id}";
                    viewModel.subCategoryTextController.clear();
                  },
                  itemBuilder: (BuildContext context) {
                    return categories.map((option) {
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
              if (subCategories.isNotEmpty) ...{
                AppTextField(
                  title: StringHelper.subCategory,
                  hint: StringHelper.selectSubCategory,
                  controller: viewModel.subCategoryTextController,
                  readOnly: true,
                  suffix: PopupMenuButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onSelected: (value) {
                      /// TODO: Need to immpliment subCat onTap
                      viewModel.subCategoryTextController.text =
                          value.name ?? '';
                      filter.subcategoryId = "${value.id}";
                    },
                    itemBuilder: (BuildContext context) {
                      return subCategories.map((option) {
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
              Container(
                color: const Color(0xffEAEEF1),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    initiallyExpanded: false,
                    title: Text(
                      viewModel.sortBy,
                      style: context.textTheme.titleSmall,
                    ),
                    backgroundColor: Colors.white,
                    children: [
                      ListTile(
                        title: const Text(
                          StringHelper.priceHighToLow,
                          selectionColor: Colors.white,
                        ),
                        onTap: () =>
                            viewModel.sortBy = StringHelper.priceHighToLow,
                      ),
                      ListTile(
                        title: const Text(StringHelper.priceLowToHigh),
                        onTap: () =>
                            viewModel.sortBy = StringHelper.priceLowToHigh,
                      ),
                      ListTile(
                        title: const Text(StringHelper.datePublished),
                        onTap: () =>
                            viewModel.sortBy = StringHelper.priceLowToHigh,
                      ),
                      ListTile(
                        title: const Text(StringHelper.distance),
                        onTap: () => viewModel.sortBy = StringHelper.distance,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: const Color(0xffEAEEF1),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.zero,
                    title: Text(
                      viewModel.publishedBy,
                      style: context.textTheme.titleSmall,
                    ),
                    backgroundColor: Colors.white,
                    children: [
                      ListTile(
                        title: const Text(
                          StringHelper.today,
                          selectionColor: Colors.white,
                        ),
                        onTap: () => viewModel.publishedBy = StringHelper.today,
                      ),
                      ListTile(
                        title: const Text(StringHelper.yesterday),
                        onTap: () =>
                            viewModel.publishedBy = StringHelper.yesterday,
                      ),
                      ListTile(
                        title: const Text(StringHelper.lastWeek),
                        onTap: () =>
                            viewModel.publishedBy = StringHelper.lastWeek,
                      ),
                      ListTile(
                        title: const Text(StringHelper.lastMonth),
                        onTap: () =>
                            viewModel.publishedBy = StringHelper.lastMonth,
                      )
                    ],
                  ),
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

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterItemView(model: filter)));
                },
                title: StringHelper.apply,
              ),
              const Gap(10),
              AppOutlineButton(
                title: StringHelper.reset,
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onTap: () {},
              ),
            ],
          ),
        );
      }),
    );
  }

  void updateFilter({required HomeVM vm}) async {
    categories = vm.categories;
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
      vm.endPriceTextController.text = filter.maxPrice ?? '20000';
      vm.currentLocation = await LocationHelper.getAddressFromCoordinates(
          vm.latitude, vm.longitude);
      vm.categoryTextController.text = getCategoryName(id: filter.categoryId);

      values = SfRangeValues(
          int.parse(vm.startPriceTextController.text.isEmpty
              ? '0'
              : vm.startPriceTextController.text),
          int.parse(vm.endPriceTextController.text.isEmpty
              ? '0'
              : vm.endPriceTextController.text));
      vm.locationTextController.text = vm.currentLocation;
    }
    log("${categories.map((element) => element.toJson()).toList()}",
        name: "BASEX");
  }

  String getCategoryName({String? id}) {
    if (id == null) return '';

    for (var category in categories) {
      if (category.id.toString() == id) {
        return category.name ?? '';
      }
    }

    return ''; // Return empty string if category not found
  }

  String getSubCategoryName({String? id}) {
    if (id == null) return '';

    for (var category in categories) {
      if (category.id.toString() == id) {
        return category.name ?? '';
      }
    }

    return ''; // Return empty string if category not found
  }

  String getSubSubCategoryName({String? id}) {
    if (id == null) return '';

    for (var category in subCategories) {
      if (category.id.toString() == id) {
        return category.name ?? '';
      }
    }

    return ''; // Return empty string if category not found
  }

  void getSubCategory({String? id}) async {
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "$id"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    subCategories = model.body ?? [];
    DialogHelper.hideLoading();
    setState(() {});
  }
}
