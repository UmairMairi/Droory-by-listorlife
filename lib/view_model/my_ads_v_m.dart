import 'dart:developer';

import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/helpers/date_helper.dart';
import '../base/helpers/db_helper.dart';
import '../models/common/map_response.dart';
import '../models/home_list_model.dart';
import '../models/prodect_detail_model.dart';
import '../base/network/api_constants.dart';
import '../base/network/api_request.dart';
import '../base/network/base_client.dart';

class MyAdsVM extends BaseViewModel {
  late RefreshController refreshController;
  int _selectIndex = 0;

  int get selectIndex => _selectIndex;

  set selectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  int _limit = 30;

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

  List<ProductDetailModel> productsList = [];
  @override
  void onInit() {
    // TODO: implement onInit
    refreshController = RefreshController(initialRefresh: true);
    super.onInit();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
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

  Future<void> getProductsApi({bool loading = false}) async {
    if (loading) isLoading = loading;
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getUsersProductsUrl(
            limit: limit, page: page, userId: "${DbHelper.getUserModel()?.id}"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));
    productsList.addAll(model.body?.data ?? []);

    if (loading) isLoading = false;
    notifyListeners();
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

    return DateHelper.getTimeAgo(timestamp);
  }

  Future<void> markAsSoldApi({required ProductDetailModel product}) async {
    Map<String, dynamic> body = {
      'product_id': product.id,
      'sell_status': 'sold'
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.markAsSoldUrl(),
        requestType: RequestType.put,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);
    print(response);
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.showToast(message: model.message);
    DialogHelper.hideLoading();
    onRefresh();
  }

  void handelPopupMenuItemClick(
      {required int index, required ProductDetailModel? item}) {
    switch (index) {
      case 1:
        /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProductForm(
                      product: item,
                    )));*/
        return;
      case 2:
        deactivateProductApi(id: item?.id);
        return;
      case 3:
        removeProductApi(id: item?.id);
      default:
        return;
    }
  }

  void removeProductApi({num? id}) async {
    DialogHelper.showLoading();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deleteProductUrl(),
        requestType: RequestType.delete,
        body: {'product_id': id});

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);
    onRefresh();
  }

  void deactivateProductApi({num? id}) async {
    DialogHelper.showLoading();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deactivateProductUrl(),
        requestType: RequestType.put,
        body: {'product_id': id, 'status': '0'});

    var response = await BaseClient.handleRequest(apiRequest);

    log("response => $response");

    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);
    onRefresh();
  }
}
