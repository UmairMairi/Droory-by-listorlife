import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ccp_dialog/country_picker/flutter_country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/base/helpers/social_login_helper.dart';
import 'package:list_and_life/base/sockets/socket_helper.dart';
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
import '../../base/helpers/string_helper.dart';

class AuthVM extends BaseViewModel {
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController lNameTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController bioTextController = TextEditingController();

  String _latitude = "${LocationHelper.cairoLatitude}";
  String _longitude = "${LocationHelper.cairoLatitude}";

  String get longitude => _longitude;
  String? _selectedGender;

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
  String? get selectedGender => _selectedGender;
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

  set selectedGender(String? value) {
    _selectedGender = value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pickImage() async {
    imagePath = await ImagePickerHelper.openImagePicker(context: context) ?? '';
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  void updateCountry(Country country) {
    selectedCountry = country;
    countryCode = country.dialingCode;
    notifyListeners();
  }

  Future<void> loginApi({bool resend = false}) async {
    DialogHelper.showLoading();
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

    try {
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<UserModel> model =
          MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
      DialogHelper.hideLoading();

      if (resend) {
        return;
      }

      if (context.mounted) {
        context.push(Routes.verify);
      } else {
        AppPages.rootNavigatorKey.currentContext?.push(Routes.verify);
      }
    } catch (e) {
      DialogHelper.hideLoading();
      log("Login API error: $e");
    }
  }

  Future<void> socialLogin({required int type}) async {
    switch (type) {
      case 1:
        var user = await SocialLoginHelper.loginWithGoogle();
        if (user != null) {
          await socialLoginApi(user: user, type: type);
        }
        break;
      case 2:
        var user = await SocialLoginHelper.loginWithFacebook();
        if (user != null) {
          await socialLoginApi(user: user, type: type);
        }
        break;
      case 3:
        var user = await SocialLoginHelper.loginWithApple();
        if (user != null) {
          await socialLoginApi(type: type, appleData: user);
        }
      default:
    }
  }

  // In your AuthVM class
  void initializeEgyptAsDefault() {
    selectedCountry = Country.findCountryByIsoCode('EG');
    countryCode = "+20";
    notifyListeners();
  }

  Future<void> socialLoginApi(
      {UserCredential? user,
      required int type,
      AuthorizationCredentialAppleID? appleData}) async {
    DialogHelper.showLoading();
    String? deviceToken = await Utils.getFcmToken();
    String deviceType = Platform.isAndroid ? '1' : '2';
    Map<String, dynamic> body = {};

    if (user != null) {
      body.addAll({
        'device_token': deviceToken,
        'device_type': deviceType,
        'type': 1,
        'social_id': user.user?.uid,
        'social_type': type,
      });

      if ((user.user?.photoURL ?? "").isNotEmpty) {
        body.addAll({'profile_pic': user.user?.photoURL});
      }
      if ((user.user?.email ?? "").isNotEmpty) {
        body.addAll({'email': user.user?.email});
      }
      if ((user.user?.displayName ?? "").isNotEmpty) {
        var nameParts = user.user!.displayName!.split(' ');
        body.addAll({
          'name': nameParts.first,
          'last_name':
              nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
        });
      }
    }

    if (appleData != null) {
      body.addAll({
        'device_token': deviceToken,
        'device_type': deviceType,
        'type': 1,
        'social_id': appleData.userIdentifier,
        'social_type': type,
      });

      if ((appleData.givenName ?? "").isNotEmpty ||
          (appleData.familyName ?? "").isNotEmpty) {
        body.addAll({
          'name': appleData.givenName ?? '',
          'last_name': appleData.familyName ?? '',
        });
      }
      if ((appleData.email ?? "").isNotEmpty) {
        body.addAll({'email': appleData.email});
      }
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.socialLoginUrl(),
        requestType: RequestType.post,
        body: body);

    try {
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<UserModel> model =
          MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
      DialogHelper.hideLoading();

      DbHelper.saveIsGuest(false);
      DbHelper.saveUserModel(model.body);
      DbHelper.saveToken(model.body?.token);
      DbHelper.saveNotificationStatus("${model.body?.notificationStatus}");
      DbHelper.saveIsLoggedIn(true);
      SocketHelper().connectUser();

      if (context.mounted) {
        context.go(Routes.main);
      } else {
        AppPages.rootNavigatorKey.currentContext?.go(Routes.main);
      }
      DialogHelper.showToast(message: model.message);
    } catch (e) {
      DialogHelper.hideLoading();
      log("Social Login API error: $e");
    }
  }

  Future<void> verifyOtpApi({required String otp}) async {
    DialogHelper.showLoading();
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': await Utils.getFcmToken(),
      'device_type': Platform.isAndroid ? '1' : '2',
      'otp': otp
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.verifyOtpUrl(),
        requestType: RequestType.post,
        body: body);
    try {
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<UserModel> model =
          MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
      DialogHelper.hideLoading();

      if (model.body?.id != null) {
        // User exists and OTP verified
        DbHelper.saveIsGuest(false);
        DbHelper.saveUserModel(model.body);
        DbHelper.saveToken(model.body?.token);
        DbHelper.saveNotificationStatus("${model.body?.notificationStatus}");
        DbHelper.saveIsLoggedIn(true);
        SocketHelper().connectUser();
        if (context.mounted) {
          context.go(Routes.main);
        } else {
          AppPages.rootNavigatorKey.currentContext?.go(Routes.main);
        }
        DialogHelper.showToast(message: model.message);
      } else {
        // User does not exist (new user flow after OTP)
        if (context.mounted) {
          context.go(Routes.completeProfile);
        } else {
          AppPages.rootNavigatorKey.currentContext?.go(Routes.completeProfile);
        }
      }
    } catch (e) {
      DialogHelper.hideLoading();
      log("Verify OTP API error: $e");
    }
  }

  Future<void> completeProfileApi() async {
    DialogHelper.showLoading();

    var communication = "";
    if (communicationChoice == "none" || communicationChoice.isEmpty) {
      communication = "chat";
    } else {
      communication = communicationChoice;
    }

    // if (imagePath.isEmpty &&
    //     nameTextController.text.isNotEmpty &&
    //     lNameTextController.text.isNotEmpty) {
    //   imagePath = await generateAndSaveDefaultAvatar(
    //       firstName: nameTextController.text.trim(),
    //       lastName: lNameTextController.text.trim());
    // } else if (imagePath.isEmpty) {
    //   log("Cannot generate default avatar due to empty name fields.");
    // }

    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneTextController.text.trim(),
      'device_token': await Utils.getFcmToken(),
      'device_type': Platform.isAndroid ? '1' : '2',
      'name': nameTextController.text.trim(),
      'type': '1',
      'last_name': lNameTextController.text.trim(),
      'address': locationTextController.text.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'communication_choice': communication,
      'bio': bioTextController.text.trim(),
      'gender': selectedGender,
    };

    if (imagePath.isNotEmpty) {
      body['profile_pic'] = await BaseClient.getMultipartImage(path: imagePath);
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.signupUrl(),
        requestType: RequestType.post,
        bodyType: imagePath.isNotEmpty ? BodyType.formData : BodyType.json,
        body: body);

    try {
      var response = await BaseClient.handleRequest(apiRequest);

      Map<String, dynamic> responseData;
      if (response is Response) {
        responseData = response.data;
      } else {
        responseData = response;
      }

      DialogHelper.hideLoading();

      if (responseData['success'] == true) {
        UserModel? userModel;
        if (responseData['body'] != null) {
          userModel = UserModel.fromJson(responseData['body']);
        }

        // Registration successful
        DialogHelper.showToast(
            message: responseData['message'] ?? "Registration successful");

        if (userModel != null) {
          DbHelper.saveUserModel(userModel);
          DbHelper.saveToken(userModel.token);
          DbHelper.saveNotificationStatus("${userModel.notificationStatus}");
        }
        DbHelper.saveIsGuest(false);
        DbHelper.saveIsLoggedIn(true);
        SocketHelper().connectUser();

        if (context.mounted) {
          context.go(Routes.main);
        } else {
          AppPages.rootNavigatorKey.currentContext?.go(Routes.main);
        }
        resetTextFields();
      } else {
        DialogHelper.showToast(
            message: responseData['message'] ?? "Registration failed");
      }
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(message: "Registration failed. Please try again.");
      log("Complete Profile API error: $e");
    }
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
    final paint = Paint()..color = Colors.blueGrey;
    const radius = 70.0;

    canvas.drawCircle(
      const Offset(radius, radius),
      radius,
      paint,
    );

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    );

    String initials = "";
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      initials = '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
    } else if (firstName.isNotEmpty) {
      initials = firstName[0].toUpperCase();
    } else if (lastName.isNotEmpty) {
      initials = lastName[0].toUpperCase();
    } else {
      initials = "U";
    }

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

    final picture = recorder.endRecording();
    final img = await picture.toImage(140, 140);

    final byteData = await img.toByteData(format: ImageByteFormat.png);
    if (byteData == null) return '';
    final buffer = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/default_avatar_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(filePath).writeAsBytes(buffer);

    return file.path;
  }

  void resetTextFields() {
    imagePath = '';
    nameTextController.clear();
    lNameTextController.clear();
    bioTextController.clear();
    selectedGender = null;
    _agreedToTerms = false;
    notifyListeners();
  }

  void resendOTP() {
    DialogHelper.showLoading();
    loginApi(resend: true).then((_) {
      DialogHelper.hideLoading();
    }).catchError((e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(
          message: "Failed to resend OTP. Please try again.");
      log("Resend OTP error: $e");
    });
  }
}
