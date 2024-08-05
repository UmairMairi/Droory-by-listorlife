import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/helpers/db_helper.dart';
import '../../../base/helpers/debouncer_helper.dart';
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
  final FilterModel model;
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

  late FilterModel filterModel;

  @override
  void initState() {
    filterModel = widget.model;
    refreshController = RefreshController(initialRefresh: true);
    getProductsApi();
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
                      hintText: 'Find Cars, Mobile Phones and more...'),
                ),
              ),
              const Gap(10),
              InkWell(
                onTap: () {
                  context.push(Routes.filter);
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
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              /*  Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  if (filterModel.categoryId != null)
                    FilterChip(
                      label: Text('Category: ${filterModel.categoryId}'),
                      onSelected: (_) => removeFilter('categoryId'),
                    ),
                  if (filterModel.subcategoryId != null)
                    FilterChip(
                      label: Text('Subcategory: ${filterModel.subcategoryId}'),
                      onSelected: (_) => removeFilter('subcategoryId'),
                    ),
                  // Add other filter chips similarly
                ],
              ),
              Gap(20),*/
              if (isLoading) ...{
                ProductListSkeleton(isLoading: isLoading)
              } else ...{
                productsList.isEmpty
                    ? const AppEmptyWidget()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                      )
              },
              const Gap(40),
              // Display selected filters
            ],
          ),
        ),
      ),
    );
  }
}
