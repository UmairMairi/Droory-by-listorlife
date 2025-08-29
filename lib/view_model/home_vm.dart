import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/scheduler.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/helpers/debouncer_helper.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/city_model.dart';
import '../base/helpers/string_helper.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/home_list_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:math';
import '../base/helpers/db_helper.dart';
import '../base/helpers/dialog_helper.dart';
import '../models/category_model.dart';
import '../models/common/list_response.dart';
import '../models/filter_model.dart';
import '../routes/app_routes.dart';
import '../view/main/home/sub_category_view.dart';

class HomeVM extends BaseViewModel {
  late Future<List<CategoryModel>> cachedCategoryList;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();
  String _currentLocation = '';

  String get currentLocation => _currentLocation;
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 1000);
  String searchQuery = '';

  List<ProductDetailModel> productsList = [];
  List<CategoryModel> categories = [];

  FocusNode searchFocusNode = FocusNode();

  String _publishedBy = 'Posted Within';

  String get publishedBy => _publishedBy;

  set publishedBy(String value) {
    _publishedBy = value;
    notifyListeners();
  }

  bool _isNavigatingToFilter = false;

  bool get isNavigatingToFilter => _isNavigatingToFilter;

  set isNavigatingToFilter(bool value) {
    _isNavigatingToFilter = value;
    notifyListeners();
  }

  set currentLocation(String value) {
    _currentLocation = value;
    notifyListeners();
  }

  int _limit = 20;

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
    notifyListeners();
  }

  int _page = 1;

  int get page => _page;

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  bool _loading = true;

  set isLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get isLoading => _loading;

  int _itemCondition = 0;

  int get itemCondition => _itemCondition;

  set itemCondition(int value) {
    _itemCondition = value;
    notifyListeners();
  }

  Future<void> navigateToFilter(BuildContext context) async {
    try {
      await getCategoryListApi();

      FilterModel filterModel = FilterModel(screenFrom: "home");
      filterModel.latitude = latitude.toString();
      filterModel.longitude = longitude.toString();

      context.push(Routes.filter, extra: filterModel);
    } catch (e) {
      print("Navigation error: $e");
    }
  }

  // Add this method to the HomeVM class in home_vm.dart
  void resetFilterControllers() {
    startPriceTextController.clear();
    endPriceTextController.clear();
    minYearTextController.clear();
    maxYearTextController.clear();
    locationTextController.clear();
    lookingForTextController.clear();
    categoryTextController.clear();
    subCategoryTextController.clear();
    brandsTextController.clear();
    sizesTextController.clear();
    subSubCategoryTextController.clear();
    genderTextController.clear();
    sortByTextController.clear();
    postedWithinTextController.clear();
    yearTextController.clear();
    transmissionTextController.clear();
    fuelTextController.clear();
    screenSizeTextController.clear();
    mileageTextController.clear();
    carRentalTermController.clear();
    minKmDrivenTextController.text = '0';
    maxKmDrivenTextController.text = '1000000';
    bodyTypeTextController.clear();
    horsePowerTextController.clear();
    carColorTextController.clear();
    modelTextController.clear();
    jobPositionTextController.clear();
    jobSalaryTextController.clear();
    jobSalaryToController.clear();
    jobSalaryFromController.clear();
    workSettingTextController.clear();
    workExperienceTextController.clear();
    ramTextController.clear();
    storageTextController.clear();
    workEducationTextController.clear();
    engineCapacityTextController.clear();
    interiorColorTextController.clear();
    numbCylindersTextController.clear();
    numbDoorsTextController.clear();
    propertyForTextController.clear();
    propertyForTypeTextController.clear();
    noOfBathroomsTextController.clear();
    noOfBedroomsTextController.clear();
    furnishingStatusTextController.clear();
    accessToUtilitiesTextController.clear();
    ownershipStatusTextController.clear();
    paymentTypeTextController.clear();
    listedByTextController.clear();
    rentalTermsTextController.clear();
    completionStatusTextController.clear();
    deliveryTermTextController.clear();
    levelTextController.clear();
    startDownPriceTextController.clear();
    endDownPriceTextController.clear();
    startAreaTextController.clear();
    endAreaTextController.clear();
    itemCondition = 0;
    currentPropertyType = "Sell";
    notifyListeners();
  }

  double latitude = 0.0;
  double longitude = 0.0;
  String locationFilterType = "all"; // "all", "city", "nearby"
  CityModel? selectedCity;

  // NEW ENHANCED LOCATION PROPERTIES
  String selectedLocationType =
      "all"; // "all", "city", "district", "neighborhood", "coordinates"
  DistrictModel? selectedDistrict;
  NeighborhoodModel? selectedNeighborhood;
  String? get _apiCityName => selectedCity?.name; // Gets English name
  String? get _apiDistrictName => selectedDistrict?.name; // Gets English name
  String? get _apiNeighborhoodName => selectedNeighborhood?.name;

  void selectCity(CityModel city) {
    selectedCity = city;
    selectedDistrict = null;
    selectedNeighborhood = null;
    locationFilterType = "city";
    selectedLocationType = "city";
    latitude = city.latitude;
    longitude = city.longitude;

    // Use localized name for display
    currentLocation = getLocalizedLocationName();
    locationTextController.text = currentLocation;

    print("Selected city: ${city.name} (${city.latitude}, ${city.longitude})");

    // Save this location
    DbHelper.saveLastLocation(UserModel(
        latitude: city.latitude,
        longitude: city.longitude,
        address: currentLocation));

    // Save user's location preference
    DbHelper.writeData("userSelectedLocation", currentLocation);
    DbHelper.writeData("userSelectedLat", latitude.toString());
    DbHelper.writeData("userSelectedLng", longitude.toString());
    DbHelper.writeData("userSelectedLocationType", selectedLocationType);

    notifyListeners();
    onRefresh();
  }

  // NEW METHOD: Select District
  void selectDistrict(DistrictModel district, CityModel city) {
    selectedDistrict = district;
    selectedCity = city;
    selectedNeighborhood = null;
    selectedLocationType = "district";
    locationFilterType = "district";
    latitude = district.latitude;
    longitude = district.longitude;

    // Use localized name for display
    currentLocation = getLocalizedLocationName();
    locationTextController.text = currentLocation;

    print(
        "Selected district: ${district.name} in ${city.name} (${district.latitude}, ${district.longitude})");

    // Save this location
    DbHelper.saveLastLocation(UserModel(
        latitude: district.latitude,
        longitude: district.longitude,
        address: currentLocation));

    // Save user's location preference
    DbHelper.writeData("userSelectedLocation", currentLocation);
    DbHelper.writeData("userSelectedLat", latitude.toString());
    DbHelper.writeData("userSelectedLng", longitude.toString());
    DbHelper.writeData("userSelectedLocationType", selectedLocationType);

    notifyListeners();
    onRefresh();
  }

  // NEW METHOD: Select Neighborhood
  void selectNeighborhood(
      NeighborhoodModel neighborhood, DistrictModel district, CityModel city) {
    selectedNeighborhood = neighborhood;
    selectedDistrict = district;
    selectedCity = city;
    selectedLocationType = "neighborhood";
    locationFilterType = "neighborhood";
    latitude = neighborhood.latitude;
    longitude = neighborhood.longitude;

    // Use localized name for display
    currentLocation = getLocalizedLocationName();
    locationTextController.text = currentLocation;

    print(
        "Selected neighborhood: ${neighborhood.name} in ${district.name}, ${city.name} (${neighborhood.latitude}, ${neighborhood.longitude})");

    // Save this location
    DbHelper.saveLastLocation(UserModel(
        latitude: neighborhood.latitude,
        longitude: neighborhood.longitude,
        address: currentLocation));

    // Save user's location preference
    DbHelper.writeData("userSelectedLocation", currentLocation);
    DbHelper.writeData("userSelectedLat", latitude.toString());
    DbHelper.writeData("userSelectedLng", longitude.toString());
    DbHelper.writeData("userSelectedLocationType", selectedLocationType);

    notifyListeners();
    onRefresh();
  }

  // ENHANCED updateLatLong METHOD
  void updateLatLong({
    double? lat,
    double? long,
    String? type,
    String?
        address, // Keep this parameter for now, it helps determine initial state
    CityModel? city,
    DistrictModel? district,
    NeighborhoodModel? neighborhood,
  }) async {
    if (lat != null && long != null) {
      latitude = lat;
      longitude = long;
      selectedCity = city; // Store the passed city model
      selectedDistrict = district; // Store the passed district model
      selectedNeighborhood =
          neighborhood; // Store the passed neighborhood model

      // Update location filter type based on the provided type or models
      if (neighborhood != null) {
        selectedLocationType = "neighborhood";
        locationFilterType = "neighborhood";
      } else if (district != null) {
        selectedLocationType = "district";
        locationFilterType = "district";
      } else if (city != null) {
        selectedLocationType = "city";
        locationFilterType = "city";
      } else if (type != null) {
        selectedLocationType = type; // e.g., "search" or "coordinates"
        locationFilterType =
            (type == "search" || type == "coordinates" || type == "nearby")
                ? type
                : "nearby";
      } else {
        selectedLocationType = "coordinates"; // Default if only lat/long given
        locationFilterType = "nearby";
      }

      // If an address string is provided (e.g., from search history or formatted prediction),
      // and it's not meant to be "All Egypt", set it to currentLocation temporarily.
      // getLocalizedLocationName will then use the specific models if available,
      // or this address if it's a custom coordinate search.
      if (address != null && address.isNotEmpty && address != "All Egypt") {
        currentLocation = address;
      } else if (address == "All Egypt") {
        // This case should ideally be handled by the 'else' block below
        // or by ensuring lat/long are 0.0 for "All Egypt"
      } else {
        // If no address string, attempt to get it from coordinates for "coordinates" type
        if (selectedLocationType == "coordinates" ||
            selectedLocationType == "nearby" ||
            selectedLocationType == "search") {
          currentLocation =
              await LocationHelper.getAddressFromCoordinates(lat, long);
        }
      }

      // Now, get the properly localized name
      String localizedName = getLocalizedLocationName();
      currentLocation = localizedName;
      locationTextController.text = localizedName;

      // Save user's location preference (not just last location)
      if (currentLocation != "All Egypt" && currentLocation != "كل مصر") {
        DbHelper.writeData(
            "userSelectedLocation", currentLocation); // Save the localized name
        DbHelper.writeData("userSelectedLat", latitude.toString());
        DbHelper.writeData("userSelectedLng", longitude.toString());
        DbHelper.writeData("userSelectedLocationType", selectedLocationType);

        // For API calls, we might need to store the English components if the selection was specific
        // This depends on how you build your API request parameters.
        // For now, we're focusing on display.
        if (city != null)
          DbHelper.writeData("userSelectedCityEng", city.name);
        else
          DbHelper.deleteData("userSelectedCityEng");
        if (district != null)
          DbHelper.writeData("userSelectedDistrictEng", district.name);
        else
          DbHelper.deleteData("userSelectedDistrictEng");
        if (neighborhood != null)
          DbHelper.writeData("userSelectedNeighborhoodEng", neighborhood.name);
        else
          DbHelper.deleteData("userSelectedNeighborhoodEng");
      }

      // Also save as last location for backward compatibility
      DbHelper.saveLastLocation(UserModel(
          latitude: latitude,
          longitude: longitude,
          address: currentLocation)); // Save localized
    } else {
      // This block is for "All Egypt" or clearing location
      _setDefaultAllEgyptLocation(); // This method already handles localization for "All Egypt"
    }

    print(
        "Location updated: $selectedLocationType, Location: $currentLocation, Lat: $latitude, Lng: $longitude");
    notifyListeners();
    onRefresh();
  }

  Future<void> updateLocation() async {
    // Use the new enhanced current location handler
    await handleCurrentLocation();

    // Save the location and refresh
    _saveLocation();
    onRefresh();
  }

  /// **Helper method to clear location preference**
  void clearLocationPreference() {
    DbHelper.deleteData("userSelectedLocation");
    DbHelper.deleteData("userSelectedLat");
    DbHelper.deleteData("userSelectedLng");
    DbHelper.deleteData("userSelectedLocationType");
    _setDefaultAllEgyptLocation();
    notifyListeners();
    onRefresh();
  }

  Future<Position?> _getCurrentGPSLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled");
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permissions are denied");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied");
        return null;
      }

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10), // 10 second timeout
      );

      return position;
    } catch (e) {
      print("Error getting current location: $e");
      return null;
    }
  }

  Map<String, dynamic>? _findNearestPredefinedLocation(
      double userLat, double userLng) {
    double minDistance = double.infinity;
    Map<String, dynamic>? nearestLocation;

    // Search through all cities, districts, and neighborhoods
    for (var city in LocationService.majorEgyptianCities) {
      // Check city distance
      double cityDistance = LocationService.calculateDistance(
          userLat, userLng, city.latitude, city.longitude);

      // If within city radius, this is a good match
      if (cityDistance <= city.defaultRadius && cityDistance < minDistance) {
        minDistance = cityDistance;
        nearestLocation = {
          'name': city.name,
          'lat': city.latitude,
          'lng': city.longitude,
          'type': 'city',
          'distance': cityDistance,
          'city': city,
          'district': null,
          'neighborhood': null,
        };
      }

      // Also check districts within this city
      if (city.districts != null) {
        for (var district in city.districts!) {
          double districtDistance = LocationService.calculateDistance(
              userLat, userLng, district.latitude, district.longitude);

          // If within district radius and closer than current best
          if (districtDistance <= district.radius &&
              districtDistance < minDistance) {
            minDistance = districtDistance;
            nearestLocation = {
              'name': '${district.name}, ${city.name}',
              'lat': district.latitude,
              'lng': district.longitude,
              'type': 'district',
              'distance': districtDistance,
              'city': city,
              'district': district,
              'neighborhood': null,
            };
          }

          // Also check neighborhoods within this district
          if (district.neighborhoods != null) {
            for (var neighborhood in district.neighborhoods!) {
              double neighborhoodDistance = LocationService.calculateDistance(
                  userLat,
                  userLng,
                  neighborhood.latitude,
                  neighborhood.longitude);

              // If within neighborhood radius and closer than current best
              if (neighborhoodDistance <= neighborhood.radius &&
                  neighborhoodDistance < minDistance) {
                minDistance = neighborhoodDistance;
                nearestLocation = {
                  'name':
                      '${neighborhood.name}, ${district.name}, ${city.name}',
                  'lat': neighborhood.latitude,
                  'lng': neighborhood.longitude,
                  'type': 'neighborhood',
                  'distance': neighborhoodDistance,
                  'city': city,
                  'district': district,
                  'neighborhood': neighborhood,
                };
              }
            }
          }
        }
      }
    }

    // Only return if we found something within reasonable distance (e.g., 100km)
    if (nearestLocation != null && minDistance <= 100.0) {
      return nearestLocation;
    }

    return null; // User is too far from any predefined location
  }

  Future<void> handleCurrentLocation() async {
    try {
      // Step 1: Get current GPS coordinates
      Position? currentPosition = await _getCurrentGPSLocation();

      if (currentPosition == null) {
        // If GPS fails, fallback to "All Egypt"
        _setDefaultAllEgyptLocation();
        notifyListeners();
        return;
      }

      print(
          "Got GPS location: ${currentPosition.latitude}, ${currentPosition.longitude}");

      // Step 2: Find nearest predefined location
      Map<String, dynamic>? nearestLocation = _findNearestPredefinedLocation(
          currentPosition.latitude, currentPosition.longitude);

      if (nearestLocation != null) {
        // Step 3: Update with nearest predefined location
        String locationName = nearestLocation['name'];
        double lat = nearestLocation['lat'];
        double lng = nearestLocation['lng'];
        String type = nearestLocation['type'];

        print(
            "Found nearest location: $locationName ($type) at distance ${nearestLocation['distance']?.toStringAsFixed(2)}km");

        // Update the location using the existing updateLatLong method
        updateLatLong(
          type: "current_location",
          address: locationName,
          lat: lat,
          long: lng,
          city: nearestLocation['city'],
          district: nearestLocation['district'],
          neighborhood: nearestLocation['neighborhood'],
        );
      } else {
        // If user is too far from any predefined location, use "All Egypt"
        print(
            "User location is too far from predefined locations, using All Egypt");
        _setDefaultAllEgyptLocation();
        notifyListeners();
      }
    } catch (e) {
      print("Error in handleCurrentLocation: $e");
      // On any error, fallback to "All Egypt"
      _setDefaultAllEgyptLocation();
      notifyListeners();
    }
  }

  /// **Helper method to set default location to All Egypt**
  void _setDefaultAllEgyptLocation() {
    latitude = 0.0;
    longitude = 0.0;
    locationFilterType = "all";
    selectedLocationType = "all";
    selectedCity = null; // Add this
    selectedDistrict = null; // Add this
    selectedNeighborhood = null; // Add this

    // Always check current language
    bool isArabic = DbHelper.getLanguage() == 'ar';
    currentLocation = isArabic ? "كل مصر" : "All Egypt";
    locationTextController.text = currentLocation;

    // Clear saved preferences when selecting "All Egypt"
    DbHelper.deleteData("userSelectedLocation");
    DbHelper.deleteData("userSelectedLat");
    DbHelper.deleteData("userSelectedLng");
    DbHelper.deleteData("userSelectedLocationType");
    DbHelper.deleteData("userSelectedCityEng");
    DbHelper.deleteData("userSelectedDistrictEng");
    DbHelper.deleteData("userSelectedNeighborhoodEng");

    print("Set default location: $currentLocation");
  }

  /// **Helper method to save location to the database**
  void _saveLocation() {
    if (context.mounted) {
      DbHelper.saveLastLocation(UserModel(
        latitude: latitude,
        longitude: longitude,
        address: currentLocation,
      ));
    }
  }

  TextEditingController startPriceTextController = TextEditingController();
  TextEditingController endPriceTextController = TextEditingController();
  TextEditingController minYearTextController = TextEditingController();
  TextEditingController maxYearTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController lookingForTextController = TextEditingController();
  TextEditingController categoryTextController = TextEditingController();
  TextEditingController subCategoryTextController = TextEditingController();
  TextEditingController brandsTextController = TextEditingController();
  TextEditingController sizesTextController = TextEditingController();
  TextEditingController subSubCategoryTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();
  TextEditingController sortByTextController = TextEditingController();
  TextEditingController postedWithinTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController transmissionTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController screenSizeTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController carRentalTermController = TextEditingController();
  TextEditingController minKmDrivenTextController =
      TextEditingController(text: '0');
  TextEditingController maxKmDrivenTextController =
      TextEditingController(text: '1000000');
  TextEditingController bodyTypeTextController = TextEditingController();
  TextEditingController horsePowerTextController = TextEditingController();
  TextEditingController carColorTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController workSettingTextController = TextEditingController();
  TextEditingController workExperienceTextController = TextEditingController();
  TextEditingController ramTextController = TextEditingController();
  TextEditingController storageTextController = TextEditingController();
  TextEditingController workEducationTextController = TextEditingController();
  TextEditingController engineCapacityTextController = TextEditingController();
  TextEditingController interiorColorTextController = TextEditingController();
  TextEditingController numbCylindersTextController = TextEditingController();
  TextEditingController numbDoorsTextController = TextEditingController();

  // List of mileage ranges
  final List<String> mileageRanges = [
    '0-5 km',
    '5-10 km',
    '10-15 km',
    '15-20 km',
    '20-25 km',
    '25-30 km',
    '30-35 km',
    '35-40 km',
    '40-45 km',
    '45-50 km',
  ];
  void refreshLocationText() {
    // Get the properly localized name based on current language
    String localizedName = getLocalizedLocationName();
    currentLocation = localizedName;
    locationTextController.text = localizedName;
    notifyListeners();
  }

  TextEditingController searchController = TextEditingController();

  List<String> searchQueryesList = [];

  List<String> jobPositionList = [
    StringHelper.contract,
    StringHelper.fullTime,
    StringHelper.partTime,
    StringHelper.temporary
  ];

  List<String> salaryPeriodList = ['Hourly', 'Monthly', 'Weekly', 'Yearly'];
  final List<String> carRentalTermOptions = ['Daily', 'Monthly', 'Yearly'];
  final List<String> bodyTypeOptions = [
    'SUV',
    'Hatchback',
    '4x4',
    'Sedan',
    'Coupe',
    'Convertible',
    'Estate',
    'MPV',
    'Pickup',
    'Crossover',
    'Van/bus',
    'Other',
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
  List<String> ramOptions = ['2 GB', '4 GB', '6 GB', '8 GB', '12 GB', '16 GB'];
  List<String> storageOptions = [
    '1 GB',
    '2 GB',
    '4 GB',
    '8 GB',
    '64 GB',
    '128 GB',
    '256 GB',
    '512 GB',
    '1 TB'
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
  final List<String> numbDoorsOptions = [
    StringHelper.doors2,
    StringHelper.doors3,
    StringHelper.doors4,
    StringHelper.doors5Plus
  ];
  final List<String> experienceOptions = [
    "No experience/Just graduated",
    "1–3 yrs",
    "3–5 yrs",
    "5–10 yrs",
    "10+ yrs"
  ];
  final List<String> workSettingOptions = [
    "Remote",
    "Office-based",
    "Mixed (Home & Office)",
    "Field-based"
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
  final List<String> workEducationOptions = [
    "None",
    "Student",
    "High-Secondary School",
    "Diploma",
    "Bachelors Degree",
    "Masters Degree",
    "Doctorate/PhD"
  ];

  @override
  void onInit() {
    callApiMethods();
    searchQueryesList.addAll(DbHelper.getSearchHistory().reversed.toList());

    searchQueryesList.addAll([
      'Electronics',
      'Home & Living',
      'Fashion',
      'Vehicles',
      'Hobbies, Music, Art & Books',
      'Pets',
      'Business & Industrial',
      'Services',
      'Jobs',
      'Mobiles & Tablets'
    ]);
    refreshController = RefreshController(initialRefresh: true);
    initializeLocationSync();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeLocation();
    });
    super.onInit();
  }

  callApiMethods() async {
    cachedCategoryList = getCategoryListApi();
  }

  void initializeLocationSync() {
    // Check if user has a saved location preference
    String? savedLocationType = DbHelper.readData("userSelectedLocationType");

    if (savedLocationType != null && savedLocationType.isNotEmpty) {
      // User has a saved location preference - restore it
      double? savedLat =
          double.tryParse(DbHelper.readData("userSelectedLat") ?? "0");
      double? savedLng =
          double.tryParse(DbHelper.readData("userSelectedLng") ?? "0");

      latitude = savedLat ?? 0.0;
      longitude = savedLng ?? 0.0;
      locationFilterType = savedLocationType;
      selectedLocationType = savedLocationType;

      // For now, just set a temporary text
      bool isArabic = DbHelper.getLanguage() == 'ar';
      if (savedLocationType == "all") {
        currentLocation = isArabic ? "كل مصر" : "All Egypt";
      } else {
        // Set a temporary location text
        currentLocation = isArabic ? "جاري التحميل..." : "Loading...";
      }
      locationTextController.text = currentLocation;
    } else {
      // No saved preference - default to "All Egypt"
      _setDefaultAllEgyptLocation();
    }
  }

  Future<void> initializeLocation() async {
    try {
      // Check if user has a saved location preference
      String? savedLocationType = DbHelper.readData("userSelectedLocationType");

      if (savedLocationType != null &&
          savedLocationType.isNotEmpty &&
          savedLocationType != "all") {
        // User has a saved location preference - restore it
        double? savedLat =
            double.tryParse(DbHelper.readData("userSelectedLat") ?? "0");
        double? savedLng =
            double.tryParse(DbHelper.readData("userSelectedLng") ?? "0");

        latitude = savedLat ?? 0.0;
        longitude = savedLng ?? 0.0;
        locationFilterType = savedLocationType;
        selectedLocationType = savedLocationType;

        // Restore the location models if they were saved
        if (savedLocationType == "city" ||
            savedLocationType == "district" ||
            savedLocationType == "neighborhood") {
          String? savedCityEng = DbHelper.readData("userSelectedCityEng");
          if (savedCityEng != null) {
            // Find and restore the city model
            selectedCity = LocationService.findCityByName(savedCityEng);

            if (savedLocationType == "district" ||
                savedLocationType == "neighborhood") {
              String? savedDistrictEng =
                  DbHelper.readData("userSelectedDistrictEng");
              if (savedDistrictEng != null && selectedCity != null) {
                selectedDistrict = LocationService.findDistrictByName(
                    selectedCity!, savedDistrictEng);

                if (savedLocationType == "neighborhood") {
                  String? savedNeighborhoodEng =
                      DbHelper.readData("userSelectedNeighborhoodEng");
                  if (savedNeighborhoodEng != null &&
                      selectedDistrict != null) {
                    selectedNeighborhood =
                        LocationService.findNeighborhoodByName(
                            selectedDistrict!, savedNeighborhoodEng);
                  }
                }
              }
            }
          }
        }

        // Get the properly localized name
        String localizedName = getLocalizedLocationName();
        currentLocation = localizedName;
        locationTextController.text = localizedName;
      } else {
        // Default to "All Egypt"
        _setDefaultAllEgyptLocation();
      }

      print(
          "Location initialized: $currentLocation (${DbHelper.getLanguage()})");
      notifyListeners();
    } catch (e) {
      print("Error initializing location: $e");
      // On any error, default to "All Egypt"
      _setDefaultAllEgyptLocation();
      notifyListeners();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  num _countMessage = 0;

  num get countMessage => _countMessage;

  set countMessage(num value) {
    _countMessage = value;
    notifyListeners();
  }

  Future<void> getChatNotifyCount() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getChatNotifyCount(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel?> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));
    if (model.body != null) {
      countMessage = model.body?.count_notification ?? 0;
      notifyListeners();
    }
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    try {
      page = 1;
      productsList.clear();
      if (!DbHelper.getIsGuest()) {
        getChatNotifyCount();
      }
      await getProductsApi(loading: true);
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<void> onLoading() async {
    // monitor network fetch
    ++page;
    await getProductsApi(loading: false);
    refreshController.loadComplete();
  }

  bool _isCurrentLanguageArabic() {
    // Use DbHelper to get the current language
    return DbHelper.getLanguage() == 'ar';
  }

  String getLocalizedLocationName() {
    // Check if Arabic language is active using DbHelper
    bool isArabic = DbHelper.getLanguage() == 'ar';

    // Handle "all" case first
    if (selectedLocationType == "all" ||
        (latitude == 0.0 && longitude == 0.0) ||
        (selectedCity == null &&
            selectedDistrict == null &&
            selectedNeighborhood == null)) {
      return isArabic ? "كل مصر" : "All Egypt";
    }

    if (selectedLocationType == "neighborhood" &&
        selectedNeighborhood != null) {
      if (selectedDistrict != null && selectedCity != null) {
        if (isArabic) {
          return "${selectedNeighborhood!.arabicName}، ${selectedDistrict!.arabicName}، ${selectedCity!.arabicName}";
        } else {
          return "${selectedNeighborhood!.name}, ${selectedDistrict!.name}, ${selectedCity!.name}";
        }
      }
    }

    if (selectedLocationType == "district" && selectedDistrict != null) {
      if (selectedCity != null) {
        if (isArabic) {
          return "${selectedDistrict!.arabicName}، ${selectedCity!.arabicName}";
        } else {
          return "${selectedDistrict!.name}, ${selectedCity!.name}";
        }
      }
    }

    if (selectedLocationType == "city" && selectedCity != null) {
      return isArabic ? selectedCity!.arabicName : selectedCity!.name;
    }

    // Default fallback
    return isArabic ? "كل مصر" : "All Egypt";
  }

  double? _getSelectedRadiusKm() {
    switch (selectedLocationType) {
      case 'city':
        return selectedCity?.defaultRadius; // from LocationService.dart
      case 'district':
        return selectedDistrict?.radius;
      case 'neighborhood':
        return selectedNeighborhood?.radius;
      default:
        return null; // "all", "coordinates"…
    }
  }

  // ENHANCED getProductsApi with better location handling
  // Updated getProductsApi method in HomeVM
  Future<void> getProductsApi({bool loading = false, String? search}) async {
    if (loading) isLoading = loading;

    // Determine coordinates and location type
    double sendLatitude = latitude;
    double sendLongitude = longitude;
    String locationTypeForAPI = selectedLocationType;

    // Build base URL
    String baseUrl = ApiConstants.getProductsUrl(
      limit: limit,
      page: page,
      latitude: sendLatitude,
      longitude: sendLongitude,
      sellStatus: 'ongoing',
      search: searchQuery,
    );

    // Build query parameters
    List<String> queryParams = [];

    // Add location_type parameter
    queryParams.add('location_type=$locationTypeForAPI');

    // Add location-specific parameters with ENGLISH NAMES
    if (locationTypeForAPI == "city" && selectedCity != null) {
      queryParams.add(
          'city=${Uri.encodeComponent(selectedCity!.name)}'); // English name
      print("HomeVM: Adding city filter: ${selectedCity!.name}");
    } else if (locationTypeForAPI == "district" &&
        selectedDistrict != null &&
        selectedCity != null) {
      queryParams.add(
          'city=${Uri.encodeComponent(selectedCity!.name)}'); // English name
      queryParams.add(
          'district_name=${Uri.encodeComponent(selectedDistrict!.name)}'); // English name
      print(
          "HomeVM: Adding district filter: ${selectedDistrict!.name} in ${selectedCity!.name}");
    } else if (locationTypeForAPI == "neighborhood" &&
        selectedNeighborhood != null &&
        selectedDistrict != null &&
        selectedCity != null) {
      queryParams.add(
          'city=${Uri.encodeComponent(selectedCity!.name)}'); // English name
      queryParams.add(
          'district_name=${Uri.encodeComponent(selectedDistrict!.name)}'); // English name
      queryParams.add(
          'neighborhood_name=${Uri.encodeComponent(selectedNeighborhood!.name)}'); // English name
      print(
          "HomeVM: Adding neighborhood filter: ${selectedNeighborhood!.name}");
    } else if (locationTypeForAPI == "coordinates" ||
        locationTypeForAPI == "nearby") {
      // For current location, use 50km radius
      queryParams.add('distance=50');
      print("HomeVM: Adding 50km distance filter for current location");
    }

    // Construct final URL
    String separator = baseUrl.contains('?') ? '&' : '?';
    String finalUrl = baseUrl;
    if (queryParams.isNotEmpty) {
      finalUrl += '$separator${queryParams.join('&')}';
    }

    ApiRequest apiRequest = ApiRequest(
      url: finalUrl,
      requestType: RequestType.get,
    );

    print("HomeVM API request URL: $finalUrl");
    print(
        "HomeVM: lat=$sendLatitude, lng=$sendLongitude, type=$locationTypeForAPI");

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));

    if (search?.isNotEmpty ?? false) {
      productsList.clear();
    }

    productsList.addAll(model.body?.data ?? []);
    productsList.removeWhere((product) {
      if (product.approvalDate == null || product.approvalDate!.isEmpty) {
        // Fallback to created date if no approval date
        if (product.createdAt == null || product.createdAt!.isEmpty)
          return false;
        DateTime createdDate = DateTime.parse(product.createdAt!);
        return DateTime.now().difference(createdDate).inDays > 30;
      }

      try {
        DateTime approvalDate =
            DateFormat("yyyy-MM-dd").parse(product.approvalDate!);
        DateTime expirationDate = approvalDate.add(Duration(days: 30));
        return DateTime.now().isAfter(expirationDate);
      } catch (e) {
        return false;
      }
    });

    if (loading) isLoading = false;
    notifyListeners();
  }

  /// Helper function to calculate distance and check if within 100 km of Cairo
  bool _isWithinCairoRadius(double lat, double lng, double radiusKm) {
    const double cairoLat = 31.2341262;
    const double cairoLng = 30.0282809;

    double distance = _calculateDistance(lat, lng, cairoLat, cairoLng);
    return distance <= radiusKm;
  }

  /// Haversine formula to calculate distance between two lat/lng points
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double degree) {
    return degree * pi / 180;
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      onRefresh();
    }

    searchQuery = query;
    _debounce.run(() {
      page = 1;
      productsList.clear();
      getProductsApi(search: searchQuery, loading: true);
      DbHelper.saveSearchQuery(query);
    });
  }

  Future<List<CategoryModel>> getCategoryListApi() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getCategoriesUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));

    categories = model.body ?? [];

    return model.body ?? [];
  }

  Future<List<CategoryModel>> getSubCategoryListApi(
      {CategoryModel? category}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubCategoriesUrl(id: "${category?.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model = ListResponse<CategoryModel>.fromJson(
        response, (json) => CategoryModel.fromJson(json));
    return model.body ?? [];
  }

  Future<void> getSubSubCategoryListApi(
      {required CategoryModel? category,
      required CategoryModel subCategory}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getSubSubCategoriesUrl(id: "${subCategory.id}"),
        requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));
    List<CategoryModel> modelList = [];
    if (category?.id == 11 && [83, 84, 87, 88, 90].contains(subCategory.id)) {
      modelList.add(CategoryModel(name: "Rent"));
      modelList.add(CategoryModel(name: "Sell"));
    } else {
      modelList = model.body ?? [];
    }

    if (modelList.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SubSubCategoryView(
                    category: category,
                    subSubCategory: modelList.reversed.toList() ?? [],
                    subCategory: subCategory,
                    latitude: "$latitude",
                    longitude: "$longitude",
                  )));
    } else {
      context.push(Routes.filterDetails,
          extra: FilterModel(
            categoryId: "${category?.id}",
            subcategoryId: "${subCategory.id ?? ""}",
            latitude: "$latitude",
            longitude: "$longitude",
          ));
    }

    DialogHelper.hideLoading();
  }

  /// new text controllers
  TextEditingController propertyForTextController = TextEditingController();
  TextEditingController propertyForTypeTextController = TextEditingController();
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
  TextEditingController completionStatusTextController =
      TextEditingController();
  TextEditingController deliveryTermTextController = TextEditingController();
  TextEditingController levelTextController = TextEditingController();

  TextEditingController startDownPriceTextController = TextEditingController();
  TextEditingController endDownPriceTextController = TextEditingController();

  TextEditingController startAreaTextController = TextEditingController();
  TextEditingController endAreaTextController = TextEditingController();
  String _currentPropertyType = "Sell";

  String get currentPropertyType => _currentPropertyType;

  set currentPropertyType(String index) {
    _currentPropertyType = index;
    notifyListeners();
  }

  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

  void clearLocation() {
    DbHelper.clearLocationSearchHistory();
    notifyListeners();
  }
}
