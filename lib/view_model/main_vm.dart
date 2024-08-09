import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/dynamic_link_helper.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import '../base/helpers/db_helper.dart';
import '../base/sockets/socket_helper.dart';
import '../routes/app_routes.dart';
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

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    DynamicLinkHelper.initDynamicLinks();
    // Attach a listener to the stream
    linkStream.listen((String? initialLink) {
      if (initialLink != null) {
        // Parse the link to extract data, e.g., ID
        Uri uri = Uri.parse(initialLink.toString());

        // Extract the ID from the path
        String id = uri.pathSegments.last;
        context.push(Routes.productDetails,
            extra: ProductDetailModel(id: num.parse(id)));
      }
    }, onError: (err) {
      DialogHelper.showToast(message: "Link is broken.");
    });

    try {
      final initialLink = await getInitialLink();

      if (initialLink != null) {
        // Parse the link to extract data, e.g., ID
        Uri uri = Uri.parse(initialLink.toString());

        // Extract the ID from the path
        String id = uri.pathSegments.last;

        if (context.mounted) {
          context.push(Routes.productDetails,
              extra: ProductDetailModel(id: num.parse(id)));
        }
      }
    } on PlatformException {
      DialogHelper.showToast(message: "Link is broken.");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit

    if (!DbHelper.getIsGuest()) {
      SocketHelper().connectUser();
    }
    initUniLinks();
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
