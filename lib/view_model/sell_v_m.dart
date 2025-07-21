import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/filter_cache_manager.dart';
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
  final FilterCacheManager _cacheManager = FilterCacheManager();

  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  StreamController<List<CategoryModel>> categoryStream =
      StreamController<List<CategoryModel>>.broadcast();
  StreamController<List<CategoryModel>> subcategoryStream =
      StreamController<List<CategoryModel>>.broadcast();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    categoryStream.close();
    subcategoryStream.close();
    super.onClose();
  }

  Future<void> getCategoryListApi() async {
    // Check cache first
    List<CategoryModel>? cachedCategories =
        _cacheManager.getFromCache(_cacheManager.categoriesKey);

    if (cachedCategories != null) {
      // Use cached data - ALWAYS add to stream
      categoryStream.sink.add(cachedCategories);
      return;
    }

    // If not cached, fetch from API
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCategoriesUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));

    List<CategoryModel> categories = model.body ?? [];

    // Add to stream
    categoryStream.sink.add(categories);

    // Save to cache
    _cacheManager.saveToCache(_cacheManager.categoriesKey, categories);
  }

  Future<void> getSubCategoryListApi({CategoryModel? category}) async {
    // Check cache first
    String cacheKey = _cacheManager.getSubCategoriesKey("${category?.id}");
    List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

    if (cachedData != null) {
      // Use cached data
      subcategoryStream.sink.add(cachedData);
      return;
    }

    // If not cached, fetch from API
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "${category?.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));

    List<CategoryModel> subcategories = model.body ?? [];

    // Add to stream
    subcategoryStream.sink.add(subcategories);

    // Save to cache
    _cacheManager.saveToCache(cacheKey, subcategories);
  }

  Future<void> getSubSubCategoryListApi(
      {required BuildContext context,
      required CategoryModel? category,
      required CategoryModel subCategory}) async {
    // Check cache first
    String cacheKey = _cacheManager.getSubSubCategoriesKey("${subCategory.id}");
    List<CategoryModel>? cachedData = _cacheManager.getFromCache(cacheKey);

    List<CategoryModel> subSubCategories;

    if (cachedData != null) {
      // Use cached data
      subSubCategories = cachedData;
    } else {
      // If not cached, fetch from API
      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getSubSubCategoriesUrl(id: "${subCategory.id}"),
          requestType: RequestType.get);

      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<CategoryModel> model = ListResponse.fromJson(
          response, (json) => CategoryModel.fromJson(json));

      subSubCategories = model.body ?? [];

      // Save to cache
      if (subSubCategories.isNotEmpty) {
        _cacheManager.saveToCache(cacheKey, subSubCategories);
      }
    }

    // Navigate based on results
    if (subSubCategories.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SellSubSubCategoryView(
                    category: category,
                    subSubCategory: subSubCategories.reversed.toList(),
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
