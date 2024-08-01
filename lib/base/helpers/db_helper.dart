import 'dart:convert';
import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';
import 'package:list_and_life/base/notification/notification_entity.dart';

import '../../models/user_model.dart';

class DbHelper {
  static const JsonDecoder _decoder = JsonDecoder();
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  static const String _userModel = "userModel";
  static const String _isLoggedIn = "isLoggedIn";
  static const String _isGuest = "isGuest";
  static const String _isVerified = "isVerified";
  static const String _token = "token";
  static const String _selectedCategory = "selectedCategory";
  static const String _selectedCategoryId = "selectedCategoryId";
  static const String _category = "category";

  static GetStorage box = GetStorage();

  static writeData(String key, dynamic value) async {
    await box.write(key, value);
  }

  static readData(String key) {
    return box.read(key);
  }

  static deleteData(String key) async {
    await box.remove(key);
  }

  static eraseData() async {
    await box.erase();
  }

  static void saveIsGuest(bool value) {
    writeData(_isGuest, value);
  }

  static bool getIsGuest() {
    return readData(_isGuest) ?? false;
  }

  static bool getIsLoggedIn() {
    return readData(_isLoggedIn) ?? false;
  }

  static void saveIsLoggedIn(bool value) {
    writeData(_isLoggedIn, value);
  }

  static bool getIsVerified() {
    return readData(_isVerified) ?? false;
  }

  static void saveIsVerified(bool value) {
    writeData(_isVerified, value);
  }

  static void saveUserModel(UserModel? model) {
    if (model != null) {
      String value = _encoder.convert(model);
      writeData(_userModel, value);
    } else {
      writeData(_userModel, null);
    }
  }

  static UserModel? getUserModel() {
    String? user = readData(_userModel);
    if (user != null) {
      Map<String, dynamic> userMap = _decoder.convert(user);
      return UserModel.fromJson(userMap);
    } else {
      return null;
    }
  }

  static void saveToken(String? token) {
    writeData(_token, token);
  }

  static String? getToken() {
    return readData(_token);
  }

/*  static NotificationEntity? convertStringToNotificationEntity(String? value) {
    if (value == null) {
      return null;
    }
    Map<String, dynamic> map = _decoder.convert(value);
    return NotificationEntity.fromJson(map);
  }

  static String convertNotificationEntityToString(
      NotificationEntity? notificationEntity) {
    String value = _encoder.convert(notificationEntity);
    return value;
  }*/

  static String imageToBase64String(Uint8List image) {
    return base64Encode(image);
  }

  static NotificationEntity? convertStringToNotificationEntity(String? value) {
    if (value == null) {
      return null;
    }
    Map<String, dynamic> map = _decoder.convert(value);
    return NotificationEntity.fromJson(map);
  }

  static String convertNotificationEntityToString(
      NotificationEntity? notificationEntity) {
    String value = _encoder.convert(notificationEntity);
    return value;
  }
}
