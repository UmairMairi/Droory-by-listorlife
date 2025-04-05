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
import '../base/utils/utils.dart';

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
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onReady() {
    showAll = false;
    super.onReady();
  }

  void _onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
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
    if (!DbHelper.getIsGuest()) {
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
        MapResponse<Object?>.fromJson(response, (json) => json);

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

  List<Widget> getSpecifications({
    required BuildContext context,
    ProductDetailModel? data,
  }) {
    List<Widget> specs = _buildSpecList(context, data);

    if (specs.isEmpty) return [];

    // If there are more than 6 specs, show only 6 and add "Read More"
    if (specs.length > 6) {
      return [
        ...specs.sublist(0, 6), // Show first 6 specs
        GestureDetector(
          onTap: () => _showFullSpecsModal(context, specs),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Text(
              StringHelper.readMore,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ];
    }

    return specs;
  }

  // Helper method to build the full list of specs
  List<Widget> _buildSpecList(BuildContext context, ProductDetailModel? data) {
    List<Widget> specs = [];

    // Electronics Specifications
    if (data?.categoryId == 1) {
      if ((data?.modelId ?? 0) != 0) {
        specs.add(_buildSpecRow(context, data?.model?.name ?? "",
            Icons.smartphone, StringHelper.models));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}", Icons.category,
            StringHelper.brand));
      }
      if (data?.fashionSize != null &&
          (data?.fashionSize?.name ?? "").isNotEmpty) {
        String title;

        // Define groups of sub-subcategory IDs
        const brandSubSubCategories = {1, 2, 14, 15, 7};
        const typeSubSubCategories = {5, 19, 94, 97};

        // Check conditions using contains() with renamed variable
        if (brandSubSubCategories.contains(data?.subSubCategoryId)) {
          title = StringHelper.brand;
        } else if (typeSubSubCategories.contains(data?.subSubCategoryId)) {
          title = StringHelper.type;
        } else {
          title = StringHelper.size; // Default title
        }

        specs.add(_buildSpecRow(
            context, "${data?.fashionSize?.name}", Icons.straighten, title));
      }
      if ((data?.ram ?? 0) != 0) {
        specs.add(_buildSpecRow(
            context, '${data?.ram} GB', Icons.memory, StringHelper.ram));
      }
      if ((data?.storage ?? 0) != 0) {
        specs.add(_buildSpecRow(context, '${data?.storage} GB',
            Icons.sd_storage, StringHelper.strong));
      }
      if ((data?.screenSize ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.screenSize}",
            Icons.aspect_ratio, StringHelper.screenSize));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}",
            Icons.verified_user, StringHelper.condition));
      }
    }

    // Home & Living Specifications
    if (data?.categoryId == 2) {
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}", Icons.chair,
            StringHelper.condition));
      }
      if (data?.fashionSize != null &&
          (data?.fashionSize?.name ?? "").isNotEmpty) {
        String title;
        if (data?.subCategoryId == 4) {
          title = StringHelper.type; // For subcategory 4 (e.g., Furniture)
        } else if (data?.subCategoryId == 2) {
          title = StringHelper.brand; // For subcategory 2
        } else {
          title = StringHelper.size; // Default title
        }
        specs.add(_buildSpecRow(
            context, "${data?.fashionSize?.name}", Icons.straighten, title));
      }

      if ((data?.material ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.material}", Icons.inbox, StringHelper.material));
      }
    }

    // Fashion Specifications
    if (data?.categoryId == 3) {
      if ((data?.modelId ?? 0) != 0) {
        specs.add(_buildSpecRow(context, '${data?.model?.name}',
            Icons.checkroom, StringHelper.models));
      }
      if (data?.fashionSize != null &&
          (data?.fashionSize?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.fashionSize?.name}",
            Icons.straighten, StringHelper.type // Fixed as "Type"
            ));
      }

      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}",
            Icons.visibility, StringHelper.condition));
      }
    }

    // Vehicles Specifications
    if (data?.categoryId == 4) {
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        // Determine the title based on subcategory ID
        String brandTitle = [
          98,
        ].contains(data?.subCategory?.id)
            ? StringHelper.brand
            : StringHelper.type;
        specs.add(_buildSpecRow(
            context, "${data?.brand?.name}", Icons.directions_car, brandTitle));
      }
      if ((data?.modelId ?? 0) != 0) {
        specs.add(_buildSpecRow(context, '${data?.model?.name}',
            Icons.directions_car, StringHelper.models));
      }
      if ((data?.year ?? 0) != 0) {
        specs.add(_buildSpecRow(
            context, "${data?.year}", Icons.calendar_today, StringHelper.year));
      }
      if ((data?.fuel ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.getFuel('${data?.fuel}'),
            Icons.local_gas_station, StringHelper.fuel));
      }
      if ((data?.milleage ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, '${data?.milleage}',
            Icons.battery_full, StringHelper.mileage));
      }
      if ((data?.kmDriven ?? 0) != 0) {
        specs.add(_buildSpecRow(context, '${data?.kmDriven} ${StringHelper.km}', Icons.speed,
            StringHelper.kmDriven));
      }
      if ((data?.transmission ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.transmission}",
            Icons.autorenew, StringHelper.transmission));
      }
      if (("${data?.numberOfOwner ?? 0}") != "0") {
        specs.add(_buildSpecRow(context, '${data?.numberOfOwner} ${StringHelper.owners}',
            Icons.account_circle, StringHelper.noOfOwners));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}",
            Icons.verified_user, StringHelper.condition));
      }
      if ((data?.carColor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.carColor}",
            Icons.verified_user, StringHelper.carColorTitle));
      }
      if ((data?.bodyType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.bodyType}",
            Icons.verified_user, StringHelper.bodyTypeTitle));
      }
      if ((data?.horsePower ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.horsePower}",
            Icons.verified_user, StringHelper.horsepowerTitle));
      }
      if ((data?.engineCapacity ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.engineCapacity}",
            Icons.verified_user, StringHelper.engineCapacityTitle));
      }
      if ((data?.interiorColor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.interiorColor}",
            Icons.verified_user, StringHelper.interiorColorTitle));
      }
      if ((data?.numbDoors ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.numbDoors}",
            Icons.verified_user, StringHelper.numbDoorsTitle));
      }
      if ((data?.carRentalTerm ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.carRentalTerm("${data?.carRentalTerm}"), Icons.timer,
            StringHelper.rentalCarTerm));
      }
    }

    // Hobbies, Music, Art & Books Specifications
    if (data?.categoryId == 5) {
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.itemCondition ?? "",
            Icons.art_track, StringHelper.condition));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}", Icons.category,
            StringHelper.type));
      }
    }
    if (data?.categoryId == 8) {
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.brand?.name}", Icons.category, "Type"));
      }
    }
    // Pets Specifications
    if (data?.categoryId == 6) {
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        // Determine the title based on subcategory and sub-subcategory
        String brandTitle;
        if (data?.subSubCategory?.id == 69) {
          brandTitle = StringHelper.breed; // "Breed" for sub-subcategory 69
        } else if (data?.subCategory?.id == 40) {
          brandTitle = StringHelper.type; // "Type" for subcategory 40
        } else {
          brandTitle = StringHelper.breed; // Default to "Breed" for other cases
        }
        specs.add(_buildSpecRow(
            context, "${data?.brand?.name}", Icons.pets, brandTitle));
      }
      if (data?.fashionSize != null &&
          (data?.fashionSize?.name ?? "").isNotEmpty) {
        String title;
        if (data?.subSubCategory?.id == 69 ||
            data?.subSubCategory?.id == 70 ||
            data?.subSubCategory?.id == 71) {
          title =
              StringHelper.breed; // "Breed" for sub-subcategories 69, 70, 71
        } else if (data?.subSubCategory?.id == 73) {
          title = StringHelper.type; // "Type" for sub-subcategory 73
        } else {
          title = StringHelper.size; // Default to "Size" for other cases
        }
        specs.add(_buildSpecRow(
            context, "${data?.fashionSize?.name}", Icons.straighten, title));
      }
    }

    // Business & Industrial Specifications
    if (data?.categoryId == 7) {
      if ("${data?.modelId ?? 0}" != "0") {
        specs.add(_buildSpecRow(context, '${data?.model?.name}', Icons.business,
            StringHelper.models));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.itemCondition ?? "",
            Icons.visibility, StringHelper.condition));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context, "${data?.brand?.name}", Icons.cast_for_education, StringHelper.type));
      }
    }

    // Jobs Specifications
    if (data?.categoryId == 9) {
      if ((data?.subCategoryId ?? 0) != 0) {
        specs.add(_buildSpecRow(context, data?.subCategory?.name ?? "",
            Icons.work, StringHelper.jobType));
      }
      if ((data?.positionType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.positionType}", Icons.work,
            StringHelper.positionType));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}",
            Icons.cast_for_education, StringHelper.specialty));
      }
      if ((data?.lookingFor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.lookingFor ?? "", Icons.person,
            StringHelper.lookingFor));
      }
      if ((data?.salleryFrom ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            num.parse(data?.salleryFrom ?? " ").toStringAsFixed(0),
            Icons.attach_money,
            StringHelper.salaryFrom));
      }

      if ((data?.salleryTo ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            num.parse(data?.salleryTo ?? " ").toStringAsFixed(0),
            Icons.attach_money,
            StringHelper.salaryTo));
      }

      if ((data?.workSetting ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.workSetting ?? " ", Icons.work,
            StringHelper.workSetting));
      }

      if ((data?.workExperience ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.workExperience ?? " ",
            Icons.timer, StringHelper.workExperience));
      }

      if ((data?.workEducation ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.getEducationOptions(data?.workEducation ?? " "),
            Icons.school, StringHelper.workEducation));
      }
    }

    // Mobiles & Tablets Specifications
    if (data?.categoryId == 10) {
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        // Determine the title based on subcategory
        String brandTitle;
        if (data?.subCategory?.id == 22) {
          brandTitle = StringHelper.type; // "Type" for subcategory 22
        } else if (data?.subCategory?.id == 23) {
          brandTitle = StringHelper.telecom; // "Telcom" for subcategory 23
        } else {
          brandTitle = StringHelper.brand; // Default to "Brand" for other cases
        }
        specs.add(_buildSpecRow(
            context, "${data?.brand?.name}", Icons.category, brandTitle));
      }
      if ("${data?.modelId ?? 0}" != "0") {
        specs.add(_buildSpecRow(context, '${data?.model?.name}',
            Icons.tablet_mac, StringHelper.models));
      }
      if ("${data?.ram ?? 0}" != "0") {
        specs.add(_buildSpecRow(
            context, '${data?.ram} GB', Icons.memory, StringHelper.ram));
      }
      if ("${data?.storage ?? 0}" != "0") {
        specs.add(_buildSpecRow(context, '${data?.storage} GB',
            Icons.sd_storage, StringHelper.strong));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.itemCondition}",
            Icons.visibility, StringHelper.condition));
      }
    }

    // Real Estate Specifications
    if (data?.categoryId == 11) {
      if ((data?.propertyFor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.getPropertyType("${data?.propertyFor}"), Icons.house,
            StringHelper.propertyType));
      }
      if ("${data?.area ?? 0}" != "0") {
        specs.add(_buildSpecRow(
            context, "${data?.area}", Icons.straighten, StringHelper.areaSize));
      }
      if ("${data?.bedrooms ?? 0}" != "0") {
        specs.add(_buildSpecRow(context, "${data?.bedrooms}", Icons.bed,
            StringHelper.noOfBedrooms));
      }
      if (("${data?.bathrooms ?? 0}") != "0") {
        specs.add(_buildSpecRow(context, "${data?.bathrooms}", Icons.bathtub,
            StringHelper.noOfBathrooms));
      }
      if ((data?.furnishedType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.getFurnished(data?.furnishedType ?? ""), Icons.chair,
            StringHelper.furnished));
      }
      if ((data?.ownership ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.ownership ?? "",
            Icons.account_balance, StringHelper.owner));
      }
      if ((data?.paymentType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.paymentType ?? "", Icons.payment,
            StringHelper.paymentType));
      }
      if ((data?.completionStatus ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.completionStatus ?? "",
            Icons.check_circle, StringHelper.completionStatus));
      }
      if ((data?.deliveryTerm ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, data?.deliveryTerm ?? "",
            Icons.local_shipping, StringHelper.deliveryTerm));
      }
    }

    // Common specifications
    if ((data?.nearby ?? "").isNotEmpty) {
      specs.add(_buildSpecRow(context, (data?.nearby ?? "").split(',').last,
          Icons.location_on, StringHelper.location));
    }
    if ((data?.createdAt ?? "").isNotEmpty) {
      specs.add(_buildSpecRow(
        context,
        DateFormat('dd MMM yyyy').format(DateTime.parse(data?.createdAt ?? "")),
        Icons.access_time,
        StringHelper.posted,
      ));
    }

    return specs.isNotEmpty ? [...specs] : [];
  }

  // Method to show modal with full specifications
  void _showFullSpecsModal(BuildContext context, List<Widget> specs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringHelper.specifications,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: specs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => specs[index],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecRow(
    BuildContext context,
    String specValue,
    IconData icon,
    String title,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // Icon(
                  //   icon,
                  //   color: Colors.black,
                  //   size: 20,
                  // ),
                  const SizedBox(width: 0.2),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                // Capitalize first letter only
                specValue.isEmpty
                    ? ''
                    : '${specValue[0].toUpperCase()}${specValue.substring(1)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
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
          '${StringHelper.adExpire} : $remainingDays Days',
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w800, fontSize: 12),
        );
      }
    }
    return SizedBox.shrink();
  }
}
