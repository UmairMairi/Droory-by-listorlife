import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/routes/app_routes.dart';

import '../models/setting_item_model.dart';

class SettingVM extends BaseViewModel {
  bool _isActiveNotification = DbHelper.getUserModel()?.notificationStatus == 1;

  bool get isActiveNotification => _isActiveNotification;
  List<SettingItemModel> appSettingList = [];
  List<SettingItemModel> supportList = [];
  List<SettingItemModel> privacySecurityList = [];
  List<SettingItemModel> accountSettingsList = [];

  bool _isGuest = DbHelper.getIsGuest();

  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  bool _isAccountSettings = false;
  bool get isAccountSettings => _isAccountSettings;
  set isAccountSettings(bool value) {
    _isAccountSettings = value;
    notifyListeners();
  }

  bool _isSupport = false;
  bool get isSupport => _isSupport;
  set isSupport(bool value) {
    _isSupport = value;
    notifyListeners();
  }

  bool _isAppSetting = false;
  bool get isAppSetting => _isAppSetting;
  set isAppSetting(bool value) {
    _isAppSetting = value;
    notifyListeners();
  }

  @override
  void onInit() {
    DbHelper.box.listenKey('isGuest', (value) {
      isGuest = DbHelper.getIsGuest();
    });
    if (!isGuest) getProfile();

    super.onInit();
  }

  set isActiveNotification(bool value) {
    _isActiveNotification = value;
    notifyListeners();
  }

  void onSwitchChanged(bool? value) {
    isActiveNotification = value ?? true;
  }

  Future<void> logoutUser(BuildContext context) async {
    ApiRequest apiRequest =
        ApiRequest(url: ApiConstants.logoutUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    if (model.success ?? false) {
      DbHelper.eraseData();
      if (context.mounted) context.go(Routes.login);
    }
  }

  Future<void> deleteAccount() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deleteAccountUrl(), requestType: RequestType.delete);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    if (model.success ?? false) {
      DbHelper.eraseData();
      if (context.mounted) context.go(Routes.login);
    }
  }

  Future<void> getProfile() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProfileUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<UserModel> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));
    DbHelper.saveUserModel(model.body);
    notifyListeners();
  }
}
