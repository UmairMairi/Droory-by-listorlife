import 'dart:developer';

import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';

import '../base/helpers/dialog_helper.dart';

class ProductVM extends BaseViewModel {
  Future<ProductDetailModel?> getProductDetails({num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductUrl(id: '$id'),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<ProductDetailModel> model =
        MapResponse<ProductDetailModel>.fromJson(
            response, (json) => ProductDetailModel.fromJson(json));

    return model.body;
  }

  Future<void> onLikeButtonTapped({required num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addFavouriteUrl(),
        requestType: RequestType.post,
        body: {'product_id': id});

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);

    log("Fav Message => ${model.message}");
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
    if (context.mounted) context.pop();
  }
}
