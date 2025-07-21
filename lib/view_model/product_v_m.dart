import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/base/base.dart';
import '../models/home_list_model.dart';
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

// Add this new method to get fresh data with all updated metrics
  Future<void> getMyProductDetailsWithFreshMetrics({num? id}) async {
    // DON'T call productViewApi for own ads - this was causing the extra view count
    // Views should only be incremented when OTHER users view your ad

    // Fetch fresh data from the user products API (same as MyAdsView)
    try {
      print("DEBUG: Fetching fresh metrics for product ID: $id");

      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getUsersProductsUrl(
                  limit: 1000,
                  page: 1,
                  userId: "${DbHelper.getUserModel()?.id}") +
              "&show_all_ads=true",
          requestType: RequestType.get);

      var response = await BaseClient.handleRequest(apiRequest);
      print("DEBUG: API Response received");

      MapResponse<HomeListModel> model = MapResponse.fromJson(
          response, (json) => HomeListModel.fromJson(json));

      // Find the specific product in the fresh data
      if (model.body?.data != null) {
        ProductDetailModel? freshProduct;
        try {
          freshProduct = model.body!.data!.firstWhere(
            (product) => product.id == id,
          );
          print("DEBUG: Found product in fresh data");
          print("DEBUG: Fresh product name: ${freshProduct.name}");
          print("DEBUG: Fresh product price: ${freshProduct.price}");
          print("DEBUG: Fresh product location: ${freshProduct.nearby}");
        } catch (e) {
          print("DEBUG: Product not found in the list");
          freshProduct = null;
        }

        // If we found the product with fresh metrics, update the stream
        if (freshProduct?.id != null) {
          productStream.sink.add(freshProduct);
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print("DEBUG: Error fetching fresh metrics: $e");
    }

    // Fallback to regular API if the above fails
    print("DEBUG: Falling back to regular API");
    await getMyProductDetails(id: id);
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

// In ProductVM class

// Modify this method
  String getLocalizedLocationFromCoordinates(
      BuildContext context, double? lat, double? lng) {
    // Added BuildContext
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      return _isCurrentLanguageArabic(context)
          ? "كل مصر"
          : "All Egypt"; // Pass context
    }

    bool isArabic = _isCurrentLanguageArabic(context); // Pass context

    // Find the nearest location using your LocationService
    CityModel? nearestCity = LocationService.findNearestCity(lat, lng); //

    if (nearestCity != null) {
      // Check if coordinates match a specific neighborhood
      if (nearestCity.districts != null) {
        for (var district in nearestCity.districts!) {
          if (district.neighborhoods != null) {
            for (var neighborhood in district.neighborhoods!) {
              double distance = LocationService.calculateDistance(
                  //
                  lat,
                  lng,
                  neighborhood.latitude,
                  neighborhood.longitude);
              if (distance <= (neighborhood.radius ?? 2.0)) {
                // Using a default radius if null
                return isArabic
                    ? "${neighborhood.arabicName}، ${district.arabicName}، ${nearestCity.arabicName}"
                    : "${neighborhood.name}, ${district.name}, ${nearestCity.name}";
              }
            }
          }

          // Check if coordinates match the district
          double distanceToDistrict = LocationService.calculateDistance(
              //
              lat,
              lng,
              district.latitude,
              district.longitude);
          if (distanceToDistrict <= (district.radius ?? 5.0)) {
            // Using a default radius if null
            return isArabic
                ? "${district.arabicName}، ${nearestCity.arabicName}"
                : "${district.name}, ${nearestCity.name}";
          }
        }
      }

      // If no specific district/neighborhood found, return city name
      return isArabic ? nearestCity.arabicName : nearestCity.name;
    }

    // Fallback: return "All Egypt" if no city found
    return isArabic ? "كل مصر" : "All Egypt";
  }

// Modify this helper method to accept BuildContext
  bool _isCurrentLanguageArabic(BuildContext context) {
    // Primary check: Use DbHelper (same as your SettingView)
    String currentLang = DbHelper.getLanguage();

    // Secondary checks for fallback
    bool isRTL = Directionality.of(context) == TextDirection.RTL;
    bool isArabicLocale = Localizations.localeOf(context).languageCode == 'ar';

    print("DEBUG: DbHelper language: $currentLang");
    print("DEBUG: isRTL: $isRTL, isArabicLocale: $isArabicLocale");

    // Primary method: DbHelper
    if (currentLang == 'ar') return true;

    // Fallback methods
    return isRTL || isArabicLocale;
  }

// Ensure the rest of your ProductVM remains the same
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
            context,
            Utils.getRam(data?.ram?.toString() ?? "0"),
            Icons.memory,
            StringHelper.ram));
      }
      if ((data?.storage ?? 0) != 0) {
        specs.add(_buildSpecRow(
            context,
            Utils.getStorage(data?.storage?.toString() ?? "0"),
            Icons.sd_storage,
            StringHelper.strong));
      }
      if ((data?.screenSize ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${Utils.getCommon(data?.screenSize)}",
            Icons.aspect_ratio, StringHelper.screenSize));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(data?.itemCondition)}",
            Icons.verified_user,
            StringHelper.condition));
      }
    }

    // Home & Living Specifications
    if (data?.categoryId == 2) {
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(data?.itemCondition)}",
            Icons.chair,
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
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(data?.itemCondition)}",
            Icons.visibility,
            StringHelper.condition));
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
        specs.add(_buildSpecRow(context, '${data?.kmDriven} ${StringHelper.km}',
            Icons.speed, StringHelper.kmDriven));
      }
      if ((data?.transmission ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(data?.transmission)}",
            Icons.autorenew,
            StringHelper.transmission));
      }
      if (("${data?.numberOfOwner ?? 0}") != "0") {
        specs.add(_buildSpecRow(
            context,
            '${data?.numberOfOwner} ${StringHelper.owners}',
            Icons.account_circle,
            StringHelper.noOfOwners));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(Utils.getCommon(data?.itemCondition))}",
            Icons.verified_user,
            StringHelper.condition));
      }
      if ((data?.carColor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${Utils.getColor(data?.carColor)}",
            Icons.verified_user, StringHelper.carColorTitle));
      }
      if ((data?.bodyType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${Utils.getBodyType(data?.bodyType)}",
            Icons.verified_user, StringHelper.bodyTypeTitle));
      }
      if ((data?.horsePower ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.getHorsePower(data?.horsePower),
            Icons.verified_user, StringHelper.horsepowerTitle));
      }
      if ((data?.engineCapacity ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getEngineCapacity(data?.engineCapacity),
            Icons.verified_user,
            StringHelper.engineCapacityTitle));
      }
      if ((data?.interiorColor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getColor(data?.interiorColor)}",
            Icons.verified_user,
            StringHelper.interiorColorTitle));
      }
      if ((data?.numbDoors ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getDoorsText(data?.numbDoors)}",
            Icons.verified_user,
            StringHelper.numbDoorsTitle));
      }
      if ((data?.carRentalTerm ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.carRentalTerm("${data?.carRentalTerm}"),
            Icons.timer,
            StringHelper.rentalCarTerm));
      }
    }

    // Hobbies, Music, Art & Books Specifications
    if (data?.categoryId == 5) {
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getCommon(data?.itemCondition) ?? "",
            Icons.art_track,
            StringHelper.condition));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}", Icons.category,
            StringHelper.type));
      }
    }
    if (data?.categoryId == 8) {
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}", Icons.category,
            StringHelper.type));
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
        specs.add(_buildSpecRow(
            context,
            Utils.getCommon(data?.itemCondition) ?? "",
            Icons.visibility,
            StringHelper.condition));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}",
            Icons.cast_for_education, StringHelper.type));
      }
    }

    // Jobs Specifications
    if (data?.categoryId == 9) {
      if ((data?.subCategoryId ?? 0) != 0) {
        specs.add(_buildSpecRow(context, data?.subCategory?.name ?? "",
            Icons.work, StringHelper.jobType));
      }
      if ((data?.positionType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(Utils.transformToSnakeCase(data?.positionType))}",
            Icons.work,
            StringHelper.positionType));
      }
      if (data?.brand != null && (data?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, "${data?.brand?.name}",
            Icons.cast_for_education, StringHelper.specialty));
      }
      if ((data?.lookingFor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getCommon(data?.lookingFor ?? ""),
            Icons.person,
            StringHelper.usertype));
      }
      if ((data?.salleryFrom ?? "").isNotEmpty) {
        num salaryFromNum =
            num.tryParse(data?.salleryFrom?.toString() ?? "0") ?? 0;
        if (salaryFromNum > 0) {
          specs.add(_buildSpecRow(context, parseAmount(data?.salleryFrom),
              Icons.attach_money, StringHelper.salaryFrom));
        }
      }

// Only add salary to if it exists and is not 0 or empty
      if ((data?.salleryTo ?? "").isNotEmpty) {
        num salaryToNum = num.tryParse(data?.salleryTo?.toString() ?? "0") ?? 0;
        if (salaryToNum > 0) {
          specs.add(_buildSpecRow(context, parseAmount(data?.salleryTo),
              Icons.attach_money, StringHelper.salaryTo));
        }
      }

      if ((data?.workSetting ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getCommon(data?.workSetting ?? " "),
            Icons.work,
            StringHelper.workSetting));
      }

      if ((data?.workExperience ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getWorkExperience(data?.workExperience),
            Icons.timer,
            StringHelper.workExperience));
      }

      if ((data?.workEducation ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getEducationOptions(data?.workEducation ?? " "),
            Icons.school,
            StringHelper.workEducation));
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
      if ((data?.ram ?? 0) != 0) {
        specs.add(_buildSpecRow(
            context,
            Utils.getRam(data?.ram?.toString() ?? "0"),
            Icons.memory,
            StringHelper.ram));
      }
      if ((data?.storage ?? 0) != 0) {
        specs.add(_buildSpecRow(
            context,
            Utils.getStorage(data?.storage?.toString() ?? "0"),
            Icons.sd_storage,
            StringHelper.strong));
      }
      if ((data?.itemCondition ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(data?.itemCondition)}",
            Icons.visibility,
            StringHelper.condition));
      }
    }

    // Real Estate Specifications
    if (data?.categoryId == 11) {
      if ((data?.propertyFor ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getPropertyType("${data?.propertyFor}"),
            Icons.house,
            StringHelper.propertyType));
      }
      if ("${data?.area ?? 0}" != "0") {
        specs.add(_buildSpecRow(
            context, "${data?.area}", Icons.straighten, StringHelper.areaSize));
      }
      if ("${data?.bedrooms ?? 0}" != "0") {
        specs.add(_buildSpecRow(
            context,
            Utils.getBedroomsText("${data?.bedrooms}"),
            Icons.bed,
            StringHelper.noOfBedrooms));
      }

      if (("${data?.bathrooms ?? 0}") != "0") {
        specs.add(_buildSpecRow(
            context,
            Utils.getBathroomsText("${data?.bathrooms}"),
            Icons.bathtub,
            StringHelper.noOfBathrooms));
      }
      if ((data?.furnishedType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getFurnished(data?.furnishedType ?? ""),
            Icons.chair,
            StringHelper.furnished));
      }
      if ((data?.ownership ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(context, Utils.getCommon(data?.ownership ?? ""),
            Icons.account_balance, StringHelper.owner));
      }
      if ((data?.paymentType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getPaymentTyp(
                Utils.transformToSnakeCase(data?.paymentType ?? "")),
            Icons.payment,
            StringHelper.paymentType));
      }
      if ((data?.completionStatus ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getUtilityTyp(data?.completionStatus ?? ""),
            Icons.check_circle,
            StringHelper.completionStatus));
      }
      if ((data?.deliveryTerm ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getCommon(data?.deliveryTerm ?? ""),
            Icons.local_shipping,
            StringHelper.deliveryTerm));
      }
    }

    // Common specifications
    // if ((data?.nearby ?? "").isNotEmpty) {
    //   specs.add(_buildSpecRow(context, (data?.nearby ?? "").split(',').last,
    //       Icons.location_on, StringHelper.location));
    if ((data?.createdAt ?? "").isNotEmpty) {
      specs.add(_buildSpecRow(
        context,
        _formatDate(context, data?.createdAt ?? ""),
        Icons.access_time,
        StringHelper.posted,
      ));
    }

    return specs.isNotEmpty ? [...specs] : [];
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return Utils.formatPrice(num.parse("${amount ?? 0}").toStringAsFixed(0));
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

  String _formatDate(BuildContext context, String dateString) {
    if (dateString.isEmpty) return "";

    try {
      DateTime date = DateTime.parse(dateString);
      bool isArabic = _isCurrentLanguageArabic(context);

      print(
          "DEBUG: Date formatting - isArabic: $isArabic, dateString: $dateString");

      if (isArabic) {
        // Arabic format: DD/MM/YYYY
        String formattedDate =
            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
        print("DEBUG: Arabic formatted date: $formattedDate");
        return formattedDate;
      } else {
        // English format: DD MMM YYYY
        String formattedDate = DateFormat('dd MMM yyyy').format(date);
        print("DEBUG: English formatted date: $formattedDate");
        return formattedDate;
      }
    } catch (e) {
      print("DEBUG: Date parsing error: $e");
      return dateString;
    }
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
          '${StringHelper.adExpire} : $remainingDays ${StringHelper.days}',
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w800, fontSize: 12),
        );
      }
    }
    return SizedBox.shrink();
  }
}
