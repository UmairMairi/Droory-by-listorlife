import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/debouncer_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/home_list_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/helpers/db_helper.dart';
import '../models/category_model.dart';
import '../models/common/list_response.dart';

class HomeVM extends BaseViewModel {
  RefreshController refreshController = RefreshController(initialRefresh: true);
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

  int _limit = 10;

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

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  double latitude = 0.0;
  double longitude = 0.0;

  void updateLatLong({required double lat, required double long}) async {
    latitude = lat;
    longitude = long;
    currentLocation = await LocationHelper.getAddressFromCoordinates(lat, long);
    notifyListeners();
    onRefresh();
  }

  Future<void> updateLocation() async {
    Position? position;

    try {
      position = await LocationHelper.getCurrentLocation();
    } catch (e) {
      position = await LocationHelper.getCurrentLocation();
    }
    bool isEgypt = await LocationHelper.checkLocationIsEgypt(
        latitude: position.latitude, longitude: position.longitude);

    if (isEgypt) {
      latitude = position.latitude;
      longitude = position.longitude;
      currentLocation =
          await LocationHelper.getAddressFromCoordinates(latitude, longitude);
    } else {
      if (context.mounted) {
        latitude = LocationHelper.cairoLatitude;
        longitude = LocationHelper.cairoLongitude;
        currentLocation = "Cairo, Egypt";
      } else {
        latitude = LocationHelper.cairoLatitude;
        longitude = LocationHelper.cairoLongitude;
        currentLocation = "Cairo, Egypt";
      }
    }
    onRefresh();
    notifyListeners();
  }

  TextEditingController startPriceTextController =
      TextEditingController(text: '0');
  TextEditingController endPriceTextController =
      TextEditingController(text: '20000');
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
    updateLocation();
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

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    refreshController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    // monitor network fetch
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
    return model.body ?? [];
  }
}
