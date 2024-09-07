import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/res/assets_res.dart';
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

  @override
  void onInit() {
    DbHelper.box.listenKey('isGuest', (value) {
      isGuest = DbHelper.getIsGuest();
      appSettingList = isGuest
          ? [
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_PRIVCY_POLICY,
                  title: 'Privacy Policy',
                  onTap: () {
                    context.push(Routes.termsOfUse, extra: 1);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_T_AND_C,
                  title: 'Terms & Conditions',
                  onTap: () {
                    context.push(Routes.termsOfUse, extra: 2);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_CONTACT_US,
                  title: 'Contact Us',
                  onTap: () {
                    context.push(Routes.contactUsView);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_FAQ,
                  title: 'FAQ\'s',
                  onTap: () {
                    context.push(Routes.faqView);
                  }),
              SettingItemModel(
                  icon: AssetsRes.IC_LOGOUT,
                  title: 'Login',
                  onTap: () {
                    context.push(Routes.guestLogin);
                  }),
            ]
          : [
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_PRIVCY_POLICY,
                  title: 'Privacy Policy',
                  onTap: () {
                    context.push(Routes.termsOfUse, extra: 1);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_T_AND_C,
                  title: 'Terms & Conditions',
                  onTap: () {
                    context.push(Routes.termsOfUse, extra: 2);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_CONTACT_US,
                  title: 'Contact Us',
                  onTap: () {
                    context.push(Routes.contactUsView);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_FAQ,
                  title: 'FAQ\'s',
                  onTap: () {
                    context.push(Routes.faqView);
                  }),
              SettingItemModel(
                  isArrow: true,
                  icon: AssetsRes.IC_BLOCS_LIST,
                  title: 'Blocked Users',
                  onTap: () {
                    context.push(Routes.blockedUserList);
                  }),
              SettingItemModel(
                  icon: AssetsRes.IC_DELETE_ACCOUNT,
                  title: 'Delete Account',
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return AppAlertDialogWithLottie(
                          lottieIcon: AssetsRes.DELETE_LOTTIE,
                          title: 'Account Delete',
                          description:
                              'Are you sure you want to delete this account?',
                          onTap: () {
                            context.pop();
                            DialogHelper.showLoading();
                            deleteAccount();
                          },
                          onCancelTap: () {
                            context.pop();
                          },
                          buttonText: 'Yes',
                          cancelButtonText: 'No',
                          showCancelButton: true,
                        );
                      },
                    );
                  }),
              SettingItemModel(
                  icon: AssetsRes.IC_LOGOUT,
                  title: 'Logout',
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return AppAlertDialogWithWidget(
                          title: 'Logout',
                          description:
                              'Are you sure you want to logout this account?',
                          onTap: () {
                            context.pop();
                            DialogHelper.showLoading();
                            logoutUser();
                          },
                          icon: AssetsRes.IC_LOGOUT_ICON,
                          onCancelTap: () {
                            context.pop();
                          },
                          buttonText: 'Yes',
                          cancelButtonText: 'No',
                          showCancelButton: true,
                        );
                      },
                    );
                  }),
            ];
    });
    if (!isGuest) getProfile();

    supportList = [
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_CONTACT_US,
          title: 'Contact Us',
          onTap: () {
            context.push(Routes.contactUsView);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_FAQ,
          title: 'FAQ\'s',
          onTap: () {
            context.push(Routes.faqView);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_PRIVCY_POLICY,
          title: 'Privacy Policy',
          onTap: () {
            context.push(Routes.termsOfUse, extra: 1);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_T_AND_C,
          title: 'Terms & Conditions',
          onTap: () {
            context.push(Routes.termsOfUse, extra: 2);
          }),
    ];
    accountSettingsList = [
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_BLOCS_LIST,
          title: 'Blocked Users',
          onTap: () {
            context.push(Routes.blockedUserList);
          }),
      SettingItemModel(
          icon: AssetsRes.IC_DELETE_ACCOUNT,
          title: 'Delete Account',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AppAlertDialogWithLottie(
                  lottieIcon: AssetsRes.DELETE_LOTTIE,
                  title: 'Account Delete',
                  description: 'Are you sure you want to delete this account?',
                  onTap: () {
                    context.pop();
                    DialogHelper.showLoading();
                    deleteAccount();
                  },
                  onCancelTap: () {
                    context.pop();
                  },
                  buttonText: 'Yes',
                  cancelButtonText: 'No',
                  showCancelButton: true,
                );
              },
            );
          }),
      SettingItemModel(
          icon: AssetsRes.IC_LOGOUT,
          title: 'Logout',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AppAlertDialogWithWidget(
                  title: 'Logout',
                  description: 'Are you sure you want to logout this account?',
                  onTap: () {
                    context.pop();
                    DialogHelper.showLoading();
                    logoutUser();
                  },
                  icon: AssetsRes.IC_LOGOUT_ICON,
                  onCancelTap: () {
                    context.pop();
                  },
                  buttonText: 'Yes',
                  cancelButtonText: 'No',
                  showCancelButton: true,
                );
              },
            );
          }),
    ];
    super.onInit();
  }

  set isActiveNotification(bool value) {
    _isActiveNotification = value;
    notifyListeners();
  }

  void onSwitchChanged(bool? value) {
    isActiveNotification = value ?? true;
  }

  Future<void> logoutUser() async {
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
