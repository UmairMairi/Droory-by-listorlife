import 'dart:async';
import 'dart:developer'; // Added for log()
import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/chat_bubble/bubble_multi_image.dart';
import 'package:list_and_life/chat_bubble/bubble_normal_image.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/debouncer_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/sockets/socket_constants.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../chat_bubble/bubble_normal_message.dart';
import '../chat_bubble/bubble_offer_message.dart';
import '../base/helpers/date_helper.dart';
import '../models/message_model.dart';
import '../res/font_res.dart';
import '../base/sockets/socket_helper.dart';

class ChatVM extends BaseViewModel {
  late Socket _socketIO;
  Timer? _inboxDebounceTimer;

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
  final StreamController<List<MessageModel>> messageStreamController =
      StreamController.broadcast();

  List<MessageModel> chatItems = [];
  final DebounceHelper _debounce = DebounceHelper(milliseconds: 500);
  num _currentProductId = 0;
  num get currentProductId => _currentProductId;
  set currentProductId(num index) {
    _currentProductId = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _inboxDebounceTimer?.cancel();
    inboxSearchTextController.dispose();
    messageTextController.dispose();
    reportTextController.dispose();
    inboxStreamController.close();
    messageStreamController.close();
    super.dispose();
  }

  void initListeners() {
    _socketIO = SocketHelper().getSocket();
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
    deleteInboxEntryListener(); // Added delete inbox entry listener
  }

  getInboxListener() {
    _socketIO.off(SocketConstants.getUserLists);
    _socketIO.on(SocketConstants.getUserLists, (data) {
      // Check if this is a force refresh signal
      if (data is Map && data['forceRefresh'] == true) {
        log("Force refresh signal received after deletion, ignoring to preserve local state",
            name: "ChatVM");
        return; // Don't fetch inbox list after deletion
      }

      inboxList.clear();

      InboxDataModel model = InboxDataModel.fromJson(data);

      if (model.list != null && model.list!.isNotEmpty) {
        for (var item in model.list!) {
          inboxList.add(item);
        }
      }

      filteredInboxList = inboxList;
      inboxStreamController.add(filteredInboxList);

      log("Inbox updated: ${inboxList.length} items", name: "ChatVM");
    });
  }

  getMessageListener() {
    _socketIO.off(SocketConstants.getMessageList);
    _socketIO.on(SocketConstants.getMessageList, (data) {
      log("Listen ${SocketConstants.getMessageList} => getMessageList $data",
          name: "ChatVM");

      MessageDataModel model = MessageDataModel.fromJson(data);
      chatItems.clear();
      for (var element in model.list ?? []) {
        chatItems.add(element);
      }
      messageStreamController.sink.add(chatItems);

      blockedUser =
          model.checkBlock?.blockByMe != 0 || model.checkBlock?.blockMe != 0;

      if (model.checkBlock?.blockByMe != 0 && model.checkBlock?.blockMe != 0) {
        blockedUser = true;
        blockByMe = 0;
        blockByOther = 0;
        blockByBoth = 1;
        blockText = StringHelper.bothUsersBlockedEachOther;
      } else if (model.checkBlock?.blockByMe != 0) {
        blockedUser = true;
        blockByMe = 1;
        blockByOther = 0;
        blockText = StringHelper.thisUserIsBlockedByYou;
      } else if (model.checkBlock?.blockMe != 0) {
        blockedUser = true;
        blockByMe = 0;
        blockByOther = 1;
        blockText = StringHelper.thisUserHasBlockedYou;
      } else {
        blockedUser = false;
      }
      notifyListeners();
    });
  }

  offerListener() {
    _socketIO.off(SocketConstants.offerUpdate);
    _socketIO.on(SocketConstants.offerUpdate, (data) {
      log("Listen ${SocketConstants.offerUpdate} => data $data",
          name: "ChatVM");
      getMessageList(
        productId: data['product_id'],
        receiverId: data['receiver_id'],
      );
    });
    notifyListeners();
  }

  sendMessageListener() {
    _socketIO.off(SocketConstants.sendMessage);
    _socketIO.on(SocketConstants.sendMessage, (data) {
      log("Listen ${SocketConstants.sendMessage} => data $data",
          name: "ChatVM");
      MessageModel message = MessageModel.fromJson(data);

      if (message.senderId != DbHelper.getUserModel()?.id &&
          message.productId == currentProductId) {
        chatItems.insert(0, message);
        messageStreamController.sink.add(chatItems);
        notifyListeners();
      }
      if (message.productId == currentProductId) {
        readChatStatus(
            receiverId: message.senderId == DbHelper.getUserModel()?.id
                ? message.receiverId
                : message.senderId,
            senderId: message.senderId == DbHelper.getUserModel()?.id
                ? message.senderId
                : message.receiverId,
            roomId: message.roomId);
        updateChatScreenId(roomId: message.roomId);
      }
      getInboxList();
    });
  }

  blockReportListener() {
    _socketIO.off(SocketConstants.blockOrReportUser);
    _socketIO.on(SocketConstants.blockOrReportUser, (data) {
      log("Listen ${SocketConstants.blockOrReportUser} => data $data",
          name: "ChatVM");
      if (data['type'] == 'report') {
        DialogHelper.showToast(message: "Your report submitted successfully");
      }
      if (data['type'] == 'block') {
        var productId = data['product_id'];
        var blockBy = data['block_by'];
        var blockTo = data['block_to'];
        var receiverId =
            "$blockTo" == "${DbHelper.getUserModel()?.id}" ? blockBy : blockTo;
        getMessageList(
          productId: productId,
          receiverId: receiverId,
        );
      }
      notifyListeners();
    });
  }

  readChatListener() {
    _socketIO.off(SocketConstants.readChatStatus);
    _socketIO.on(SocketConstants.readChatStatus, (data) {
      print("📨 READ STATUS RESPONSE FROM SERVER: $data");
      if (data != null) {
        for (var element in chatItems) {
          if (element.senderId != DbHelper.getUserModel()?.id) {
            element.isRead = 1;
          }
        }
        messageStreamController.sink.add(chatItems);
      }
      notifyListeners();
    });
  }

  updateChatScreenIdListener() {
    _socketIO.off(SocketConstants.updateChatScreenId);
    _socketIO.on(SocketConstants.updateChatScreenId, (data) {
      log("Listen ${SocketConstants.updateChatScreenId} => $data",
          name: "ChatVM");
      getInboxList();
      notifyListeners();
    });
  }

  clearChatListener() {
    _socketIO.off(SocketConstants.clearChat);
    _socketIO.on(SocketConstants.clearChat, (data) {
      log("Listen ${SocketConstants.clearChat} => data $data", name: "ChatVM");
      getMessageList(
        productId: data['product_id'],
        receiverId: data['receiver_id'],
      );
      getInboxList();
      notifyListeners();
    });
  }

  // New listener for delete inbox entry
  void deleteInboxEntryListener() {
    _socketIO.off('deleteInboxEntry');
    _socketIO.on('deleteInboxEntry', (data) {
      print("===== DELETE RESPONSE FROM SERVER =====");
      print("Response data: $data");
      print("Success: ${data['success']}");

      if (data['success'] == true) {
        // Remove from local lists immediately
        final productId = data['product_id'];
        final senderId = data['sender_id'];
        final receiverId = data['receiver_id'];

        print("Removing from local lists - ProductId: $productId");

        // Remove from main inbox list
        inboxList.removeWhere((inbox) {
          bool shouldRemove = inbox.productId == productId &&
              ((inbox.senderId == senderId && inbox.receiverId == receiverId) ||
                  (inbox.senderId == receiverId &&
                      inbox.receiverId == senderId));
          if (shouldRemove) {
            print("Removed from inboxList - ProductId: ${inbox.productId}");
          }
          return shouldRemove;
        });

        // Remove from filtered list
        filteredInboxList.removeWhere((inbox) {
          bool shouldRemove = inbox.productId == productId &&
              ((inbox.senderId == senderId && inbox.receiverId == receiverId) ||
                  (inbox.senderId == receiverId &&
                      inbox.receiverId == senderId));
          if (shouldRemove) {
            print(
                "Removed from filteredInboxList - ProductId: ${inbox.productId}");
          }
          return shouldRemove;
        });

        // Update the stream immediately
        inboxStreamController.add(List.from(filteredInboxList));
        notifyListeners();
        print("Local lists updated successfully");
      }

      if (data['error'] != null) {
        print("ERROR: ${data['error']}");
      }
    });
  }

  // Method to delete inbox entry (complete removal)
  void deleteInboxEntry({
    required num? receiverId,
    required num? productId,
  }) {
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "receiver_id": receiverId,
      "product_id": productId,
    };

    print("===== SENDING DELETE TO SERVER =====");
    print("Delete data: $map");

    _socketIO.emit('delete_inbox_entry',
        map); // Changed from 'deleteInboxEntry' to 'delete_inbox_entry'
  }

  // Method to delete multiple chats
  void deleteChats(List<InboxModel> chatsToDelete) {
    print("===== DELETE CHATS CALLED =====");
    print("Number of chats to delete: ${chatsToDelete.length}");

    // Store the chats we're about to delete for immediate local removal
    List<Map<String, dynamic>> deletingChats = [];

    for (var chat in chatsToDelete) {
      print(
          "Deleting chat - ProductId: ${chat.productId}, SenderId: ${chat.senderId}, ReceiverId: ${chat.receiverId}");

      final receiverId = chat.senderId == DbHelper.getUserModel()?.id
          ? chat.receiverDetail?.id
          : chat.senderDetail?.id;

      // Store deletion info
      deletingChats.add({
        'product_id': chat.productId,
        'sender_id': DbHelper.getUserModel()?.id,
        'receiver_id': receiverId,
      });

      // Send delete request to server
      deleteInboxEntry(
        receiverId: receiverId,
        productId: chat.productId,
      );
    }

    // Immediately remove from local lists for instant UI feedback
    for (var deleteInfo in deletingChats) {
      final productId = deleteInfo['product_id'];
      final senderId = deleteInfo['sender_id'];
      final receiverId = deleteInfo['receiver_id'];

      print("Immediately removing from local lists - ProductId: $productId");

      // Remove from main inbox list
      inboxList.removeWhere((inbox) {
        bool shouldRemove = inbox.productId == productId &&
            ((inbox.senderId == senderId && inbox.receiverId == receiverId) ||
                (inbox.senderId == receiverId && inbox.receiverId == senderId));
        if (shouldRemove) {
          print(
              "Immediately removed from inboxList - ProductId: ${inbox.productId}");
        }
        return shouldRemove;
      });

      // Remove from filtered list
      filteredInboxList.removeWhere((inbox) {
        bool shouldRemove = inbox.productId == productId &&
            ((inbox.senderId == senderId && inbox.receiverId == receiverId) ||
                (inbox.senderId == receiverId && inbox.receiverId == senderId));
        if (shouldRemove) {
          print(
              "Immediately removed from filteredInboxList - ProductId: ${inbox.productId}");
        }
        return shouldRemove;
      });
    }

    // Update the stream immediately for instant UI update
    inboxStreamController.add(List.from(filteredInboxList));
    notifyListeners();
    print("Local lists updated immediately for instant UI feedback");
  }

  // Method to mark chats as read
  void markChatsAsRead(List<InboxModel> chatsToMark) {
    for (var chat in chatsToMark) {
      // Reset unread count locally
      chat.unread_count = 0;

      // Find and update in main list
      for (var inbox in inboxList) {
        if (inbox.productId == chat.productId &&
            ((inbox.senderId == chat.senderId &&
                    inbox.receiverId == chat.receiverId) ||
                (inbox.senderId == chat.receiverId &&
                    inbox.receiverId == chat.senderId))) {
          inbox.unread_count = 0;
        }
      }

      // Send read status to server
      readChatStatus(
        receiverId: chat.senderId == DbHelper.getUserModel()?.id
            ? chat.receiverDetail?.id
            : chat.senderDetail?.id,
        senderId: DbHelper.getUserModel()?.id,
        roomId: chat.lastMessageDetail?.roomId ?? 0,
      );
    }

    // Update the stream
    inboxStreamController.add(filteredInboxList);
    notifyListeners();
  }

  void getInboxList() {
    // Cancel previous timer if exists
    _inboxDebounceTimer?.cancel();

    // Add small delay to prevent multiple calls
    _inboxDebounceTimer = Timer(Duration(milliseconds: 300), () {
      Map<String, dynamic> map = {
        "sender_id": DbHelper.getUserModel()?.id,
        "limit": 10000,
        "page": 1
      };
      print("📤 Requesting inbox list");
      _socketIO.emit(SocketConstants.getUserLists, map);
    });
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

  void resetUnreadCount({required num? productId, required num? otherUserId}) {
    print("🔄 RESETTING UNREAD COUNT for productId: $productId");

    // Reset in main list
    for (int i = 0; i < inboxList.length; i++) {
      var inbox = inboxList[i];
      if (inbox.productId == productId) {
        print(
            "✅ FOUND inbox item - Current unread_count: ${inbox.unread_count}");
        inbox.unread_count = 0;
        print("✅ RESET unread_count to: ${inbox.unread_count}");
      }
    }

    // Reset in filtered list
    for (int i = 0; i < filteredInboxList.length; i++) {
      var inbox = filteredInboxList[i];
      if (inbox.productId == productId) {
        print("✅ RESET filtered list unread_count for productId: $productId");
        inbox.unread_count = 0;
      }
    }

    // Force update
    inboxStreamController.add(List.from(filteredInboxList));
    notifyListeners();
    print("✅ STREAM UPDATED and notifyListeners called");
  }

  final ScrollController scrollController = ScrollController();
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

    // Add the message locally with isRead = 0 (unread)
    chatItems.insert(
      0,
      MessageModel(
          message: message,
          senderId: DbHelper.getUserModel()?.id?.toInt(),
          receiverId: receiverId?.toInt(),
          messageType: type,
          productId: productId,
          isRead: 0, // 0 = unread, 1 = read
          createdAt: "${DateTime.now()}",
          updatedAt: "${DateTime.now()}"),
    );
    messageStreamController.sink.add(chatItems);
    DialogHelper.hideLoading();
    notifyListeners();


    scrollController.jumpTo(
      scrollController.position.maxScrollExtent,
    );
  }

  void readChatStatus(
      {required dynamic roomId,
      required dynamic receiverId,
      required dynamic senderId}) {
    print("📤 SENDING READ STATUS:");
    print("   roomId: $roomId");
    print("   receiverId: $receiverId");
    print("   senderId: $senderId");
    print("   currentUser: ${DbHelper.getUserModel()?.id}");

    Map<String, dynamic> map = {
      "sender_id": senderId,
      "receiver_id": receiverId,
      "room_id": roomId,
    };
    _socketIO.emit(SocketConstants.readChatStatus, map);
    print("✅ READ STATUS SENT");
  }

  void updateChatScreenId({required dynamic roomId}) {
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "room_id": roomId,
    };
    _socketIO.emit(SocketConstants.updateChatScreenId, map);
    getInboxList();
    log("updateChatScreenId $map", name: "SOCKET");
  }

  void reportBlockUser(
      {String? reason,
      required String? userId,
      dynamic productId,
      bool report = false}) {
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
    if (!report) {
      map.addAll({
        "product_id": productId,
      });
    }
    log("Socket Emit => ${SocketConstants.blockOrReportUser} with $map",
        name: "SOCKET");
    reportTextController.clear();
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
    final searchTerm = query.toLowerCase();
    _debounce.run(() {
      if (searchTerm.isEmpty) {
        filteredInboxList = inboxList;
      } else {
        filteredInboxList = inboxList.where((inbox) {
          return [
            inbox.senderDetail?.name?.toLowerCase(),
            inbox.receiverDetail?.name?.toLowerCase(),
            inbox.productDetail?.name?.toLowerCase(),
            inbox.lastMessageDetail?.message?.toLowerCase()
          ].any((field) => field?.contains(searchTerm) ?? false);
        }).toList();
      }
      inboxStreamController.sink.add(filteredInboxList);
    });
    notifyListeners();
  }

  // --- PLACEHOLDER LOGIC ---
  int? _normalizedCategoryId(dynamic raw) {
    log("[ChatVM DEBUG] _normalizedCategoryId - Input: $raw, Type: ${raw.runtimeType}",
        name: "ChatVM");

    if (raw == null) {
      log("[ChatVM DEBUG] _normalizedCategoryId - Input is null, returning null",
          name: "ChatVM");
      return null;
    }

    if (raw is int) {
      log("[ChatVM DEBUG] _normalizedCategoryId - Input is already int: $raw",
          name: "ChatVM");
      return raw;
    }

    if (raw is String) {
      if (raw.isEmpty) {
        log("[ChatVM DEBUG] _normalizedCategoryId - Input is empty string, returning null",
            name: "ChatVM");
        return null;
      }
      final parsed = int.tryParse(raw);
      log("[ChatVM DEBUG] _normalizedCategoryId - Parsed from String '$raw' to: $parsed",
          name: "ChatVM");
      return parsed;
    }

    if (raw is num) {
      final intValue = raw.toInt();
      log("[ChatVM DEBUG] _normalizedCategoryId - Converted from num $raw to: $intValue",
          name: "ChatVM");
      return intValue;
    }

    try {
      final stringValue = raw.toString();
      if (stringValue == 'null' || stringValue.isEmpty) {
        log("[ChatVM DEBUG] _normalizedCategoryId - String conversion resulted in 'null' or empty, returning null",
            name: "ChatVM");
        return null;
      }
      final parsed = int.tryParse(stringValue);
      log("[ChatVM DEBUG] _normalizedCategoryId - Converted via toString: '$stringValue' -> $parsed",
          name: "ChatVM");
      return parsed;
    } catch (e) {
      log("[ChatVM DEBUG] _normalizedCategoryId - Exception during conversion: $e, returning null",
          name: "ChatVM");
      return null;
    }
  }

  String _placeholderFor(int? catId) {
    log("[ChatVM DEBUG] _placeholderFor - Input catId: $catId", name: "ChatVM");
    String result;
    switch (catId) {
      case 8: // Services
        result = AssetsRes.SERVICE_FILLER_IMAGE;
        break;
      case 9: // Jobs
        result = AssetsRes.JOB_FILLER_IMAGE;
        break;
      default:
        result = AssetsRes.APP_LOGO;
        break;
    }
    log("[ChatVM DEBUG] _placeholderFor - Returning placeholder: $result for catId: $catId",
        name: "ChatVM");
    return result;
  }

  String getPlaceholderForChat(InboxModel? chat) {
    if (chat == null) {
      log("[ChatVM DEBUG] getPlaceholderForChat - Input chat is null, returning default logo.",
          name: "ChatVM");
      return AssetsRes.APP_LOGO;
    }

    log("[ChatVM DEBUG] getPlaceholderForChat - Product: ${chat.productDetail?.name}, Raw CategoryId: ${chat.productDetail?.categoryId}, Type: ${chat.productDetail?.categoryId.runtimeType}",
        name: "ChatVM");

    final categoryId = _normalizedCategoryId(chat.productDetail?.categoryId);
    log("[ChatVM DEBUG] getPlaceholderForChat - Normalized CategoryId: $categoryId",
        name: "ChatVM");

    String placeholder = _placeholderFor(categoryId);
    log("[ChatVM DEBUG] getPlaceholderForChat - Final placeholder: $placeholder",
        name: "ChatVM");

    return placeholder;
  }

  Map<dynamic, int?> _productCategoryCache = {};

  int? getCachedCategoryId(dynamic productId) {
    return _productCategoryCache[productId];
  }

  void cacheProductCategory(dynamic productId, int? categoryId) {
    if (productId != null && categoryId != null) {
      _productCategoryCache[productId] = categoryId;
    }
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    return DateHelper.getTimeAgo(timestamp);
  }

  // Helper method to check if we should show date header
  bool shouldShowDateHeader(
      MessageModel currentMessage, MessageModel? previousMessage) {
    if (previousMessage == null) return true;

    try {
      DateTime currentDate =
          DateTime.parse(currentMessage.createdAt ?? DateTime.now().toString());
      DateTime previousDate = DateTime.parse(
          previousMessage.createdAt ?? DateTime.now().toString());

      // Check if dates are different (different days)
      return currentDate.year != previousDate.year ||
          currentDate.month != previousDate.month ||
          currentDate.day != previousDate.day;
    } catch (e) {
      return false;
    }
  }

  // Helper method to format date header with translations
  String formatDateHeader(String? dateTimeString, BuildContext context) {
    if (dateTimeString == null) return '';

    try {
      DateTime messageDate = DateTime.parse(dateTimeString);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));
      DateTime messageDay =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      // Check if we're in Arabic mode
      bool isArabic = Directionality.of(context) == TextDirection.rtl;

      if (messageDay == today) {
        return StringHelper.today;
      } else if (messageDay == yesterday) {
        return StringHelper.yesterday;
      } else {
        // Format as month name with proper translation
        List<String> monthsEn = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];

        List<String> monthsAr = [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر'
        ];

        String monthName = isArabic
            ? monthsAr[messageDate.month - 1]
            : monthsEn[messageDate.month - 1];

        return isArabic
            ? '$monthName ${messageDate.day}، ${messageDate.year}'
            : '$monthName ${messageDate.day}, ${messageDate.year}';
      }
    } catch (e) {
      return '';
    }
  }

  // Helper method to format time for bubbles with translations
  String formatBubbleTime(String? dateTimeString, BuildContext context) {
    if (dateTimeString == null) return '';

    try {
      DateTime messageTime = DateTime.parse(dateTimeString);
      bool isArabic = Directionality.of(context) == TextDirection.rtl;

      // Format as 12-hour time with AM/PM
      int hour = messageTime.hour;
      int minute = messageTime.minute;

      // Get translated AM/PM
      String period = hour >= 12 ? StringHelper.pm : StringHelper.am;

      // Convert to 12-hour format
      if (hour == 0) {
        hour = 12; // 12 AM
      } else if (hour > 12) {
        hour = hour - 12; // Convert to PM
      }

      // Format minute with leading zero if needed
      String minuteStr = minute.toString().padLeft(2, '0');

      return '$hour:$minuteStr $period';
    } catch (e) {
      return '';
    }
  }

  // Helper method to build date header widget
  Widget buildDateHeader(String? dateTimeString, BuildContext context) {
    String dateText = formatDateHeader(dateTimeString, context);
    if (dateText.isEmpty) return SizedBox.shrink();

    bool isArabic = Directionality.of(context) == TextDirection.rtl;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateText,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          ),
        ),
      ),
    );
  }

  // Updated getBubble method that includes date headers
  Widget getBubbleWithDateHeader(
      {int? type,
      required MessageModel data,
      required MessageModel? previousMessage,
      required InboxModel? chat,
      required BuildContext context}) {
    return Column(
      children: [
        // Date header (show only when date changes)
        if (shouldShowDateHeader(data, previousMessage))
          buildDateHeader(data.createdAt, context),

        // Original message bubble
        getBubble(
          type: type,
          data: data,
          chat: chat,
          context: context,
        ),
      ],
    );
  }

  Widget getBubble(
      {int? type,
      required MessageModel data,
      required InboxModel? chat,
      required BuildContext context}) {
    switch (type) {
      case 1:
        bool isMyMessage = data.senderId == DbHelper.getUserModel()?.id;

        return Directionality(
          textDirection: TextDirection.ltr, // Force LTR for message content
          child: BubbleNormalMessage(
            textStyle: TextStyle(
              color: isMyMessage ? Colors.white : Colors.black87,
            ),
            timeStamp: true,
            sent: isMyMessage,
            delivered: isMyMessage && data.id != null && data.isRead == 0,
            seen: isMyMessage && data.isRead == 1,
            createdAt: formatBubbleTime(data.updatedAt, context),
            text: data.message ?? '',
            isSender: isMyMessage,
            color: isMyMessage ? Colors.black : Colors.grey[200]!,
          ),
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
            createdAt: formatBubbleTime(
                data.updatedAt, context), // Use context for translation
            text: data.message ?? '',
            isSender: data.senderId == DbHelper.getUserModel()?.id,
            color: data.senderId == DbHelper.getUserModel()?.id
                ? Colors.black
                : Colors.grey.shade600);
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
          createdAt: formatBubbleTime(
              data.updatedAt, context), // Use context for translation
          isSender: data.senderId == DbHelper.getUserModel()?.id,
          image: Container(
            width: 120,
            height: 150,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(BUBBLE_RADIUS_IMAGE)
            ),
            // child: Image.asset(
            //   AssetsRes.SERVICE_FILLER_IMAGE,
            //   width: 120,
            //   height: 150,
            //   fit: BoxFit.cover,
            //   errorBuilder: (context, error, stackTrace) {
            //     return Container(
            //       color: Colors.red,
            //       child: Center(
            //         child: Text(
            //           "SERVICE\nIMAGE\nMISSING",
            //           style: TextStyle(color: Colors.white, fontSize: 10),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            child: FadeInImage(placeholder: AssetImage(AssetsRes.SERVICE_FILLER_IMAGE), image: NetworkImage("${ApiConstants.imageUrl}/${data.message}"),fit: BoxFit.cover,),
          ),
        );
      case 4:
        List<String> imageUrls = (data.message ?? '')
            .split(',')
            .map((url) => "${ApiConstants.imageUrl}/$url")
            .toList();

        bool isMyMessage = data.senderId == DbHelper.getUserModel()?.id;

        return BubbleMultiImage(
          id: "${data.id}",
          imageUrls: imageUrls,
          isSender: isMyMessage,
          sent: isMyMessage,
          delivered: isMyMessage && data.id != null && data.isRead == 0,
          seen: isMyMessage && data.isRead == 1,
          timeStamp: true,
          createdAt: formatBubbleTime(data.updatedAt, context), // Use context for translation
          color: isMyMessage ? Colors.black : Colors.grey[200]!,
        );
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
            createdAt: formatBubbleTime(
                data.updatedAt, context), // Use context for translation
            text: data.message ?? '',
            isSender: data.senderId == DbHelper.getUserModel()?.id,
            color: data.senderId == DbHelper.getUserModel()?.id
                ? Colors.black
                : Colors.grey.shade600);
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
            createdAt: formatBubbleTime(
                data.updatedAt, context), // Use context for translation
            text: data.message ?? '',
            isSender: data.senderId == DbHelper.getUserModel()?.id,
            color: data.senderId == DbHelper.getUserModel()?.id
                ? Colors.black
                : Colors.grey.shade600);
      case 7:
        // File message
        List<String> parts = (data.message ?? '').split('|');
        String fileName = parts.isNotEmpty ? parts[0] : 'Unknown File';
        String fileUrl = parts.length > 1 ? parts[1] : '';

        bool isMyMessage = data.senderId == DbHelper.getUserModel()?.id;
        bool isArabic = Directionality.of(context) == TextDirection.rtl;

        return Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisAlignment:
                isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMyMessage ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: BoxConstraints(maxWidth: 250),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: isMyMessage ? Colors.white : Colors.black54,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName,
                            style: TextStyle(
                              color:
                                  isMyMessage ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        // Open file URL
                        if (fileUrl.isNotEmpty) {
                          // You can use url_launcher package or show in browser
                          print("Opening file: $fileUrl");
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isMyMessage
                              ? Colors.white.withOpacity(0.2)
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Open File',
                          style: TextStyle(
                            color:
                                isMyMessage ? Colors.white : Colors.blue[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          textDirection:
                              isArabic ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatBubbleTime(data.updatedAt, context),
                      style: TextStyle(
                        color: isMyMessage ? Colors.white70 : Colors.grey[600],
                        fontSize: 11,
                      ),
                      textDirection:
                          isArabic ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  getLastMessage({MessageModel? message}) {
    if (message?.isDeleted != null) {
      return "Start Chat";
    }

    String messageText;
    switch (message?.messageType) {
      case 2:
        messageText = '🎁EGP ${message?.message}';
        break;
      case 3:
        messageText = '🌄Image';
        break;
      case 4:
        int imageCount = (message?.message ?? '').split(',').length;
        messageText = '🖼️ $imageCount Photos';
        break;
      case 5:
        List<String> parts = (message?.message ?? '').split('|');
        String fileName = parts.isNotEmpty ? parts[0] : 'File';
        messageText = '📄 $fileName';
        break;
      default:
        messageText = '${message?.message ?? ''}';
        break;
    }

    // Force LTR markers for mixed content to prevent punctuation flipping
    if (messageText.isNotEmpty) {
      // Check if the text contains both English and punctuation
      bool hasEnglish = RegExp(r'[a-zA-Z]').hasMatch(messageText);
      bool hasPunctuation = RegExp(r'[?!.,;:]').hasMatch(messageText);

      if (hasEnglish && hasPunctuation) {
        // Add LTR mark to prevent punctuation flipping
        messageText =
            '\u202D$messageText\u202C'; // LTR override + pop directional formatting
      }
    }

    return messageText;
  }
}
