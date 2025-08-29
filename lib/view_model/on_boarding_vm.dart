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
        title: 'Welcome To Daroory',
        description:
            "The easiest way to buy and sell. Quickly, simply, and without stress."),
    OnBoardingModel(
        image: AssetsRes.ON_BOARD_SECOND,
        title: 'Chat, Agree, Done!',
        description:
            "Connect instantly with buyers or sellers. No drama, just smooth deals with a few taps."),
    OnBoardingModel(
        image: AssetsRes.ON_BOARD_THIRD,
        title: 'Your Next Best Deal Awaits!',
        description:
            "Explore amazing deals or post your own effortlessly. Your next great find is just a tap away."),
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
