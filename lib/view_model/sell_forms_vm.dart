import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';

import '../base/base_view_model.dart';
import '../view/main/sell/forms/post_added_final_view.dart';

class SellFormsVM extends BaseViewModel {
  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  int _currentIndex = 1;
  int _transmission = 0;

  final FocusNode priceText = FocusNode();
  final FocusNode yearText = FocusNode();

  final FocusNode kmDrivenText = FocusNode();

  final FocusNode ownerText = FocusNode();

  String _mainImagePath = "";
  List<String> imagesList = <String>[];

  List<String> educationList = [
    'Tutions',
    'Hobby Classes',
    'Skill Development',
    'Others'
  ];

  @override
  void onReady() {
    // TODO: implement onInit
    resetTextFields();
    super.onReady();
  }

  List<String> jobPositionList = [
    'Contract',
    'Full Time',
    'Part-time',
    'Temporary'
  ];

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

  List<String> salaryPeriodList = ['Hourly', 'Monthly', 'Weekly', 'Yearly'];

  String? country = '';
  String? city = '';
  String? state = '';
  String? latitude = '0.0', longitude = '0.0';

  void addImage(String path) {
    imagesList.add(path);
    notifyListeners();
  }

  void removeImage(int index) {
    imagesList.removeAt(index);
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

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get transmission => _transmission;

  set transmission(int value) {
    _transmission = value;
    notifyListeners();
  }

  CategoryModel? _selectedBrand;
  CategoryModel? _selectedModel;

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

  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
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
  TextEditingController addressTextController = TextEditingController();
  TextEditingController ramTextController = TextEditingController();
  TextEditingController storageTextController = TextEditingController();
  TextEditingController screenSizeTextController = TextEditingController();
  TextEditingController materialTextController = TextEditingController();

  void resetTextFields() {
    currentIndex = 1;
    transmission = 0;
    mainImagePath = "";
    imagesList = [];
    jobPositionTextController.clear();
    jobSalaryTextController.clear();
    jobSalaryFromController.clear();
    jobSalaryToController.clear();
    brandTextController.clear();
    yearTextController.clear();
    fuelTextController.clear();
    kmDrivenTextController.clear();
    numOfOwnerTextController.clear();
    adTitleTextController.clear();
    descriptionTextController.clear();
    priceTextController.clear();
    addressTextController.clear();
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
    bool isEgypt = await LocationHelper.checkLocationIsEgypt(
        latitude: double.parse(latitude ?? '0'),
        longitude: double.parse(longitude ?? '0'));

    if (!isEgypt) {
      DialogHelper.hideLoading();
      LocationHelper.showPopupAddProduct(context, () {});
      return;
    }

    final List<String> images = [];
    String mainImage = await BaseClient.uploadImage(imagePath: mainImagePath);
    images.add(mainImage);

    var count = 0;

    for (var element in imagesList) {
      print("count => ${++count}");
      images.add(await BaseClient.uploadImage(imagePath: element));
    }
    Map<String, dynamic> body = {
      "category_id": category?.id,
      "sub_category_id": subCategory?.id,
      "sub_sub_category_id": subSubCategory?.id,
      "brand_id": brand?.id,
      "model_id": models?.id,
      "name": adTitleTextController.text.trim(),
      "item_condition": currentIndex == 1 ? "new" : "used",
      "description": descriptionTextController.text.trim(),
      "image": mainImage,
      "medias": images.reversed.toList(),
      "price": priceTextController.text.trim(),
      "year": yearTextController.text.trim(),
      "fuel": fuelTextController.text.trim(),
      "transmission": transmission == 1 ? 'automatic' : 'manual',
      "km_driven": kmDrivenTextController.text.trim(),
      "number_of_owner": numOfOwnerTextController.text.trim(),
      "education_type": educationTypeTextController.text.trim(),
      "country": country,
      "state": state,
      "city": city,
      "latitude": latitude,
      "longitude": longitude,
      "nearby": addressTextController.text.trim(),
      "position_type":
          getPositionType(type: jobPositionTextController.text.trim()),
      "sallery_period":
          getSallaryPeriod(type: jobSalaryTextController.text.trim()),
      "sallery_from": jobSalaryFromController.text.trim(),
      "sallery_to": jobSalaryToController.text.trim()
    };

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
    DialogHelper.showToast(message: model.message);
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
    print("response ~--> $response");
  }
}
