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
import '../base/helpers/string_helper.dart';
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
      {double? lat, double? long, String? type, String? address}) async {
    if (lat != null && long != null) {
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
    } else {
      latitude = 0.0;
      longitude = 0.0;
      currentLocation = address ?? "";
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
    } else {
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
  TextEditingController sizesTextController = TextEditingController();
  TextEditingController subSubCategoryTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  TextEditingController sortByTextController = TextEditingController();
  TextEditingController postedWithinTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController transmissionTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController screenSizeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController carRentalTermController = TextEditingController();
  TextEditingController minKmDrivenTextController =
      TextEditingController(text: '0');
  TextEditingController maxKmDrivenTextController =
      TextEditingController(text: '1000000');
  TextEditingController bodyTypeTextController = TextEditingController();
  TextEditingController horsePowerTextController = TextEditingController();
  TextEditingController carColorTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController workSettingTextController = TextEditingController();
  TextEditingController workExperienceTextController = TextEditingController();
  TextEditingController ramTextController = TextEditingController();
  TextEditingController storageTextController = TextEditingController();
  TextEditingController workEducationTextController = TextEditingController();
  TextEditingController engineCapacityTextController = TextEditingController();
  TextEditingController interiorColorTextController = TextEditingController();
  TextEditingController numbCylindersTextController = TextEditingController();
  TextEditingController numbDoorsTextController = TextEditingController();

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
    StringHelper.contract,
    StringHelper.fullTime,
    StringHelper.partTime,
    StringHelper.temporary
  ];

  List<String> salaryPeriodList = ['Hourly', 'Monthly', 'Weekly', 'Yearly'];
  final List<String> carRentalTermOptions = ['Daily', 'Monthly', 'Yearly'];
  final List<String> bodyTypeOptions = [
    'SUV',
    'Hatchback',
    '4x4',
    'Sedan',
    'Coupe',
    'Convertible',
    'Estate',
    'MPV',
    'Pickup',
    'Crossover',
    'Van/bus',
    'Other',
  ];

  final List<String> horsepowerOptions = [
    'Less than 100 HP',
    '100 - 200 HP',
    '200 - 300 HP',
    '300 - 400 HP',
    '400 - 500 HP',
    '500 - 600 HP',
    '600 - 700 HP',
    '700 - 800 HP',
    '800+ HP',
    'Other',
  ];

  final List<String> engineCapacityOptions = [
    'Below 500 cc',
    '500 - 999 cc',
    '1000 - 1499 cc',
    '1500 - 1999 cc',
    '2000 - 2499 cc',
    '2500 - 2999 cc',
    '3000 - 3499 cc',
    '3500 - 3999 cc',
    '4000+ cc',
    'Other',
  ];

  final List<String> numbCylindersOptions = [
    '2 Cylinders',
    '3 Cylinders',
    '4 Cylinders',
    '5 Cylinders',
    '6 Cylinders',
    '7 Cylinders',
    '8 Cylinders',
    'Other',
  ];
  List<String> ramOptions = ['2 GB', '4 GB', '6 GB', '8 GB', '12 GB', '16 GB'];
  List<String> storageOptions = [
    '1 GB',
    '2 GB',
    '4 GB',
    '8 GB',
    '64 GB',
    '128 GB',
    '256 GB',
    '512 GB',
    '1 TB'
  ];
  final List<String?> phoneRamOptions = [
    "2 GB",
    "3 GB",
    "4 GB",
    "6 GB",
    "8 GB",
    "12 GB",
    "16 GB",
  ];
  final List<String?> phoneStorageOptions = [
    "16 GB",
    "32 GB",
    "64 GB",
    "128 GB",
    "256 GB",
    "512 GB",
    "1 TB",
  ];
  final List<String> numbDoorsOptions = [
    '2 Doors',
    '3 Doors',
    '4 Doors',
    '5+ Doors',
  ];
  final List<String> experienceOptions = [
    "No experience/Just graduated",
    "1–3 yrs",
    "3–5 yrs",
    "5–10 yrs",
    "10+ yrs"
  ];
  final List<String> workSettingOptions = [
    "Remote",
    "Office-based",
    "Mixed (Home & Office)",
    "Field-based"
  ];
  final List<String> tvSizeOptions = [
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
    'Other'
  ];
  final List<String> workEducationOptions = [
    "None",
    "Student",
    "High-Secondary School",
    "Diploma",
    "Bachelors Degree",
    "Masters Degree",
    "Doctorate/PhD"
  ];
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

  num _countMessage = 0;

  num get countMessage => _countMessage;

  set countMessage(num value) {
    _countMessage = value;
    notifyListeners();
  }

  Future<void> getChatNotifyCount() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getChatNotifyCount(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel?> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));
    if (model.body != null) {
      countMessage = model.body?.count_notification ?? 0;
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    try {
      page = 1;
      productsList.clear();
      if (!DbHelper.getIsGuest()) {
        getChatNotifyCount();
      }
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
    return model.body ?? [];
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
    if (category?.id == 11 && [83, 84, 87, 88, 90].contains(subCategory.id)) {
      modelList.add(CategoryModel(name: "Rent"));
      modelList.add(CategoryModel(name: "Sell"));
    } else {
      modelList = model.body ?? [];
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

  void clearLocation() {
    DbHelper.clearLocationSearchHistory();
    notifyListeners();
  }
}
