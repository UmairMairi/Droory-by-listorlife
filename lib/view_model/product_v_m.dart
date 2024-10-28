import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';

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

    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.showToast(message: model.message);
    DialogHelper.hideLoading();
    if (context.mounted) context.pop();
  }

  List<Widget> getSpecifications(
      {required BuildContext context, ProductDetailModel? data}) {
    List<Widget> specs = [];

    // Existing specifications for model, RAM, storage, etc.
    if (data?.modelId != null && data!.modelId != 0) {
      specs.add(_buildSpecRow(context, 'Model', '${data.model?.name}'));
    }

    if (data?.ram != null && data!.ram != 0) {
      specs.add(_buildSpecRow(context, 'RAM', '${data.ram} GB'));
    }
    if (data?.storage != null && data!.storage != 0) {
      specs.add(_buildSpecRow(context, 'Storage', '${data.storage} GB'));
    }
    if (data?.screenSize != null && data!.screenSize!.isNotEmpty) {
      specs.add(_buildSpecRow(context, 'Screen Size', "${data.screenSize}"));
    }
    if (data?.material != null && data!.material!.isNotEmpty) {
      specs.add(_buildSpecRow(context, 'Material', "${data.material}"));
    }
    if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
      specs.add(_buildSpecRow(context, 'Condition', "${data.itemCondition}"));
    }

    // Specifications for cars (categoryId == 4)
    if (data?.categoryId == 4) {
      if (data?.transmission != null && data!.transmission!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, 'Transmission', "${data.transmission}"));
      }
      if (data?.kmDriven != null) {
        specs.add(_buildSpecRow(context, 'KM Driven', '${data?.kmDriven} km'));
      }
      if (data?.numberOfOwner != null && data!.numberOfOwner != 0) {
        specs.add(_buildSpecRow(
            context, 'Number of Owners', '${data.numberOfOwner}'));
      }
    }

    // New specifications for properties
    if (data?.propertyFor != null && data!.propertyFor!.isNotEmpty) {
      specs.add(_buildSpecRow(context, 'Property For', "${data.propertyFor}"));
    }
    if (data?.bedrooms != null && data!.bedrooms != 0) {
      specs.add(_buildSpecRow(context, 'Bedrooms', "${data.bedrooms}"));
    }
    if (data?.bathrooms != null && data!.bathrooms != 0) {
      specs.add(_buildSpecRow(context, 'Bathrooms', "${data.bathrooms}"));
    }
    if (data?.furnishedType != null && data!.furnishedType!.isNotEmpty) {
      specs.add(
          _buildSpecRow(context, 'Furnished Type', "${data.furnishedType}"));
    }
    if (data?.ownership != null && data!.ownership!.isNotEmpty) {
      specs.add(_buildSpecRow(context, 'Ownership', "${data.ownership}"));
    }
    if (data?.paymentType != null && data!.paymentType!.isNotEmpty) {
      specs.add(_buildSpecRow(context, 'Payment Type', "${data.paymentType}"));
    }
    if (data?.completionStatus != null && data!.completionStatus!.isNotEmpty) {
      specs.add(_buildSpecRow(
          context, 'Completion Status', "${data.completionStatus}"));
    }
    if (data?.deliveryTerm != null && data!.deliveryTerm!.isNotEmpty) {
      specs
          .add(_buildSpecRow(context, 'Delivery Term', "${data.deliveryTerm}"));
    }

    // Additional Vehicle Specifications for Cars (categoryId == 4)
    if (data?.categoryId == 4) {
      if (data?.year != null && data!.year != 0) {
        specs.add(_buildSpecRow(context, 'Year', "${data.year}"));
      }
      if (data?.milleage != null && data!.milleage!.isNotEmpty) {
        specs.add(_buildSpecRow(context, 'Mileage', '${data.milleage} km'));
      }
      if (data?.fuel != null && data!.fuel!.isNotEmpty) {
        specs.add(_buildSpecRow(context, 'Fuel', '${data.fuel}'));
      }
    }

    if (data?.nearby != null && data!.nearby!.isNotEmpty) {
      specs.add(_buildSpecRow(
          context, 'Location', '${data.nearby?.split(',').last}'));
    }
    if (data?.createdAt != null && data!.createdAt!.isNotEmpty) {
      specs.add(_buildSpecRow(
          context,
          'Posted At',
          DateFormat('dd MMM yyyy')
              .format(DateTime.parse('${data.createdAt}'))));
    }

    return specs.isNotEmpty
        ? [
            ...specs,
          ]
        : [];
  }

  Widget _buildSpecRow(
      BuildContext context, String specName, String specValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          specName,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        Text(specValue),
      ],
    );
  }
}
