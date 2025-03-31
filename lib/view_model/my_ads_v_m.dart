import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/helpers/date_helper.dart';
import '../base/helpers/db_helper.dart';
import '../base/helpers/string_helper.dart';
import '../base/network/api_constants.dart';
import '../base/network/api_request.dart';
import '../base/network/base_client.dart';
import '../models/common/map_response.dart';
import '../models/home_list_model.dart';
import '../models/product_detail_model.dart';
import '../res/assets_res.dart';
import '../view/main/sell/forms/sell_form_view.dart';
import '../view/product/my_product_view.dart';
import '../widgets/app_elevated_button.dart';

class MyAdsVM extends BaseViewModel {
  RefreshController refreshController = RefreshController(initialRefresh: true);
  int _selectIndex = 0;

  int get selectIndex => _selectIndex;

  set selectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  int _limit = 1000;

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
  List<ProductDetailModel> allAds = [];
  List<ProductDetailModel> liveAds = [];
  List<ProductDetailModel> underReviewAds = [];
  List<ProductDetailModel> draftAds = [];
  List<ProductDetailModel> expiredAds = [];
  List<ProductDetailModel> rejectedAds = [];

  int selectedFilter = 0; // Tracks the currently selected filter

  bool _isGuest = DbHelper.getIsGuest();

  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  bool _learnMore = false;

  bool get learnMore => _learnMore;

  set learnMore(bool value) {
    _learnMore = value;
    notifyListeners();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    // DbHelper.box.listenKey('isGuest', (value) {
    //   isGuest = DbHelper.getIsGuest();
    // });
    // if (!isGuest) onRefresh();
    super.onInit();
  }

  @override
  void onReady(){
    // TODO: implement onReady
    DbHelper.box.listenKey('isGuest', (value) {
      isGuest = DbHelper.getIsGuest();
    });
    if (!isGuest) onRefresh();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    //refreshController.dispose();
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
            limit: 1000, page: 1, userId: "${DbHelper.getUserModel()?.id}"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));
    allAds.clear();
    liveAds.clear();
    underReviewAds.clear();
    expiredAds.clear();
    rejectedAds.clear();
    allAds.addAll(model.body?.data ?? []);

    // Categorize ads based on their status
    liveAds = allAds
        .where((ad) => ad.status == 1 && ad.sellStatus == 'ongoing')
        .toList();
    underReviewAds = allAds.where((ad) => ad.status == 0).toList();
    expiredAds = allAds
        .where((ad) =>
            DateTime.now()
                .difference(DateTime.parse(ad.createdAt ?? ''))
                .inDays >
            30)
        .toList();
    rejectedAds = allAds.where((ad) => ad.status == 2).toList();

    // Set initial filter to All Ads
    changeFilter(selectedFilter);

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
    debugPrint("$response");
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.showToast(message: model.message);
    DialogHelper.hideLoading();
    onRefresh();
  }

  Future<void> handelPopupMenuItemClick(
      {required BuildContext context,
      required int index,
      required ProductDetailModel? item,
      bool isDetailsPage = false}) async {
    switch (index) {
      case 1:
        navigateToEditProduct(context: context, item: item);

        return;
      case 2:
        deactivateDialog(context: context,
            title: StringHelper.deactivate,
            description: StringHelper.deactivate.toLowerCase(),
            onTap: ()async{
          await deactivateProductApi(id: item?.id,status: "deactivate");
          if (context.mounted) context.pop();
        });

        return;
      case 3:
        deactivateDialog(context: context,
            title: StringHelper.remove,
            description: StringHelper.remove.toLowerCase(),
            onTap: ()async{
              await removeProductApi(id: item?.id);
              if (context.mounted) context.pop();
            });

      case 4:
        navigateToEditProduct(context: context, item: item);
        // deactivateDialog(context: context,
        //     title: "Republish",
        //     description: "Republish",
        //     image: AssetsRes.TICK_MARK_LOTTIE,
        //     onTap: ()async{
        //       await deactivateProductApi(id: item?.id,status: "activate");
        //       if (context.mounted) context.pop();
        //     });
      default:
        return;
    }
  }
  void deactivateDialog({required BuildContext context,String? title,String? description,String? image,required Function() onTap}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppAlertDialogWithLottie(
          lottieIcon: image ??AssetsRes.DELETE_LOTTIE,
          title: title??"",
          description: 'Are you sure you want to ${description??""} this ad?',
          onTap: () {
            context.pop();
            DialogHelper.showLoading();
            onTap();
          },
          onCancelTap: () {
            context.pop();
          },
          buttonText: StringHelper.yes,
          cancelButtonText: StringHelper.no,
          showCancelButton: true,
        );
      },
    );
  }

  Future<void> removeProductApi({num? id}) async {
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

  Future<void> deactivateProductApi({num? id,String? status}) async {
    DialogHelper.showLoading();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deactivateProductUrl(),
        requestType: RequestType.put,
        body: {'product_id': id, 'ad_status': status});

    var response = await BaseClient.handleRequest(apiRequest);

    log("response => $response");

    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);
    onRefresh();
  }

  void navigateToEditProduct(
      {ProductDetailModel? item, required BuildContext context}) async {
    CategoryModel category = CategoryModel(
        id: item?.categoryId?.toInt(), name: item?.category?.name, type: item?.category?.type);
    CategoryModel subCategory = CategoryModel(
        id: item?.subCategoryId?.toInt(), name: item?.subCategory?.name, type: item?.subCategory?.type);
    CategoryModel subSubCategory = CategoryModel(
        id: item?.subSubCategoryId?.toInt(), name: item?.subSubCategory?.name, type: item?.subSubCategory?.type);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SellFormView(
              screenType: "edit",
                  category: category,
                  subSubCategory: subSubCategory,
                  subCategory: subCategory,
                  type: category.type?.toLowerCase(),
                  item: item,
                ))).then((value){
                  if(value != null){
                  Provider.of<ProductVM>(context, listen: false).getMyProductDetails(id: item?.id);

                  }
    });
    onRefresh();
  }

  // Method to change the selected filter and update the filtered list
  void changeFilter(int filterIndex) {
    selectedFilter = filterIndex;

    switch (filterIndex) {
      case 0: // All Ads
        productsList = allAds;
        notifyListeners();
        break;
      case 1: // Live Ads
        productsList = liveAds;
        notifyListeners();
        break;
      case 2: // Under Review Ads
        productsList = underReviewAds;
        notifyListeners();
        break;
      case 3: // Drafts
        productsList = draftAds;
        notifyListeners();
        break;
      case 4: // Expired Ads
        productsList = expiredAds;
        notifyListeners();
        break;
      case 5: // Rejected Ads
        productsList = rejectedAds;
        notifyListeners();
        break;
      default:
        productsList = allAds;
        notifyListeners();
    }

    notifyListeners(); // To update UI with the filtered list
  }

  Widget getStatus({required BuildContext context,required ProductDetailModel productDetails}) {
    switch (productDetails.status) {
      case 0:
        if (DateTime.now().difference(DateTime.parse(productDetails.createdAt ?? '')).inDays >
            30) {
          return AppElevatedButton(
            onTap: () {},
            title: StringHelper.expiredAds,
            height: 30,
            width: 100,
            backgroundColor: Colors.red, // Red for Expired Ads
          );
        }
        return AppElevatedButton(
          onTap: () {},
          title: StringHelper.review,
          height: 30,
          width: 100,
          backgroundColor: Colors.amber,
        );

      case 1:
        return productDetails.sellStatus?.toLowerCase() != StringHelper.sold.toLowerCase()
            ? AppElevatedButton(
                onTap: () {},
                title: StringHelper.active,
                height: 30,
                width: 100,
                backgroundColor: Colors.green,
              )
            : AppElevatedButton(
                title: StringHelper.sold,
                height: 30,
                width: 100,
                backgroundColor: Colors.grey,
              );
      case 2:
        return AppElevatedButton(
          title: StringHelper.rejected,
          height: 30,
          width: 100,
          backgroundColor: Colors.brown,
        );
      default:
        return AppElevatedButton(
          title: StringHelper.expiredAds,
          height: 30,
          width: 100,
          backgroundColor: Colors.red, // Red for Expired Ads
        );
    }
  }

  Widget getRemainDays({required ProductDetailModel item}) {
    String approvalDateString = item.approvalDate ?? '';

    if (approvalDateString.isNotEmpty) {
      DateTime approvalDate =
          DateFormat("yyyy-MM-dd").parse(approvalDateString);

      // Calculate the expiration date by adding 30 days
      DateTime expirationDate = approvalDate.add(Duration(days: 30));

      // Calculate the difference in days from today
      DateTime today = DateTime.now();
      int remainingDays = expirationDate.difference(today).inDays;

      // Check if the date is expired
      if (remainingDays <= 0) {
        return Text(
          'Expired',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
        );
      } else {
        return Text(
          'Ad Expires in : $remainingDays Days',
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w800, fontSize: 12),
        );
      }
    }
    return SizedBox.shrink();
  }
}
