import 'package:ccp_dialog/country_picker/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:provider/provider.dart';

import '../base/helpers/dialog_helper.dart';
import '../models/common/map_response.dart';
import '../models/user_model.dart';
import '../base/network/api_constants.dart';
import '../base/network/base_client.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';

class ProfileVM extends BaseViewModel {
  TextEditingController nameTextController =
      TextEditingController(text: DbHelper.getUserModel()?.name??"");
  TextEditingController lastNameController =
      TextEditingController(text: DbHelper.getUserModel()?.lastName??"");
  TextEditingController locationTextController =
      TextEditingController(text: DbHelper.getUserModel()?.address??"");
  TextEditingController emailTextController =
      TextEditingController(text: DbHelper.getUserModel()?.email??"");
  TextEditingController phoneTextController =
      TextEditingController(text: DbHelper.getUserModel()?.phoneNo??"");
  TextEditingController bioTextController =
      TextEditingController(text: DbHelper.getUserModel()?.bio??"");


  String _imagePath = '';
  bool _agreedToTerms = false;

  bool _isPhoneVerified = false;
  bool _isEmailVerified = false;
  String _communicationChoice =
      DbHelper.getUserModel()?.communicationChoice ?? '';

  String get imagePath => _imagePath;

  bool get agreedToTerms => _agreedToTerms;

  final FocusNode nodeText = FocusNode();

  String countryCode = "+20";
  Country selectedCountry = Country.EG;

  set isPhoneVerified(bool value) {
    _isPhoneVerified = value;
    notifyListeners();
  }

  bool get isPhoneVerified => _isPhoneVerified;

  set communicationChoice(String value) {
    _communicationChoice = value;
    notifyListeners();
  }

  String get communicationChoice => _communicationChoice;

  set isEmailVerified(bool value) {
    _isEmailVerified = value;
    notifyListeners();
  }


  Future<Country?> getCountryByCountryCode(String countryCode) async {
    var list = Country.ALL;
    return list.firstWhere((element) => element.dialingCode == countryCode);
  }
  bool get isEmailVerified => _isEmailVerified;

  String _latitude = DbHelper.getUserModel()?.latitude ?? '';
  String _longitude = DbHelper.getUserModel()?.longitude ?? '';

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

  set agreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  set imagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    WidgetsBinding.instance.addPostFrameCallback((call) async {
      await context.read<SettingVM>().getProfile();
      nameTextController =
          TextEditingController(text: DbHelper.getUserModel()?.name??"");
      lastNameController =
          TextEditingController(text: DbHelper.getUserModel()?.lastName??"");
      locationTextController =
          TextEditingController(text: DbHelper.getUserModel()?.address??"");
      emailTextController =
          TextEditingController(text: DbHelper.getUserModel()?.email??"");
      phoneTextController =
          TextEditingController(text: DbHelper.getUserModel()?.phoneNo??"");
      bioTextController =
          TextEditingController(text: DbHelper.getUserModel()?.bio??"");

      isPhoneVerified = DbHelper.getUserModel()?.phoneVerified != 0;
      isEmailVerified = DbHelper.getUserModel()?.emailVerified != 0;
      communicationChoice = DbHelper.getUserModel()?.communicationChoice ?? '';
      var country =  await getCountryByCountryCode( DbHelper.getUserModel()?.countryCode ?? '');
      if(country != null){
        updateCountry(country);
      }
    });

    super.onInit();
  }

  void updateCountry(Country country) {
    selectedCountry = country;
    countryCode = country.dialingCode;
    notifyListeners();
  }

  void pickImage() async {
    imagePath = await ImagePickerHelper.openImagePicker(context: context) ?? '';
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  Future<void> updateProfileApi() async {
    var communication = "";
    if(communicationChoice == "none" || communicationChoice.isEmpty){
      communication = "chat";
    }else{
      communication = communicationChoice;
    }
    Map<String, dynamic> body = {
      'name': nameTextController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'email': emailTextController.text.trim(),
      'bio': bioTextController.text.trim(),
      'phone_no': phoneTextController.text.trim(),
      'country_code': countryCode,
      'communication_choice': communication,
      'address': locationTextController.text.trim(),
      'latitude': latitude,
      'longitude': longitude
    };

    if (imagePath.isNotEmpty) {
      body['profile_pic'] = await BaseClient.getMultipartImage(path: imagePath);
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.editProfileUrl(),
        requestType: RequestType.put,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));

    DbHelper.saveUserModel(model.body);
    if (context.mounted) {
      context.read<SettingVM>().isActiveNotification =
          model.body?.notificationStatus == 1;
    }
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: "Profile updated successfully");
    if (context.mounted) context.pop();
  }

  Future<void> sendVerificationMail({required String email}) async {
    if (email.isEmpty) {
      DialogHelper.showToast(message: "Please enter email address");
      return;
    }
    if (email.isNotEmail()) {
      DialogHelper.showToast(message: "Please enter valid email address");
      return;
    }
    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.sendMailForVerifyUrl(),
        requestType: RequestType.post,
        body: {'email': email});
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    debugPrint("$model");
    //DialogHelper.showToast(message: model.message);
    if (context.mounted) {
      context.push(Routes.verifyProfile, extra: email);
    } else {
      AppPages.rootNavigatorKey.currentContext?.push(Routes.verifyProfile,extra: email);
    }
  }

  Future<void> sendVerificationPhone({required String? phone,required String? countryCode}) async {
    if (phone?.isEmpty ?? false) {
      DialogHelper.showToast(message: "Please enter phone number");
      return;
    }

    DialogHelper.showLoading();
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.sendOtpMobileUrl(),
        requestType: RequestType.post,
        body: {'country_code': countryCode, 'phone_no': phone});
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    debugPrint("$model");
    DialogHelper.hideLoading();
    if (context.mounted) {
      context.push(Routes.verifyProfile, extra: phoneTextController.text.trim());
    } else {
      AppPages.rootNavigatorKey.currentContext?.push(Routes.verifyProfile);
    }
    //DialogHelper.showToast(message: "Your verification code is 1111");

    /// DialogHelper.showToast(message: model.message);
  }

  Future<void> verifyOtpApi(
      {required String? countryCode,required String? phoneNo, required String? otp}) async {
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneNo,
      'otp': otp
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.verifyOtpMobileUrl(),
        requestType: RequestType.post,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));
    DialogHelper.hideLoading();
    await updateProfileApi();
    if (context.mounted) {
      context.pop();
    } else {
      AppPages.rootNavigatorKey.currentContext?.pop();
    }
    DialogHelper.showToast(message: model.message);
    /*if (model.body?.id != null) {
      DbHelper.saveIsGuest(false);
      DbHelper.saveUserModel(model.body);
      if (context.mounted) {
        context.pop();
      } else {
        AppPages.rootNavigatorKey.currentContext?.pop();
      }
      DialogHelper.showToast(message: model.message);
    }*/
  }
}
