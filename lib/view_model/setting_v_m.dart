import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';

class SettingVM extends BaseViewModel {
  bool _isActiveNotification = true;

  bool get isActiveNotification => _isActiveNotification;

  List<SettingItemModel> settingList = [
    SettingItemModel(
        icon: AssetsRes.IC_PRIVCY_POLICY,
        title: 'Privacy Policy',
        onTap: () {}),
    SettingItemModel(
        icon: AssetsRes.IC_T_AND_C, title: 'Terms & Conditions', onTap: () {}),
    SettingItemModel(
        icon: AssetsRes.IC_DELETE_ACCOUNT,
        title: 'Delete Account',
        onTap: () {}),
    SettingItemModel(icon: AssetsRes.IC_LOGOUT, title: 'Logout', onTap: () {}),
  ];

  set isActiveNotification(bool value) {
    _isActiveNotification = value;
    notifyListeners();
  }

  void onSwitchChanged(bool? value) {
    isActiveNotification = value ?? true;
  }
}

class SettingItemModel {
  final String icon;
  final String title;
  final VoidCallback onTap;
  SettingItemModel(
      {required this.icon, required this.title, required this.onTap});
}
