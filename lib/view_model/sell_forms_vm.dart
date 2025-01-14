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
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/product_detail_model.dart';

import '../base/base_view_model.dart';
import '../view/main/sell/forms/post_added_final_view.dart';

class SellFormsVM extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  int _itemCondition = 1;
  int _transmission = 0;
  bool _isEditProduct = false;
  String _communicationChoice =
      DbHelper.getUserModel()?.communicationChoice ?? '';

  bool get isEditProduct => _isEditProduct;

  set isEditProduct(bool value) {
    _isEditProduct = value;
    notifyListeners();
  }

  List<int?> _amenities = [];

  set amenities(List<int?> value) {
    _amenities = value;
    notifyListeners();
  }

  List<int?> get amenities => _amenities;

  final FocusNode priceText = FocusNode();
  final FocusNode yearText = FocusNode();

  final FocusNode kmDrivenText = FocusNode();

  final FocusNode ownerText = FocusNode();

  String _mainImagePath = "";
  List<ProductMedias> imagesList = <ProductMedias>[];
  List<String> deletedImageIds = <String>[];

  List<String> educationList = [
    'Tutions',
    'Hobby Classes',
    'Skill Development',
    'Others'
  ];

  @override
  void onReady() {
    // TODO: implement onInit
    // resetTextFields();
    super.onReady();
  }

  set communicationChoice(String value) {
    _communicationChoice = value;
    notifyListeners();
  }

  String get communicationChoice => _communicationChoice;

  List<String> jobPositionList = [
    'Contract',
    'Full Time',
    'Part-time',
    'Temporary'
  ];

  List<String> salaryPeriodList = ['Hourly', 'Monthly', 'Weekly', 'Yearly'];

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
  final List<String> screenSizeOptions = [
    '5.5"',
    '6.1"',
    '6.5"',
    '6.7"',
    '7.0"'
  ];
  final List<String> materialOptions = ['Wood', 'Metal', 'Fabric'];
  final List<CategoryModel> sizeOptions = [];

  String? country = '';
  String? city = '';
  String? state = '';

  void addImage(String path) {
    imagesList.add(ProductMedias(media: path));
    notifyListeners();
  }

  void removeImage(int index, {required ProductMedias data}) {
    imagesList.removeAt(index);
    deletedImageIds.add("${data.id}");
    notifyListeners();
  }

  List<CategoryModel?> _allModels = [];

  List<CategoryModel?> get allModels => _allModels;

  set allModels(List<CategoryModel?> values) {
    _allModels = values;
    notifyListeners();
  }

  String get mainImagePath => _mainImagePath;

  set mainImagePath(String image) {
    _mainImagePath = image;
    notifyListeners();
  }

  int get itemCondition => _itemCondition;

  set itemCondition(int index) {
    _itemCondition = index;
    notifyListeners();
  }

  String _currentPropertyType = "Sell";

  String get currentPropertyType => _currentPropertyType;

  set currentPropertyType(String index) {
    _currentPropertyType = index;
    notifyListeners();
  }

  int productStatus = 0;
  String _currentFurnishing = "";

  String get currentFurnishing => _currentFurnishing;

  set currentFurnishing(String index) {
    _currentFurnishing = index;
    notifyListeners();
  }

  String _currentAccessToUtilities = "";

  String get currentAccessToUtilities => _currentAccessToUtilities;

  set currentAccessToUtilities(String index) {
    _currentAccessToUtilities = index;
    notifyListeners();
  }

  String _currentPaymentOption = "";

  String get currentPaymentOption => _currentPaymentOption;

  set currentPaymentOption(String index) {
    _currentPaymentOption = index;
    notifyListeners();
  }

  String _currentCompletion = "";

  String get currentCompletion => _currentCompletion;

  set currentCompletion(String index) {
    _currentCompletion = index;
    notifyListeners();
  }

  String _currentDeliveryTerm = "";

  String get currentDeliveryTerm => _currentDeliveryTerm;

  set currentDeliveryTerm(String index) {
    _currentDeliveryTerm = index;
    notifyListeners();
  }

  int get transmission => _transmission;

  set transmission(int value) {
    _transmission = value;
    notifyListeners();
  }

  CategoryModel? _selectedBrand;
  CategoryModel? _selectedModel;
  CategoryModel? _selectedSize;

  CategoryModel? get selectedBrand => _selectedBrand;

  set selectedBrand(CategoryModel? value) {
    _selectedBrand = value;
    notifyListeners();
  }

  CategoryModel? get selectedModel => _selectedModel;

  set selectedModel(CategoryModel? value) {
    _selectedModel = value;
    notifyListeners();
  }

  CategoryModel? get selectedSize => _selectedSize;

  set selectedSize(CategoryModel? value) {
    _selectedSize = value;
    notifyListeners();
  }

  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController lookingForController = TextEditingController();
  TextEditingController brandTextController = TextEditingController();
  TextEditingController modelTextController = TextEditingController();
  TextEditingController mileageTextController = TextEditingController();
  TextEditingController educationTypeTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController kmDrivenTextController = TextEditingController();
  TextEditingController numOfOwnerTextController = TextEditingController();
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

  List<String> yearsType = [];

  List<String> fuelsType = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas'];
  String _selectedOption = 'Select';

  String get selectedOption => _selectedOption;

  set selectedOption(String value) {
    _selectedOption = value;
    notifyListeners();
  }

  void updateTextFieldsItems({ProductDetailModel? item}) async {
    if (item == null) {
      resetTextFields();
      communicationChoice = DbHelper.getUserModel()?.communicationChoice ?? '';
      isEditProduct = false;
      return;
    }
    log("${item.toJson()}", name: "~-> Alok", level: 200);
    isEditProduct = true;
    imagesList.clear();
    deletedImageIds.clear();
    var productImagesList = item.productMedias ?? [];
    if (productImagesList.isNotEmpty) {
      for (var element in productImagesList) {
        if ((element.media ?? "").isNotEmpty) {
          imagesList.add(ProductMedias(
              id: element.id,
              media: "${ApiConstants.imageUrl}/${element.media}"));
        }
      }
    }
    // imagesList.addAll(item.productMedias
    //         ?.map((element) => ProductMedias(
    //             id: element.id,
    //             media: "${ApiConstants.imageUrl}/${element.media}"))
    //         .toList() ??
    //     []);
    if (item.brandId != null) {
      getModels(brandId: int.parse("${item.brandId}"));
    }
    transmission = (item.transmission?.isNotEmpty ?? false)
        ? (item.transmission == 'manual' ? 2 : 1)
        : 0;
    mainImagePath = "${ApiConstants.imageUrl}/${item.image}";
    adTitleTextController.text = item.name ?? '';
    descriptionTextController.text = item.description ?? '';
    lookingForController.text = item.lookingFor ?? '';
    addressTextController.text = "${item.nearby}";
    priceTextController.text = item.price ?? '';
    productStatus = (item.status ?? 0).toInt();
    itemCondition =
        (item.itemCondition?.toLowerCase().contains('used') ?? false) ? 2 : 1;
    brandTextController.text = item.brand?.name ?? '';
    modelTextController.text = item.model?.name ?? '';
    ramTextController.text =
        "${item.ram ?? ''}".isNotEmpty ? "${item.ram ?? ''} GB" : "";
    storageTextController.text =
        "${item.storage ?? ''}".isNotEmpty ? "${item.storage ?? ''} GB" : "";
    screenSizeTextController.text =
        (item.screenSize ?? "").isNotEmpty ? item.screenSize ?? '5.5"' : "";
    jobPositionTextController.text = item.positionType ?? '';
    jobSalaryTextController.text = item.salleryPeriod ?? '';
    jobSalaryFromController.text = item.salleryFrom ?? '';
    jobSalaryToController.text = item.salleryTo ?? '';
    mileageTextController.text = item.milleage ?? '';
    educationTypeTextController.text = item.educationType ?? '';
    yearTextController.text = "${item.year ?? ''}";
    fuelTextController.text = item.fuel ?? '';
    kmDrivenTextController.text = "${item.kmDriven ?? ''}";
    numOfOwnerTextController.text = "${item.numberOfOwner ?? ''}";
    sizeTextController.text = "${item.fashionSize ?? ''}";
    if (item.brandId != null) {
      selectedBrand = CategoryModel(id: item.brandId, name: item.brand?.name);
    }
    if (item.modelId != null) {
      selectedModel = CategoryModel(id: item.modelId, name: item.model?.name);
    }
    if (item.sizeId != null) {
      selectedSize =
          CategoryModel(id: item.sizeId, name: item.fashionSize?.name);
    }
    isEditProduct = true;
    communicationChoice = item.communicationChoice ?? '';

    propertyForTextController.text = item.propertyFor ?? '';
    currentPropertyType = item.propertyFor ?? '';

    noOfBedroomsTextController.text = "${item.bedrooms ?? ''}";
    noOfBathroomsTextController.text = "${item.bathrooms ?? ''}";

    levelTextController.text = item.level ?? '';
    propertyAgeTextController.text = item.buildingAge ?? '';
    depositTextController.text = item.deposit ?? '';
    insuranceTextController.text = item.insurance ?? '';
    rentalTermsTextController.text = item.rentalTerm ?? '';
    rentalPriceTextController.text = item.rentalPrice ?? '';
    listedByTextController.text = item.listedBy ?? '';
    propertyForTypeTextController.text = item.type ?? '';

    furnishingStatusTextController.text = item.furnishedType ?? '';
    currentFurnishing = item.furnishedType ?? '';
    ownershipStatusTextController.text = item.ownership ?? '';
    paymentTypeTextController.text = item.paymentType ?? '';
    currentPaymentOption = item.paymentType ?? '';

    accessToUtilitiesTextController.text = item.accessToUtilities ?? '';
    currentAccessToUtilities = item.accessToUtilities ?? '';

    areaSizeTextController.text = "${item.area ?? ''}";

    completionStatusTextController.text = item.completionStatus ?? '';
    currentCompletion = item.completionStatus ?? '';

    amenities =
        item.productAmenities?.map((element) => element.amnityId).toList() ??
            [];
  }

  void resetTextFields() {
    currentPropertyType = "Sell";
    currentFurnishing = "";
    currentAccessToUtilities = "";
    currentPaymentOption = "";
    currentCompletion = "";
    currentDeliveryTerm = "";
    itemCondition = 1;
    transmission = 0;
    mainImagePath = "";
    imagesList = [];
    lookingForController.clear();
    jobPositionTextController.clear();
    jobSalaryTextController.clear();
    jobSalaryFromController.clear();
    jobSalaryToController.clear();
    brandTextController.clear();
    modelTextController.clear();
    mileageTextController.clear();
    educationTypeTextController.clear();
    yearTextController.clear();
    fuelTextController.clear();
    kmDrivenTextController.clear();
    numOfOwnerTextController.clear();
    adTitleTextController.clear();
    descriptionTextController.clear();
    priceTextController.clear();
    addressTextController.clear();
    ramTextController.clear();
    storageTextController.clear();
    screenSizeTextController.clear();
    materialTextController.clear();
    sizeTextController.clear();
    propertyForTextController.clear();
    propertyForTypeTextController.clear();
    levelTextController.clear();
    propertyAgeTextController.clear();
    listedByTextController.clear();
    rentalTermsTextController.clear();
    accessToUtilitiesTextController.clear();
    rentalPriceTextController.clear();
    insuranceTextController.clear();
    depositTextController.clear();
    areaSizeTextController.clear();
    noOfBedroomsTextController.clear();
    noOfBathroomsTextController.clear();
    furnishingStatusTextController.clear();
    ownershipStatusTextController.clear();
    paymentTypeTextController.clear();
    completionStatusTextController.clear();
    deliveryTermTextController.clear();
    amenities = [];
    addressTextController.text = DbHelper.getUserModel()?.address ?? '';
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

  Future<void> addProduct({
    required CategoryModel? category,
    required CategoryModel? subCategory,
    CategoryModel? subSubCategory,
    CategoryModel? brand,
    CategoryModel? models,
  }) async {
    Position? position = await LocationHelper.getCoordinatesFromAddress(
        addressTextController.text.trim());

    bool isEgypt = await LocationHelper.checkLocationIsEgypt(
        latitude: double.parse("${position?.latitude}"),
        longitude: double.parse("${position?.longitude}"));

    if (!isEgypt) {
      DialogHelper.hideLoading();
      LocationHelper.showPopupAddProduct(context, () {});
      return;
    }
    Map<String, dynamic> body = {};

    String mainImage = "";
    final List<String> images = [];
    if (mainImagePath.isNotEmpty) {
      mainImage = await BaseClient.uploadImage(imagePath: mainImagePath);
    }
    if (imagesList.isNotEmpty) {
      for (var element in imagesList) {
        images
            .add(await BaseClient.uploadImage(imagePath: element.media ?? ''));
      }
    }
    var communication = "";
    if (communicationChoice == "none" || communicationChoice.isEmpty) {
      communication = "chat";
    } else {
      communication = communicationChoice;
    }

      Map<String, dynamic> fields = {
        "name": trimController(adTitleTextController),
        "description": trimController(descriptionTextController),
        "looking_for": trimController(lookingForController),
        "image": mainImage,
        "medias": images.reversed.toList().join(','),
        "price": trimController(priceTextController) ?? '0',
        "year": trimController(yearTextController),
        "fuel": trimController(fuelTextController),
        "mileage": trimController(mileageTextController),
        "km_driven": trimController(kmDrivenTextController),
        "number_of_owner": trimController(numOfOwnerTextController),
        "education_type": trimController(educationTypeTextController),
        "country": country,
        "state": state,
        "city": city,
        "latitude": position?.latitude,
        "longitude": position?.longitude,
        "nearby": trimController(addressTextController),
        "position_type": trimController(jobPositionTextController) != null
            ? getPositionType(type: jobPositionTextController.text.trim())
            : "",
        "salary_period": trimController(jobSalaryTextController) != null
            ? getSallaryPeriod(type: jobSalaryTextController.text.trim())
            : "",
        "salary_from": trimController(jobSalaryFromController),
        "salary_to": trimController(jobSalaryToController),
        "material": trimController(materialTextController),
        "ram": trimController(ramTextController),
        "storage": trimController(storageTextController),
        "screen_size": trimController(screenSizeTextController),
        "communication_choice": communication,
        "property_for": trimController(propertyForTextController),
        "bedrooms": trimController(noOfBedroomsTextController),
        "bathrooms": trimController(noOfBathroomsTextController),
        "furnished_type": trimController(furnishingStatusTextController),
        "ownership": trimController(ownershipStatusTextController),
        "payment_type": transformToSnakeCase(trimController(paymentTypeTextController)),
        "completion_status": transformToSnakeCase(trimController(completionStatusTextController)),
        "delivery_term": transformToSnakeCase(trimController(deliveryTermTextController)),
        "selected_amenities": amenities.isNotEmpty ? amenities.join(',') : "",
        "area": trimController(areaSizeTextController),
        "type": trimController(propertyForTypeTextController),
        "level": trimController(levelTextController),
        "building_age": trimController(propertyAgeTextController),
        "listed_by": trimController(listedByTextController),
        "rental_price": trimController(rentalPriceTextController),
        "rental_term": trimController(rentalTermsTextController),
        "deposit": trimController(depositTextController),
        "insurance": trimController(insuranceTextController),
        "access_to_utilities": trimController(accessToUtilitiesTextController),
      };

      // Adding dynamic fields
      if (category != null) fields["category_id"] = category.id;
      if (subCategory != null) fields["sub_category_id"] = subCategory.id;
      if (subSubCategory != null) fields["sub_sub_category_id"] = subSubCategory.id;
      if (brand != null) fields["brand_id"] = brand.id;
      if (models != null) fields["model_id"] = models.id;
      if (selectedSize != null) fields["size_id"] = selectedSize?.id;

      if (category?.id != null &&
          ![6, 8, 9, 11].contains(category?.id)) {
        fields["item_condition"] = itemCondition == 1 ? "new" : "used";
      }

      if (transmission != 0) {
        fields["transmission"] = transmission == 1 ? "automatic" : "manual";
      }

    fields.forEach((key, value) {
      if (value != null && "$value".trim().isNotEmpty) {
        body[key] = value;
      }
    });
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addProductsUrl(),
        requestType: RequestType.post,
        bodyType: BodyType.formData,
        body: body);

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

  String getSallaryPeriod({required String type}) {
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
  void editProduct(
      {int? productId,
      CategoryModel? category,
      CategoryModel? subCategory,
      CategoryModel? subSubCategory,
      CategoryModel? brand,
      CategoryModel? models}) async {
    Position? position = await LocationHelper.getCoordinatesFromAddress(
        addressTextController.text.trim());

    bool isEgypt = await LocationHelper.checkLocationIsEgypt(
        latitude: double.parse("${position?.latitude}"),
        longitude: double.parse("${position?.longitude}"));

    if (!isEgypt) {
      DialogHelper.hideLoading();
      LocationHelper.showPopupAddProduct(context, () {});
      return;
    }
    Map<String, dynamic> body = {};

    String mainImage = "";
    final List<String> images = [];
    if (mainImagePath.isNotEmpty) {
      mainImage = mainImagePath.contains('http')
          ? mainImagePath.split('/').last
          : await BaseClient.uploadImage(imagePath: mainImagePath);
    }
    if (imagesList.isNotEmpty) {
      for (var element in imagesList) {
        if (!element.media!.contains('http')) {
          images.add(
              await BaseClient.uploadImage(imagePath: element.media ?? ''));
        }
      }
    }
    var communication = "";
    if (communicationChoice == "none" || communicationChoice.isEmpty) {
      communication = "chat";
    } else {
      communication = communicationChoice;
    }
    Map<String, dynamic> fields = {
      "product_id": productId,
      "name": trimController(adTitleTextController),
      "description": trimController(descriptionTextController),
      "looking_for ": trimController(lookingForController),
      "image": mainImage,
      "medias": images.reversed.toList().join(','),
      "price": trimController(priceTextController)??"0",
      "year": trimController(yearTextController),
      "fuel": trimController(fuelTextController),
      "km_driven": trimController(kmDrivenTextController),
      "number_of_owner": trimController(numOfOwnerTextController),
      "education_type": trimController(educationTypeTextController),
      "country": country,
      "state": state,
      "city": city,
      "latitude": position?.latitude,
      "longitude": position?.longitude,
      "nearby": trimController(addressTextController),
      "position_type": trimController(jobPositionTextController) != null
          ? getPositionType(type: jobPositionTextController.text.trim())
          : "",
      "sallery_period": trimController(jobSalaryTextController) != null
          ? getSallaryPeriod(type: jobSalaryTextController.text.trim())
          : "",
      "sallery_from": trimController(jobSalaryFromController),
      "sallery_to": trimController(jobSalaryToController),
      "material": trimController(materialTextController),
      "ram": trimController(ramTextController),
      "storage": trimController(storageTextController),
      "screen_size": trimController(screenSizeTextController),
      "delete_img_id":
          deletedImageIds.isNotEmpty ? deletedImageIds.join(',') : "",
      'communication_choice': communication,
      'property_for': trimController(propertyForTextController),
      'bedrooms': trimController(noOfBedroomsTextController),
      'bathrooms': trimController(noOfBathroomsTextController),
      'furnished_type': trimController(furnishingStatusTextController),
      'ownership': trimController(ownershipStatusTextController),
      'payment_type': transformToSnakeCase(trimController(paymentTypeTextController)),
      'completion_status': transformToSnakeCase(trimController(completionStatusTextController)),
      'delivery_term': transformToSnakeCase(trimController(deliveryTermTextController)),
      'selected_amnities': amenities.isNotEmpty ? amenities.join(',') : "",
      'area': trimController(areaSizeTextController),
      'type': trimController(propertyForTypeTextController),
      'level': trimController(levelTextController),
      'building_age': trimController(propertyAgeTextController),
      'listed_by': trimController(listedByTextController),
      'rental_price': trimController(rentalPriceTextController),
      'rental_term': trimController(rentalTermsTextController),
      'deposit': trimController(depositTextController),
      'insurance': trimController(insuranceTextController),
      'access_to_utilities': trimController(accessToUtilitiesTextController),
    };
    // Adding dynamic fields
    if (category != null) fields["category_id"] = category.id;
    if (subCategory != null) fields["sub_category_id"] = subCategory.id;
    if (subSubCategory != null) fields["sub_sub_category_id"] = subSubCategory.id;
    if (brand != null) fields["brand_id"] = brand.id;
    if (models != null) fields["model_id"] = models.id;
    if (selectedSize != null) fields["size_id"] = selectedSize?.id;

    if (category?.id != null &&
        ![6, 8, 9, 11].contains(category?.id)) {
      fields["item_condition"] = itemCondition == 1 ? "new" : "used";
    }

    if (transmission != 0) {
      fields["transmission"] = transmission == 1 ? "automatic" : "manual";
    }
    if (productStatus == 2) {
      fields['status'] = 0;
    }

    fields.forEach((key, value) {
      if (value != null && "$value".trim().isNotEmpty) {
        body[key] = value;
      }
    });

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.editProductsUrl(),
        requestType: RequestType.put,
        bodyType: BodyType.formData,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);
    log("$response", name: "BASEX");
    MapResponse<ProductDetailModel> model = MapResponse.fromJson(
        response, (json) => ProductDetailModel.fromJson(json));
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);
    Navigator.pop(context);
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => PostAddedFinalView(
                data: model.body,
              )),
    );*/
  }
}
