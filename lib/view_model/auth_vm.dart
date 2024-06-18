import 'dart:io';

import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/network/base_client.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/routes/app_routes.dart';

import '../helpers/image_picker_helper.dart';

class AuthVM extends BaseViewModel {
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();

  TextEditingController nameTextController = TextEditingController();
  TextEditingController lNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  String countryCode = "+91";
  Country selectedCountry = Country.IN;

  String _imagePath = '';
  bool _agreedToTerms = false;
  String get imagePath => _imagePath;

  bool get agreedToTerms => _agreedToTerms;

  final FocusNode nodeText = FocusNode();

  set agreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  set imagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void pickImage() async {
    imagePath = await ImagePickerHelper.openImagePicker(context: context) ?? '';
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  void updateCountry(Country country) {
    selectedCountry = country;
    countryCode = "+${country.dialingCode}";
    notifyListeners();
  }

  Future<void> loginApi() async {
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': 'dds',
      'device_type': Platform.isAndroid ? '1' : '2'
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.loginUrl(),
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);
    if (context.mounted) {
      context.push(Routes.verify);
    } else {
      AppPages.rootNavigatorKey.currentContext?.push(Routes.verify);
    }

    /*  DbHelper.saveIsGuest(false);
    context.pop();*/
  }

  Future<void> verifyOtpApi() async {
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': 'dds',
      'device_type': Platform.isAndroid ? '1' : '2',
      'otp': otpTextController.text.trim()
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.verifyOtpUrl(),
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();

    if (model.body?.id != null) {
      DbHelper.saveUserModel(model.body);
      DbHelper.saveToken(model.body?.token);
      DbHelper.saveIsGuest(false);
      DbHelper.saveIsLoggedIn(true);
      if (context.mounted) {
        context.go(Routes.main);
      } else {
        AppPages.rootNavigatorKey.currentContext?.go(Routes.main);
      }
      DialogHelper.showToast(message: model.message);
    } else {
      if (context.mounted) {
        context.go(Routes.completeProfile);
      } else {
        AppPages.rootNavigatorKey.currentContext?.go(Routes.completeProfile);
      }
      DialogHelper.showToast(
          message: 'Welcome to List & Lift, Complete your profile.');
    }
  }

  Future<void> completeProfileApi() async {
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': 'dds',
      'device_type': Platform.isAndroid ? '1' : '2',
      'name': nameTextController.text.trim(),
      'type': '2',
      'last_name': lNameTextController.text.trim(),
      'email': emailTextController.text.trim(),
      'profile_pic': await BaseClient.getMultipartImage(path: imagePath)
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.signupUrl(),
        requestType: RequestType.POST,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: model.message);

    DbHelper.saveUserModel(model.body);
    DbHelper.saveToken(model.body?.token);
    DbHelper.saveIsGuest(false);
    DbHelper.saveIsLoggedIn(true);
    if (context.mounted) {
      context.push(Routes.main);
    } else {
      AppPages.rootNavigatorKey.currentContext?.push(Routes.main);
    }
  }
}
