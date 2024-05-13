import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/on_boarding_model.dart';
import 'package:list_and_life/res/assets_res.dart';

class OnBoardingVM extends BaseViewModel {
  int _currentIndexPage = 0;
  final PageController _pageViewController = PageController(initialPage: 0);

  List<OnBoardingModel> itemsList = [
    OnBoardingModel(
        image: AssetsRes.ON_BOARD_FIRST,
        title: 'Welcome To List Or Lift',
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
    OnBoardingModel(
        image: AssetsRes.ON_BOARD_SECOND,
        title: 'Welcome To List Or Lift',
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
    OnBoardingModel(
        image: AssetsRes.ON_BOARD_THIRD,
        title: 'Welcome To List Or Lift',
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
  ];

  int get currentIndexPage => _currentIndexPage;
  PageController get pageViewController => _pageViewController;

  set currentIndexPage(int index) {
    _currentIndexPage = index;
    notifyListeners();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    _pageViewController.dispose();
    super.onClose();
  }
}
