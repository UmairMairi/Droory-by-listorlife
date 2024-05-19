import 'package:flutter/cupertino.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';

class ChatVM extends BaseViewModel {
  List<SettingItemModel> inboxItems = [
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

  List<MessageModel> chatItems = [
    MessageModel(message: 'Ok!', isSender: false, timeStamp: 1716099522),
    MessageModel(message: 'I am Fine.', isSender: false, timeStamp: 1716099522),
    MessageModel(message: 'Oh! Cool', isSender: true, timeStamp: 1716099720),
    MessageModel(
        message: 'Hi, son, how are you doing?',
        isSender: true,
        timeStamp: 1716099720),
  ];

  void sendMessage(String? message) {
    if (message == null) {
      return;
    }

    chatItems.insert(
        0,
        MessageModel(
            message: message,
            isSender: true,
            timeStamp: DateTime.now().millisecondsSinceEpoch));
    notifyListeners();
  }

  final TextEditingController _messageTextController = TextEditingController();
  TextEditingController get messageTextController => _messageTextController;
}

class MessageModel {
  final String? message;
  final bool? isSender;

  final int? timeStamp;
  MessageModel(
      {required this.message, required this.isSender, required this.timeStamp});
}
