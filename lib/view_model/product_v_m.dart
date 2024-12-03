import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/product_detail_model.dart';

import '../base/helpers/dialog_helper.dart';

class ProductVM extends BaseViewModel {

  final ScrollController scrollController = ScrollController();
  bool isAppBarVisible = true;
  bool _showAll = false; // Initial state to show less
  bool get showAll => _showAll;
  set showAll(bool value) {
    _showAll = value;
    notifyListeners(); // Notify listeners when state changes
  }

  @override
  void onInit() {
    // TODO: implement onInit
    showAll = false;
    scrollController.addListener(_onScroll);
    super.onInit();
  }



  void _onScroll() {
    if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (isAppBarVisible) {
          isAppBarVisible = false;
      }
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!isAppBarVisible) {
          isAppBarVisible = true;
      }
    }
    notifyListeners();
  }

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
        specs.add(_buildSpecRow(
            context, '${data.model?.name}', Icons.smartphone, 'Model'));
      }
      if (data?.ram != null && data!.ram != 0) {
        specs
            .add(_buildSpecRow(context, '${data.ram} GB', Icons.memory, 'RAM'));
      }
      if (data?.storage != null && data!.storage != 0) {
        specs.add(_buildSpecRow(
            context, '${data.storage} GB', Icons.sd_storage, 'Storage'));
      }
      if (data?.screenSize != null && data!.screenSize!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.screenSize}", Icons.aspect_ratio, 'Screen Size'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.itemCondition}",
            Icons.verified_user, 'Condition'));
      }
    }

    // Home & Living Specifications
    if (data?.categoryId == 2) {
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.itemCondition}", Icons.chair, 'Condition'));
      }
      if (data?.material != null && data!.material!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.material}", Icons.inbox, 'Material'));
      }
    }

    // Fashion Specifications
    if (data?.categoryId == 3) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(
            context, '${data.model?.name}', Icons.checkroom, 'Model'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.itemCondition}", Icons.visibility, 'Condition'));
      }
    }

    // Vehicles Specifications
    if (data?.categoryId == 4) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(
            context, '${data.model?.name}', Icons.directions_car, 'Model'));
      }
      if (data?.year != null && data!.year != 0) {
        specs.add(_buildSpecRow(
            context, "${data.year}", Icons.calendar_today, 'Year'));
      }
      if (data?.fuel != null && data!.fuel!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, '${data.fuel}', Icons.local_gas_station, 'Fuel'));
      }
      if (data?.milleage != null && data!.milleage!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, '${data.milleage}', Icons.battery_full, 'Mileage'));
      }
      if (data?.kmDriven != null) {
        specs.add(_buildSpecRow(
            context, '${data?.kmDriven} km', Icons.speed, 'KM Driven'));
      }
      if (data?.transmission != null && data!.transmission!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.transmission}", Icons.autorenew, 'Transmission'));
      }
      if (data?.numberOfOwner != null && data!.numberOfOwner != 0) {
        specs.add(_buildSpecRow(context, '${data.numberOfOwner} Owners',
            Icons.account_circle, 'Number of Owners'));
      }
    }

    // Hobbies, Music, Art & Books Specifications
    if (data?.categoryId == 5) {
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.itemCondition}", Icons.art_track, 'Condition'));
      }
    }

    // Pets Specifications
    if (data?.categoryId == 6) {
      if (data?.brand != null && data!.brand!.name!.isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data.brand?.name}", Icons.pets, 'Breed'));
      }
    }

    // Business & Industrial Specifications
    if (data?.categoryId == 7) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(_buildSpecRow(
            context, '${data.model?.name}', Icons.business, 'Model'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.itemCondition}",
            Icons.visibility_off, 'Condition'));
      }
    }

    // Jobs Specifications
    if (data?.categoryId == 9) {
      if (data?.positionType != null && data!.positionType!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.positionType}", Icons.work, 'Position Type'));
      }
      if (data?.salleryPeriod != null && data!.salleryPeriod!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.salleryPeriod}",
            Icons.attach_money, 'Salary Period'));
      }
      if (data?.salleryFrom != null && data?.salleryTo != null) {
        specs.add(_buildSpecRow(
            context,
            "${data?.salleryFrom}-${data?.salleryTo}",
            Icons.attach_money,
            'Salary Range'));
      }
    }

    // Mobiles & Tablets Specifications
    if (data?.categoryId == 10) {
      if (data?.modelId != null && data!.modelId != 0) {
        specs.add(
            _buildSpecRow(context, '${data.model}', Icons.tablet_mac, 'Model'));
      }
      if (data?.ram != null && data!.ram != 0) {
        specs
            .add(_buildSpecRow(context, '${data.ram} GB', Icons.memory, 'RAM'));
      }
      if (data?.storage != null && data!.storage != 0) {
        specs.add(_buildSpecRow(
            context, '${data.storage} GB', Icons.sd_storage, 'Storage'));
      }
      if (data?.itemCondition != null && data!.itemCondition!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.itemCondition}", Icons.visibility, 'Condition'));
      }
    }

    // Real Estate Specifications
    if (data?.categoryId == 11) {
      if (data?.propertyFor != null && data!.propertyFor!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.propertyFor}", Icons.house, 'Property For'));
      }
      if (data?.area != null && data!.area != 0) {
        specs.add(
            _buildSpecRow(context, "${data.area}", Icons.straighten, 'Area'));
      }
      if (data?.bedrooms != null && data!.bedrooms != 0) {
        specs.add(
            _buildSpecRow(context, "${data.bedrooms}", Icons.bed, 'Bedrooms'));
      }
      if (data?.bathrooms != null && data!.bathrooms != 0) {
        specs.add(_buildSpecRow(
            context, "${data.bathrooms}", Icons.bathtub, 'Bathrooms'));
      }
      if (data?.furnishedType != null && data!.furnishedType!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.furnishedType}", Icons.chair, 'Furnished Type'));
      }
      if (data?.ownership != null && data!.ownership!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.ownership}", Icons.account_balance, 'Ownership'));
      }
      if (data?.paymentType != null && data!.paymentType!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data.paymentType}", Icons.payment, 'Payment Type'));
      }
      if (data?.completionStatus != null &&
          data!.completionStatus!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.completionStatus}",
            Icons.check_circle, 'Completion Status'));
      }
      if (data?.deliveryTerm != null && data!.deliveryTerm!.isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data.deliveryTerm}",
            Icons.local_shipping, 'Delivery Term'));
      }
    }

    // Common specifications
    if (data?.nearby != null && data!.nearby!.isNotEmpty) {
      specs.add(_buildSpecRow(context, '${data.nearby?.split(',').last}',
          Icons.location_on, 'Location'));
    }
    if (data?.createdAt != null && data!.createdAt!.isNotEmpty) {
      specs.add(_buildSpecRow(
        context,
        DateFormat('dd MMM yyyy').format(DateTime.parse('${data.createdAt}')),
        Icons.access_time,
        'Posted',
      ));
    }

    return specs.isNotEmpty ? [...specs] : [];
  }

  Widget _buildSpecRow(
      BuildContext context, String specValue, IconData icon, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        Row(
          children: [
            Icon(
              icon,
              color: Colors.blueGrey, // Set icon color to grey
              size: 20, // Set icon size as needed
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                specValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getRemainDays({required ProductDetailModel? item}) {
    String approvalDateString = item?.approvalDate ?? '';

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
          'Ad Expired in : $remainingDays Days',
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w800, fontSize: 12),
        );
      }
    }
    return SizedBox.shrink();
  }
}
