import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';

import '../../view_model/main_vm.dart';

class MainView extends BaseView<MainVM> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, MainVM viewModel) {
    return Scaffold(
        extendBody: true,
        body: PersistentTabView(
          context,
          onItemSelected: (index) => viewModel.onIndexSelected(index: index),
          controller: viewModel.navController,
          screens: viewModel.screensView,
          items: [
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.home_outlined),
              title: ("Home"),
              activeColorPrimary: CupertinoColors.black,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(CupertinoIcons.chat_bubble_text),
              title: ("My Chats"),
              activeColorPrimary: CupertinoColors.black,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(
                CupertinoIcons.add,
                color: Colors.white,
                weight: 5,
                size: 30,
              ),
              title: ("Sell"),
              activeColorPrimary: CupertinoColors.black,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.favorite_border_outlined),
              title: ("My Ads"),
              activeColorPrimary: CupertinoColors.black,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
            PersistentBottomNavBarItem(
              icon: const Icon(Icons.person),
              title: ("My Profile"),
              activeColorPrimary: CupertinoColors.black,
              inactiveColorPrimary: CupertinoColors.systemGrey,
            ),
          ],
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style15, // Choose the nav bar style with this property.
        ));
  }
}
