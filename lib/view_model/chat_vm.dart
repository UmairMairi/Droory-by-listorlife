import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/chat_bubble/bubble_normal_image.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/debouncer_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/sockets/socket_constants.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../chat_bubble/bubble_normal_message.dart';
import '../chat_bubble/bubble_offer_message.dart';
import '../base/helpers/date_helper.dart';
import '../models/message_model.dart';
import '../res/font_res.dart';
import '../base/sockets/socket_helper.dart';

class ChatVM extends BaseViewModel {
  final Socket _socketIO = SocketHelper().getSocket();

  final TextEditingController inboxSearchTextController =
      TextEditingController();
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController reportTextController = TextEditingController();

  List<InboxModel> inboxList = [];
  List<InboxModel> filteredInboxList = [];

  bool blockedUser = false;
  int blockByMe = 0;
  int blockByOther = 0;
  int blockByBoth = 0;
  String blockText = "";

  ///Message types 1 => Text 2=> offer

  StreamController<List<InboxModel>> inboxStreamController =
      StreamController<List<InboxModel>>.broadcast();
  StreamController<List<MessageModel>> messageStreamController =
      StreamController<List<MessageModel>>.broadcast();

  List<MessageModel> chatItems = [];
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);

  @override
  void onInit() {
    getInboxList();
    initListeners();

    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    //getInboxList();
    //initListeners();
    // TODO: implement onReady
    super.onReady();
  }

  void initListeners() {
    if (SocketHelper().isUserConnected == false) {
      SocketHelper().connectUser();
    }
    getInboxListener();
    getMessageListener();
    offerListener();
    sendMessageListener();
    blockReportListener();
    readChatListener();
    updateChatScreenIdListener();
    clearChatListener();
  }

  getInboxListener() {
    _socketIO.on(SocketConstants.getUserLists, (data) {
      log("Listen ${SocketConstants.getUserLists} => data $data");
      inboxList.clear();

      InboxDataModel model = InboxDataModel.fromJson(data);

      if (data.isNotEmpty) {
        for (var item in model.list ?? []) {
          inboxList.add(item);
        }
      }
      filteredInboxList = inboxList;
      inboxStreamController.add(filteredInboxList);
    });
  }

  getMessageListener() {
    _socketIO.on(SocketConstants.getMessageList, (data) {
      log("Listen ${SocketConstants.getMessageList} => getMessageList $data");

      MessageDataModel model = MessageDataModel.fromJson(data);
      chatItems.clear();
      for (var element in model.list ?? []) {
        chatItems.add(element);
      }
      //if(chatItems.isNotEmpty){
      //   var message = chatItems.first;
      //   var receiverId = message.senderId == DbHelper.getUserModel()?.id
      //       ? message.receiverId
      //       : message.senderId;
      //   var roomId = message.roomId;
      //   updateChatScreenId(
      //     //receiverId: receiverId,
      //     roomId: roomId
      //   );
      // }
      messageStreamController.sink.add(chatItems);

      blockedUser =
          model.checkBlock?.blockByMe != 0 || model.checkBlock?.blockMe != 0;

      if (model.checkBlock?.blockByMe != 0 && model.checkBlock?.blockMe != 0) {
        blockedUser = true;
        blockByMe = 0;
        blockByOther = 0;
        blockByBoth = 1;
        blockText = "Both you and this user have blocked each other";
      } else if (model.checkBlock?.blockByMe != 0) {
        blockedUser = true;
        blockByMe = 1;
        blockByOther = 0;
        blockText = "This user is blocked by you";
      } else if (model.checkBlock?.blockMe != 0) {
        blockedUser = true;
        blockByMe = 0;
        blockByOther = 1;
        blockText = "This user has blocked you";
      } else {
        blockedUser = false;
      }
      notifyListeners();
    });
  }

  offerListener() {
    _socketIO.on(SocketConstants.offerUpdate, (data) {
      log("Listen ${SocketConstants.offerUpdate} => data $data");

      getMessageList(
        productId: data['product_id'],
        receiverId: data['receiver_id'],
      );
    });
  }

  sendMessageListener() {
    _socketIO.on(SocketConstants.sendMessage, (data) {
      log("Listen ${SocketConstants.sendMessage} => data $data");

      /// getInboxList();
      MessageModel message = MessageModel.fromJson(data);

      if (message.senderId != DbHelper.getUserModel()?.id) {
        chatItems.insert(0, message);
        messageStreamController.add(chatItems);
      }
    });
  }

  blockReportListener() {
    _socketIO.on(SocketConstants.blockOrReportUser, (data) {
      log("Listen ${SocketConstants.blockOrReportUser} => data $data");

      if (data['type'] == 'report') {
        DialogHelper.showToast(message: "Your report submitted successfully");
      }
      if (data['type'] == 'block') {
        var productId = data['product_id'];
        var blockBy = data['block_by'];
        var blockTo = data['block_to'];
        var receiverId = "$blockTo" == "${DbHelper.getUserModel()?.id}"?blockBy:blockTo;
        getMessageList(
          productId: productId,
          receiverId: receiverId,
        );
        //DialogHelper.showToast(message: "Settings updated successfully.");
      }

      /* if (data['type'] == 'block') {
        DialogHelper.showToast(message: "You blocked this user successfully");
      }


      if (data['type'] == 'unblock') {
        DialogHelper.showToast(message: "You unblocked this user successfully");
      }
*/
      notifyListeners();
      //DialogHelper.showToast(message: "You blocked this user successfully");
    });
  }

  readChatListener() {
    _socketIO.on(SocketConstants.readChatStatus, (data) {
      try {
        log("Listen ${SocketConstants.readChatStatus} => readChatStatus data $data");

        if (data != null) {
          var senderId = data["sender_id"];
          var receiverId = data["receiver_id"];
          var roomId = data["room_id"];
          var read = data["read"];

          for (var element in chatItems) {
            element.isRead = 1;
          }
          messageStreamController.sink.add(chatItems);
        }
      } catch (e) {
        log("Error in readChatListener: $e");
      }
      notifyListeners();
    });
  }

  updateChatScreenIdListener() {
    _socketIO.on(SocketConstants.updateChatScreenId, (data) {
      log("Listen ${SocketConstants.updateChatScreenId} => $data");
    });
  }

  clearChatListener() {
    _socketIO.on(SocketConstants.clearChat, (data) {
      log("Listen ${SocketConstants.clearChat} => data $data");
      //{sender_id: 64, receiver_id: 88, product_id: 107}
      getMessageList(
        productId: data['product_id'],
        receiverId: data['receiver_id'],
      );
      //Navigator.pop(context);
      getInboxList();
      notifyListeners();
    });
  }

  void getInboxList() {
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "limit": 10000,
      "page": 1
    };
    log("Socket Emit => ${SocketConstants.getUserLists} with $map",
        name: "SOCKET");
    _socketIO.emit(SocketConstants.getUserLists, map);
  }

  void getMessageList({dynamic receiverId, dynamic productId}) {
    blockedUser = false;
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "receiver_id": "$receiverId",
      "product_id": "$productId",
      "limit": 10000,
      "page": 1
    };
    log("Socket Emit => ${SocketConstants.getMessageList} with $map",
        name: "SOCKET");
    _socketIO.emit(SocketConstants.getMessageList, map);
  }

  void updateOfferStatus(
      {required num? messageId,
      required num? messageType,
      required num? productId,
      required num? receiverId}) {
    Map<String, dynamic> map = {
      'message_id': messageId,
      'message_type': messageType,
      'receiver_id': receiverId,
      'product_id': productId,
      'sender_id': DbHelper.getUserModel()?.id,
    };
    log("Socket Emit => ${SocketConstants.offerUpdate} with $map",
        name: "SOCKET");
    _socketIO.emit(SocketConstants.offerUpdate, map);
  }

  void sendMessage(
      {String? message,
      int? type,
      required num? receiverId,
      required num? productId}) {
    if (message == null) {
      return;
    }

    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "receiver_id": receiverId,
      "product_id": productId,
      "message": message,
      "message_type": type
    };
    log("Socket Emit => ${SocketConstants.sendMessage} with $map",
        name: "SOCKET");
    _socketIO.emit(SocketConstants.sendMessage, map);

    chatItems.insert(
      0,
      MessageModel(
          message: message,
          senderId: DbHelper.getUserModel()?.id?.toInt(),
          receiverId: receiverId?.toInt(),
          messageType: type,
          createdAt: "${DateTime.now()}",
          updatedAt: "${DateTime.now()}"),
    );
    messageStreamController.add(chatItems);

    DialogHelper.hideLoading();
  }

  void readChatStatus({required dynamic roomId, required dynamic receiverId}) {
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "receiver_id": receiverId,
      "room_id": roomId,
    };
    _socketIO.emit(SocketConstants.readChatStatus, map);
    debugPrint("readChat emit ===> $map");
  }
  void updateChatScreenId({dynamic roomId}) {
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "room_id": roomId,
    };
    _socketIO.emit(SocketConstants.updateChatScreenId, map);
    debugPrint("updateChatScreenId $map");
  }

  void reportBlockUser(
      {String? reason, required String? userId,dynamic productId, bool report = false}) {
    if (report) {
      if (reason?.isEmpty ?? false) {
        return;
      }
    }
    Map<String, dynamic> map = {
      "block_by": DbHelper.getUserModel()?.id,
      "block_to": userId,
      "type": report ? "report" : "block",
      "reason": reason ?? ''
    };
    if(!report){
      map.addAll({
        "product_id": productId,
      });
    }
    log("Socket Emit => ${SocketConstants.blockOrReportUser} with $map",
        name: "SOCKET");
    _socketIO.emit(SocketConstants.blockOrReportUser, map);
  }

  void clearChat({num? reciver, num? sender, required num? product}) {
    Map<String, dynamic> map = {
      "sender_id": sender,
      "receiver_id": reciver,
      "product_id": product
    };
    log("Socket Emit => ${SocketConstants.clearChat} with $map",
        name: "SOCKET");

    _socketIO.emit(SocketConstants.clearChat, map);
  }

  void searchInbox(String query) {
    _debounce.run(() {
      if (query.isEmpty) {
        filteredInboxList = inboxList;
      } else {
        filteredInboxList = inboxList.where((inbox) {
          String senderName = inbox.senderDetail?.name?.toLowerCase() ?? '';
          String receiverName = inbox.receiverDetail?.name?.toLowerCase() ?? '';
          String productName = inbox.productDetail?.name?.toLowerCase() ?? '';
          String lastMessage =
              inbox.lastMessageDetail?.message?.toLowerCase() ?? '';
          return senderName.contains(query.toLowerCase()) ||
              receiverName.contains(query.toLowerCase()) ||
              productName.contains(query.toLowerCase()) ||
              lastMessage.contains(query.toLowerCase());
        }).toList();
      }
      inboxStreamController.add(filteredInboxList);
    });
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

    return DateHelper.getTimeAgo(timestamp);
  }

  Widget getBubble(
      {int? type, required MessageModel data, required InboxModel? chat, required BuildContext context}) {
    switch (type) {
      case 1:
        return BubbleNormalMessage(
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          timeStamp: true,
          sent: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          delivered: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          seen: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 1
              : false,
          createdAt: DateHelper.getTimeAgo(
              DateTime.parse(data.updatedAt ?? '2021-01-01 00:00:00')
                  .millisecondsSinceEpoch),
          text: data.message ?? '',
          isSender: data.senderId == DbHelper.getUserModel()?.id,
          color: data.senderId == DbHelper.getUserModel()?.id
              ? Colors.black
              : context.theme.colorScheme.error,
        );
      case 2:
        return BubbleOfferMessage(
          textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: FontRes.MONTSERRAT_SEMIBOLD),
          sent: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          delivered: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          seen: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 1
              : false,
          onAccept: () {
            updateOfferStatus(
              messageId: data.id,
              messageType: 5,
              productId: chat?.productId,
              receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                  ? chat?.receiverDetail?.id
                  : chat?.senderDetail?.id,
            );
            sendMessage(
                type: 1,
                receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                    ? chat?.receiverDetail?.id
                    : chat?.senderDetail?.id,
                productId: chat?.productId,
                message:
                    "I am pleased to accept your offer of EGP ${data.message}. Let's close this deal fast");
          },
          onReject: () {
            updateOfferStatus(
              messageId: data.id,
              messageType: 6,
              productId: chat?.productId,
              receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                  ? chat?.receiverDetail?.id
                  : chat?.senderDetail?.id,
            );
            sendMessage(
                type: 1,
                receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                    ? chat?.receiverDetail?.id
                    : chat?.senderDetail?.id,
                productId: chat?.productId,
                message:
                    "Thank you for your offer of EGP ${data.message}  was hoping for a slightly higher amount. Would you be willing to increase your offer, so, I would be happy to close the deal promptly");
          },
          timeStamp: true,
          createdAt: DateHelper.getTimeAgo(
              DateTime.parse(data.updatedAt ?? '2021-01-01 00:00:00')
                  .millisecondsSinceEpoch),
          text: data.message ?? '',
          isSender: data.senderId == DbHelper.getUserModel()?.id,
          color: data.senderId == DbHelper.getUserModel()?.id
              ? Colors.black
              : context.theme.colorScheme.error,
        );
      case 3:
        return BubbleNormalImage(
            sent: data.senderId == DbHelper.getUserModel()?.id
                ? data.isRead == 0
                : false,
            delivered: data.senderId == DbHelper.getUserModel()?.id
                ? data.isRead == 0
                : false,
            seen: data.senderId == DbHelper.getUserModel()?.id
                ? data.isRead == 1
                : false,
            id: "${data.id}",
            imageUrl: "${ApiConstants.imageUrl}/${data.message}",
            timeStamp: true,
            createdAt: DateHelper.getTimeAgo(
                DateTime.parse(data.updatedAt ?? '2021-01-01 00:00:00')
                    .millisecondsSinceEpoch),
            isSender: data.senderId == DbHelper.getUserModel()?.id,
            image: ImageView.rect(
                image: "${ApiConstants.imageUrl}/${data.message}",
                width: 120,
                height: 150));
      case 5:
        return BubbleOfferAcceptedMessage(
          sent: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          delivered: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          seen: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 1
              : false,
          textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: FontRes.MONTSERRAT_SEMIBOLD),
          timeStamp: true,
          createdAt: DateHelper.getTimeAgo(
              DateTime.parse(data.updatedAt ?? '2021-01-01 00:00:00')
                  .millisecondsSinceEpoch),
          text: data.message ?? '',
          isSender: data.senderId == DbHelper.getUserModel()?.id,
          color: data.senderId == DbHelper.getUserModel()?.id
              ? Colors.black
              : context.theme.colorScheme.error,
        );

      case 6:
        return BubbleOfferAcceptedMessage(
          sent: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          delivered: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 0
              : false,
          seen: data.senderId == DbHelper.getUserModel()?.id
              ? data.isRead == 1
              : false,
          isAccepted: false,
          textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: FontRes.MONTSERRAT_SEMIBOLD),
          timeStamp: true,
          createdAt: DateHelper.getTimeAgo(
              DateTime.parse(data.updatedAt ?? '2021-01-01 00:00:00')
                  .millisecondsSinceEpoch),
          text: data.message ?? '',
          isSender: data.senderId == DbHelper.getUserModel()?.id,
          color: data.senderId == DbHelper.getUserModel()?.id
              ? Colors.black
              : context.theme.colorScheme.error,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  getLastMessage({MessageModel? message}) {
    if(message?.isDeleted != null){
      return "Start Chat";
    }
    switch (message?.messageType) {
      case 2:
        return '🎁EGP ${message?.message}';
      case 3:
        return '🌄Image';
      default:
        return '${message?.message}';
    }
  }
}
