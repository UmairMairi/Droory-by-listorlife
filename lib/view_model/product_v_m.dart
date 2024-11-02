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

    // Electronics Specifications
    if (data?.categoryId == 1) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(context, '${data.model?.name}', '📱', 'Model'));
      }
      if (data?.ram != null && data!.ram != 0) {
        specs.add(_buildSpecRow(context, '${data.ram} GB', '🧠', 'RAM'));
      }
      if (data?.storage != null && data!.storage != 0) {
        specs
            .add(_buildSpecRow(context, '${data.storage} GB', '💾', 'Storage'));
      }
      if (data?.screenSize != null && data!.screenSize!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.screenSize}", '📏', 'Screen Size'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.itemCondition}", '🔍', 'Condition'));
      }
    }

    // Home & Living Specifications
    if (data?.categoryId == 2) {
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.itemCondition}", '🛋️', 'Condition'));
      }
      if (data?.material != null && data!.material!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.material}", '🪵', 'Material'));
      }
    }

    // Fashion Specifications
    if (data?.categoryId == 3) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(context, '${data.model?.name}', '👗', 'Model'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.itemCondition}", '🔍', 'Condition'));
      }
    }

    // Vehicles Specifications
    if (data?.categoryId == 4) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(context, '${data.model?.name}', '🚗', 'Model'));
      }
      if (data?.year != null && data!.year != 0) {
        specs.add(_buildSpecRow(context, "${data.year}", '📅', 'Year'));
      }
      if (data?.fuel != null && data!.fuel!.isNotEmpty) {
        specs.add(_buildSpecRow(context, '${data.fuel}', '⛽', 'Fuel'));
      }
      if (data?.milleage != null && data!.milleage!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, '${data.milleage} km', '🔋', 'Mileage'));
      }
      if (data?.kmDriven != null) {
        specs.add(
            _buildSpecRow(context, '${data?.kmDriven} km', '🚙', 'KM Driven'));
      }
      if (data?.transmission != null && data!.transmission!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.transmission}", '⚙️', 'Transmission'));
      }
      if (data?.numberOfOwner != null && data!.numberOfOwner != 0) {
        specs.add(_buildSpecRow(
            context, '${data.numberOfOwner} Owners', '👤', 'Number of Owners'));
      }
    }

    // Hobbies, Music, Art & Books Specifications
    if (data?.categoryId == 5) {
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.itemCondition}", '🎨', 'Condition'));
      }
    }

    // Pets Specifications
    if (data?.categoryId == 6) {
      if (data?.brand != null && data!.brand!.name!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.brand?.name}", '🐶', 'Breed'));
      }
    }

    // Business & Industrial Specifications
    if (data?.categoryId == 7) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(context, '${data.model?.name}', '🏢', 'Model'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.itemCondition}", '🔍', 'Condition'));
      }
    }

    // Jobs Specifications
    if (data?.categoryId == 9) {
      if (data?.positionType != null && data!.positionType!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.positionType}", '💼', 'Position Type'));
      }
      if (data?.salleryPeriod != null && data!.salleryPeriod!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.salleryPeriod}", '💰', 'Salary Period'));
      }
      if (data?.salleryFrom != null && data?.salleryTo != null) {
        specs.add(_buildSpecRow(context,
            "${data?.salleryFrom}-${data?.salleryTo}", '💰', 'Salary Range'));
      }
    }

    // Mobiles & Tablets Specifications
    if (data?.categoryId == 10) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(context, '${data.model?.name}', '📱', 'Model'));
      }
      if (data?.ram != null && data!.ram != 0) {
        specs.add(_buildSpecRow(context, '${data.ram} GB', '🧠', 'RAM'));
      }
      if (data?.storage != null && data!.storage != 0) {
        specs
            .add(_buildSpecRow(context, '${data.storage} GB', '💾', 'Storage'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.itemCondition}", '🔍', 'Condition'));
      }
    }

    // Real Estate Specifications
    if (data?.categoryId == 11) {
      if (data?.propertyFor != null && data!.propertyFor!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.propertyFor}", '🏠', 'Property For'));
      }
      if (data?.area != null && data!.area != 0) {
        specs.add(_buildSpecRow(context, "${data.area}", '📏', 'Area'));
      }
      if (data?.bedrooms != null && data!.bedrooms != 0) {
        specs
            .add(_buildSpecRow(context, "${data.bedrooms}", '🛏️', 'Bedrooms'));
      }
      if (data?.bathrooms != null && data!.bathrooms != 0) {
        specs.add(
            _buildSpecRow(context, "${data.bathrooms}", '🚽', 'Bathrooms'));
      }
      if (data?.furnishedType != null && data!.furnishedType!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.furnishedType}", '🛋️', 'Furnished Type'));
      }
      if (data?.ownership != null && data!.ownership!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.ownership}", '📜', 'Ownership'));
      }
      if (data?.paymentType != null && data!.paymentType!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.paymentType}", '💳', 'Payment Type'));
      }
      if (data?.completionStatus != null &&
          data!.completionStatus!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.completionStatus}", '✅', 'Completion Status'));
      }
      if (data?.deliveryTerm != null && data!.deliveryTerm!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.deliveryTerm}", '🚚', 'Delivery Term'));
      }
    }

    // Common specifications
    if (data?.nearby != null && data!.nearby!.isNotEmpty) {
      specs.add(_buildSpecRow(
          context, '${data.nearby?.split(',').last}', '📍', 'Location'));
    }
    if (data?.createdAt != null && data!.createdAt!.isNotEmpty) {
      specs.add(_buildSpecRow(
        context,
        DateFormat('dd MMM yyyy').format(DateTime.parse('${data.createdAt}')),
        '🕒',
        'Posted',
      ));
    }

    return specs.isNotEmpty ? [...specs] : [];
  }

  Widget _buildSpecRow(
      BuildContext context, String specValue, String symbol, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 9.0, // Smaller font size for the title
            fontWeight: FontWeight.w400, // Lighter font weight
            color: Colors.black54, // Grey color for the title
            overflow: TextOverflow.ellipsis, // Ensure title does not overflow
          ),
          maxLines: 1, // Limit to 1 line
        ),
        Row(
          children: [
            Text(
              symbol,
              style:
                  const TextStyle(fontSize: 15.0), // Customize size as needed
            ),
            const SizedBox(width: 3), // Space between symbol and text
            Expanded(
              child: Text(
                specValue,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              ),
            ),
          ],
        ), // Space between value and title
      ],
    );
  }
}
