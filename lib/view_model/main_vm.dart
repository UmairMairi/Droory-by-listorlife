import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/providers/language_provider.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/view_model/my_ads_v_m.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';
import 'package:provider/provider.dart';

import '../base/helpers/db_helper.dart';
import '../base/notification/notification_entity.dart';
import '../base/notification/notification_service.dart';
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


  bool _isGuest = DbHelper.getIsGuest();

  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  num _countMessage = 0;

  num get countMessage => _countMessage;

  set countMessage(num value) {
    _countMessage = value;
    notifyListeners();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        NotificationService().pushNextScreenFromForeground(
            NotificationEntity.fromJson(initialMessage.data));
      }
    });

    context.read<LanguageProvider>().updateLanguage(
          context: context,
          lang: DbHelper.getLanguage(),
        );
    DbHelper.box.listenKey('isGuest', (value) {
      isGuest = DbHelper.getIsGuest();
    });
    if (!isGuest) {
      SocketHelper().connectUser();
      getChatNotifyCount();
    }

    initUniLinks();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    // if (!isGuest)  {
    //   var model = context.read<ChatVM>();
    //   model.initListeners();
    // }
    super.onReady();
  }

  void onIndexSelected({required int index,required BuildContext context}) {
    switch (index) {
      case 0:
        context.read<HomeVM>().callApiMethods();
        context.read<HomeVM>().onRefresh();
        return;
      case 1:
        if (DbHelper.getIsGuest()) {
          context.push(Routes.guestLogin);
          navController.jumpToTab(0);
        } else {
          //context.read<ChatVM>().getInboxList();
          getChatNotifyCount();
        }
      case 2:
      case 3:
        if (DbHelper.getIsGuest()) {
          context.push(Routes.guestLogin);
          navController.jumpToTab(0);
        } else {
          context.read<MyAdsVM>().onRefresh();
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


  Future<void> getChatNotifyCount() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getChatNotifyCount(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel?> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));
    if(model.body != null){
      countMessage = model.body?.count_message??0;
      notifyListeners();
    }
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
