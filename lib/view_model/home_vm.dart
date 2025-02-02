import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/debouncer_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/home_list_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/helpers/db_helper.dart';
import '../base/helpers/dialog_helper.dart';
import '../models/category_model.dart';
import '../models/common/list_response.dart';
import '../models/filter_model.dart';
import '../routes/app_routes.dart';
import '../view/main/home/sub_category_view.dart';

class HomeVM extends BaseViewModel {
  late Future<List<CategoryModel>> cachedCategoryList;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();
  String _currentLocation = '';

  String get currentLocation => _currentLocation;
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 1000);
  String searchQuery = '';

  List<ProductDetailModel> productsList = [];
  List<CategoryModel> categories = [];

  FocusNode searchFocusNode = FocusNode();

  String _publishedBy = 'Posted Within';

  String get publishedBy => _publishedBy;

  set publishedBy(String value) {
    _publishedBy = value;
    notifyListeners();
  }

  set currentLocation(String value) {
    _currentLocation = value;
    notifyListeners();
  }

  int _limit = 20;

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
    notifyListeners();
  }

  int _page = 1;

  int get page => _page;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  bool _loading = true;

  set isLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get isLoading => _loading;

  int _itemCondition = 0;

  int get itemCondition => _itemCondition;

  set itemCondition(int value) {
    _itemCondition = value;
    notifyListeners();
  }

  double latitude = 0.0;
  double longitude = 0.0;

  void updateLatLong(
      { double? lat,
       double? long,
      String? type,
      String? address}) async {
    if(lat != null && long != null){
      latitude = lat;
      longitude = long;
      if (type == null) {
        currentLocation =
        await LocationHelper.getAddressFromCoordinates(lat, long);
      } else {
        currentLocation = address ?? "";
      }
      DbHelper.saveLastLocation(UserModel(
          latitude: latitude, longitude: longitude, address: currentLocation));
    }else{
      latitude = 0.0;
      longitude = 0.0;
    }
    notifyListeners();
    onRefresh();
  }

  Future<void> updateLocation() async {
    // Retrieve the last known location if available
    var userAddress = DbHelper.getLastLocation();
    if (userAddress != null) {
      latitude = userAddress.latitude;
      longitude = userAddress.longitude;
      currentLocation = userAddress.address;
    }else{
      Position? position;
      try {
        position = await LocationHelper.getCurrentLocation();
      } catch (e) {
        debugPrint("Error getting location: $e");
        position = null;
      }

      // If we couldn't get the location, use Cairo as the fallback
      if (position == null) {
        _setDefaultCairoLocation();
      } else {
        bool isEgypt = await LocationHelper.checkLocationIsEgypt(
            latitude: position.latitude, longitude: position.longitude);

        if (isEgypt) {
          latitude = position.latitude;
          longitude = position.longitude;
          currentLocation = await LocationHelper.getAddressFromCoordinates(
              latitude, longitude);
        } else {
          _setDefaultCairoLocation();
        }
      }

      _saveLocation();
      onRefresh();
      notifyListeners();
    }
  }

  /// **Helper method to set Cairo as the fallback location**
  void _setDefaultCairoLocation() {
    latitude = LocationHelper.cairoLatitude;
    longitude = LocationHelper.cairoLongitude;
    currentLocation = "Cairo, Egypt";
  }

  /// **Helper method to save location to the database**
  void _saveLocation() {
    if (context.mounted) {
      DbHelper.saveLastLocation(UserModel(
        latitude: latitude,
        longitude: longitude,
        address: currentLocation,
      ));
    }
  }


  TextEditingController startPriceTextController =
      TextEditingController(text: '0');
  TextEditingController endPriceTextController =
      TextEditingController(text: '100000');

  TextEditingController locationTextController = TextEditingController();
  TextEditingController categoryTextController = TextEditingController();
  TextEditingController subCategoryTextController = TextEditingController();
  TextEditingController brandsTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  TextEditingController sortByTextController = TextEditingController();
  TextEditingController postedWithinTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController transmissionTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController kmDrivenTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();

  // List of mileage ranges
  final List<String> mileageRanges = [
    '0-5 km',
    '5-10 km',
    '10-15 km',
    '15-20 km',
    '20-25 km',
    '25-30 km',
    '30-35 km',
    '35-40 km',
    '40-45 km',
    '45-50 km',
  ];

  TextEditingController searchController = TextEditingController();

  List<String> searchQueryesList = [];

  List<String> jobPositionList = [
    'Contract',
    'Full Time',
    'Part-time',
    'Temporary'
  ];

  List<String> salaryPeriodList = ['Hourly', 'Monthly', 'Weekly', 'Yearly'];

  @override
  void onInit() {
    // TODO: implement onInit
    callApiMethods();
    searchQueryesList.addAll(DbHelper.getSearchHistory().reversed.toList());

    searchQueryesList.addAll([
      'Electronics',
      'Home & Living',
      'Fashion',
      'Vehicles',
      'Hobbies, Music, Art & Books',
      'Pets',
      'Business & Industrial',
      'Services',
      'Jobs',
      'Mobiles & Tablets'
    ]);
    refreshController = RefreshController(initialRefresh: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateLocation();
    });
    super.onInit();
  }

  callApiMethods() async {
    cachedCategoryList = getCategoryListApi();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    //refreshController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    try {
      page = 1;
      productsList.clear();
      await getProductsApi(loading: true);
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoading() async {
    // monitor network fetch
    ++page;
    await getProductsApi(loading: false);

    ///await fetchProducts();
    refreshController.loadComplete();
  }

  Future<void> getProductsApi({bool loading = false, String? search}) async {
    if (loading) isLoading = loading;

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductsUrl(
            limit: limit,
            page: page,
            latitude: latitude,
            longitude: longitude,
            sellStatus: 'ongoing',
            search: searchQuery), // Add search parameter
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));
    if (search?.isNotEmpty ?? false) {
      productsList.clear();
    }

    productsList.addAll(model.body?.data ?? []);

    if (loading) isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      onRefresh();
    }

    searchQuery = query;
    _debounce.run(() {
      page = 1;
      productsList.clear();
      getProductsApi(search: searchQuery, loading: true);
      DbHelper.saveSearchQuery(query);
    });
  }

  Future<List<CategoryModel>> getCategoryListApi() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCategoriesUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));

    categories = model.body ?? [];

    return model.body ?? [];
  }

  Future<List<CategoryModel>> getSubCategoryListApi(
      {CategoryModel? category}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "${category?.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    return model.body??[];
  }

  Future<void> getSubSubCategoryListApi(
      {required CategoryModel? category,
      required CategoryModel subCategory}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubSubCategoriesUrl(id: "${subCategory.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    List<CategoryModel> modelList = [];
    if(category?.id == 11 && [83, 84, 87, 88,90].contains(subCategory.id)){
      modelList.add(CategoryModel(name: "Rent"));
      modelList.add(CategoryModel(name: "Sell"));
    }else{
      modelList =  model.body ?? [];
    }

    if (modelList.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubSubCategoryView(
                    category: category,
                    subSubCategory: modelList.reversed.toList() ?? [],
                    subCategory: subCategory,
                    latitude: "$latitude",
                    longitude: "$longitude",
                  )));
    } else {
      context.push(Routes.filterDetails,
          extra: FilterModel(
            categoryId: "${category?.id}",
            subcategoryId: "${subCategory.id ?? ""}",
            latitude: "$latitude",
            longitude: "$longitude",
          ));
    }

    DialogHelper.hideLoading();
  }

  /// new text controllers
  TextEditingController propertyForTextController = TextEditingController();
  TextEditingController propertyForTypeTextController = TextEditingController();
  TextEditingController noOfBathroomsTextController = TextEditingController();
  TextEditingController noOfBedroomsTextController = TextEditingController();
  TextEditingController furnishingStatusTextController =
      TextEditingController();

  TextEditingController accessToUtilitiesTextController =
      TextEditingController();
  TextEditingController ownershipStatusTextController = TextEditingController();
  TextEditingController paymentTypeTextController = TextEditingController();
  TextEditingController listedByTextController = TextEditingController();
  TextEditingController rentalTermsTextController = TextEditingController();
  TextEditingController completionStatusTextController =
      TextEditingController();
  TextEditingController deliveryTermTextController = TextEditingController();
  TextEditingController levelTextController = TextEditingController();

  TextEditingController startDownPriceTextController =
      TextEditingController(text: '0');
  TextEditingController endDownPriceTextController =
      TextEditingController(text: '100000');

  TextEditingController startAreaTextController =
      TextEditingController(text: '0');
  TextEditingController endAreaTextController =
      TextEditingController(text: '100000');
  String _currentPropertyType = "Sell";

  String get currentPropertyType => _currentPropertyType;

  set currentPropertyType(String index) {
    _currentPropertyType = index;
    notifyListeners();
  }

  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
}
