import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';

class ChatVM extends BaseViewModel {
  List<SettingItemModel> chatItems = [
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE1,
      title: 'Stells Stefword',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE2,
      title: 'John Marker',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE3,
      title: 'Jolly Deo',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE4,
      title: 'Hick G',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE5,
      title: 'Jack Dick',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE6,
      title: 'Micky Geo',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
    SettingItemModel(
      icon: AssetsRes.DUMMY_CHAT_IMAGE3,
      title: 'Jolly Deo',
      subTitle: 'Lorem Ipsum is simply dummy text.',
      timeStamp: '1 min ago',
    ),
  ];
}
