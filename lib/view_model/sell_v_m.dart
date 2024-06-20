import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/network/base_client.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/routes/app_routes.dart';

class SellVM extends BaseViewModel {
  void handelSellCat({required CategoryModel item}) {
    if (context.mounted) {
      context.push(Routes.sellSubCategoryView, extra: item);
    } else {
      AppPages.rootNavigatorKey?.currentContext
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
