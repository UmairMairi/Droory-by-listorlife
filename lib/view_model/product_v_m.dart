import 'dart:developer';

import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/network/base_client.dart';

class ProductVM extends BaseViewModel {
  Future<ProductDetailModel?> getProductDetails({num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductUrl(id: '$id'),
        requestType: RequestType.GET);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<ProductDetailModel> model =
        MapResponse<ProductDetailModel>.fromJson(
            response, (json) => ProductDetailModel.fromJson(json));

    return model.body;
  }

  Future<void> onLikeButtonTapped({required num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addFavouriteUrl(),
        requestType: RequestType.POST,
        body: {'product_id': id});

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);

    log("Fav Message => ${model.message}");
  }
}
