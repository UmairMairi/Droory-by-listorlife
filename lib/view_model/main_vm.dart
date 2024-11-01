import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dynamic_link_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/providers/language_provider.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';
import 'package:provider/provider.dart';

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
  final _appLinks = AppLinks();
  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    //DynamicLinkHelper.initDynamicLinks();
    // Attach a listener to the stream

    // Subscribe to all events (initial link and further)
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.toString().isNotEmpty) {
        // Extract the ID from the path
        String id = uri.pathSegments.last;
        context.push(Routes.productDetails,
            extra: ProductDetailModel(id: int.parse(id)));
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    context.read<LanguageProvider>().updateLanguage(
          context: context,
          lang: DbHelper.getLanguage(),
        );

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
        if (!DbHelper.getIsGuest()) {
          getProfile();
        }
        return;
    }
    notifyListeners();
  }

  Future<void> getProfile() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProfileUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<UserModel> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));
    DbHelper.saveUserModel(model.body);
    notifyListeners();
  }
}
