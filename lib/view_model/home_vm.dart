import 'package:geolocator/geolocator.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/debouncer_helper.dart';
import 'package:list_and_life/helpers/location_helper.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/home_list_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/network/base_client.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/setting_item_model.dart';

class HomeVM extends BaseViewModel {
  late RefreshController refreshController;
  String _currentLocation = "";
  String get currentLocation => _currentLocation;
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);
  String searchQuery = '';
  List<SettingItemModel> categoryItems = [];

  List<ProductDetailModel> productsList = [];

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

  @override
  void onInit() {
    // TODO: implement onInit
    refreshController = RefreshController(initialRefresh: true);
    initCategories();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    refreshController.dispose();
    super.onClose();
  }

  void initCategories() {
    categoryItems = [
      SettingItemModel(icon: AssetsRes.IC_CAT_CAR, title: 'Cars', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_MOBILE, title: 'Mobile', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_LAPTOP, title: 'Laptops', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_FURNITURE, title: 'Furniture', onTap: () {}),
      SettingItemModel(
          icon: AssetsRes.IC_CAT_CLOTHS, title: 'Clothes', onTap: () {}),
    ];
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    page = 1;
    productsList.clear();
    await getProductsApi(loading: true);
    refreshController.refreshCompleted();
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

    Position? position;
    try {
      position = await LocationHelper.getCurrentLocation();
    } catch (e) {
      position = await LocationHelper.getCurrentLocation();
    }
    currentLocation = await LocationHelper.getAddressFromCoordinates(
        position.latitude, position.longitude);

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductsUrl(
            limit: limit,
            page: page,
            latitude: position.latitude,
            longitude: position.longitude,
            sellStatus: 'ongoing',
            search: searchQuery), // Add search parameter
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));

    productsList.clear();
    productsList.addAll(model.body?.data ?? []);

    if (loading) isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    _debounce.run(() {
      getProductsApi(search: searchQuery, loading: true);
    });
  }
}
