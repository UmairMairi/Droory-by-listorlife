import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/network/base_client.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view/main/sell/sub_sub_category/sell_sub_sub_category_view.dart';

import '../view/main/sell/forms/sell_form_view.dart';

class SellVM extends BaseViewModel {
  void handelSellCat({required CategoryModel item}) {
    if (context.mounted) {
      context.push(Routes.sellSubCategoryView, extra: item);
    } else {
      AppPages.rootNavigatorKey.currentContext
          ?.push(Routes.sellSubCategoryView, extra: item);
    }
  }

  Future<List<CategoryModel>> getCategoryListApi() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCategoriesUrl(), requestType: RequestType.GET);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));

    return model.body ?? [];
  }

  Future<List<CategoryModel>> getSubCategoryListApi(
      {CategoryModel? category}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "${category?.id}"),
        requestType: RequestType.GET);

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
        requestType: RequestType.GET);

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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SellFormView(
                    category: category,
                    subCategory: subCategory,
                    type: category?.name?.toLowerCase(),
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
