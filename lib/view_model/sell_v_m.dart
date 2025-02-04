import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view/main/sell/sub_sub_category/sell_sub_sub_category_view.dart';
import 'package:list_and_life/view_model/sell_forms_vm.dart';
import 'package:provider/provider.dart';

import '../base/helpers/db_helper.dart';
import '../view/main/sell/forms/sell_form_view.dart';

class SellVM extends BaseViewModel {

  bool _isGuest = DbHelper.getIsGuest();

  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }
  // void handelSellCat({required CategoryModel item}) {
  //   if (context.mounted) {
  //     context.push(Routes.sellSubCategoryView, extra: item);
  //   } else {
  //     AppPages.rootNavigatorKey.currentContext
  //         ?.push(Routes.sellSubCategoryView, extra: item);
  //   }
  // }

  StreamController<List<CategoryModel>> categoryStream = StreamController<List<CategoryModel>>.broadcast();
  StreamController<List<CategoryModel>> subcategoryStream = StreamController<List<CategoryModel>>.broadcast();

  Future<void> getCategoryListApi() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCategoriesUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));

    categoryStream.sink.add(model.body ?? []);
  }

  Future<void> getSubCategoryListApi(
      {CategoryModel? category}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "${category?.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    subcategoryStream.sink.add(model.body ?? []);
  }

  Future<void> getSubSubCategoryListApi(
      {required BuildContext context,
      required CategoryModel? category,
      required CategoryModel subCategory}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubSubCategoriesUrl(id: "${subCategory.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));

    if (model.body?.isNotEmpty ?? false) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SellSubSubCategoryView(
                    category: category,
                    subSubCategory: model.body?.reversed.toList() ?? [],
                    subCategory: subCategory,
                  )));
    } else {
      context.read<SellFormsVM>().allModels.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SellFormView(
                    category: category,
                    subCategory: subCategory,
                    type: category?.type?.toLowerCase(),
                  )));
    }

    DialogHelper.hideLoading();
  }
}

class Item {
  String? title;
  String? type;
  String? image;
  int? id;
  List<Item>? subCategories;
  List<String>? brands;

  Item({
    this.id,
    this.type,
    this.subCategories,
    this.brands,
    this.title,
    this.image,
  });
}
