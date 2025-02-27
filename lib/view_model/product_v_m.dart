import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
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

    scrollController.addListener(_onScroll);
    super.onInit();
  }


  @override
  void onReady() {
    showAll = false;
    super.onReady();
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

  StreamController<ProductDetailModel?> productStream =
  StreamController<ProductDetailModel?>.broadcast();
  Future<void> getMyProductDetails({num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductUrl(id: '$id'),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<ProductDetailModel> model =
        MapResponse<ProductDetailModel>.fromJson(
            response, (json) => ProductDetailModel.fromJson(json));
    productStream.sink.add(model.body);
    notifyListeners();
  }
  Future<ProductDetailModel?> getProductDetails({num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductUrl(id: '$id'),
        requestType: RequestType.get);
    if(!DbHelper.getIsGuest()){
      productViewApi(id: id);
    }
    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<ProductDetailModel> model =
        MapResponse<ProductDetailModel>.fromJson(
            response, (json) => ProductDetailModel.fromJson(json));
    return model.body;
  }

  Future<Object?> productViewApi({num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.productViewUrl(),
        body: {"product_id": id},
        requestType: RequestType.post);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<Object?> model =
        MapResponse<Object?>.fromJson(
            response, (json) => json);

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
    getMyProductDetails(id: product.id);
    if (context.mounted) context.pop();
  }

  List<Widget> getSpecifications(
      {required BuildContext context, ProductDetailModel? data}) {
    List<Widget> specs = [];

    // Electronics Specifications
    if (data?.categoryId == 1) {
      if ((data?.modelId??0) != 0) {
        specs.add(_buildSpecRow(
            context, data?.model?.name??"", Icons.smartphone, StringHelper.models));
      }
      if ((data?.ram??0) != 0) {
        specs
            .add(_buildSpecRow(context, '${data?.ram} GB', Icons.memory, StringHelper.ram));
      }
      if ((data?.storage??0) != 0) {
        specs.add(_buildSpecRow(
            context, '${data?.storage} GB', Icons.sd_storage, StringHelper.strong));
      }
      if ((data?.screenSize??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.screenSize}", Icons.aspect_ratio, StringHelper.screenSize));
      }
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}",
            Icons.verified_user, StringHelper.condition));
      }
    }

    // Home & Living Specifications
    if (data?.categoryId == 2) {
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.itemCondition}", Icons.chair, StringHelper.condition));
      }
      if ((data?.material??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.material}", Icons.inbox, StringHelper.material));
      }
    }

    // Fashion Specifications
    if (data?.categoryId == 3) {
      if ((data?.modelId??0) != 0) {
        specs.add(_buildSpecRow(
            context, '${data?.model?.name}', Icons.checkroom, StringHelper.models));
      }
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.itemCondition}", Icons.visibility, StringHelper.condition));
      }
    }

    // Vehicles Specifications
    if (data?.categoryId == 4) {
      if ((data?.modelId??0) != 0) {
        specs.add(_buildSpecRow(
            context, '${data?.model?.name}', Icons.directions_car, StringHelper.models));
      }
      if ((data?.year??0) != 0) {
        specs.add(_buildSpecRow(
            context, "${data?.year}", Icons.calendar_today, StringHelper.year));
      }
      if ((data?.fuel ??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, '${data?.fuel}', Icons.local_gas_station, StringHelper.fuel));
      }
      if ((data?.milleage??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, '${data?.milleage}', Icons.battery_full, StringHelper.mileage));
      }
      if ((data?.kmDriven??0) != 0) {
        specs.add(_buildSpecRow(
            context, '${data?.kmDriven} km', Icons.speed, StringHelper.kmDriven));
      }
      if ((data?.transmission??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.transmission}", Icons.autorenew, StringHelper.transmission));
      }
      if (("${data?.numberOfOwner??0}") != "0") {
        specs.add(_buildSpecRow(context, '${data?.numberOfOwner} Owners',
            Icons.account_circle, StringHelper.noOfOwners));
      }
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}",
            Icons.verified_user, StringHelper.condition));
      }
      if (data?.brand != null && (data?.brand?.name??"").isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data?.brand?.name}", Icons.directions_car, StringHelper.brand));
      }
    }

    // Hobbies, Music, Art & Books Specifications
    if (data?.categoryId == 5) {
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, data?.itemCondition??"", Icons.art_track, StringHelper.condition));
      }
    }

    // Pets Specifications
    if (data?.categoryId == 6) {
      if (data?.brand != null && (data?.brand?.name??"").isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data?.brand?.name}", Icons.pets, StringHelper.breed));
      }
    }

    // Business & Industrial Specifications
    if (data?.categoryId == 7) {
      if ("${data?.modelId??0}" != "0") {
        specs.add(_buildSpecRow(
            context, '${data?.model?.name}', Icons.business, StringHelper.models));
      }
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.itemCondition??"",
            Icons.visibility, StringHelper.condition));
      }
    }

    // Jobs Specifications
    if (data?.categoryId == 9) {
      if ((data?.subCategoryId??0) != 0) {
        specs.add(_buildSpecRow(
            context, data?.subCategory?.name??"", Icons.work, StringHelper.jobType));
      }
      if ((data?.positionType??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.positionType}", Icons.work, StringHelper.positionType));
      }
      if ((data?.lookingFor??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.lookingFor??"",
            Icons.person, StringHelper.lookingFor));
      }
      if ((data?.salleryFrom??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, num.parse(data?.salleryFrom??" ").toStringAsFixed(0),
            Icons.attach_money, StringHelper.salary));
      }
      if ((data?.salleryPeriod??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.salleryPeriod??" ",
            Icons.watch_later, StringHelper.salaryPeriod));
      }
      // if (data?.salleryFrom != null && data?.salleryTo != null) {
      //   specs.add(_buildSpecRow(
      //       context,
      //       "${data?.salleryFrom}-${data?.salleryTo}",
      //       Icons.attach_money,
      //       'Salary Range'));
      // }
      // if ((data?.salleryFrom??"").isNotEmpty) {
      //   specs.add(_buildSpecRow(
      //       context,
      //       data?.salleryFrom??"",
      //       Icons.attach_money,
      //       'Salary Range'));
      // }
    }

    // Mobiles & Tablets Specifications
    if (data?.categoryId == 10) {
      if (data?.brand != null && (data?.brand?.name??"").isNotEmpty) {
        specs.add(
            _buildSpecRow(context, "${data?.brand?.name}", Icons.tablet_mac, StringHelper.breed));
      }
      if ("${data?.modelId??0}" != "0") {
        specs.add(
            _buildSpecRow(context, '${data?.model?.name}', Icons.tablet_mac, StringHelper.models));
      }
      if ("${data?.ram ??0 }" != "0") {
        specs
            .add(_buildSpecRow(context, '${data?.ram} GB', Icons.memory, StringHelper.ram));
      }
      if ("${data?.storage??0}" != "0") {
        specs.add(_buildSpecRow(
            context, '${data?.storage} GB', Icons.sd_storage, StringHelper.strong));
      }
      if ((data?.itemCondition??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.itemCondition}", Icons.visibility, StringHelper.condition));
      }
    }

    // Real Estate Specifications
    if (data?.categoryId == 11) {
      if ((data?.propertyFor??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.propertyFor}", Icons.house, StringHelper.propertyType));
      }
      if ("${data?.area??0}"  != "0") {
        specs.add(
            _buildSpecRow(context, "${data?.area}", Icons.straighten, StringHelper.areaSize));
      }
      if ("${data?.bedrooms??0}" != "0") {
        specs.add(
            _buildSpecRow(context, "${data?.bedrooms}", Icons.bed, StringHelper.noOfBedrooms));
      }
      if (("${data?.bathrooms??0}") != "0") {
        specs.add(_buildSpecRow(
            context, "${data?.bathrooms}", Icons.bathtub, StringHelper.noOfBathrooms));
      }
      if ((data?.furnishedType ??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, data?.furnishedType??"", Icons.chair, StringHelper.furnished));
      }
      if ((data?.ownership??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, data?.ownership??"", Icons.account_balance, StringHelper.owner));
      }
      if ((data?.paymentType??"").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, data?.paymentType??"", Icons.payment, StringHelper.paymentType));
      }
      if ((data?.completionStatus??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.completionStatus??"",
            Icons.check_circle, StringHelper.completionStatus));
      }
      if ((data?.deliveryTerm??"").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.deliveryTerm??"",
            Icons.local_shipping, StringHelper.deliveryTerm));
      }
    }

    // Common specifications
    if ((data?.nearby??"").isNotEmpty) {
      specs.add(_buildSpecRow(context, (data?.nearby??"").split(',').last,
          Icons.location_on, StringHelper.location));
    }
    if ((data?.createdAt??"").isNotEmpty) {
      specs.add(_buildSpecRow(
        context,
        DateFormat('dd MMM yyyy').format(DateTime.parse(data?.createdAt??"")),
        Icons.access_time,
        StringHelper.posted,
      ));
    }

    return specs.isNotEmpty ? [...specs] : [];
  }

  Widget _buildSpecRow(
      BuildContext context, String? specValue, IconData icon, String? title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title??"",
          style: const TextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.blueGrey,
              size: 16,
            ),
            const SizedBox(width: 3),
            Text(
              specValue??"",
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
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
          StringHelper.expired,
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
