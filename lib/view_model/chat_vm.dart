import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/sockets/socket_constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../helpers/date_helper.dart';
import '../models/message_model.dart';
import '../sockets/socket_helper.dart';

class ChatVM extends BaseViewModel {
  final Socket? _socketIO = SocketHelper().getSocket();

  final TextEditingController messageTextController = TextEditingController();

  List<InboxModel> inboxList = [];

  ///Message types 1 => Text 2=> offer
  List<MessageModel> chatItems = [];

  void sendMessage({String? message, int? type}) {
    if (message == null) {
      return;
    }

    chatItems.insert(
        0,
        MessageModel(
            message: message,
            senderId: DbHelper.getUserModel()?.id?.toInt(),
            messageType: type,
            createdAt: "${DateTime.now()}"));
    notifyListeners();
  }

  StreamController<List<InboxModel>> inboxStreamController =
      StreamController<List<InboxModel>>();

  @override
  void onInit() {
    // TODO: implement onInit
    getInboxList();
    super.onInit();
  }

  void getInboxList() {
    _socketIO?.off(SocketConstants.getUserLists);
    _socketIO?.on(SocketConstants.getUserLists, (data) {
      log("Users List: $data");
      inboxList.clear();

      InboxDataModel model = InboxDataModel.fromJson(data);

      if (data.isNotEmpty) {
        for (var item in model.list ?? []) {
          inboxList.add(item);
        }
        /* inboxList.sort((a, b) {
          return a.updatedAt != null && b.updatedAt != null
              ? b.updatedAt!.compareTo(a.updatedAt!)
              : 1;
        });*/
      }

      /// UI Update
      print("UI updated");
      inboxStreamController.add(inboxList);
      // notifyListeners();
    });
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "limit": 10000,
      "page": 1
    };

    log("Get Users Resq: $map");
    _socketIO?.emit(SocketConstants.getUserLists, map);
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    print("Timestamp: $timestamp");
    return DateHelper.getChatTime(timestamp);
  }
}
