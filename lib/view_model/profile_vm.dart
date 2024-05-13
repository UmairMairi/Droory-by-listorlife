import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/image_picker_helper.dart';

class ProfileVM extends BaseViewModel {
  String _imagePath = '';
  bool _agreedToTerms = false;
  String get imagePath => _imagePath;

  bool get agreedToTerms => _agreedToTerms;
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
}
