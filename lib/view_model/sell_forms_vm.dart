import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/category_model.dart';
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
  }

  ///---------------------
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

  ///---------------------
  String? country = '';
  String? city = '';
  String? state = '';
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

  set mainImagePath(String image) {
    _mainImagePath = image;
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
  List<String> jobPositionList = [
    StringHelper.contract,
    StringHelper.fullTime,
    StringHelper.partTime,
    StringHelper.temporary
  ];
  List<String> salaryPeriodList = [StringHelper.hourly, StringHelper.weekly, StringHelper.monthly, StringHelper.yearly];

  final List<String> ramOptions = [
    '2 GB',
    '4 GB',
    '6 GB',
    '8 GB',
    '12 GB',
    '16 GB'
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
  final List<String> experienceOptions = [
    "No experience/Just graduated",
    "1–3 yrs",
    "3–5 yrs",
    "5–10 yrs",
    "10+ yrs"
  ];
  final List<String> workSettingOptions = [
    StringHelper.remote,
    StringHelper.officeBased,
    StringHelper.mixOfficeBased,
    StringHelper.fieldBased
  ];
  final List<String> workEducationOptions = [
    StringHelper.none,
    StringHelper.student,
    StringHelper.highSchool,
    StringHelper.diploma,
    StringHelper.bDegree,
    StringHelper.mDegree,
    StringHelper.phd
  ];

  final List<String> carRentalTermOptions = [StringHelper.daily, StringHelper.monthly, StringHelper.yearly];

  final List<String> horsepowerOptions = [
    'Less than 100 HP',
    '100 - 200 HP',
    '200 - 300 HP',
    '300 - 400 HP',
    '400 - 500 HP',
    '500 - 600 HP',
    '600 - 700 HP',
    '700 - 800 HP',
    '800+ HP',
    'Other',
  ];

  final List<String> engineCapacityOptions = [
    'Below 500 cc',
    '500 - 999 cc',
    '1000 - 1499 cc',
    '1500 - 1999 cc',
    '2000 - 2499 cc',
    '2500 - 2999 cc',
    '3000 - 3499 cc',
    '3500 - 3999 cc',
    '4000+ cc',
    'Other',
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
    '2 Doors',
    '3 Doors',
    '4 Doors',
    '5+ Doors',
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


  List<String> fuelsType = [StringHelper.petrol, StringHelper.diesel, StringHelper.electric, StringHelper.hybrid, StringHelper.gas];
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
        return 'full_time';
      case 'Part-time':
        return 'part_time';
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
    resetTextFields();
    if (item == null) {
      communicationChoice = DbHelper.getUserModel()?.communicationChoice ?? '';
      isEditProduct = false;
      return;
    }

    log("${item.toJson()}", name: "Product Detail", level: 200);

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

    if (item.brandId != null) {
      getModels(brandId: int.tryParse("${item.brandId}") ?? 0);
    }

    transmission = (item.transmission?.isNotEmpty ?? false)
        ? (item.transmission == 'manual' ? 2 : 1)
        : 0;

    mainImagePath = item.image?.isNotEmpty ?? false
        ? "${ApiConstants.imageUrl}/${item.image}"
        : '';

    adTitleTextController.text = item.name ?? '';
    descriptionTextController.text = item.description ?? '';
    lookingForController.text = Utils.getCommon(item.lookingFor ?? '');
    addressTextController.text = item.nearby ?? '';
    priceTextController.text = item.price ?? '';
    productStatus = (item.status ?? 0).toInt();
    adStatus = item.adStatus ?? "";
    if ((item.itemCondition ?? "").isNotEmpty) {
      itemCondition =
          (item.itemCondition?.toLowerCase().contains('used') ?? false) ? 2 : 1;
    }

    brandTextController.text = item.brand?.name ?? '';
    modelTextController.text = item.model?.name ?? '';
    ramTextController.text =
        (item.ram != null && "${item.ram ?? " "}".isNotEmpty)
            ? "${item.ram} GB"
            : '';
    storageTextController.text =
        (item.storage != null && "${item.storage ?? " "}".isNotEmpty)
            ? "${item.storage} GB"
            : '';
    screenSizeTextController.text = item.screenSize ?? '';
    jobPositionTextController.text = Utils.getCommon(item.positionType ?? '');
    jobSalaryTextController.text = Utils.carRentalTerm(item.salleryPeriod ?? '');
    jobSalaryFromController.text = item.salleryFrom ?? '';
    jobSalaryToController.text = item.salleryTo ?? '';
    mileageTextController.text = item.milleage ?? '';
    educationTypeTextController.text = Utils.getEducationOptions(item.educationType ?? '');
    workSettingTextController.text = Utils.getCommon(item.workSetting ?? '');
    workExperienceTextController.text = item.workExperience ?? '';
    workEducationTextController.text = Utils.getEducationOptions(item.workEducation ?? '');
    yearTextController.text = item.year?.toString() ?? '';
    fuelTextController.text = Utils.getFuel(item.fuel ?? '');
    horsePowerTextController.text = item.horsePower ?? '';
    bodyTypeTextController.text = item.bodyType ?? '';
    carColorTextController.text = item.carColor ?? '';
    engineCapacityTextController.text = item.engineCapacity ?? '';
    interiorColorTextController.text = item.interiorColor ?? '';
    numbCylindersTextController.text = item.numbCylinders ?? '';
    carRentalTermTextController.text = Utils.carRentalTerm(item.carRentalTerm ?? '');
    numbDoorsTextController.text = item.numbDoors ?? '';
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

    propertyForTextController.text = Utils.setPropertyType(item.propertyFor ?? '');
    currentPropertyType = Utils.setPropertyType(item.propertyFor ?? '');
    noOfBedroomsTextController.text = "${item.bedrooms ?? ''}";
    noOfBathroomsTextController.text = "${item.bathrooms ?? ''}";
    levelTextController.text = item.level ?? '';
    propertyAgeTextController.text = item.buildingAge ?? '';
    depositTextController.text = item.deposit ?? '';
    insuranceTextController.text = item.insurance ?? '';
    rentalTermsTextController.text = Utils.carRentalTerm(item.rentalTerm ?? '');
    rentalPriceTextController.text = item.rentalPrice ?? '';
    listedByTextController.text = Utils.getCommon(item.listedBy ?? '');
    propertyForTypeTextController.text = Utils.getProperty(item.type ?? '');
    furnishingStatusTextController.text = Utils.getFurnished(item.furnishedType ?? '');
    currentFurnishing = Utils.getFurnished(item.furnishedType ?? '');
    ownershipStatusTextController.text = Utils.getCommon(item.ownership ?? '');
    paymentTypeTextController.text = Utils.getPaymentTyp(item.paymentType ?? '');
    currentPaymentOption = Utils.getPaymentTyp(item.paymentType ?? '');
    accessToUtilitiesTextController.text = Utils.getUtilityTyp(item.accessToUtilities ?? '');
    sizeTextController.text = item.fashionSize?.name ?? '';

    currentAccessToUtilities = Utils.getUtilityTyp(item.accessToUtilities ?? '');
    areaSizeTextController.text = "${item.area ?? ''}";
    completionStatusTextController.text = Utils.getUtilityTyp(item.completionStatus ?? '');
    currentCompletion = Utils.getUtilityTyp(item.completionStatus ?? '');
    currentDeliveryTerm = Utils.getCommon(item.deliveryTerm ?? '');
    deliveryTermTextController.text = Utils.getCommon(item.deliveryTerm ?? '');
    amenities =
        item.productAmenities?.map((element) => element.amnityId).toList() ??
            [];
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
    addressTextController.clear();
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
    Position? position = await LocationHelper.getCurrentLocation();
    if (position != null) {
      addressTextController.text =
          await LocationHelper.getAddressFromCoordinates(
              position.latitude, position.longitude);
    } else {
      addressTextController.text = DbHelper.getUserModel()?.address ?? '';
    }
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

  String _getCommunicationChoice() {
    return communicationChoice == "none" || communicationChoice.isEmpty
        ? "chat"
        : communicationChoice;
  }

  Future<Position?> _getPositionFromAddress() async {
    Position? position = await LocationHelper.getCoordinatesFromAddress(
      addressTextController.text.trim(),
    );
    return position;
  }

  Future<bool> _validateLocationIsEgypt(Position? position) async {
    var latitude = double.parse("${position?.latitude ?? 0.0}");
    var longitude = double.parse("${position?.longitude ?? 0.0}");
    bool isEgypt = await LocationHelper.checkLocationIsEgypt(
      latitude: latitude,
      longitude: longitude,
    );
    if (!isEgypt) {
      DialogHelper.hideLoading();
      LocationHelper.showPopupAddProduct(context, () {});
    }
    return isEgypt;
  }

  Future<String> _uploadMainImage() async {
    if (mainImagePath.isNotEmpty) {
      if (mainImagePath.contains('http')) {
        return mainImagePath.split('/').last;
      } else {
        return await BaseClient.uploadImage(imagePath: mainImagePath);
      }
    }
    return "";
  }

  Future<List<String>> _uploadMediaImages() async {
    List<String> images = [];

    for (var element in imagesList) {
      final mediaPath = element.media ?? '';
      if (mediaPath.isNotEmpty) {
        if (!mediaPath.contains('http')) {
          images.add(await BaseClient.uploadImage(imagePath: mediaPath));
        } else {
          //images.add(mediaPath);
        }
      }
    }
    return images.toList();
  }

  Future<void> addProduct({
    required CategoryModel? category,
    required CategoryModel? subCategory,
    CategoryModel? subSubCategory,
    CategoryModel? brand,
    CategoryModel? models,
  }) async {
    Position? position = await _getPositionFromAddress();

    if (!await _validateLocationIsEgypt(position)) return;

    String mainImage = await _uploadMainImage();
    final images = await _uploadMediaImages();
    final communication = _getCommunicationChoice();

    Map<String, dynamic> fields = {
      "name": trimController(adTitleTextController),
      "description": trimController(descriptionTextController),
      "looking_for": Utils.setCommon(trimController(lookingForController)),
      "price": trimController(priceTextController) ?? '0',
      "year": trimController(yearTextController),
      "fuel": Utils.setFuel(trimController(fuelTextController)),
      "milleage": trimController(mileageTextController),
      "km_driven": trimController(kmDrivenTextController),
      "number_of_owner": trimController(numOfOwnerTextController),
      "car_color": trimController(carColorTextController),
      "horse_power": trimController(horsePowerTextController),
      "education_type": Utils.setEducationOptions(trimController(educationTypeTextController)),
      "body_type": trimController(bodyTypeTextController),
      "engine_capacity": trimController(engineCapacityTextController),
      "interior_color": trimController(interiorColorTextController),
      "numb_cylinders": trimController(numbCylindersTextController),
      "numb_doors": trimController(numbDoorsTextController),
      "car_rental_term": Utils.setCarRentalTerm(trimController(carRentalTermTextController)),
      "country": country,
      "state": state,
      "city": city,
      "latitude": position?.latitude,
      "longitude": position?.longitude,
      "nearby": trimController(addressTextController),
      "position_type": trimController(jobPositionTextController) != null
          ? getPositionType(type: Utils.setCommon(jobPositionTextController.text.trim()))
          : "",
      "sallery_period": trimController(jobSalaryTextController) != null
          ? getSalaryPeriod(type: Utils.setCarRentalTerm(jobSalaryTextController.text.trim()))
          : "",
      "sallery_from": trimController(jobSalaryFromController),
      "sallery_to": trimController(jobSalaryToController),
      "work_setting": Utils.setCommon(trimController(workSettingTextController)),
      "work_experience": trimController(workExperienceTextController),
      "work_education": Utils.setEducationOptions(trimController(workEducationTextController)),
      "material": trimController(materialTextController),
      "ram": trimController(ramTextController),
      "storage": trimController(storageTextController),
      "screen_size": trimController(screenSizeTextController),
      "communication_choice": communication,
      "property_for": Utils.setPropertyType(trimController(propertyForTextController)),
      "bedrooms": trimController(noOfBedroomsTextController),
      "bathrooms": trimController(noOfBathroomsTextController),
      "furnished_type": Utils.setFurnished(trimController(furnishingStatusTextController)),
      "ownership": Utils.setCommon(trimController(ownershipStatusTextController)),
      "payment_type":
          transformToSnakeCase(Utils.setPaymentTyp(trimController(paymentTypeTextController))),
      "completion_status":
          transformToSnakeCase(Utils.setUtilityTyp(trimController(completionStatusTextController))),
      "delivery_term":
          transformToSnakeCase(Utils.setCommon(trimController(deliveryTermTextController))),
      "selected_amnities": amenities.isNotEmpty ? amenities.join(',') : "",
      "area": trimController(areaSizeTextController),
      "type": Utils.setProperty(trimController(propertyForTypeTextController)),
      "level": trimController(levelTextController),
      "building_age": trimController(propertyAgeTextController),
      "listed_by": Utils.setCommon(trimController(listedByTextController)),
      "rental_price": trimController(rentalPriceTextController),
      "rental_term": Utils.setCarRentalTerm(trimController(rentalTermsTextController)),
      "deposit": trimController(depositTextController),
      "insurance": trimController(insuranceTextController),
      "access_to_utilities": Utils.setUtilityTyp(trimController(accessToUtilitiesTextController)),
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
    DialogHelper.showToast(
        message:
            "Your ad has been submitted to the admin and will be approved soon!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => PostAddedFinalView(
                data: model.body,
              )),
    );
  }

  void editProduct(
      {int? productId,
      CategoryModel? category,
      CategoryModel? subCategory,
      CategoryModel? subSubCategory,
      CategoryModel? brand,
      CategoryModel? models}) async {
    Position? position = await _getPositionFromAddress();

    if (!await _validateLocationIsEgypt(position)) return;

    String mainImage = await _uploadMainImage();

    final images = await _uploadMediaImages();

    final communication = _getCommunicationChoice();

    Map<String, dynamic> fields = {
      "product_id": productId,
      "name": trimController(adTitleTextController),
      "description": trimController(descriptionTextController),
      "looking_for ": Utils.setCommon(trimController(lookingForController)),
      "price": trimController(priceTextController) ?? "0",
      "year": trimController(yearTextController),
      "fuel": Utils.setFuel(trimController(fuelTextController)),
      "milleage": trimController(mileageTextController),
      "km_driven": trimController(kmDrivenTextController),
      "number_of_owner": trimController(numOfOwnerTextController),
      "education_type": Utils.setEducationOptions(trimController(educationTypeTextController)),
      "country": country,
      "state": state,
      "city": city,
      "latitude": position?.latitude,
      "longitude": position?.longitude,
      "nearby": trimController(addressTextController),
      "position_type": trimController(jobPositionTextController) != null
          ? getPositionType(type: Utils.setCommon(jobPositionTextController.text.trim()))
          : "",
      "sallery_period": trimController(jobSalaryTextController) != null
          ? getSalaryPeriod(type: Utils.setCarRentalTerm(jobSalaryTextController.text.trim()))
          : "",
      "sallery_from": trimController(jobSalaryFromController),
      "sallery_to": trimController(jobSalaryToController),
      "work_setting": Utils.setCommon(trimController(workSettingTextController)),
      "work_experience": trimController(workExperienceTextController),
      "work_education": Utils.setEducationOptions(trimController(workEducationTextController)),
      "material": trimController(materialTextController),
      "ram": trimController(ramTextController),
      "storage": trimController(storageTextController),
      "body_type": trimController(bodyTypeTextController),
      "car_color": trimController(carColorTextController),
      "car_rental_term": Utils.setCarRentalTerm(trimController(carRentalTermTextController)),
      "screen_size": trimController(screenSizeTextController),
      "horse_power": trimController(horsePowerTextController),
      "engine_capacity": trimController(engineCapacityTextController),
      "interior_color": trimController(interiorColorTextController),
      "numb_cylinders": trimController(numbCylindersTextController),
      "numb_doors": trimController(numbDoorsTextController),
      "delete_img_id":
          deletedImageIds.isNotEmpty ? deletedImageIds.join(',') : "",
      'communication_choice': communication,
      'property_for': trimController(propertyForTextController),
      'bedrooms': trimController(noOfBedroomsTextController),
      'bathrooms': trimController(noOfBathroomsTextController),
      'furnished_type': Utils.setFurnished(trimController(furnishingStatusTextController)),
      'ownership': Utils.setCommon(trimController(ownershipStatusTextController)),
      'payment_type':
          transformToSnakeCase(Utils.setPaymentTyp(trimController(paymentTypeTextController))),
      'completion_status':
          transformToSnakeCase(Utils.setUtilityTyp(trimController(completionStatusTextController))),
      'delivery_term':
          transformToSnakeCase(Utils.setCommon(trimController(deliveryTermTextController))),
      'selected_amnities': amenities.isNotEmpty ? amenities.join(',') : "",
      'area': trimController(areaSizeTextController),
      'type': Utils.setProperty(trimController(propertyForTypeTextController)),
      'level': trimController(levelTextController),
      'building_age': trimController(propertyAgeTextController),
      'listed_by': Utils.setCommon(trimController(listedByTextController)),
      'rental_price': trimController(rentalPriceTextController),
      'rental_term': Utils.setCarRentalTerm(trimController(rentalTermsTextController)),
      'deposit': trimController(depositTextController),
      'insurance': trimController(insuranceTextController),
      'access_to_utilities': Utils.setUtilityTyp(trimController(accessToUtilitiesTextController)),
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
    Navigator.pop(context, true);
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => PostAddedFinalView(
                data: model.body,
              )),
    );*/
  }
}
