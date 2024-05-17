import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/image_picker_helper.dart';

class ProfileVM extends BaseViewModel {
  TextEditingController nameTextController =
      TextEditingController(text: 'John Marker');
  TextEditingController emailTextController =
      TextEditingController(text: 'john@gmail.com');
  TextEditingController phoneTextController =
      TextEditingController(text: '+1-123-456-789');
  TextEditingController bioTextController = TextEditingController(text: '');

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
