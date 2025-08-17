import 'dart:developer';
import 'dart:io';
import 'dart:math'; // Added for math functions
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/helpers/db_helper.dart';
import '../../../base/helpers/debouncer_helper.dart';
import '../../../base/helpers/dialog_helper.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../models/common/list_response.dart';
import '../../../models/common/map_response.dart';
import '../../../models/filter_model.dart';
import '../../../models/home_list_model.dart';
import '../../../models/product_detail_model.dart';
import '../../../res/assets_res.dart';
import '../../../routes/app_routes.dart';
import '../../../skeletons/product_list_skeleton.dart';
import '../../../widgets/app_empty_widget.dart';
import '../../../widgets/app_product_item_widget.dart';
import '../../../widgets/app_search_view.dart';
import '../../../widgets/scroll_to_top_fab.dart';

class FilterItemView extends StatefulWidget {
  final FilterModel? model;
  const FilterItemView({super.key, required this.model});

  @override
  State<FilterItemView> createState() => _FilterItemViewState();
}

class _FilterItemViewState extends State<FilterItemView> {
  List<ProductDetailModel> productsList = [];
  late RefreshController refreshController;
  late ScrollController scrollController;
  int limit = 20;
  int page = 1;
  bool isLoading = true;
  String searchQuery = '';
  FocusNode searchFocusNode = FocusNode();
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);

  late FilterModel filterModel;

  @override
  void initState() {
    super.initState();
    filterModel = widget.model ?? FilterModel();

    // Initialize location details after the first frame.
    // _initializeLocationFromHomeVM might trigger a state change that could
    // influence what getProductsApi (called by initialRefresh) fetches.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeLocationFromHomeVM();
        // If initialRefresh is true, onRefresh will be called automatically.
        // If productsList is still empty after that initial refresh (e.g., no items found),
        // the UI will show the empty state.
      }
    });

    refreshController =
        RefreshController(initialRefresh: true); // This will trigger onRefresh
    scrollController = ScrollController();
    // No need to call getProductsApi() here directly if initialRefresh is true.
  }

  // NEW METHOD: Initialize location from HomeVM to ensure consistency
  // PASTE THIS into _FilterItemViewState, replacing your existing _initializeLocationFromHomeVM()

  void _initializeLocationFromHomeVM() {
    final homeVM = context.read<HomeVM>();

    // Check if filterModel has complete location data
    bool modelHasCompleteLocation = filterModel.locationType != null &&
        filterModel.locationType!.isNotEmpty &&
        filterModel.latitude != null &&
        filterModel.latitude!.isNotEmpty &&
        filterModel.longitude != null &&
        filterModel.longitude!.isNotEmpty;

    // Additional check for name-based searches
    bool modelHasLocationNames = false;
    if (filterModel.locationType == "city") {
      modelHasLocationNames =
          filterModel.city != null && filterModel.city!.isNotEmpty;
    } else if (filterModel.locationType == "district") {
      modelHasLocationNames = filterModel.city != null &&
          filterModel.city!.isNotEmpty &&
          filterModel.districtName != null &&
          filterModel.districtName!.isNotEmpty;
    } else if (filterModel.locationType == "neighborhood") {
      modelHasLocationNames = filterModel.city != null &&
          filterModel.city!.isNotEmpty &&
          filterModel.districtName != null &&
          filterModel.districtName!.isNotEmpty &&
          filterModel.neighborhoodName != null &&
          filterModel.neighborhoodName!.isNotEmpty;
    } else if (filterModel.locationType == "coordinates" ||
        filterModel.locationType == "nearby" ||
        filterModel.locationType == "all") {
      modelHasLocationNames = true; // These types don't need names
    }

    if (modelHasCompleteLocation && modelHasLocationNames) {
      // FilterModel has complete location data, just ensure proper formatting
      filterModel.latitude =
          (double.tryParse(filterModel.latitude ?? "0.0") ?? 0.0)
              .toStringAsFixed(6);
      filterModel.longitude =
          (double.tryParse(filterModel.longitude ?? "0.0") ?? 0.0)
              .toStringAsFixed(6);

      print("FilterItemView: Using complete location from filterModel");
      print("- Type: ${filterModel.locationType}");
      print("- City: ${filterModel.city}");
      print("- District: ${filterModel.districtName}");
      print("- Neighborhood: ${filterModel.neighborhoodName}");
      print("- Lat: ${filterModel.latitude}, Lng: ${filterModel.longitude}");
      print("- Distance: ${filterModel.distance}");

      return; // Don't inherit from HomeVM
    }

    // NEW: Check if HomeVM is explicitly set to "All Egypt" - respect that choice
    if (homeVM.selectedLocationType == "all" &&
        homeVM.latitude == 0.0 &&
        homeVM.longitude == 0.0 &&
        homeVM.selectedCity == null &&
        homeVM.selectedDistrict == null &&
        homeVM.selectedNeighborhood == null) {
      // User explicitly chose "All Egypt" - respect this choice
      filterModel.locationType = "all";
      filterModel.latitude = "0.0";
      filterModel.longitude = "0.0";
      filterModel.city = null;
      filterModel.districtName = null;
      filterModel.neighborhoodName = null;
      filterModel.distance = null;

      print("FilterItemView: Respecting 'All Egypt' choice from HomeVM");
      return;
    }

    // If we reach here, inherit from HomeVM (normal location inheritance)
    filterModel.locationType = homeVM.selectedLocationType;

    if (homeVM.selectedLocationType == "city" && homeVM.selectedCity != null) {
      filterModel.latitude = homeVM.selectedCity!.latitude.toStringAsFixed(6);
      filterModel.longitude = homeVM.selectedCity!.longitude.toStringAsFixed(6);
      filterModel.city = homeVM.selectedCity!.name; // English name
      filterModel.districtName = null;
      filterModel.neighborhoodName = null;
      filterModel.distance = null;
    } else if (homeVM.selectedLocationType == "district" &&
        homeVM.selectedDistrict != null &&
        homeVM.selectedCity != null) {
      filterModel.latitude =
          homeVM.selectedDistrict!.latitude.toStringAsFixed(6);
      filterModel.longitude =
          homeVM.selectedDistrict!.longitude.toStringAsFixed(6);
      filterModel.city = homeVM.selectedCity!.name; // English name
      filterModel.districtName = homeVM.selectedDistrict!.name; // English name
      filterModel.neighborhoodName = null;
      filterModel.distance = null;
    } else if (homeVM.selectedLocationType == "neighborhood" &&
        homeVM.selectedNeighborhood != null &&
        homeVM.selectedDistrict != null &&
        homeVM.selectedCity != null) {
      filterModel.latitude =
          homeVM.selectedNeighborhood!.latitude.toStringAsFixed(6);
      filterModel.longitude =
          homeVM.selectedNeighborhood!.longitude.toStringAsFixed(6);
      filterModel.city = homeVM.selectedCity!.name; // English name
      filterModel.districtName = homeVM.selectedDistrict!.name; // English name
      filterModel.neighborhoodName =
          homeVM.selectedNeighborhood!.name; // English name
      filterModel.distance = null;
    } else if (homeVM.selectedLocationType == "coordinates" ||
        homeVM.selectedLocationType == "nearby") {
      filterModel.latitude = homeVM.latitude.toStringAsFixed(6);
      filterModel.longitude = homeVM.longitude.toStringAsFixed(6);
      filterModel.city = null;
      filterModel.districtName = null;
      filterModel.neighborhoodName = null;
      filterModel.distance = "50"; // Default 50km for current location
    } else {
      // "all" or default
      filterModel.locationType = "all";
      filterModel.latitude = "0.0";
      filterModel.longitude = "0.0";
      filterModel.city = null;
      filterModel.districtName = null;
      filterModel.neighborhoodName = null;
      filterModel.distance = null;
    }

    print("FilterItemView: Inherited location from HomeVM");
    print("- Type: ${filterModel.locationType}");
    print("- City: ${filterModel.city}");
    print("- District: ${filterModel.districtName}");
    print("- Neighborhood: ${filterModel.neighborhoodName}");
    print("- Lat: ${filterModel.latitude}, Lng: ${filterModel.longitude}");
    print("- Distance: ${filterModel.distance}");
  }

// END OF _initializeLocationFromHomeVM REPLACEMENT
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
    page++;
    await getProductsApi(loading: false);
    refreshController.loadComplete();
  }

  // UPDATED: Use HomeVM's location logic for consistent filtering
// PASTE THIS into _FilterItemViewState, replacing your existing constructUrl() method

  // Updated constructUrl method in FilterItemView
// Updated constructUrl method in FilterItemView
  String constructUrl(FilterModel currentLocalFilterModel) {
    List<String> queryParamsList = [];

    // Add search from FilterItemView's state if it's not empty
    if (searchQuery.isNotEmpty) {
      queryParamsList.add('search=${Uri.encodeComponent(searchQuery)}');
    }

    // --- Location Parameters from currentLocalFilterModel ---
    String effectiveLocationType =
        currentLocalFilterModel.locationType ?? "all";
    queryParamsList.add('location_type=$effectiveLocationType');

    // ALWAYS USE ENGLISH NAMES for API calls
    String? cityForAPI = currentLocalFilterModel.city; // Already in English
    String? districtForAPI =
        currentLocalFilterModel.districtName; // Already in English
    String? neighborhoodForAPI =
        currentLocalFilterModel.neighborhoodName; // Already in English
    String? latStrForAPI = currentLocalFilterModel.latitude;
    String? lngStrForAPI = currentLocalFilterModel.longitude;

    print(
        "FilterItemView constructUrl: locationType=$effectiveLocationType, city=$cityForAPI, district=$districtForAPI, neighborhood=$neighborhoodForAPI");

    // Apply location filters based on type
    if (effectiveLocationType == "city" &&
        cityForAPI != null &&
        cityForAPI.isNotEmpty) {
      queryParamsList.add('city=${Uri.encodeComponent(cityForAPI)}');
      print("FilterItemView: Adding city filter: $cityForAPI");
    } else if (effectiveLocationType == "district" &&
        districtForAPI != null &&
        districtForAPI.isNotEmpty &&
        cityForAPI != null &&
        cityForAPI.isNotEmpty) {
      queryParamsList
          .add('district_name=${Uri.encodeComponent(districtForAPI)}');
      queryParamsList.add('city=${Uri.encodeComponent(cityForAPI)}');
      print(
          "FilterItemView: Adding district filter: $districtForAPI in $cityForAPI");
    } else if (effectiveLocationType == "neighborhood" &&
        neighborhoodForAPI != null &&
        neighborhoodForAPI.isNotEmpty &&
        districtForAPI != null &&
        districtForAPI.isNotEmpty &&
        cityForAPI != null &&
        cityForAPI.isNotEmpty) {
      queryParamsList
          .add('neighborhood_name=${Uri.encodeComponent(neighborhoodForAPI)}');
      queryParamsList
          .add('district_name=${Uri.encodeComponent(districtForAPI)}');
      queryParamsList.add('city=${Uri.encodeComponent(cityForAPI)}');
      print("FilterItemView: Adding neighborhood filter: $neighborhoodForAPI");
    } else if (effectiveLocationType == "coordinates" ||
        effectiveLocationType == "nearby") {
      // For coordinate-based searches, add distance parameter (50km default for current location)
      double? radiusKm = _getFilterModelRadiusKm();
      if (radiusKm == null || radiusKm == 0) {
        radiusKm = 50.0; // Default 50km for current location
      }
      queryParamsList.add('distance=${radiusKm.round()}');
      print(
          "FilterItemView: Adding distance filter: ${radiusKm.round()}km for coordinate search");
    }

    // Add latitude and longitude for ordering and distance calculation
    if (latStrForAPI != null &&
        latStrForAPI.isNotEmpty &&
        double.tryParse(latStrForAPI) != 0.0 &&
        lngStrForAPI != null &&
        lngStrForAPI.isNotEmpty &&
        double.tryParse(lngStrForAPI) != 0.0) {
      queryParamsList
          .add('latitude=${double.tryParse(latStrForAPI)!.toStringAsFixed(6)}');
      queryParamsList.add(
          'longitude=${double.tryParse(lngStrForAPI)!.toStringAsFixed(6)}');
    }

    // Add other filters from currentLocalFilterModel.toJson()
    Map<String, dynamic> allFilterParamsJson = currentLocalFilterModel.toJson();
    allFilterParamsJson.forEach((key, value) {
      if (![
            'location_type',
            'city',
            'district_name',
            'neighborhood_name',
            'latitude',
            'longitude',
            'distance',
            'search',
            'limit',
            'page',
            'screenFrom'
          ].contains(key) &&
          value != null &&
          value.toString().isNotEmpty) {
        queryParamsList.add('$key=${Uri.encodeComponent(value.toString())}');
      }
    });

    String baseUrlWithPageLimit =
        ApiConstants.getFilteredProduct(limit: limit, page: page);
    String additionalQueryString = queryParamsList.join('&');
    final separator = baseUrlWithPageLimit.contains('?') ? '&' : '?';
    final url =
        '$baseUrlWithPageLimit${additionalQueryString.isNotEmpty ? '$separator$additionalQueryString' : ''}';

    print("FilterItemView constructUrl FINAL URL: $url");
    return url;
  }
// END OF constructUrl REPLACEMENT

  // NEW METHOD: Get radius like in HomeVM
  // PASTE THIS NEW METHOD into _FilterItemViewState

  double? _getFilterModelRadiusKm() {
    // 1. Use distance if explicitly set in filterModel (e.g., from a distance slider in FilterView)
    if (filterModel.distance != null && filterModel.distance!.isNotEmpty) {
      return double.tryParse(filterModel.distance!);
    }

    // 2. If location type implies a predefined radius from LocationService
    //    (This part is more for 'nearby' if a city/district was selected to define the 'nearby' area)
    if (filterModel.locationType == 'city' && filterModel.city != null) {
      final city = LocationService.majorEgyptianCities.firstWhere(
          (c) => c.name == filterModel.city,
          orElse: () => CityModel(
              name: '',
              arabicName: '',
              latitude: 0,
              longitude: 0,
              defaultRadius: 0.0)); // Default to avoid null error
      return city.defaultRadius;
    } else if (filterModel.locationType == 'district' &&
        filterModel.districtName != null &&
        filterModel.city != null) {
      final city = LocationService.majorEgyptianCities.firstWhere(
          (c) => c.name == filterModel.city,
          orElse: () => CityModel(
              name: '',
              arabicName: '',
              latitude: 0,
              longitude: 0,
              districts: []));
      final district = city.districts?.firstWhere(
          (d) => d.name == filterModel.districtName,
          orElse: () => DistrictModel(
              name: '',
              arabicName: '',
              latitude: 0,
              longitude: 0,
              radius: 0.0));
      return district?.radius;
    } else if (filterModel.locationType == 'neighborhood' &&
        filterModel.neighborhoodName != null &&
        filterModel.districtName != null &&
        filterModel.city != null) {
      final city = LocationService.majorEgyptianCities.firstWhere(
          (c) => c.name == filterModel.city,
          orElse: () => CityModel(
              name: '',
              arabicName: '',
              latitude: 0,
              longitude: 0,
              districts: []));
      final district = city.districts?.firstWhere(
          (d) => d.name == filterModel.districtName,
          orElse: () => DistrictModel(
              name: '',
              arabicName: '',
              latitude: 0,
              longitude: 0,
              radius: 0.0,
              neighborhoods: []));
      final neighborhood = district?.neighborhoods?.firstWhere(
          (n) => n.name == filterModel.neighborhoodName,
          orElse: () => NeighborhoodModel(
              name: '',
              arabicName: '',
              latitude: 0,
              longitude: 0,
              radius: 0.0));
      return neighborhood?.radius;
    }
    // Default if no specific distance or area radius can be determined from filterModel
    return null;
  }
// END OF _getFilterModelRadiusKm ADDITION

  Future<void> getProductsApi({bool loading = false}) async {
    if (loading) setState(() => isLoading = true);

    final url = constructUrl(filterModel);
    print("FilterItemView API URL: $url");

    ApiRequest apiRequest = ApiRequest(url: url, requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model = MapResponse.fromJson(
      response,
      (json) => HomeListModel.fromJson(json),
    );

    if (page == 1) productsList.clear();
    productsList.addAll(model.body?.data ?? []);

    // Remove expired products
    productsList.removeWhere((product) {
      if (product.approvalDate == null || product.approvalDate!.isEmpty) {
        if (product.createdAt == null || product.createdAt!.isEmpty)
          return false;
        DateTime createdDate = DateTime.parse(product.createdAt!);
        return DateTime.now().difference(createdDate).inDays > 30;
      }

      try {
        DateTime approvalDate =
            DateFormat("yyyy-MM-dd").parse(product.approvalDate!);
        DateTime expirationDate = approvalDate.add(Duration(days: 30));
        return DateTime.now().isAfter(expirationDate);
      } catch (e) {
        return false;
      }
    });

    // Add this line - you had 'false' as a standalone statement
    if (loading) setState(() => isLoading = false);

    // Force a rebuild
    setState(() {});
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    _debounce.run(() {
      page = 1;
      getProductsApi(loading: true);
    });
  }

  Future<String>? getSearchedData(BuildContext context, {String? query}) async {
    String? value;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigatorKey = AppPages.rootNavigatorKey;
      Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (context) => AppSearchView(value: query),
        ),
      ).then((result) {
        value = result?.name ?? '';
      });
    });
    
    return value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Row(
            children: Directionality.of(context) == TextDirection.RTL
                ? [
                    // For Arabic (RTL), use arrow_back_ios which flips to point right
                    IconButton(
                      onPressed: () => context.go(Routes.main),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        readOnly: true,
                        onTap: () async {
                          await getSearchedData(context, query: "");
                        },
                        focusNode: searchFocusNode,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffd5d5d5)),
                          ),
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                          hintText: StringHelper.findCarsMobilePhonesAndMore,
                        ),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          AssetsRes.IC_FILTER_ICON,
                          height: 25,
                        ),
                      ),
                    ),
                    const Gap(10),
                  ]
                : [
                    // For LTR, arrow_back_ios points left
                    IconButton(
                      onPressed: () => context.go(Routes.main),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: false,
                        readOnly: true,
                        onTap: () async {
                          await getSearchedData(context, query: "");
                        },
                        focusNode: searchFocusNode,
                        onChanged: onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffd5d5d5)),
                          ),
                          hintStyle: Theme.of(context).textTheme.labelSmall,
                          hintText: StringHelper.findCarsMobilePhonesAndMore,
                        ),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
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
        scrollController: scrollController,
        header: WaterDropHeader(
          complete: Platform.isAndroid
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator(),
        ),
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: isLoading
            ? loadingWidget(isLoading)
            : productsList.isEmpty
                ? emptyWidget()
                : dataWidget(context),
      ),
      floatingActionButton: ScrollToTopFAB(
        controller: scrollController,
        threshold: 50 * 100.0,
      ),
    );
  }

  Future<List<CategoryModel>> getSubCategory({String? id}) async {
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.getSubCategoriesUrl(id: "$id"),
      requestType: RequestType.get,
    );
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
      response,
      (json) => CategoryModel.fromJson(json),
    );
    DialogHelper.hideLoading();
    return model.body ?? [];
  }

  Widget getFilterWidget({required FilterModel? data}) {
    return Consumer<HomeVM>(
      builder: (BuildContext context, viewModel, Widget? child) {
        // ... existing filter widgets unchanged ...
        return Container();
      },
    );
  }

  Widget loadingWidget(bool isLoading) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ProductListSkeleton(isLoading: isLoading),
      ],
    );
  }

  Widget emptyWidget() {
    return Column(
      children: const [
        SizedBox(height: 20),
        Expanded(child: AppEmptyWidget()),
      ],
    );
  }

  Widget dataWidget(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: productsList.length,
      itemBuilder: (context, index) {
        var productDetails = productsList[index];
        return AppProductItemWidget(
          onItemTapped: () {
            if (productDetails.userId == DbHelper.getUserModel()?.id) {
              context.push(Routes.myProduct, extra: productDetails);
            } else {
              context.push(Routes.productDetails, extra: productDetails);
            }
          },
          data: productDetails,
          isLastItem: index == productsList.length - 1, // Add this
          totalItems: productsList.length,
          showImage: productDetails.categoryId != 9,
          screenType: "filter",
        );
      },
      separatorBuilder: (context, index) => const Gap(20),
    );
  }
}
