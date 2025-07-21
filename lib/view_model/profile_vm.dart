import 'package:ccp_dialog/country_picker/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'dart:convert';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:async';
import 'package:dio/dio.dart';
import '../base/helpers/dialog_helper.dart';
import '../models/common/map_response.dart';
import '../models/user_model.dart';
import '../base/network/api_constants.dart';
import '../base/network/base_client.dart';
import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import '../../base/helpers/string_helper.dart';

class ProfileVM extends BaseViewModel {
  TextEditingController nameTextController =
      TextEditingController(text: DbHelper.getUserModel()?.name ?? "");
  TextEditingController lastNameController =
      TextEditingController(text: DbHelper.getUserModel()?.lastName ?? "");
  TextEditingController locationTextController = TextEditingController();
  TextEditingController emailTextController =
      TextEditingController(text: DbHelper.getUserModel()?.email ?? "");
  TextEditingController phoneTextController =
      TextEditingController(text: DbHelper.getUserModel()?.phoneNo ?? "");
  TextEditingController bioTextController =
      TextEditingController(text: DbHelper.getUserModel()?.bio ?? "");

  String _imagePath = '';
  bool _agreedToTerms = false;
  bool _isImageDeleted = false; // NEW: Track if image was deleted

  bool _isPhoneVerified = DbHelper.getUserModel()?.phoneVerified != 0;
  bool _isEmailVerified = DbHelper.getUserModel()?.emailVerified != 0;
  String _communicationChoice =
      DbHelper.getUserModel()?.communicationChoice ?? '';

  String? _selectedGender = DbHelper.getUserModel()?.gender;

  String? _emailError;
  bool _isCheckingEmail = false;
  Timer? _emailCheckTimer;

  String get imagePath => _imagePath;
  bool get agreedToTerms => _agreedToTerms;
  bool get isImageDeleted => _isImageDeleted; // NEW: Getter for deletion flag
  final FocusNode nodeText = FocusNode();

  String countryCode = DbHelper.getUserModel()?.countryCode ?? "+20";
  Country selectedCountry = Country.EG;

  String _latitude = DbHelper.getUserModel()?.latitude?.toString() ?? '';
  String _longitude = DbHelper.getUserModel()?.longitude?.toString() ?? '';
  String? profileCityEn = DbHelper.getUserModel()?.cityEn;
  String? profileDistrictEn = DbHelper.getUserModel()?.districtEn;
  String? profileNeighborhoodEn = DbHelper.getUserModel()?.neighborhoodEn;

  set isPhoneVerified(bool value) {
    _isPhoneVerified = value;
    notifyListeners();
  }

  String? _getLocalizedGenderFromKey(String? genderKey) {
    if (genderKey == null || genderKey.isEmpty) return null;

    switch (genderKey.toLowerCase()) {
      case 'male':
        return StringHelper.male;
      case 'female':
        return StringHelper.female;
      case 'prefer_not_to_say':
        return StringHelper.preferNotToSay;
      default:
        if (genderKey == 'Male' || genderKey == 'ذكر') return StringHelper.male;
        if (genderKey == 'Female' || genderKey == 'أنثى')
          return StringHelper.female;
        if (genderKey == 'Prefer not to say' || genderKey == 'أفضل عدم القول')
          return StringHelper.preferNotToSay;
        return genderKey;
    }
  }

  String? _convertGenderToKey(String? localizedGender) {
    if (localizedGender == null || localizedGender.isEmpty) return null;

    if (localizedGender == StringHelper.male ||
        localizedGender == 'Male' ||
        localizedGender == 'ذكر') {
      return 'male';
    } else if (localizedGender == StringHelper.female ||
        localizedGender == 'Female' ||
        localizedGender == 'أنثى') {
      return 'female';
    } else if (localizedGender == StringHelper.preferNotToSay ||
        localizedGender == 'Prefer not to say' ||
        localizedGender == 'أفضل عدم القول') {
      return 'prefer_not_to_say';
    }

    return localizedGender;
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

  bool get isEmailVerified => _isEmailVerified;

  String? get emailError => _emailError;
  bool get isCheckingEmail => _isCheckingEmail;

  set emailError(String? value) {
    _emailError = value;
    notifyListeners();
  }

  set isCheckingEmail(bool value) {
    _isCheckingEmail = value;
    notifyListeners();
  }

  String? get selectedGender => _selectedGender;

  set selectedGender(String? value) {
    _selectedGender = value;
    notifyListeners();
  }

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
    _isImageDeleted = path.isEmpty;
    notifyListeners();
  }

  // NEW: Method to explicitly delete image
  void deleteImage() {
    print('🟡 DELETE IMAGE CALLED');

    _imagePath = '';
    _isImageDeleted = true;

    // Immediately update the local user model
    final currentUser = DbHelper.getUserModel();
    if (currentUser != null) {
      print('🟡 Clearing profilePic from local user model');
      currentUser.profilePic = null;
      currentUser.profilePic = ''; // Set empty string to ensure it's cleared
      DbHelper.saveUserModel(currentUser);
    }

    print('🟡 Image deleted successfully');
    notifyListeners();
  }

  // NEW: Method to reset image deletion flag
  void resetImageDeletionFlag() {
    _isImageDeleted = false;
  }

  @override
  void onInit() {
    super.onInit();

    initializeForEditProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = DbHelper.getUserModel();

      // Set the initial text values
      nameTextController.text = user?.name ?? "";
      lastNameController.text = user?.lastName ?? "";
      emailTextController.text = user?.email ?? "";
      phoneTextController.text = user?.phoneNo ?? "";
      bioTextController.text = user?.bio ?? "";
      _selectedGender = _getLocalizedGenderFromKey(user?.gender);
      _isPhoneVerified = user?.phoneVerified != 0;
      _isEmailVerified = user?.emailVerified != 0;
      _communicationChoice = user?.communicationChoice ?? '';
      _latitude = user?.latitude?.toString() ?? '';
      _longitude = user?.longitude?.toString() ?? '';
      profileCityEn = user?.cityEn;
      profileDistrictEn = user?.districtEn;
      profileNeighborhoodEn = user?.neighborhoodEn;

      updateDisplayedProfileLocationText();

      countryCode = user?.countryCode ?? "+20";
      var country = await getCountryByCountryCode(countryCode);
      if (country != null) {
        selectedCountry = country;
      } else {
        selectedCountry = Country.EG;
      }

      // Don't reset deletion flag - it should persist
      // Only reset if we're not in a deletion state
      if (!_isImageDeleted) {
        _imagePath = '';
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _emailCheckTimer?.cancel();
    // Dispose controllers
    nameTextController.dispose();
    lastNameController.dispose();
    locationTextController.dispose();
    emailTextController.dispose();
    phoneTextController.dispose();
    bioTextController.dispose();
    nodeText.dispose();

    super.dispose();
  }

  void checkEmailAvailability(String email) {
    _emailCheckTimer?.cancel();

    if (email.trim().isEmpty) {
      emailError = null;
      return;
    }

    if (!email.trim().isEmail()) {
      emailError = FormFieldErrors.invalidEmail;
      return;
    }

    final currentUserEmail = DbHelper.getUserModel()?.email ?? '';
    if (email.trim() == currentUserEmail) {
      emailError = null;
      return;
    }

    isCheckingEmail = true;
    emailError = null;

    _emailCheckTimer = Timer(const Duration(milliseconds: 800), () {
      _performEmailCheck(email.trim());
    });
  }

  Future<void> _performEmailCheck(String email) async {
    try {
      bool emailExists = await checkIfEmailExists(email);

      if (emailExists) {
        emailError = "This email is already registered";
      } else {
        emailError = null;
      }
    } catch (e) {
      log('Error checking email availability: $e');
      emailError = "Unable to verify email availability";
    } finally {
      isCheckingEmail = false;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.checkEmailExistsUrl(email: email),
        requestType: RequestType.get,
      );

      var responseData = await BaseClient.handleRequest(apiRequest);
      bool backendSuccessFlag = responseData['success'] ?? false;

      return !backendSuccessFlag;
    } catch (e) {
      log('Error checking email from server: $e');
      return false;
    }
  }

  Future<bool> checkEmailExistsForVerification(String email) async {
    if (email.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.emailRequired);
      return false;
    }

    if (!email.trim().isEmail()) {
      DialogHelper.showToast(message: StringHelper.pleaseEnterValidEmail);
      return false;
    }

    final currentUserEmail = DbHelper.getUserModel()?.email ?? '';
    if (email.trim() == currentUserEmail) {
      DialogHelper.showToast(message: "This is already your current email.");
      emailError = null;
      notifyListeners();
      return false;
    }

    isCheckingEmail = true;
    notifyListeners();

    bool emailIsTakenByOtherUser = await checkIfEmailExists(email.trim());

    isCheckingEmail = false;
    notifyListeners();

    if (emailIsTakenByOtherUser) {
      emailError = StringHelper.emailAlreadyRegistered;
      return false;
    }

    emailError = null;
    return true;
  }

  Future<void> sendVerificationMail({required String email}) async {
    DialogHelper.showLoading();

    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.sendMailForVerifyUrl(),
      requestType: RequestType.post,
      body: {'email': email.trim()},
    );

    try {
      var response = await BaseClient.handleRequest(apiRequest);
      DialogHelper.hideLoading();

      Map<String, dynamic> responseData;

      if (response is Response) {
        responseData = response.data;
      } else {
        responseData = response;
      }

      bool isSuccess = responseData['success'] ?? false;

      if (isSuccess) {
        emailError = null;
        log('✅ Verification email sent successfully to $email');

        if (context.mounted) {
          context.push(Routes.verifyProfile,
              extra: {'value': email.trim(), 'type': 'email'});
        } else {
          AppPages.rootNavigatorKey.currentContext?.push(Routes.verifyProfile,
              extra: {'value': email.trim(), 'type': 'email'});
        }
      } else {
        String errorMessage =
            responseData['message'] ?? StringHelper.unableToVerifyEmail;
        emailError = errorMessage;
        log('❌ Email verification failed: $errorMessage');
      }
    } catch (error) {
      DialogHelper.hideLoading();
      log('❌ Email sending failed: $error');
      emailError = StringHelper.unableToVerifyEmail;
    }
  }

  Future<Country?> getCountryByCountryCode(String countryCode) async {
    var list = Country.ALL;
    try {
      return list.firstWhere((element) => element.dialingCode == countryCode);
    } catch (e) {
      return null;
    }
  }

  void setLocationData(
    String displayLocationName,
    double lat,
    double lng,
    String? cityEn,
    String? districtEn,
    String? neighborhoodEn,
  ) {
    locationTextController.text = displayLocationName;
    latitude = lat.toString();
    longitude = lng.toString();
    profileCityEn = cityEn;
    profileDistrictEn = districtEn;
    profileNeighborhoodEn = neighborhoodEn;
    notifyListeners();
  }

  void updateDisplayedProfileLocationText() {
    bool isArabic = _isCurrentLanguageArabic();

    if (profileCityEn != null && profileCityEn!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(profileCityEn!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;
        String districtName = "";
        String neighborhoodName = "";

        if (profileDistrictEn != null && profileDistrictEn!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, profileDistrictEn!);
          if (districtModel != null) {
            districtName =
                isArabic ? districtModel.arabicName : districtModel.name;
            if (profileNeighborhoodEn != null &&
                profileNeighborhoodEn!.isNotEmpty) {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, profileNeighborhoodEn!);
              if (neighborhoodModel != null) {
                neighborhoodName = isArabic
                    ? neighborhoodModel.arabicName
                    : neighborhoodModel.name;
                locationTextController.text =
                    "$neighborhoodName، $districtName، $cityName";
                return;
              }
            }
            locationTextController.text = "$districtName، $cityName";
            return;
          }
        }
        locationTextController.text = cityName;
        return;
      }
    }

    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      double? latDouble = double.tryParse(latitude);
      double? lngDouble = double.tryParse(longitude);
      if (latDouble != null &&
          lngDouble != null &&
          !(latDouble == 0.0 && lngDouble == 0.0)) {
        locationTextController.text =
            _getDisplayAddressFromCoordinates(context, latDouble, lngDouble);
        return;
      }
    }

    final user = DbHelper.getUserModel();
    if (user?.address != null && user!.address!.isNotEmpty) {
      locationTextController.text = user.address!;
    } else {
      locationTextController.text = isArabic ? "حدد الموقع" : "Select Location";
    }
  }

  void initializeForEditProfile() {
    _emailError = null;
    _isCheckingEmail = false;

    // Check if the current user has no profile pic (could mean it was deleted)
    final currentUser = DbHelper.getUserModel();
    if (currentUser?.profilePic == null ||
        currentUser?.profilePic?.isEmpty == true) {
      _isImageDeleted = true;
    } else {
      _isImageDeleted = false;
    }

    notifyListeners();
  }

  void clearEmailError() {
    emailError = null;
    _isCheckingEmail = false;
    notifyListeners();
  }

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

  bool _isCurrentLanguageArabic() {
    try {
      if (context.mounted) {
        return Directionality.of(context) == TextDirection.rtl;
      }
    } catch (e) {
      log("Context not available for _isCurrentLanguageArabic, falling back to platform dispatcher: $e");
    }
    return WidgetsBinding.instance.platformDispatcher.locale.languageCode ==
        'ar';
  }

  void updateCountry(Country country) {
    selectedCountry = country;
    countryCode = country.dialingCode;
    notifyListeners();
  }

  void pickImage() async {
    imagePath = await ImagePickerHelper.openImagePicker(context: context) ?? '';
    notifyListeners();
  }

  Future<void> updateProfileApi() async {
    DialogHelper.showLoading();
    var communication = "";
    if (communicationChoice == "none" || communicationChoice.isEmpty) {
      communication = "chat";
    } else {
      communication = communicationChoice;
    }

    Map<String, dynamic> body = {
      'name': nameTextController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'email': emailTextController.text.trim(),
      'bio': bioTextController.text.trim(),
      'gender': _convertGenderToKey(selectedGender),
      'phone_no': phoneTextController.text.trim(),
      'country_code': countryCode,
      'communication_choice': communication,
      'address': locationTextController.text.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'city': profileCityEn,
      'district_name': profileDistrictEn,
      'neighborhood_name': profileNeighborhoodEn,
    };

    body.removeWhere((key, value) =>
        (key == 'city' ||
            key == 'district_name' ||
            key == 'neighborhood_name') &&
        (value == null || value.isEmpty));

    // Handle image deletion or update
    bool needsFormData = false;

    if (_isImageDeleted && imagePath.isEmpty) {
      // User deleted the image - send explicit removal
      body['remove_profile_pic'] = true;
      needsFormData = true;
      print('🟡 API: Sending remove_profile_pic = true');
    } else if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      // User selected a new image
      body['profile_pic'] = await BaseClient.getMultipartImage(path: imagePath);
      needsFormData = true;
      print('🟡 API: Sending new image');
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.editProfileUrl(),
        requestType: RequestType.put,
        bodyType: needsFormData ? BodyType.formData : BodyType.json,
        body: body);

    try {
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse<UserModel> model =
          MapResponse.fromJson(response, (json) => UserModel.fromJson(json));

      UserModel? updatedUserFromApi = model.body;
      if (updatedUserFromApi != null) {
        // Handle image deletion in local storage
        if (_isImageDeleted && imagePath.isEmpty) {
          updatedUserFromApi.profilePic = null;
          print('🟡 API Response: Profile pic removed from user model');
        }

        updatedUserFromApi.cityEn = profileCityEn ?? updatedUserFromApi.cityEn;
        updatedUserFromApi.districtEn =
            profileDistrictEn ?? updatedUserFromApi.districtEn;
        updatedUserFromApi.neighborhoodEn =
            profileNeighborhoodEn ?? updatedUserFromApi.neighborhoodEn;
        updatedUserFromApi.latitude =
            latitude.isNotEmpty ? latitude : updatedUserFromApi.latitude;
        updatedUserFromApi.longitude =
            longitude.isNotEmpty ? longitude : updatedUserFromApi.longitude;
        updatedUserFromApi.address =
            locationTextController.text.trim().isNotEmpty
                ? locationTextController.text.trim()
                : updatedUserFromApi.address;
        updatedUserFromApi.gender =
            _convertGenderToKey(selectedGender) ?? updatedUserFromApi.gender;
        DbHelper.saveUserModel(updatedUserFromApi);

        print('🟡 Updated user model saved to local storage');
      }

      if (context.mounted) {
        context.read<SettingVM>().isActiveNotification =
            model.body?.notificationStatus == 1;
      }

      DialogHelper.hideLoading();
      DialogHelper.showToast(message: StringHelper.profileUpdatedSuccessfully);

      // Reset deletion flag after successful update
      if (_isImageDeleted) {
        resetImageDeletionFlag();
        print('🟡 Image deletion flag reset after successful API update');
      }

      if (context.mounted) context.pop();
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(
          message: "Profile update failed. Please try again.");
      log("Update profile API error: $e");
    }
  }

  Future<void> sendVerificationPhoneWithoutCheck({
    required String countryCode,
    required String phone,
  }) async {
    try {
      print('🔍 Sending verification for: $countryCode$phone');

      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.sendOtpMobileUrl(),
        requestType: RequestType.post,
        body: {
          'country_code': countryCode,
          'phone_no': phone.trim(),
        },
      );

      final response = await BaseClient.handleRequest(apiRequest);

      print('✅ OTP request completed');
      print('Response: $response');
    } catch (e) {
      print('❌ Phone verification failed: $e');
      throw Exception('Failed to send OTP. Please try again.');
    }
  }

  Future<void> checkUserStatus() async {
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProfileUrl(),
        requestType: RequestType.get,
      );

      await BaseClient.handleRequest(apiRequest);
      print('✅ User status check passed');
    } catch (e) {
      print('❌ User status check failed: $e');
    }
  }

  Future<bool> checkPhoneExists({
    required String phoneNumber,
    required String countryCode,
  }) async {
    try {
      print('🔍 Checking phone: $countryCode$phoneNumber');

      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.checkPhoneExistsUrl(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
        ),
        requestType: RequestType.get,
      );

      final response = await BaseClient.handleRequest(apiRequest);

      print('✅ Phone check response received');

      Map<String, dynamic> responseData;
      if (response is Response) {
        responseData = response.data;
      } else if (response is Map<String, dynamic>) {
        responseData = response;
      } else {
        print('❌ Unexpected response type: ${response.runtimeType}');
        return false;
      }

      bool isSuccess = responseData['success'] ?? false;

      if (isSuccess) {
        print('✅ Phone is available');
        return false;
      } else {
        print('❌ Phone already exists');
        return true;
      }
    } catch (e) {
      print('❌ Phone check error: $e');

      String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('already registered') ||
          errorStr.contains('already exist')) {
        print('❌ Phone exists (from error message)');
        return true;
      }

      print('❌ Network/other error, assuming phone is available');
      return false;
    }
  }

  Future<void> sendVerificationPhone(
      {required String? phone, required String? countryCode}) async {
    if (phone == null || phone.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }

    String cleanPhone = phone.trim().replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length != 10) {
      DialogHelper.showToast(message: StringHelper.invalidPhoneNumber);
      return;
    }

    final currentUser = DbHelper.getUserModel();
    final currentPhone = currentUser?.phoneNo ?? '';
    final currentCountryCode = currentUser?.countryCode ?? '';

    if (phone.trim() == currentPhone && countryCode == currentCountryCode) {
      DialogHelper.showToast(
          message: "This is already your current phone number.");
      return;
    }

    DialogHelper.showLoading();

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.sendOtpMobileUrl(),
        requestType: RequestType.post,
        body: {'country_code': countryCode, 'phone_no': phone.trim()});

    try {
      var response = await BaseClient.handleRequest(apiRequest);
      DialogHelper.hideLoading();

      Map<String, dynamic> responseData;
      if (response is Response) {
        responseData = response.data;
      } else {
        responseData = response;
      }

      bool isSuccess = responseData['success'] ?? false;

      if (isSuccess) {
        print(
            '✅ Phone verification OTP sent successfully to $countryCode$phone');

        if (context.mounted) {
          context.push(Routes.verifyProfile, extra: {
            'value': phone.trim(),
            'type': 'phone',
            'countryCode': countryCode
          });
        } else {
          AppPages.rootNavigatorKey.currentContext?.push(Routes.verifyProfile,
              extra: {
                'value': phone.trim(),
                'type': 'phone',
                'countryCode': countryCode
              });
        }
      } else {
        String errorMessage =
            responseData['message'] ?? "Please enter a correct mobile number";
        DialogHelper.showToast(message: errorMessage);
        print('❌ Phone verification failed: $errorMessage');
      }
    } catch (e) {
      DialogHelper.hideLoading();
      print('❌ Phone verification failed: $e');
      DialogHelper.showToast(message: "Please enter a correct mobile number");
    }
  }

  Future<void> verifyOtpApi(
      {required String? countryCode,
      required String? phoneNo,
      required String? otp}) async {
    DialogHelper.showLoading();
    Map<String, dynamic> body = {
      'country_code': countryCode,
      'phone_no': phoneNo,
      'otp': otp
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.verifyOtpMobileUrl(),
        requestType: RequestType.post,
        body: body);

    try {
      var response = await BaseClient.handleRequest(apiRequest);
      DialogHelper.hideLoading();

      Map<String, dynamic> responseData;
      if (response is Response) {
        responseData = response.data;
      } else {
        responseData = response;
      }

      bool isSuccess = responseData['success'] ?? false;

      if (isSuccess) {
        final currentUser = DbHelper.getUserModel();
        if (currentUser != null) {
          currentUser.phoneVerified = 1;
          currentUser.phoneNo = phoneNo;
          currentUser.countryCode = countryCode;

          DbHelper.saveUserModel(currentUser);

          isPhoneVerified = true;
          phoneTextController.text = phoneNo ?? phoneTextController.text;
          this.countryCode = countryCode ?? this.countryCode;

          var newCountry = await getCountryByCountryCode(this.countryCode);
          if (newCountry != null) selectedCountry = newCountry;

          notifyListeners();
        }

        DialogHelper.showToast(message: StringHelper.phoneIsVerified);

        if (context.mounted) {
          int popCount = 0;
          Navigator.of(context).popUntil((_) => popCount++ >= 2);
        } else {
          if (AppPages.rootNavigatorKey.currentContext != null) {
            int popCount = 0;
            Navigator.of(AppPages.rootNavigatorKey.currentContext!)
                .popUntil((_) => popCount++ >= 2);
          }
        }
      } else {
        DialogHelper.showToast(
            message: responseData['message'] ?? "Phone verification failed");
      }
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(
          message: "Phone OTP verification failed. Please try again.");
      print("Verify Phone OTP API error: $e");
    }
  }

  Future<void> verifyOtpEmailApi(
      {required String? otp, required String? emailToVerify}) async {
    DialogHelper.showLoading();
    Map<String, dynamic> body = {
      'otp': otp,
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.verifyOtpEmailUrl(),
        requestType: RequestType.post,
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
        final currentUser = DbHelper.getUserModel();

        if (currentUser != null) {
          currentUser.email = emailToVerify ?? currentUser.email;
          currentUser.emailVerified = 1;

          DbHelper.saveUserModel(currentUser);

          isEmailVerified = true;
          emailTextController.text =
              currentUser.email ?? emailTextController.text;

          notifyListeners();
        }

        DialogHelper.showToast(
            message: responseData['message'] ??
                StringHelper.emailVerifiedSuccessfully);

        if (context.mounted) {
          int popCount = 0;
          Navigator.of(context).popUntil((_) => popCount++ >= 2);
        } else {
          if (AppPages.rootNavigatorKey.currentContext != null) {
            int popCount = 0;
            Navigator.of(AppPages.rootNavigatorKey.currentContext!)
                .popUntil((_) => popCount++ >= 2);
          }
        }
      } else {
        DialogHelper.showToast(
            message: responseData['message'] ?? "Email verification failed");
      }
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(
          message: "Email OTP verification failed. Please try again.");
      log("Verify Email OTP API error: $e");
    }
  }
}
