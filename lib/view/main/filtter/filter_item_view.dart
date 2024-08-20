import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/helpers/db_helper.dart';
import '../../../base/helpers/debouncer_helper.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../models/common/map_response.dart';
import '../../../models/filter_model.dart';
import '../../../models/home_list_model.dart';
import '../../../models/prodect_detail_model.dart';
import '../../../res/assets_res.dart';
import '../../../routes/app_routes.dart';
import '../../../skeletons/product_list_skeleton.dart';
import '../../../widgets/app_empty_widget.dart';
import '../../../widgets/app_product_item_widget.dart';

class FilterItemView extends StatefulWidget {
  final FilterModel? model;
  const FilterItemView({super.key, required this.model});

  @override
  State<FilterItemView> createState() => _FilterItemViewState();
}

class _FilterItemViewState extends State<FilterItemView> {
  List<ProductDetailModel> productsList = [];
  late RefreshController refreshController;
  int limit = 10;
  int page = 1;
  bool isLoading = true;
  String searchQuery = '';
  FocusNode searchFocusNode = FocusNode();
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);

  // Map of filters based on category ID
  Map<int, List<String>> filters = {
    1: ['Brand', 'Model', 'Condition'], // Electronics
    2: ['Category', 'Condition'], // Home & Living
    3: ['Condition', 'Type'], // Fashion
    4: ['Make', 'Model', 'Year', 'Mileage'], // Vehicles
    5: ['Condition'], // Hobbies, Music, Art & Books
    6: ['Gender'], // Pets
    7: ['Condition'], // Business & Industrial
    8: ['Service Type'], // Services
    9: ['Job Type', 'Education', 'Salary Range', 'Experience'], // Jobs
    10: ['Brand', 'Condition'], // Mobiles & Tablets
  };
  List<String> filtersCat = [];
  // Method to get filters based on the selected category ID
  List<String> getFiltersByCategory(int? categoryId) {
    return filters[categoryId] ?? [];
  }

  late FilterModel filterModel;

  @override
  void initState() {
    print(widget.model?.toMap());
    filterModel = widget.model ?? FilterModel();
    refreshController = RefreshController(initialRefresh: true);
    getProductsApi();
    setState(() {
      filtersCat =
          getFiltersByCategory(int.tryParse("${filterModel.categoryId}"));
    });
    super.initState();
  }

  Future<void> onRefresh() async {
    try {
      page = 1;
      productsList.clear();
      await getProductsApi(loading: true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoading() async {
    ++page;
    await getProductsApi(loading: false);
    refreshController.loadComplete();
  }

  String constructUrl(FilterModel model) {
    final baseUrl = ApiConstants.getFilteredProduct(limit: limit, page: page);
    final queryParams = model
        .toMap()
        .entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    return '$baseUrl&$queryParams&search=$searchQuery';
  }

  Future<void> getProductsApi({bool loading = false}) async {
    if (loading) isLoading = loading;
    print("--------------Raja Babu--------------");
    print(filterModel.toMap());
    final url = constructUrl(filterModel);
    ApiRequest apiRequest = ApiRequest(url: url, requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));

    if (page == 1) {
      productsList.clear();
    }

    productsList.addAll(model.body?.data ?? []);

    if (loading) isLoading = false;
    setState(() {});
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    _debounce.run(() {
      page = 1;
      getProductsApi(loading: true);
    });
  }

  void removeFilter(String key) {
    setState(() {
      filterModel = filterModel.copyWith(
        limit: key == 'limit' ? null : filterModel.limit,
        page: key == 'page' ? null : filterModel.page,
        categoryId: key == 'categoryId' ? null : filterModel.categoryId,
        subcategoryId:
            key == 'subcategoryId' ? null : filterModel.subcategoryId,
        brandId: key == 'brandId' ? null : filterModel.brandId,
        userId: key == 'userId' ? null : filterModel.userId,
        favourite: key == 'favourite' ? null : filterModel.favourite,
        latitude: key == 'latitude' ? null : filterModel.latitude,
        longitude: key == 'longitude' ? null : filterModel.longitude,
        minPrice: key == 'minPrice' ? null : filterModel.minPrice,
        maxPrice: key == 'maxPrice' ? null : filterModel.maxPrice,
        minKmDriven: key == 'minKmDriven' ? null : filterModel.minKmDriven,
        maxKmDriven: key == 'maxKmDriven' ? null : filterModel.maxKmDriven,
        fuel: key == 'fuel' ? null : filterModel.fuel,
        numberOfOwner:
            key == 'numberOfOwner' ? null : filterModel.numberOfOwner,
        year: key == 'year' ? null : filterModel.year,
        sellStatus: key == 'sellStatus' ? null : filterModel.sellStatus,
        search: key == 'search' ? null : filterModel.search,
        datePublished:
            key == 'datePublished' ? null : filterModel.datePublished,
        sortByPrice: key == 'sortByPrice' ? null : filterModel.sortByPrice,
        distance: key == 'distance' ? null : filterModel.distance,
        itemCondition:
            key == 'itemCondition' ? null : filterModel.itemCondition,
        startDate: key == 'startDate' ? null : filterModel.startDate,
        endDate: key == 'endDate' ? null : filterModel.endDate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: false,
                  focusNode: searchFocusNode,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xffd5d5d5))),
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      hintText: StringHelper.findCarsMobilePhonesAndMore),
                ),
              ),
              const Gap(10),
              InkWell(
                onTap: () {
                  context.push(Routes.filter, extra: filterModel);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color(0xffd5d5d5),
                      borderRadius: BorderRadius.circular(8)),
                  child: Image.asset(
                    AssetsRes.IC_FILTER_ICON,
                    height: 25,
                  ),
                ),
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: filtersCat.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String filter = filtersCat[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterWidget(filterName: filter),
                );
              },
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                complete: Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(),
              ),
              onRefresh: onRefresh,
              onLoading: onLoading,
              child: Column(
                children: [
                  if (isLoading) ...{
                    ProductListSkeleton(isLoading: isLoading)
                  } else ...{
                    if (productsList.isEmpty)
                      const Expanded(child: AppEmptyWidget())
                    else
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          itemCount: productsList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (productsList[index].userId ==
                                    DbHelper.getUserModel()?.id) {
                                  context.push(Routes.myProduct,
                                      extra: productsList[index]);
                                  return;
                                }

                                context.push(Routes.productDetails,
                                    extra: productsList[index]);
                              },
                              child: AppProductItemWidget(
                                data: productsList[index],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Gap(20);
                          },
                        ),
                      )
                  },
                  // Display selected filters
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  final String filterName;

  FilterWidget({required this.filterName});

  @override
  Widget build(BuildContext context) {
    // Here, you can customize how each filter is rendered
    // Based on the filterName, you can render Dropdowns, Checkboxes, Sliders, etc.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          filterName,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (filterName == 'Brand' || filterName == 'Model')
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              items: ['Option 1', 'Option 2', 'Option 3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {},
            ),
          )
        else if (filterName == 'Condition')
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              items: ['New', 'Used', 'Refurbished'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {},
            ),
          )
        else
          // Default text field or any other input type
          SizedBox(
            width: 120,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter value for $filterName',
                border: OutlineInputBorder(),
              ),
            ),
          ),
      ],
    );
  }
}
