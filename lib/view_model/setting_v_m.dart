import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';

import '../models/setting_item_model.dart';

class SettingVM extends BaseViewModel {
  bool _isActiveNotification = true;

  bool get isActiveNotification => _isActiveNotification;
  List<SettingItemModel> settingList = [];

  @override
  void onInit() {
    settingList = [
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
                    DbHelper.eraseData();
                    context.go(Routes.login);
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
                    DbHelper.eraseData();
                    context.go(Routes.login);
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
}
