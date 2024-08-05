import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';
import 'package:provider/provider.dart';

import '../base/helpers/db_helper.dart';
import '../routes/app_routes.dart';
import '../base/sockets/socket_helper.dart';
import '../view/main/chat/inbox_view.dart';
import '../view/main/fevorite/ads_view.dart';
import '../view/main/home/home_view.dart';
import '../view/main/sell/category/sell_category_view.dart';
import '../view/main/settings/setting_view.dart';

class MainVM extends BaseViewModel {
  final PersistentTabController navController =
      PersistentTabController(initialIndex: 0);

  List<Widget> screensView = [
    const HomeView(),
    const InboxView(),
    const SellCategoryView(),
    const AdsView(),
    const SettingView()
  ];

  @override
  void onInit() {
    // TODO: implement onInit

    if (!DbHelper.getIsGuest()) {
      SocketHelper().connectUser();
    }

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    if (!DbHelper.getIsGuest()) {
      var model = context.read<ChatVM>();
      model.initListeners();
    }
    super.onReady();
  }

  void onIndexSelected({required int index}) {
    switch (index) {
      case 0:
        return;
      case 1:
        if (DbHelper.getIsGuest()) {
          context.push(Routes.guestLogin);
          navController.jumpToTab(0);
        } else {
          context.read<ChatVM>().getInboxList();
        }
      case 2:
      case 3:
        if (DbHelper.getIsGuest()) {
          context.push(Routes.guestLogin);
          navController.jumpToTab(0);
        }
        return;
      case 4:
        return;
    }
    notifyListeners();
  }
}
