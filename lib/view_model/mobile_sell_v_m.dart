import 'package:flutter/material.dart';

import '../base/base_view_model.dart';

class SellFormsVM extends BaseViewModel {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  var regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';
  int _currentIndex = 1;
  int _transmission = 0;

  String _mainImagePath = "";
  List<String> imagesList = <String>[];

  List<String> jobPositionList = [
    'Contract',
    'Full Time',
    'Part-time',
    'Temporary'
  ];

  List<String> salaryPeriodList = [
    'Hourly',
    'Monthly',
    'Weekly',
    'Yearly'
  ];

  void addImage(String path) {
    imagesList.add(path);
    notifyListeners();
  }

  String get mainImagePath => _mainImagePath;

  set mainImagePath(String image) {
    _mainImagePath = image;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get transmission => _transmission;

  set transmission(int value) {
    _transmission = value;
    notifyListeners();
  }
  TextEditingController jobPositionTextController = TextEditingController();
  TextEditingController jobSalaryTextController = TextEditingController();
  TextEditingController jobSalaryFromController = TextEditingController();
  TextEditingController jobSalaryToController = TextEditingController();
  TextEditingController brandTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  TextEditingController fuelTextController = TextEditingController();
  TextEditingController kmDrivenTextController = TextEditingController();
  TextEditingController numOfOwnerTextController = TextEditingController();
  TextEditingController adTitleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
}
