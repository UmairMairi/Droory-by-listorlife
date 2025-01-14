import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/helpers/social_login_helper.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_in_with_apple_platform_interface/authorization_credential.dart';

import '../base/helpers/image_picker_helper.dart';

class AuthVM extends BaseViewModel {
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();

  TextEditingController nameTextController = TextEditingController();
  TextEditingController lNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();

  String _latitude = "${LocationHelper.cairoLatitude}";
  String _longitude = "${LocationHelper.cairoLatitude}";

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
    notifyListeners();
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
    notifyListeners();
  }

  String _communicationChoice =
      DbHelper.getUserModel()?.communicationChoice ?? '';

  String countryCode = "+20";
  Country selectedCountry = Country.EG;

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

  Future<void> loginApi({bool resend = false}) async {
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': await Utils.getFcmToken(),
      'device_type': Platform.isAndroid ? '1' : '2'
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.loginUrl(),
        requestType: RequestType.post,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();
    // DialogHelper.showToast(message: model.message);

    if (resend) {
      DialogHelper.showToast(message: "Your verification code is 1111");
      return;
    }

    if (context.mounted) {
      context.push(Routes.verify);
    } else {
      AppPages.rootNavigatorKey.currentContext?.push(Routes.verify);
    }
    DialogHelper.showToast(message: "Your verification code is 1111");
  }

  Future<void> socialLogin({required int type}) async {
    switch (type) {
      case 1:
        var user = await SocialLoginHelper.loginWithGoogle();
        if (user != null) {
          socialLoginApi(user: user, type: type);
        }
        break;
      case 2:
        var user = await SocialLoginHelper.loginWithFacebook();
        if (user != null) {
          socialLoginApi(user: user, type: type);
        }
        break;
      case 3:
        var user = await SocialLoginHelper.loginWithApple();
        if (user != null) {

          socialLoginApi(type: type,appleData:user);
        }
      default:
    }
  }

  Future<void> socialLoginApi(
      {UserCredential? user, required int type,AuthorizationCredentialAppleID? appleData}) async {
    DialogHelper.showLoading();
    String? deviceToken = await Utils.getFcmToken();
    String deviceType = Platform.isAndroid ? '1' : '2';
    Map<String, dynamic> body = {};
    if(user != null){
      body.addAll({
        'device_token': deviceToken,
        'device_type': deviceType,
        'name': user.user?.displayName?.split(' ').first,
        'type': 1,
        'last_name': user.user?.displayName?.split(' ').last,
        'social_id': user.user?.uid,
        'social_type': type,
        'email': user.user?.email,
        'profile_pic': user.user?.photoURL,
      });
    }

    ///for apple only
    if(appleData != null){
      body.addAll({
        'device_token': deviceToken,
        'device_type': deviceType,
        'name': appleData.givenName?.split(' ').first,
        'type': 1,
        'last_name': appleData.givenName?.split(' ').last,
        'social_id': appleData.userIdentifier,
        'social_type': type,
        'email': appleData.email,
       // 'profile_pic': user.user?.photoURL,
      });
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.socialLoginUrl(),
        requestType: RequestType.post,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();
    ////DialogHelper.showToast(message: model.message);

    DbHelper.saveIsGuest(false);
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
  }

  Future<void> verifyOtpApi() async {
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': await Utils.getFcmToken(),
      'device_type': Platform.isAndroid ? '1' : '2',
      'otp': otpTextController.text.trim()
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.verifyOtpUrl(),
        requestType: RequestType.post,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();

    if (model.body?.id != null) {
      DbHelper.saveIsGuest(false);
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
      /*DialogHelper.showToast(
          message: 'Welcome to List & Lift, Complete your profile.');*/
    }
  }

  Future<void> completeProfileApi() async {
    var communication = "";
    if(communicationChoice == "none" || communicationChoice.isEmpty){
      communication = "chat";
    }else{
      communication = communicationChoice;
    }
    // If no image is selected, generate a default image with the first name's letter
    if (imagePath.isEmpty) {
      imagePath = await generateAndSaveDefaultAvatar(
          firstName: nameTextController.text.trim(),
          lastName: lNameTextController.text.trim());
    }

    log("image path => $imagePath");

    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': await Utils.getFcmToken(),
      'device_type': Platform.isAndroid ? '1' : '2',
      'name': nameTextController.text.trim(),
      'type': '1',
      'last_name': lNameTextController.text.trim(),
      'email': emailTextController.text.trim(),
      'address': locationTextController.text.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'communication_choice': communication,
      'profile_pic': await BaseClient.getMultipartImage(path: imagePath)
    };

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.signupUrl(),
        requestType: RequestType.post,
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
      context.go(Routes.main);
    } else {
      AppPages.rootNavigatorKey.currentContext?.go(Routes.main);
    }
    resetTextFields();
  }

  set communicationChoice(String value) {
    _communicationChoice = value;
    notifyListeners();
  }

  String get communicationChoice => _communicationChoice;

  Future<String> generateAndSaveDefaultAvatar(
      {required String firstName, required String lastName}) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.blue;
    const radius = 70.0;

    // Draw the circle
    canvas.drawCircle(
      const Offset(radius, radius),
      radius,
      paint,
    );

    // Draw the initials (first letter of first and last name)
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );

    // Combine first and last name initials
    final initials =
        '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';

    final textSpan = TextSpan(
      text: initials,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    // Convert to image
    final picture = recorder.endRecording();
    final img = await picture.toImage(140, 140);

    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    // Save the image to a file
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/default_avatar.png';
    final file = await File(filePath).writeAsBytes(buffer);

    return file.path;
  }

  void resetTextFields() {
    imagePath = '';
    nameTextController.clear();
    lNameTextController.clear();
    emailTextController.clear();
    agreedToTerms = false;
  }

  void resendOTP() {
    DialogHelper.showLoading();
    Future.delayed(Duration(seconds: 2), () {
      DialogHelper.hideLoading();
      DialogHelper.showToast(message: "Your verification code is 1111");
    });
  }
}
