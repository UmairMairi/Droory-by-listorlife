import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

class SettingVM extends BaseViewModel {
  bool _isActiveNotification = true;

  bool get isActiveNotification => _isActiveNotification;

  List<SettingItemModel> settingList = [];

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
