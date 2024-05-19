import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';

import '../models/setting_item_model.dart';

class NotificationVM extends BaseViewModel {
  List<SettingItemModel> notificationList = [
    SettingItemModel(
        icon: AssetsRes.DUMMY_CHAT_IMAGE1,
        title: 'Kim Shine',
        timeStamp: 'August 13, 2024',
        description:
            "I loved this dress so much as soon as I tried it on I knew I had to buy it in another color. I am 5'3 about."),
    SettingItemModel(
        icon: AssetsRes.DUMMY_CHAT_IMAGE3,
        title: 'Jack Deo',
        timeStamp: 'August 13, 2024',
        description:
            "I loved this dress so much as soon as I tried it on I knew I had to buy it in another color. I am 5'3 about."),
    SettingItemModel(
        icon: AssetsRes.DUMMY_CHAT_IMAGE2,
        title: 'John Smith',
        timeStamp: 'August 13, 2024',
        description:
            "I loved this dress so much as soon as I tried it on I knew I had to buy it in another color. I am 5'3 about."),
    SettingItemModel(
        icon: AssetsRes.DUMMY_CHAT_IMAGE4,
        title: 'Jack Deo',
        timeStamp: 'August 13, 2024',
        description:
            "I loved this dress so much as soon as I tried it on I knew I had to buy it in another color. I am 5'3 about."),
  ];
}
