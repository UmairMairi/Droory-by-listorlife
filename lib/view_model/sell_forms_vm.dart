import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/routes/app_routes.dart';
import '../base/helpers/string_helper.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/product_detail_model.dart';

import '../base/base_view_model.dart';
import '../base/utils/utils.dart';
import '../view/main/sell/forms/post_added_final_view.dart';

class SellFormsVM extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

  ///---------------------

  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController workSettingTextController = TextEditingController();
  TextEditingController workExperienceTextController = TextEditingController();
  TextEditingController workEducationTextController = TextEditingController();
  TextEditingController lookingForController = TextEditingController();
  TextEditingController brandTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController educationTypeTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController kmDrivenTextController = TextEditingController();
  TextEditingController numOfOwnerTextController = TextEditingController();
  TextEditingController carColorTextController = TextEditingController();
  TextEditingController horsePowerTextController = TextEditingController();
  TextEditingController bodyTypeTextController = TextEditingController();
  TextEditingController engineCapacityTextController = TextEditingController();
  TextEditingController interiorColorTextController = TextEditingController();
  TextEditingController numbCylindersTextController = TextEditingController();
  TextEditingController numbDoorsTextController = TextEditingController();
  TextEditingController carRentalTermTextController = TextEditingController();
  TextEditingController adTitleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController depositTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController ramTextController = TextEditingController();
  TextEditingController storageTextController = TextEditingController();
  TextEditingController screenSizeTextController = TextEditingController();
  TextEditingController materialTextController = TextEditingController();
  TextEditingController sizeTextController = TextEditingController();
  TextEditingController propertyForTextController = TextEditingController();
  TextEditingController propertyForTypeTextController = TextEditingController();
  TextEditingController propertyAgeTextController = TextEditingController();
  TextEditingController noOfBathroomsTextController = TextEditingController();
  TextEditingController noOfBedroomsTextController = TextEditingController();
  TextEditingController furnishingStatusTextController =
      TextEditingController();

  TextEditingController accessToUtilitiesTextController =
      TextEditingController();
  TextEditingController ownershipStatusTextController = TextEditingController();
  TextEditingController paymentTypeTextController = TextEditingController();
  TextEditingController listedByTextController = TextEditingController();
  TextEditingController rentalTermsTextController = TextEditingController();
  TextEditingController rentalPriceTextController = TextEditingController();
  TextEditingController completionStatusTextController =
      TextEditingController();
  TextEditingController deliveryTermTextController = TextEditingController();
  TextEditingController areaSizeTextController = TextEditingController();
  TextEditingController insuranceTextController = TextEditingController();
  TextEditingController levelTextController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  SellFormsVM() {
    priceTextController.addListener(_updateDeposit);
    percentageController.addListener(_updateDeposit);
    WidgetsBinding.instance.platformDispatcher.onLocaleChanged =
        onLanguageChanged;
  }

  ///---------------------
  ///
  int productStatus = 0;
  String adStatus = '';
  int _itemCondition = 1;
  int _transmission = 0;

  int get itemCondition => _itemCondition;

  int get transmission => _transmission;

  set itemCondition(int index) {
    _itemCondition = index;
    notifyListeners();
  }

  set transmission(int value) {
    _transmission = value;
    notifyListeners();
  }

  ///---------------------
  bool _isEditProduct = false;

  bool get isEditProduct => _isEditProduct;

  set isEditProduct(bool value) {
    _isEditProduct = value;
    notifyListeners();
  }

  bool _hasInitializedForEdit = false;

  bool get hasInitializedForEdit => _hasInitializedForEdit;
  set hasInitializedForEdit(bool value) {
    _hasInitializedForEdit = value;
    notifyListeners();
  }

  ///---------------------
  String? country = '';
  String? city = '';
  String? state = '';
  double? adLatitude;
  double? adLongitude;
  String? adCityNameEn;
  String? adDistrictNameEn;
  String? adNeighborhoodNameEn;
  String? adFullDisplayAddress;
  String? adFullDisplayAddressEn;
  bool _isUserImage = false;
  bool get isUserImage => _isUserImage; // Added getter
  set isUserImage(bool value) {
    _isUserImage = value;
    notifyListeners();
  }

  String _mainImagePath = "";
  String _communicationChoice =
      DbHelper.getUserModel()?.communicationChoice ?? '';
  String _currentPropertyType = "Sell";
  String _currentFurnishing = "";
  String _currentAccessToUtilities = "";
  String _currentPaymentOption = "";
  String _currentCompletion = "";
  String _currentDeliveryTerm = "";
  String _selectedOption = 'Select';

  String get selectedOption => _selectedOption;

  String get currentDeliveryTerm => _currentDeliveryTerm;

  String get currentCompletion => _currentCompletion;

  String get currentPaymentOption => _currentPaymentOption;

  String get currentAccessToUtilities => _currentAccessToUtilities;

  String get currentFurnishing => _currentFurnishing;

  String get currentPropertyType => _currentPropertyType;

  String get communicationChoice => _communicationChoice;

  String get mainImagePath => _mainImagePath;

  set communicationChoice(String value) {
    _communicationChoice = value;
    notifyListeners();
  }

  void removeMainImage() {
    _mainImagePath = "";
    _isUserImage = false; // Reset isUserImage
    notifyListeners();
  }

  void onLanguageChanged() {
    // if (context.mounted) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     updateDisplayedLocationText();
    //   });
    // }
  }

  String _currentOwnership = "";
  String get currentOwnership => _currentOwnership;
  set currentOwnership(String value) {
    _currentOwnership = value;
    notifyListeners();
  }

  set mainImagePath(String image) {
    _mainImagePath = image;
    _isUserImage = image.isNotEmpty; // Update isUserImage based on image
    notifyListeners();
  }

  set currentPropertyType(String index) {
    _currentPropertyType = index;
    notifyListeners();
  }

  set currentFurnishing(String index) {
    _currentFurnishing = index;
    notifyListeners();
  }

  set currentAccessToUtilities(String index) {
    _currentAccessToUtilities = index;
    notifyListeners();
  }

  set currentPaymentOption(String index) {
    _currentPaymentOption = index;
    notifyListeners();
  }

  set currentCompletion(String index) {
    _currentCompletion = index;
    notifyListeners();
  }

  set currentDeliveryTerm(String index) {
    _currentDeliveryTerm = index;
    notifyListeners();
  }

  set selectedOption(String value) {
    _selectedOption = value;
    notifyListeners();
  }

  ///---------------------
  List<int?> _amenities = [];
  List<ProductMedias> imagesList = <ProductMedias>[];
  List<String> deletedImageIds = <String>[];
  List<String> educationList = [
    StringHelper.tutions,
    StringHelper.hobbyClasses,
    StringHelper.skillDevelopment,
    StringHelper.others
  ];
  double latitude = 0.0;
  double longitude = 0.0;
  // List<String> jobPositionList = [
  //   StringHelper.contract,
  //   StringHelper.fullTime,
  //   StringHelper.partTime,
  //   StringHelper.temporary
  // ];
  // List<String> salaryPeriodList = [
  //   StringHelper.hourly,
  //   StringHelper.weekly,
  //   StringHelper.monthly,
  //   StringHelper.yearly
  // ];

  final List<String> ramOptions = [
    '2 GB',
    '4 GB',
    '6 GB',
    '8 GB',
    '12 GB',
    '16 GB'
        '16 GB+'
  ];
  final List<String> storageOptions = [
    '1 GB',
    '2 GB',
    '4 GB',
    '8 GB',
    '64 GB',
    '128 GB',
    '256 GB',
    '512 GB',
    '1 TB'
        '1 TB+'
  ];
  final List<String> tvSizeOptions = [
    '24',
    '28',
    '32',
    '40',
    '43',
    '48',
    '50',
    '55',
    '58',
    '65',
    '70',
    '75',
    '85',
    'Other'
  ];
  final List<String?> phoneRamOptions = [
    "2 GB",
    "3 GB",
    "4 GB",
    "6 GB",
    "8 GB",
    "12 GB",
    "16 GB",
  ];
  final List<String?> phoneStorageOptions = [
    "16 GB",
    "32 GB",
    "64 GB",
    "128 GB",
    "256 GB",
    "512 GB",
    "1 TB",
  ];
  // final List<String> experienceOptions = [
  //   StringHelper.noExperience,
  //   StringHelper.oneToThreeYears,
  //   StringHelper.threeToFiveYears,
  //   StringHelper.fiveToTenYears,
  //   StringHelper.tenPlusYears
  // ];
  // final List<String> workSettingOptions = [
  //   StringHelper.remote,
  //   StringHelper.officeBased,
  //   StringHelper.mixOfficeBased,
  //   StringHelper.fieldBased
  // ];
  // final List<String> workEducationOptions = [
  //   StringHelper.noEducation,
  //   StringHelper.student,
  //   StringHelper.highSchool,
  //   StringHelper.diploma,
  //   StringHelper.bDegree,
  //   StringHelper.mDegree,
  //   StringHelper.phd
  // ];

  final List<String> carRentalTermOptions = [
    StringHelper.daily,
    StringHelper.monthly,
    StringHelper.yearly
  ];

  final List<String> horsepowerOptions = [
    StringHelper.lessThan100HP,
    StringHelper.hp100To200,
    StringHelper.hp200To300,
    StringHelper.hp300To400,
    StringHelper.hp400To500,
    StringHelper.hp500To600,
    StringHelper.hp600To700,
    StringHelper.hp700To800,
    StringHelper.hp800Plus,
    StringHelper.other
  ];

  final List<String> engineCapacityOptions = [
    StringHelper.below500cc,
    StringHelper.cc500To999,
    StringHelper.cc1000To1499,
    StringHelper.cc1500To1999,
    StringHelper.cc2000To2499,
    StringHelper.cc2500To2999,
    StringHelper.cc3000To3499,
    StringHelper.cc3500To3999,
    StringHelper.cc4000Plus,
    StringHelper.other
  ];

  final List<String> numbCylindersOptions = [
    '2 Cylinders',
    '3 Cylinders',
    '4 Cylinders',
    '5 Cylinders',
    '6 Cylinders',
    '7 Cylinders',
    '8 Cylinders',
    'Other',
  ];

  final List<String> numbDoorsOptions = [
    StringHelper.doors2,
    StringHelper.doors3,
    StringHelper.doors4,
    StringHelper.doors5Plus
  ];
  Map<int, Map<String, num>> getCategoryPriceRanges() {
    // For category-level prices
    return {
      1: {"min": 50, "max": 1000000}, // Electronics
      2: {"min": 100, "max": 1000000}, // Home and Living
      3: {"min": 50, "max": 500000}, // Fashion (default)
      5: {"min": 50, "max": 400000}, // Hobbies, Music, Art and Books (default)
      7: {"min": 1000, "max": 500000000}, // Business and Industrial
      8: {"min": 50, "max": 800000}, // Services
      6: {"min": 50, "max": 1000000},
      10: {"min": 500, "max": 1000000}, // Mobile and Tablets
      // Default range
      0: {"min": 1000, "max": 100000}, // Default
    };
  }

  Map<int, Map<String, num>> getSubCategoryPriceRanges() {
    // For sub-category specific prices
    return {
      31: {"min": 50, "max": 50000000}, // Hobbies music and art sub-category 31
    };
  }

  Map<int, Map<String, num>> getSubSubCategoryPriceRanges() {
    // For sub-sub-category specific prices
    return {
      104: {"min": 50, "max": 50000000}, // Fashion sub-sub-category 104
      106: {"min": 50, "max": 50000000}, // Fashion sub-sub-category 106
    };
  }
// PASTE THIS METHOD inside your SellFormsVM class, for example, after the properties

  // This method should be called after SellFormLocationScreen returns its data.
  // The 'locationData' map should be structured as defined in its comments.
  bool _isCurrentLanguageArabic() {
    if (context.mounted) {
      return Directionality.of(context) == TextDirection.rtl;
    }
    // Fallback if context is not mounted
    return WidgetsBinding.instance.platformDispatcher.locale.languageCode ==
        'ar';
  }

  // Method to get display address from coordinates
  String _getDisplayAddressFromCoordinates(
      BuildContext context, double lat, double lng) {
    bool isArabic = Directionality.of(context) == TextDirection.rtl;
    CityModel? nearestCity = LocationService.findNearestCity(lat, lng);
    if (nearestCity != null) {
      String cityName = isArabic ? nearestCity.arabicName : nearestCity.name;
      if (nearestCity.districts != null) {
        for (var district in nearestCity.districts!) {
          if (district.neighborhoods != null) {
            for (var neighborhood in district.neighborhoods!) {
              double distanceToNeighborhood = LocationService.calculateDistance(
                  lat, lng, neighborhood.latitude, neighborhood.longitude);
              if (distanceToNeighborhood <= (neighborhood.radius ?? 2.0)) {
                String districtName =
                    isArabic ? district.arabicName : district.name;
                String neighborhoodName =
                    isArabic ? neighborhood.arabicName : neighborhood.name;
                return "$neighborhoodName، $districtName، $cityName";
              }
            }
          }
          double distanceToDistrict = LocationService.calculateDistance(
              lat, lng, district.latitude, district.longitude);
          if (distanceToDistrict <= (district.radius ?? 5.0)) {
            String districtName =
                isArabic ? district.arabicName : district.name;
            return "$districtName، $cityName";
          }
        }
      }
      return cityName;
    }
    return isArabic ? "موقع غير محدد" : "Unknown Location";
  }

  // Method to fallback to profile location
  void _fallbackToProfileLocation() {
    bool isArabic = _isCurrentLanguageArabic();
    final user = DbHelper.getUserModel();

    // Try to use profile's structured location data
    if (user?.cityEn != null && user!.cityEn!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(user.cityEn!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;
        String districtName = "";
        String neighborhoodName = "";

        if (user.districtEn != null && user.districtEn!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, user.districtEn!);
          if (districtModel != null) {
            districtName =
                isArabic ? districtModel.arabicName : districtModel.name;
            if (user.neighborhoodEn != null &&
                user.neighborhoodEn!.isNotEmpty) {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, user.neighborhoodEn!);
              if (neighborhoodModel != null) {
                neighborhoodName = isArabic
                    ? neighborhoodModel.arabicName
                    : neighborhoodModel.name;
                addressTextController.text =
                    "$neighborhoodName، $districtName، $cityName";

                // Also set the ad location to profile location as fallback
                adLatitude = user.latitude?.toDouble();
                adLongitude = user.longitude?.toDouble();
                adCityNameEn = user.cityEn;
                adDistrictNameEn = user.districtEn;
                adNeighborhoodNameEn = user.neighborhoodEn;
                adFullDisplayAddress = addressTextController.text;

                notifyListeners();
                return;
              }
            }
            addressTextController.text = "$districtName، $cityName";

            adLatitude = user.latitude?.toDouble();
            adLongitude = user.longitude?.toDouble();
            adCityNameEn = user.cityEn;
            adDistrictNameEn = user.districtEn;
            adNeighborhoodNameEn = null;
            adFullDisplayAddress = addressTextController.text;

            notifyListeners();
            return;
          }
        }
        addressTextController.text = cityName;

        adLatitude = user.latitude?.toDouble();
        adLongitude = user.longitude?.toDouble();
        adCityNameEn = user.cityEn;
        adDistrictNameEn = null;
        adNeighborhoodNameEn = null;
        adFullDisplayAddress = addressTextController.text;

        notifyListeners();
        return;
      }
    }

    // Final fallback to raw address or coordinates
    if (user?.latitude != null && user!.longitude != null) {
      double? latDouble = user.latitude?.toDouble();
      double? lngDouble = user.longitude?.toDouble();
      if (latDouble != null &&
          lngDouble != null &&
          !(latDouble == 0.0 && lngDouble == 0.0)) {
        addressTextController.text =
            _getDisplayAddressFromCoordinates(context, latDouble, lngDouble);

        adLatitude = latDouble;
        adLongitude = lngDouble;
        adFullDisplayAddress = addressTextController.text;

        notifyListeners();
        return;
      }
    }

    // Last resort - raw address or empty
    if (user?.address != null && user!.address!.isNotEmpty) {
      addressTextController.text = user.address!;
    } else {
      addressTextController.text = isArabic ? "حدد الموقع" : "Select Location";
    }
    notifyListeners();
  }

  // Method to initialize location from profile (for new ads)
  // void _initializeLocationFromProfile() {
  //   final user = DbHelper.getUserModel();
  //   if (user != null) {
  //     // Copy profile location to ad location initially
  //     if (user.latitude != null && user.longitude != null) {
  //       adLatitude = user.latitude?.toDouble();
  //       adLongitude = user.longitude?.toDouble();
  //       latitude = adLatitude ?? 0.0;
  //       longitude = adLongitude ?? 0.0;
  //     }

  //     adCityNameEn = user.cityEn;
  //     adDistrictNameEn = user.districtEn;
  //     adNeighborhoodNameEn = user.neighborhoodEn;

  //     // Update the display text based on current language
  //     updateDisplayedLocationText();
  //   }
  // }

  // Method to update the displayed location text based on current language
  // void updateDisplayedLocationText() {
  //   print("DEBUG: updateDisplayedLocationText called");
  //   print("DEBUG: context.mounted = ${context.mounted}");

  //   if (!context.mounted) {
  //     print("DEBUG: Context not mounted, returning");
  //     return;
  //   }

  //   bool isArabic = _isCurrentLanguageArabic();
  //   print("DEBUG: isArabic = $isArabic");
  //   print("DEBUG: adCityNameEn = '$adCityNameEn'");
  //   print("DEBUG: adDistrictNameEn = '$adDistrictNameEn'");
  //   print("DEBUG: adNeighborhoodNameEn = '$adNeighborhoodNameEn'");
  //   print("DEBUG: adFullDisplayAddress = '$adFullDisplayAddress'");
  //   print("DEBUG: adLatitude = $adLatitude, adLongitude = $adLongitude");

  //   // If we have structured location data (city, district, neighborhood in English)
  //   if (adCityNameEn != null && adCityNameEn!.isNotEmpty) {
  //     CityModel? cityModel = LocationService.findCityByName(adCityNameEn!);
  //     if (cityModel != null) {
  //       String cityName = isArabic ? cityModel.arabicName : cityModel.name;

  //       if (adDistrictNameEn != null && adDistrictNameEn!.isNotEmpty) {
  //         DistrictModel? districtModel =
  //             LocationService.findDistrictByName(cityModel, adDistrictNameEn!);
  //         if (districtModel != null) {
  //           String districtName =
  //               isArabic ? districtModel.arabicName : districtModel.name;

  //           if (adNeighborhoodNameEn != null &&
  //               adNeighborhoodNameEn!.isNotEmpty) {
  //             NeighborhoodModel? neighborhoodModel =
  //                 LocationService.findNeighborhoodByName(
  //                     districtModel, adNeighborhoodNameEn!);
  //             if (neighborhoodModel != null) {
  //               String neighborhoodName = isArabic
  //                   ? neighborhoodModel.arabicName
  //                   : neighborhoodModel.name;
  //               addressTextController.text =
  //                   "$neighborhoodName، $districtName، $cityName";
  //               notifyListeners();
  //               return;
  //             }
  //           }
  //           addressTextController.text = "$districtName، $cityName";
  //           notifyListeners();
  //           return;
  //         }
  //       }
  //       addressTextController.text = cityName;
  //       notifyListeners();
  //       return;
  //     }
  //   }

  //   // If we have coordinates but no structured data, use coordinates
  //   if (adLatitude != null &&
  //       adLongitude != null &&
  //       adLatitude != 0.0 &&
  //       adLongitude != 0.0) {
  //     addressTextController.text =
  //         _getDisplayAddressFromCoordinates(context, adLatitude!, adLongitude!);
  //     notifyListeners();
  //     return;
  //   }

  //   // If we have a nearby/full display address, try to parse and localize it
  //   if (adFullDisplayAddress != null && adFullDisplayAddress!.isNotEmpty) {
  //     // Try to parse the address if it's in "neighborhood, district, city" format
  //     List<String> parts =
  //         adFullDisplayAddress!.split(',').map((e) => e.trim()).toList();
  //     if (parts.length >= 2) {
  //       // Try to match the last part as city
  //       String possibleCity = parts.last;
  //       CityModel? cityModel = LocationService.findCityByName(possibleCity);
  //       if (cityModel == null) {
  //         // Try finding by Arabic name
  //         cityModel = LocationService.majorEgyptianCities.firstWhere(
  //           (city) => city.arabicName == possibleCity,
  //           orElse: () => null as CityModel,
  //         );
  //       }

  //       if (cityModel != null) {
  //         // We found the city, now try to parse district and neighborhood
  //         addressTextController.text = _buildAddressFromComponents();
  //         notifyListeners();
  //         return;
  //       }
  //     }

  //     // If parsing fails, use the address as is
  //     addressTextController.text = adFullDisplayAddress!;
  //     notifyListeners();
  //     return;
  //   }

  //   // Default text if nothing is available
  //   addressTextController.text = isArabic ? "حدد الموقع" : "Select Location";
  //   notifyListeners();
  // }

// REPLACE your existing handleLocationSelectedFromAdForm method with this:
  void handleLocationSelectedFromAdForm(Map<String, dynamic> locationData) {
    print("Received location data: $locationData");

    // Update all location fields
    adLatitude = locationData['latitude'] as double?;
    latitude = adLatitude ?? 0.0;

    adLongitude = locationData['longitude'] as double?;
    longitude = adLongitude ?? 0.0;

    adCityNameEn = locationData['city_name_en'] as String?;
    city = adCityNameEn;

    adDistrictNameEn = locationData['district_name_en'] as String?;
    adNeighborhoodNameEn = locationData['neighborhood_name_en'] as String?;

    // Get the display address that's already localized from the location screen
    String? displayAddress = locationData['display_address'] as String?;
    adFullDisplayAddress = displayAddress;
    adFullDisplayAddressEn = locationData['full_address_en'] as String?;

    // Simply set the text field with the display address
    if (displayAddress != null && displayAddress.isNotEmpty) {
      addressTextController.text = displayAddress;
    } else {
      // Fallback - build address from components
      addressTextController.text = _buildAddressFromComponents();
    }

    // REMOVE OR COMMENT OUT THIS LINE - it's causing the form validation to reset
    // notifyListeners();

    print("Location text set to: ${addressTextController.text}");
  }

  String _buildAddressFromComponents() {
    bool isArabic = _isCurrentLanguageArabic();

    if (adCityNameEn == null || adCityNameEn!.isEmpty) {
      return isArabic ? "حدد الموقع" : "Select Location";
    }

    // Try to get localized names
    CityModel? cityModel = LocationService.findCityByName(adCityNameEn!);
    if (cityModel == null) {
      return adCityNameEn!; // Return English name if not found
    }

    String cityName = isArabic ? cityModel.arabicName : cityModel.name;

    if (adDistrictNameEn != null && adDistrictNameEn!.isNotEmpty) {
      DistrictModel? districtModel =
          LocationService.findDistrictByName(cityModel, adDistrictNameEn!);
      if (districtModel != null) {
        String districtName =
            isArabic ? districtModel.arabicName : districtModel.name;

        if (adNeighborhoodNameEn != null && adNeighborhoodNameEn!.isNotEmpty) {
          NeighborhoodModel? neighborhoodModel =
              LocationService.findNeighborhoodByName(
                  districtModel, adNeighborhoodNameEn!);
          if (neighborhoodModel != null) {
            String neighborhoodName = isArabic
                ? neighborhoodModel.arabicName
                : neighborhoodModel.name;
            return "$neighborhoodName، $districtName، $cityName";
          }
        }
        return "$districtName، $cityName";
      }
    }

    return cityName;
  }

// ... (rest of your SellFormsVM class methods like addProduct, editProduct, etc.)
  num getMinPrice(CategoryModel? categoryModel, CategoryModel? subCategory,
      CategoryModel? subSubCategory) {
    // Check sub-sub-category first
    if (subSubCategory != null) {
      var subSubRanges = getSubSubCategoryPriceRanges();
      if (subSubRanges.containsKey(subSubCategory.id)) {
        return subSubRanges[subSubCategory.id]!["min"]!;
      }
    }

    // Then check sub-category
    if (subCategory != null) {
      var subRanges = getSubCategoryPriceRanges();
      if (subRanges.containsKey(subCategory.id)) {
        return subRanges[subCategory.id]!["min"]!;
      }
    }

    // Finally default to category
    var ranges = getCategoryPriceRanges();
    int categoryId = categoryModel?.id ?? 0;
    return ranges.containsKey(categoryId)
        ? ranges[categoryId]!["min"]!
        : ranges[0]!["min"]!;
  }

  num getMaxPrice(CategoryModel? categoryModel, CategoryModel? subCategory,
      CategoryModel? subSubCategory) {
    // Check sub-sub-category first
    if (subSubCategory != null) {
      var subSubRanges = getSubSubCategoryPriceRanges();
      if (subSubRanges.containsKey(subSubCategory.id)) {
        return subSubRanges[subSubCategory.id]!["max"]!;
      }
    }

    // Then check sub-category
    if (subCategory != null) {
      var subRanges = getSubCategoryPriceRanges();
      if (subRanges.containsKey(subCategory.id)) {
        return subRanges[subCategory.id]!["max"]!;
      }
    }

    // Finally default to category
    var ranges = getCategoryPriceRanges();
    int categoryId = categoryModel?.id ?? 0;
    return ranges.containsKey(categoryId)
        ? ranges[categoryId]!["max"]!
        : ranges[0]!["max"]!;
  }

  String formatPrice(num price) {
    // Format with thousands separator
    if (price >= 1000) {
      return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    }
    return price.toString();
  }

  final List<CategoryModel> sizeOptions = [];
  List<CategoryModel?> _allModels = [];
  List<String> yearsType = [];

  List<String> fuelsType = [
    StringHelper.petrol,
    StringHelper.diesel,
    StringHelper.electric,
    StringHelper.hybrid,
    StringHelper.gas
  ];
  List<int?> get amenities => _amenities;

  List<CategoryModel?> get allModels => _allModels;

  set amenities(List<int?> value) {
    _amenities = value;
    notifyListeners();
  }

  set allModels(List<CategoryModel?> values) {
    _allModels = values;
    notifyListeners();
  }

  ///---------------------

  CategoryModel? _selectedBrand;
  CategoryModel? _selectedModel;
  CategoryModel? _selectedSize;

  CategoryModel? get selectedBrand => _selectedBrand;

  CategoryModel? get selectedSize => _selectedSize;

  CategoryModel? get selectedModel => _selectedModel;

  set selectedBrand(CategoryModel? value) {
    _selectedBrand = value;
    notifyListeners();
  }

  set selectedModel(CategoryModel? value) {
    _selectedModel = value;
    notifyListeners();
  }

  set selectedSize(CategoryModel? value) {
    _selectedSize = value;
    notifyListeners();
  }

  List<String> getYearList() {
    List<String> years = [];
    int currentYear = DateTime.now().year;
    for (int i = 0; i < 20; i++) {
      years.add((currentYear - i).toString());
    }
    return years;
  }

  ///---------------------
  final FocusNode priceText = FocusNode();
  final FocusNode yearText = FocusNode();
  final FocusNode kmDrivenText = FocusNode();
  final FocusNode ownerText = FocusNode();

  String getPositionType({required String type}) {
    switch (type) {
      case 'Contract':
        return 'contract';
      case 'Full Time':
        return 'full time';
      case 'Part time':
        return 'part time';
      case 'Temporary':
        return 'temporary';
      default:
        return 'contract';
    }
  }

  String getSalaryPeriod({required String type}) {
    /// 'Hourly', 'Monthly', 'Weekly', 'Yearly'
    switch (type) {
      case 'Hourly':
        return 'hourly';
      case 'Monthly':
        return 'monthly';
      case 'Weekly':
        return 'weekly';
      case 'Yearly':
        return 'yearly';
      default:
        return 'hourly';
    }
  }

// Add these properties at the top of your SellFormsVM class
  Future<List<CategoryModel>>? _cachedSizeOptions;
  String? _cachedSizeSubCategoryId;

// Add these methods to your SellFormsVM class
  Future<List<CategoryModel>> getCachedSizeOptions(String subCategoryId) {
    // If we already have cached data for this subcategory, return it
    if (_cachedSizeOptions != null &&
        _cachedSizeSubCategoryId == subCategoryId) {
      return _cachedSizeOptions!;
    }

    // Otherwise, fetch new data and cache it
    _cachedSizeSubCategoryId = subCategoryId;
    _cachedSizeOptions = getSizeOptions(subCategoryId);
    return _cachedSizeOptions!;
  }

// Clear cache when needed (call this when changing categories)
  void clearSizeCache() {
    _cachedSizeOptions = null;
    _cachedSizeSubCategoryId = null;
  }

  @override
  void onReady() {
    // TODO: implement onInit
    // resetTextFields();
    super.onReady();
  }

  void _updateDeposit() {
    final price = num.tryParse(priceTextController.text) ?? 0;
    final percentage = num.tryParse(percentageController.text) ?? 0;
    if (price > 0 && percentage > 0 && percentage <= 100) {
      final deposit = (price * percentage / 100).round();
      depositTextController.text = deposit.toString();
    }
    notifyListeners();
  }

  void addImage(String path) {
    imagesList.add(ProductMedias(media: path));
    notifyListeners();
  }

  void removeImage(int index, {required ProductMedias data}) {
    imagesList.removeAt(index);
    deletedImageIds.add("${data.id}");
    notifyListeners();
  }

  void updateTextFieldsItems({ProductDetailModel? item}) async {
    print("DEBUG updateTextFieldsItems called:");
    print("  - item is null? ${item == null}");
    print("  - hasInitializedForEdit before reset = $hasInitializedForEdit");

    // resetTextFields();
    if (item == null) {
      communicationChoice = DbHelper.getUserModel()?.communicationChoice ?? '';
      isEditProduct = false;
      isUserImage = false;
      return;
    }

    log("${item.toJson()}", name: "Product Detail", level: 200);
    hasInitializedForEdit = false;

    isEditProduct = true;

    imagesList.clear();
    deletedImageIds.clear();

    var productImagesList = item.productMedias ?? [];
    if (productImagesList.isNotEmpty) {
      for (var element in productImagesList) {
        if ((element.media ?? "").isNotEmpty) {
          imagesList.add(ProductMedias(
            id: element.id,
            media: "${ApiConstants.imageUrl}/${element.media}",
          ));
        }
      }
    }

    // adCityNameEn = item.city;
    // adDistrictNameEn = item.districtName;
    // adNeighborhoodNameEn = item.neighborhoodName;
    // adFullDisplayAddress = item.nearby;

// Set latitude and longitude if available
//     if (item.nearby != null && item.nearby!.isNotEmpty) {
//       addressTextController.text = item.nearby!;
//       print(
//           "DEBUG: Set addressTextController.text from nearby = '${addressTextController.text}'");
//     } else {
//       print("DEBUG: item.nearby is null or empty");
//     }
// // Don't set the text here - let updateDisplayedLocationText handle it
// // Update display immediately with proper language
//     print("DEBUG: Before calling updateDisplayedLocationText");
//     print(
//         "DEBUG: addressTextController.text = '${addressTextController.text}'");

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       print("DEBUG: After updateDisplayedLocationText (next frame)");
//       print(
//           "DEBUG: addressTextController.text = '${addressTextController.text}'");
//     });

    if (item.brandId != null) {
      getModels(brandId: int.tryParse("${item.brandId}") ?? 0);
    }

    transmission = (item.transmission?.isNotEmpty ?? false)
        ? (item.transmission == 'manual' ? 2 : 1)
        : 0;

    // Only set mainImagePath if there's actually an image
    print("DEBUG: item.image = '${item.image}'");
    print("DEBUG: item.image?.isNotEmpty = ${item.image?.isNotEmpty}");

// Only set mainImagePath if there's actually an image
    // Handle main image - check for null, empty, whitespace, or '0'
    String? imageValue = item.image;
    if (imageValue != null &&
        imageValue.trim().isNotEmpty &&
        imageValue != '0' &&
        imageValue != '0.jpg' &&
        imageValue != '0.png') {
      mainImagePath = "${ApiConstants.imageUrl}/${imageValue}";
      isUserImage = true;
    } else {
      mainImagePath = '';
      isUserImage = false;
    }
    adTitleTextController.text = item.name ?? '';
    descriptionTextController.text = item.description ?? '';
    lookingForController.text = item.lookingFor ?? '';

    // addressTextController.text = item.nearby ?? '';
    priceTextController.text = parseAmount(item.price);
    workEducationTextController.text =
        Utils.getEducationOptions(item.workEducation ?? '');

    productStatus = (item.status ?? 0).toInt();
    adStatus = item.adStatus ?? "";
    if ((item.itemCondition ?? "").isNotEmpty) {
      itemCondition =
          (item.itemCondition?.toLowerCase().contains('used') ?? false) ? 2 : 1;
    }

    brandTextController.text = item.brand?.name ?? '';
    String translatedAddress = getLocalizedLocationForProduct(context, item);
    addressTextController.text = translatedAddress;

    modelTextController.text = item.model?.name ?? '';
    ramTextController.text = Utils.getRam(item.ram?.toString());
    storageTextController.text = Utils.getStorage(item.storage?.toString());
    screenSizeTextController.text = Utils.getCommon(item.screenSize ?? '');
    jobPositionTextController.text = item.positionType ?? '';
    jobSalaryTextController.text =
        Utils.carRentalTerm(item.salleryPeriod ?? '');
    jobSalaryFromController.text = parseSalaryAmount(item.salleryFrom);
    jobSalaryToController.text = parseSalaryAmount(item.salleryTo);
    mileageTextController.text = item.milleage ?? '';
    educationTypeTextController.text =
        Utils.getEducationOptions(item.educationType ?? '');
    workSettingTextController.text = item.workSetting ?? '';
    workExperienceTextController.text =
        Utils.getWorkExperience(item.workExperience ?? '');

    yearTextController.text = item.year?.toString() ?? '';
    fuelTextController.text = Utils.getFuel(item.fuel ?? '');
    horsePowerTextController.text = Utils.getHorsePower(item.horsePower ?? '');
    bodyTypeTextController.text = Utils.getBodyType(item.bodyType);
    interiorColorTextController.text = Utils.getColor(item.interiorColor ?? '');
    engineCapacityTextController.text =
        Utils.getEngineCapacity(item.engineCapacity ?? '');
    carColorTextController.text = Utils.getColor(item.carColor ?? '');
    numbCylindersTextController.text = item.numbCylinders ?? '';
    carRentalTermTextController.text =
        Utils.carRentalTerm(item.carRentalTerm ?? '');
    numbDoorsTextController.text = Utils.getDoorsText(item.numbDoors ?? '');

    kmDrivenTextController.text = item.kmDriven?.toString() ?? '';
    numOfOwnerTextController.text = item.numberOfOwner?.toString() ?? '';
    sizeTextController.text = "${item.fashionSize ?? ''}";
    selectedBrand = item.brandId != null
        ? CategoryModel(id: item.brandId, name: item.brand?.name)
        : null;

    selectedModel = item.modelId != null
        ? CategoryModel(id: item.modelId, name: item.model?.name)
        : null;

    selectedSize = item.sizeId != null
        ? CategoryModel(id: item.sizeId, name: item.fashionSize?.name)
        : null;

    propertyForTextController.text =
        Utils.setPropertyType(item.propertyFor ?? '');
    currentPropertyType = Utils.setPropertyType(item.propertyFor ?? '');
    noOfBedroomsTextController.text =
        Utils.getBedroomsText("${item.bedrooms ?? ''}");
    noOfBathroomsTextController.text =
        Utils.getBathroomsText("${item.bathrooms ?? ''}");
    levelTextController.text = Utils.getCommon(item.level ?? '');
    propertyAgeTextController.text = item.buildingAge ?? '';
    if (Utils.setPropertyType(item.propertyFor ?? '').toLowerCase() == "rent") {
      depositTextController.text = parseAmount(item.deposit);
    } else {
      depositTextController
          .clear(); // Ensure deposit is cleared for sale properties
    }
    insuranceTextController.text = item.insurance ?? '';
    rentalTermsTextController.text = Utils.carRentalTerm(item.rentalTerm ?? '');
    rentalPriceTextController.text = item.rentalPrice ?? '';
    listedByTextController.text = Utils.getCommon(item.listedBy ?? '');
    propertyForTypeTextController.text = Utils.getProperty(item.type ?? '');
    furnishingStatusTextController.text =
        Utils.getFurnished(item.furnishedType ?? '');
    currentFurnishing = Utils.getFurnished(item.furnishedType ?? '');
    currentFurnishing = Utils.getFurnished(item.furnishedType ?? '');
    ownershipStatusTextController.text = Utils.getCommon(item.ownership ?? '');
    paymentTypeTextController.text =
        Utils.getPaymentTyp(item.paymentType ?? '');
    currentPaymentOption = Utils.getPaymentTyp(item.paymentType ?? '');
    String utilities = Utils.getUtilityTyp(item.accessToUtilities ?? '');
    accessToUtilitiesTextController.text = utilities;
    currentAccessToUtilities = utilities;
    sizeTextController.text = item.fashionSize?.name ?? '';

    areaSizeTextController.text = "${item.area ?? ''}";
    completionStatusTextController.text =
        Utils.getUtilityTyp(item.completionStatus ?? '');
    currentCompletion = Utils.getUtilityTyp(item.completionStatus ?? '');
    deliveryTermTextController.text = Utils.getCommon(item.deliveryTerm ?? '');
    currentDeliveryTerm = Utils.getCommon(item.deliveryTerm ?? '');

    amenities =
        item.productAmenities?.map((element) => element.amnityId).toList() ??
            [];
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return num.parse("${amount ?? 0}").toStringAsFixed(0);
  }

  String parseSalaryAmount(dynamic amount) {
    // If amount is null, empty, or "0", return empty string for text fields
    if (amount == null || "$amount".isEmpty || "$amount" == "0") return "";

    // For actual numbers, format them properly
    try {
      num parsedAmount = num.parse("$amount");
      // If the parsed amount is 0, return empty string
      if (parsedAmount == 0) return "";
      return parsedAmount.toStringAsFixed(0);
    } catch (e) {
      return "";
    }
  }

  bool _showValidationErrors = false;
  bool get showValidationErrors => _showValidationErrors;
  set showValidationErrors(bool value) {
    _showValidationErrors = value;
    notifyListeners();
  }

  void resetTextFields() async {
    showValidationErrors = false;
    currentPropertyType = "Sell";
    currentFurnishing = "";
    currentAccessToUtilities = "";
    currentPaymentOption = "";
    currentCompletion = "";
    currentDeliveryTerm = "";
    itemCondition = 1;
    transmission = 0;
    mainImagePath = "";
    isUserImage = false; // Reset isUserImage
    adStatus = "";
    selectedOption = "";
    yearsType.clear();
    yearsType = getYearList();
    imagesList.clear();
    amenities.clear();
    jobPositionTextController.clear();
    jobSalaryTextController.clear();
    jobSalaryFromController.clear();
    jobSalaryToController.clear();
    workSettingTextController.clear();
    workExperienceTextController.clear();
    workEducationTextController.clear();
    lookingForController.clear();
    brandTextController.clear();
    percentageController.clear();
    modelTextController.clear();
    mileageTextController.clear();
    educationTypeTextController.clear();
    yearTextController.clear();
    fuelTextController.clear();
    kmDrivenTextController.clear();
    numOfOwnerTextController.clear();
    carColorTextController.clear();
    horsePowerTextController.clear();
    bodyTypeTextController.clear();
    engineCapacityTextController.clear();
    interiorColorTextController.clear();
    numbCylindersTextController.clear();
    carRentalTermTextController.clear();
    numbDoorsTextController.clear();
    adTitleTextController.clear();
    descriptionTextController.clear();
    priceTextController.clear();
    depositTextController.clear();

    ramTextController.clear();
    storageTextController.clear();
    screenSizeTextController.clear();
    materialTextController.clear();
    sizeTextController.clear();
    propertyForTextController.clear();
    propertyForTypeTextController.clear();
    propertyAgeTextController.clear();
    noOfBathroomsTextController.clear();
    noOfBedroomsTextController.clear();
    furnishingStatusTextController.clear();
    accessToUtilitiesTextController.clear();
    ownershipStatusTextController.clear();
    paymentTypeTextController.clear();
    listedByTextController.clear();
    rentalTermsTextController.clear();
    rentalPriceTextController.clear();
    completionStatusTextController.clear();
    deliveryTermTextController.clear();
    areaSizeTextController.clear();
    insuranceTextController.clear();

    levelTextController.clear();
    selectedBrand = null;
    selectedModel = null;
    selectedSize = null;
    adLatitude = null;
    adLongitude = null;
    adCityNameEn = null;
    adDistrictNameEn = null;
    adNeighborhoodNameEn = null;
    adFullDisplayAddress = null;
    addressTextController.clear();
    // bool isArabic = _isCurrentLanguageArabic();

    // addressTextController.text = isArabic ? "حدد الموقع" : "Select Location";

    // if (!isEditProduct) {
    //   addressTextController.clear();
    // }
// Clear the text field initially

    // Now, initialize from the user's profile
    final user = DbHelper.getUserModel();
    // if (user != null) {
    //   if (user.latitude != null && user.longitude != null) {
    //     // Try to parse latitude and longitude from user profile
    //     // These might be String or num, handle accordingly.
    //     final latDouble = double.tryParse(user.latitude.toString());
    //     final lonDouble = double.tryParse(user.longitude.toString());

    //     if (latDouble != null && lonDouble != null) {
    //       adLatitude = latDouble;
    //       adLongitude = lonDouble;
    //       latitude = latDouble; // Keep these general ones updated too
    //       longitude = lonDouble;
    //     }
    //   }
    //   adCityNameEn = user
    //       .cityEn; // Assuming UserModel has cityEn, districtEn, neighborhoodEn
    //   adDistrictNameEn = user.districtEn;
    //   adNeighborhoodNameEn = user.neighborhoodEn;
    //   adFullDisplayAddress =
    //       user.address; // The user's saved (possibly localized) address string
    // }
    // if (adCityNameEn != null && adCityNameEn!.isNotEmpty) {
    //   addressTextController.text = _buildAddressFromComponents();
    // } else {
    //   // Try to get location from user profile
    //   Position? position = await LocationHelper.getCurrentLocation();
    //   if (position != null) {
    //     addressTextController.text =
    //         await LocationHelper.getAddressFromCoordinates(
    //             position.latitude, position.longitude);
    //   } else if (DbHelper.getUserModel()?.address != null) {
    //     addressTextController.text = DbHelper.getUserModel()!.address!;
    //   } else {
    //     bool isArabic = _isCurrentLanguageArabic();
    //     addressTextController.text =
    //         isArabic ? "حدد الموقع" : "Select Location";
    //   }
    // }
    // Position? position = await LocationHelper.getCurrentLocation();
    // if (position != null) {
    //   addressTextController.text =
    //       await LocationHelper.getAddressFromCoordinates(
    //           position.latitude, position.longitude);
    // } else {
    //   addressTextController.text = DbHelper.getUserModel()?.address ?? '';
    // }
  }

  Future<List<CategoryModel>> getBrands({CategoryModel? data}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getBrandsUrl(id: "${data?.id}"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));

    return model.body ?? [];
  }

  Future<void> getModels({required int? brandId}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getModelsUrl(brandId: "$brandId"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    DialogHelper.hideLoading();
    allModels = model.body ?? [];
    debugPrint("response ~--> $response");
  }

  Future<List<CategoryModel>> getSizeOptions(String id) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getFashionSizeUrl(id: id),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    return model.body ?? [];
  }

  String? transformToSnakeCase(String? value) =>
      value?.toLowerCase().split(' ').join('_');

  String? trimController(TextEditingController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  Map<String, dynamic> _filterValidFields(Map<String, dynamic> fields) {
    final body = <String, dynamic>{};
    fields.forEach((key, value) {
      if (value != null && "$value".trim().isNotEmpty) {
        body[key] = value;
      }
    });
    return body;
  }

  bool _isPhoneVerified = false;
  String? _currentPhone;

  bool get isPhoneVerified => _isPhoneVerified;
  String? get currentPhone => _currentPhone;

// Add this method:
  void updatePhoneVerificationStatus(bool isVerified, String? phone) {
    _isPhoneVerified = isVerified;
    _currentPhone = phone;
    notifyListeners();
  }

  String _getCommunicationChoice() {
    return communicationChoice == "none" || communicationChoice.isEmpty
        ? "chat"
        : communicationChoice;
  }

  Future<Position?> _getPositionFromAddress() async {
    String addressText = addressTextController.text.trim();

    // If using coordinates from location selection, return them directly
    if (latitude != 0.0 && longitude != 0.0) {
      return Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 100.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }

    if (addressText.isEmpty || addressText.toLowerCase() == "all egypt") {
      // Set default Egypt coordinates
      latitude = 30.0444; // Cairo
      longitude = 31.2357;
      return Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 100.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }

    // Only try geocoding as last resort
    try {
      Position? position =
          await LocationHelper.getCoordinatesFromAddress(addressText);
      if (position != null) {
        latitude = position.latitude;
        longitude = position.longitude;
        return position;
      }
    } catch (e) {
      debugPrint("Geocoding failed: $e");
    }

    // Fallback to default coordinates
    latitude = 30.0444;
    longitude = 31.2357;
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 100.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  Future<bool> _validateLocationIsEgypt(Position? position) async {
    if (position == null) {
      // If no position, don't show error - just use default Egypt coordinates
      latitude = 30.0444; // Cairo coordinates
      longitude = 31.2357;
      return true; // Allow the form to proceed
    }

    var lat = position.latitude;
    var lng = position.longitude;

    // Check if coordinates are within Egypt bounds
    if (lat < 22.0 || lat > 31.8 || lng < 25.0 || lng > 37.0) {
      DialogHelper.hideLoading();
      LocationHelper.showPopupAddProduct(context, () {});
      return false;
    }

    // Additional check using geocoding (only if coordinates look valid)
    try {
      bool isEgypt = await LocationHelper.checkLocationIsEgypt(
        latitude: lat,
        longitude: lng,
      );

      if (!isEgypt) {
        DialogHelper.hideLoading();
        LocationHelper.showPopupAddProduct(context, () {});
        return false;
      }
    } catch (e) {
      debugPrint(
          "Geocoding validation failed, but coordinates are in Egypt bounds: $e");
      // If geocoding fails but coordinates are in Egypt bounds, allow it
    }

    return true;
  }

  Future<String> _uploadMainImage() async {
    if (mainImagePath.isNotEmpty) {
      if (mainImagePath.contains('http')) {
        return mainImagePath.split('/').last;
      } else {
        try {
          return await BaseClient.uploadImage(imagePath: mainImagePath).timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              log("Main image upload timed out", name: "UploadImage");
              DialogHelper.showToast(
                  message: "Main image upload timed out. Using placeholder.");
              return ''; // Return empty on timeout
            },
          );
        } catch (e) {
          log("Error uploading main image: $e", name: "UploadImage");
          DialogHelper.showToast(
              message: "Failed to upload main image. Using placeholder.");
          return '';
        }
      }
    }
    return "";
  }

  String getLocalizedLocationForProduct(
      BuildContext context, ProductDetailModel? data) {
    bool isArabic = _isCurrentLanguageArabic();

    if (data?.nearby != null && data!.nearby!.isNotEmpty) {
      List<String> parts =
          data.nearby!.split(',').map((e) => e.trim()).toList();
      String finalCityEng = "";
      String finalDistrictEng = "";
      String finalNeighborhoodEng = "";

      if (parts.length == 3) {
        finalNeighborhoodEng = parts[0];
        finalDistrictEng = parts[1];
        finalCityEng = parts[2];
      } else if (parts.length == 2) {
        finalDistrictEng = parts[0];
        finalCityEng = parts[1];
      } else if (parts.length == 1) {
        finalCityEng = parts[0];
      }

      if (finalCityEng.isNotEmpty) {
        CityModel? cityModelFromNearby =
            LocationService.findCityByName(finalCityEng);
        if (cityModelFromNearby != null) {
          String cityNearbyLocalized = isArabic
              ? cityModelFromNearby.arabicName
              : cityModelFromNearby.name;
          if (finalDistrictEng.isNotEmpty) {
            DistrictModel? districtModelFromNearby =
                LocationService.findDistrictByName(
                    cityModelFromNearby, finalDistrictEng);
            if (districtModelFromNearby != null) {
              String districtNearbyLocalized = isArabic
                  ? districtModelFromNearby.arabicName
                  : districtModelFromNearby.name;
              if (finalNeighborhoodEng.isNotEmpty) {
                NeighborhoodModel? neighborhoodModelFromNearby =
                    LocationService.findNeighborhoodByName(
                        districtModelFromNearby, finalNeighborhoodEng);
                if (neighborhoodModelFromNearby != null) {
                  String neighborhoodNearbyLocalized = isArabic
                      ? neighborhoodModelFromNearby.arabicName
                      : neighborhoodModelFromNearby.name;
                  return "$neighborhoodNearbyLocalized، $districtNearbyLocalized، $cityNearbyLocalized";
                }
              }
              return "$districtNearbyLocalized، $cityNearbyLocalized";
            }
          }
          return cityNearbyLocalized;
        }
      }
      return data.nearby!;
    }

    return isArabic ? "مصر" : "Egypt";
  }

  Future<List<String>> _uploadMediaImages() async {
    final results = <String>[];

    // Process images in batches of 3
    for (int i = 0; i < imagesList.length; i += 3) {
      final batch = <Future<String>>[];

      // Create a batch of up to 3 images
      for (int j = i; j < i + 3 && j < imagesList.length; j++) {
        final path = imagesList[j].media ?? '';

        if (path.isEmpty) continue;

        // Check if this is an existing image from server (has http URL)
        if (path.startsWith('http')) {
          // Skip existing images - don't add them to upload results
          continue;
        } else {
          // This is a new image that needs to be uploaded
          batch.add(BaseClient.uploadImage(imagePath: path).timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              log("Image upload timed out: $path", name: "UploadImage");
              return '';
            },
          ).catchError((error) {
            log("Error uploading image: $error", name: "UploadImage");
            return '';
          }));
        }
      }

      // Wait for this batch to complete before starting next batch
      if (batch.isNotEmpty) {
        final batchResults = await Future.wait(batch);
        results.addAll(batchResults);
      }
    }

    return results.where((id) => id.isNotEmpty).toList();
  }

  Future<void> addProduct({
    required CategoryModel? category,
    required CategoryModel? subCategory,
    CategoryModel? subSubCategory,
    CategoryModel? brand,
    CategoryModel? models,
    Function(ProductDetailModel? model)? onSuccess,
  }) async {
    Position? position = await _getPositionFromAddress();
    if (!_isPhoneVerified || _currentPhone == null || _currentPhone!.isEmpty) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }
    if (!await _validateLocationIsEgypt(position)) return;
// Upload main image and other images at the same time
    final uploadResults = await Future.wait([
      _uploadMainImage(),
      _uploadMediaImages(),
    ]);

    final mainImage = uploadResults[0] as String;
    final images = uploadResults[1] as List<String>;
    final communication = _getCommunicationChoice();
    if (addressTextController.text.trim().isEmpty ||
        adLatitude == null ||
        adLongitude == null) {
      DialogHelper.showToast(message: StringHelper.locationIsRequired);
      DialogHelper.hideLoading(); // Hide loading if shown before this check
      return;
    }

    Map<String, dynamic> fields = {
      "name": trimController(adTitleTextController),
      "description": trimController(descriptionTextController),
      "looking_for": Utils.setCommon(trimController(lookingForController)),
      "latitude": adLatitude.toString(), // Send as string
      "longitude": adLongitude.toString(), // Send as string
      "city": adCityNameEn ?? "", // ENGLISH city name for API
      "district_name": adDistrictNameEn ?? "", // ENGLISH district name for API
      "neighborhood_name":
          adNeighborhoodNameEn ?? "", // ENGLISH neighborhood name for API
      "nearby": adFullDisplayAddressEn?.isNotEmpty == true
          ? adFullDisplayAddressEn // Use English full address if available
          : (adFullDisplayAddress ??
              addressTextController.text
                  .trim()), // Display address (can be localized)

      "price": trimController(priceTextController) ?? '0',
      "year": trimController(yearTextController),
      "fuel": Utils.setFuel(trimController(fuelTextController)),
      "milleage": trimController(mileageTextController),
      "km_driven": trimController(kmDrivenTextController),
      "number_of_owner": trimController(numOfOwnerTextController),
      "car_color": Utils.setColor(trimController(carColorTextController)),
      "horse_power":
          Utils.setHorsePower(trimController(horsePowerTextController)),
      "education_type": Utils.setEducationOptions(
          trimController(educationTypeTextController)),
      "body_type": Utils.setBodyType(trimController(bodyTypeTextController)),
      "engine_capacity":
          Utils.setEngineCapacity(trimController(engineCapacityTextController)),
      "interior_color":
          Utils.setColor(trimController(interiorColorTextController)),
      "numb_cylinders": trimController(numbCylindersTextController),
      "numb_doors": Utils.setDoorsText(trimController(numbDoorsTextController)),
      "car_rental_term":
          Utils.setCarRentalTerm(trimController(carRentalTermTextController)),
      "country": country,
      "state": state,
      // "city": city,
      // "latitude": position?.latitude,
      // "longitude": position?.longitude,
      // "nearby": addressTextController.text.trim(),
      "position_type":
          Utils.setCommon(trimController(jobPositionTextController)),
      "sallery_period": trimController(jobSalaryTextController) != null
          ? getSalaryPeriod(
              type: Utils.setCarRentalTerm(jobSalaryTextController.text.trim()))
          : "",
      // REPLACE only these two lines:
// "sallery_from": trimController(jobSalaryFromController),
// "sallery_to": trimController(jobSalaryToController),

// WITH these two lines:
      "sallery_from": jobSalaryFromController.text.trim().isEmpty
          ? "0"
          : jobSalaryFromController.text.trim(),
      "sallery_to": jobSalaryToController.text.trim().isEmpty
          ? "0"
          : jobSalaryToController.text.trim(),
      "work_setting":
          Utils.setCommon(trimController(workSettingTextController)),
      "work_experience":
          Utils.setWorkExperience(trimController(workExperienceTextController)),
      "work_education": Utils.setEducationOptions(
          trimController(workEducationTextController)),
      "material": trimController(materialTextController),
      "ram": trimController(ramTextController) != null
          ? Utils.setRam(ramTextController.text.trim())
          : null,
      "storage": trimController(storageTextController) != null
          ? Utils.setStorage(storageTextController.text.trim())
          : null,
      "screen_size": Utils.setCommon(trimController(screenSizeTextController)),
      "communication_choice": communication,
      "property_for":
          Utils.setPropertyType(trimController(propertyForTextController)),
      "bedrooms":
          Utils.setBedroomsText(trimController(noOfBedroomsTextController)),
      "bathrooms":
          Utils.setBathroomsText(trimController(noOfBathroomsTextController)),
      "furnished_type":
          Utils.setFurnished(trimController(furnishingStatusTextController)),
      "ownership":
          Utils.setCommon(trimController(ownershipStatusTextController)),
      "payment_type": transformToSnakeCase(
          Utils.setPaymentTyp(trimController(paymentTypeTextController))),
      "completion_status": transformToSnakeCase(
          Utils.setUtilityTyp(trimController(completionStatusTextController))),
      'delivery_term':
          Utils.setCommon(trimController(deliveryTermTextController)),
      "selected_amnities": amenities.isNotEmpty ? amenities.join(',') : "",
      "area": trimController(areaSizeTextController),
      "type": Utils.setProperty(trimController(propertyForTypeTextController)),
      "level": Utils.setCommon(trimController(levelTextController)),
      "building_age": trimController(propertyAgeTextController),
      "listed_by": Utils.setCommon(trimController(listedByTextController)),
      "rental_price": trimController(rentalPriceTextController),
      "rental_term":
          Utils.setCarRentalTerm(trimController(rentalTermsTextController)),
      "deposit": trimController(depositTextController),
      "insurance": trimController(insuranceTextController),
      "access_to_utilities":
          Utils.setUtilityTyp(trimController(accessToUtilitiesTextController)),
    };

    if (mainImage.isNotEmpty) {
      fields.addAll({
        "image": mainImage,
      });
    }

    if (images.isNotEmpty) {
      fields.addAll({
        "medias": images.reversed.toList().join(','),
      });
    }

    // Adding dynamic fields
    if (category != null) fields["category_id"] = category.id;
    if (subCategory != null) fields["sub_category_id"] = subCategory.id;
    if (subSubCategory != null) {
      fields["sub_sub_category_id"] = subSubCategory.id;
    }
    if (brand != null) fields["brand_id"] = brand.id;
    if (models != null) fields["model_id"] = models.id;
    if (selectedSize != null) fields["size_id"] = selectedSize?.id;

    if (category?.id != null &&
        ![6, 8, 9, 11].contains(category?.id) &&
        itemCondition != 0) {
      fields["item_condition"] = itemCondition == 1 ? "new" : "used";
    }

    if (transmission != 0) {
      fields["transmission"] = transmission == 1 ? "automatic" : "manual";
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addProductsUrl(),
        requestType: RequestType.post,
        bodyType: BodyType.formData,
        body: _filterValidFields(fields));

    var response = await BaseClient.handleRequest(apiRequest);
    log("$response", name: "BASEX");
    MapResponse<ProductDetailModel> model = MapResponse.fromJson(
        response, (json) => ProductDetailModel.fromJson(json));
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: StringHelper.adSubmittedForApproval);
    if (onSuccess != null) {
      onSuccess.call(model.body);
    } else {
      // Use a safer navigation approach with AppPages.rootNavigatorKey
      final navigatorKey = AppPages.rootNavigatorKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentContext != null) {
          GoRouter.of(navigatorKey.currentContext!).pushReplacement(Routes.postAddedFinalView, extra: model.body);
        }
      });
    }
  }

  // In your SellFormsVM, replace the editProduct method with this version:

  void editProduct({
    int? productId,
    CategoryModel? category,
    CategoryModel? subCategory,
    CategoryModel? subSubCategory,
    CategoryModel? brand,
    CategoryModel? models,
    VoidCallback? onSuccess, // Add callback parameter
  }) async {
    Position? position = await _getPositionFromAddress();
    if (!_isPhoneVerified || _currentPhone == null || _currentPhone!.isEmpty) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(message: "Please verify your phone number first");
      return;
    }
    if (!await _validateLocationIsEgypt(position)) return;
    adLatitude = position?.latitude;
    adLongitude = position?.longitude;
    if (addressTextController.text.trim().isEmpty || adLatitude == null || adLongitude == null) {
      DialogHelper.showToast(message: StringHelper.locationIsRequired);
      return;
    }
    // Upload main image and other images at the same time
    final uploadResults = await Future.wait([
      _uploadMainImage(),
      _uploadMediaImages(),
    ]);

    final mainImage = uploadResults[0] as String;
    final images = uploadResults[1] as List<String>;

    final communication = _getCommunicationChoice();

    Map<String, dynamic> fields = {
      "product_id": productId,
      "name": trimController(adTitleTextController),
      "description": trimController(descriptionTextController),
      "latitude": adLatitude.toString(), // Send as string
      "longitude": adLongitude.toString(), // Send as string
      "city": adCityNameEn ?? "", // ENGLISH city name for API
      "district_name": adDistrictNameEn ?? "", // ENGLISH district name for API
      "neighborhood_name":
          adNeighborhoodNameEn ?? "", // ENGLISH neighborhood name for API
      "nearby": adFullDisplayAddressEn?.isNotEmpty == true
          ? adFullDisplayAddressEn // Use English full address if available
          : (adFullDisplayAddress ??
              addressTextController.text
                  .trim()), // Display address (can be localized)

      "looking_for": Utils.setCommon(trimController(lookingForController)),
      "price": trimController(priceTextController) ?? "0",
      "year": trimController(yearTextController),
      "fuel": Utils.setFuel(trimController(fuelTextController)),
      "milleage": trimController(mileageTextController),
      "km_driven": trimController(kmDrivenTextController),
      "number_of_owner": trimController(numOfOwnerTextController),
      "education_type": Utils.setEducationOptions(
          trimController(educationTypeTextController)),
      "country": country,
      "state": state,
      // "nearby": addressTextController.text.trim(),
      "position_type":
          Utils.setCommon(trimController(jobPositionTextController)),
      "sallery_period": trimController(jobSalaryTextController) != null
          ? getSalaryPeriod(
              type: Utils.setCarRentalTerm(jobSalaryTextController.text.trim()))
          : "",
      // REPLACE only these two lines:
// "sallery_from": trimController(jobSalaryFromController),
// "sallery_to": trimController(jobSalaryToController),

// WITH these two lines:
      "sallery_from": jobSalaryFromController.text.trim().isEmpty
          ? "0"
          : jobSalaryFromController.text.trim(),
      "sallery_to": jobSalaryToController.text.trim().isEmpty
          ? "0"
          : jobSalaryToController.text.trim(),
      "work_setting":
          Utils.setCommon(trimController(workSettingTextController)),
      "work_experience":
          Utils.setWorkExperience(trimController(workExperienceTextController)),
      "work_education": Utils.setEducationOptions(
          trimController(workEducationTextController)),
      "material": trimController(materialTextController),
      "ram": trimController(ramTextController) != null
          ? Utils.setRam(ramTextController.text.trim())
          : null,
      "storage": trimController(storageTextController) != null
          ? Utils.setStorage(storageTextController.text.trim())
          : null,
      "body_type": Utils.setBodyType(trimController(bodyTypeTextController)),
      "car_color": Utils.setColor(trimController(carColorTextController)),
      "car_rental_term":
          Utils.setCarRentalTerm(trimController(carRentalTermTextController)),
      "screen_size": Utils.setCommon(trimController(screenSizeTextController)),
      "horse_power": trimController(horsePowerTextController),
      "engine_capacity":
          Utils.setEngineCapacity(trimController(engineCapacityTextController)),
      "interior_color":
          Utils.setColor(trimController(interiorColorTextController)),
      "numb_cylinders": trimController(numbCylindersTextController),
      "numb_doors": Utils.setDoorsText(trimController(numbDoorsTextController)),
      "delete_img_id":
          deletedImageIds.isNotEmpty ? deletedImageIds.join(',') : "",
      'communication_choice': communication,
      'property_for': trimController(propertyForTextController),
      "bedrooms":
          Utils.setBedroomsText(trimController(noOfBedroomsTextController)),
      "bathrooms":
          Utils.setBathroomsText(trimController(noOfBathroomsTextController)),
      'furnished_type':
          Utils.setFurnished(trimController(furnishingStatusTextController)),
      'ownership':
          Utils.setCommon(trimController(ownershipStatusTextController)),
      'payment_type': transformToSnakeCase(
          Utils.setPaymentTyp(trimController(paymentTypeTextController))),
      'completion_status': transformToSnakeCase(
          Utils.setUtilityTyp(trimController(completionStatusTextController))),
      'delivery_term':
          Utils.setCommon(trimController(deliveryTermTextController)),
      'selected_amnities': amenities.isNotEmpty ? amenities.join(',') : "",
      'area': trimController(areaSizeTextController),
      'type': Utils.setProperty(trimController(propertyForTypeTextController)),
      "level": Utils.setCommon(trimController(levelTextController)),
      'building_age': trimController(propertyAgeTextController),
      'listed_by': Utils.setCommon(trimController(listedByTextController)),
      'rental_price': trimController(rentalPriceTextController),
      'rental_term':
          Utils.setCarRentalTerm(trimController(rentalTermsTextController)),
      'deposit': trimController(depositTextController),
      'insurance': trimController(insuranceTextController),
      'access_to_utilities':
          Utils.setUtilityTyp(trimController(accessToUtilitiesTextController)),
    };

    if (mainImage.isNotEmpty) {
      fields.addAll({
        "image": mainImage,
      });
    }

    if (images.isNotEmpty) {
      fields.addAll({
        "medias": images.reversed.toList().join(','),
      });
    }

    // Adding dynamic fields
    if (category != null) fields["category_id"] = category.id;
    if (subCategory != null) fields["sub_category_id"] = subCategory.id;
    if (subSubCategory != null) {
      fields["sub_sub_category_id"] = subSubCategory.id;
    }
    if (brand != null) fields["brand_id"] = brand.id;
    if (models != null) fields["model_id"] = models.id;
    if (selectedSize != null) fields["size_id"] = selectedSize?.id;

    if (category?.id != null &&
        ![6, 8, 9, 11].contains(category?.id) &&
        itemCondition != 0) {
      fields["item_condition"] = itemCondition == 1 ? "new" : "used";
    }

    if (transmission != 0) {
      fields["transmission"] = transmission == 1 ? "automatic" : "manual";
    }
    if (adStatus == "deactivate") {
      fields["ad_status"] = "activate";
    }
    fields['status'] = 0;

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.editProductsUrl(),
        requestType: RequestType.put,
        bodyType: BodyType.formData,
        body: _filterValidFields(fields));

    var response = await BaseClient.handleRequest(apiRequest);
    log("$response", name: "BASEX");
    MapResponse<ProductDetailModel> model = MapResponse.fromJson(
        response, (json) => ProductDetailModel.fromJson(json));
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);

    // Use callback instead of Navigator
    if (onSuccess != null) {
      onSuccess();
    } else {
      // Default behavior if no callback provided
      Navigator.of(context)
          .pop(true); // Return true to indicate successful edit
    }
  }
}
