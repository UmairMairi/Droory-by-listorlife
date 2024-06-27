import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/location_helper.dart';
import 'package:list_and_life/models/common/list_response.dart';
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

  List<SettingItemModel> categoryItems = [];

  List<SettingItemModel> homeItemList = [];

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

  int _page = 0;

  int get page => _page;
  set page(int value) {
    _page = value;
    notifyListeners();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    updateLocation();
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
    homeItemList = [
      SettingItemModel(
          imageList: [
            AssetsRes.DUMMY_IPHONE_IMAGE1,
            AssetsRes.DUMMY_IPHONE_IMAGE2,
            AssetsRes.DUMMY_IPHONE_IMAGE3,
            AssetsRes.DUMMY_IPHONE_IMAGE4,
          ],
          title: 'EGP300',
          subTitle: 'Apple iPhone 15 Pro',
          description:
              'Open Box iPhone 15 & 14 Plus Pro Max 128GB 256GB 512GB 1TB Warranty 76',
          location: 'New York City',
          timeStamp: 'Today',
          longDescription:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
      SettingItemModel(
          imageList: [
            AssetsRes.DUMMY_CAR_IMAGE1,
            AssetsRes.DUMMY_CAR_IMAGE2,
            AssetsRes.DUMMY_CAR_IMAGE3,
            AssetsRes.DUMMY_CAR_IMAGE4,
          ],
          title: 'EGP300',
          subTitle: 'Maruti Suzuki Swift 1.2 VXI (O), 2015, Petrol',
          description: '2015 - 48000 km',
          location: 'New York City',
          timeStamp: 'Today',
          longDescription:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
    ];
  }

  Future<void> updateLocation() async {
    Position position = await LocationHelper.getCurrentLocation();
    currentLocation = await LocationHelper.getAddressFromCoordinates(
        position.latitude, position.longitude);
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    page = 0;
    productsList.clear();
    Position? position = await LocationHelper.getCurrentLocation();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductsUrl(
            limit: limit,
            page: page,
            latitude: position.latitude,
            longitude: position.longitude),
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<ProductDetailModel> model = ListResponse.fromJson(
        response, (json) => ProductDetailModel.fromJson(json));
    productsList.addAll(model.body ?? []);
    refreshController.refreshCompleted();
  }

  Future<void> onLoading() async {
    // monitor network fetch
    ++page;
    Position? position = await LocationHelper.getCurrentLocation();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductsUrl(
            limit: limit,
            page: page,
            latitude: position.latitude,
            longitude: position.longitude),
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<ProductDetailModel> model = ListResponse.fromJson(
        response, (json) => ProductDetailModel.fromJson(json));
    productsList.addAll(model.body ?? []);
    notifyListeners();

    ///await fetchProducts();
    refreshController.loadComplete();
  }

  List<ProductDetailModel> productsList = [];

  Future<List<ProductDetailModel>> getProductsApi() async {
    Position? position = await LocationHelper.getCurrentLocation();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductsUrl(
            limit: limit,
            page: page,
            latitude: position.latitude,
            longitude: position.longitude),
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<ProductDetailModel> model = ListResponse.fromJson(
        response, (json) => ProductDetailModel.fromJson(json));
    productsList.addAll(model.body ?? []);
    return productsList;
  }
}
