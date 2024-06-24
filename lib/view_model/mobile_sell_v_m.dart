import 'package:flutter/material.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/models/category_model.dart';
import 'package:list_and_life/models/common/list_response.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/network/base_client.dart';

import '../base/base_view_model.dart';
import '../view/main/sell/forms/post_added_final_view.dart';

class SellFormsVM extends BaseViewModel {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  int _currentIndex = 1;
  int _transmission = 0;

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

  List<String> salaryPeriodList = ['Hourly', 'Monthly', 'Weekly', 'Yearly'];

  String? country = '';
  String? city = '';
  String? state = '';

  void addImage(String path) {
    imagesList.add(path);
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

  CategoryModel? get selectedBrand => _selectedBrand;

  set selectedBrand(CategoryModel? value) {
    _selectedBrand = value;
    notifyListeners();
  }

  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController brandTextController = TextEditingController();
  TextEditingController educationTypeTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController kmDrivenTextController = TextEditingController();
  TextEditingController numOfOwnerTextController = TextEditingController();
  TextEditingController adTitleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();

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
        requestType: RequestType.GET);
    var response = await BaseClient.handleRequest(apiRequest);

    ListResponse<CategoryModel> model =
        ListResponse.fromJson(response, (json) => CategoryModel.fromJson(json));

    return model.body ?? [];
  }

  Future<void> addProduct(
      {required CategoryModel? category,
      required CategoryModel? subCategory,
      CategoryModel? subSubCategory,
      CategoryModel? brands}) async {
    final List<String> images = [];
    images.add(await BaseClient.uploadImage(imagePath: mainImagePath));
    for (var element in imagesList) {
      images.add(await BaseClient.uploadImage(imagePath: element));
    }
    Map<String, dynamic> body = {
      "category_id": category?.id,
      "sub_category_id": subCategory?.id,
      "sub_sub_category_id": subSubCategory?.id,
      "brand_id": brands?.id,
      "name": adTitleTextController.text.trim(),
      "item_condition": currentIndex == 1 ? "new" : "used",
      "description": descriptionTextController.text.trim(),
      "medias": images,
      "price": priceTextController.text.trim(),
      "year": yearTextController.text.trim(),
      "fuel": fuelTextController.text.trim(),
      "transmission": transmission == 1 ? 'automatic' : 'manual',
      "km_driven": kmDrivenTextController.text.trim(),
      "number_of_owner": numOfOwnerTextController.text.trim(),
      "country": country,
      "state": state,
      "city": city,
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
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PostAddedFinalView()),
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
}
