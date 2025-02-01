import 'package:flutter/foundation.dart';
import 'package:list_and_life/base/sockets/socket_constants.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../routes/app_pages.dart';
import '../../view_model/chat_vm.dart';
import '../helpers/db_helper.dart';
class SocketHelper {
  static final SocketHelper _singleton = SocketHelper._internal();
  SocketHelper._internal();

  factory SocketHelper() => _singleton;

  late io.Socket _socketIO;

  bool isConnected = false, isUserConnected = false;

  void init() {
    _socketIO = io.io(
        SocketConstants.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .build());
    _initListener();
  }

  _initListener() {
    _socketIO.onConnect((data) {
      isConnected = true;
      if (DbHelper.getUserModel()?.id != null) {
        connectUser();
        updateChatScreenId();
      }
      if (kDebugMode) {
        print('socket connected');
      }
    });
    _socketIO.onConnectError((data) {
      isConnected = false;
      if (kDebugMode) {
        print(data.toString());
      }
    });
    _socketIO.onError((data) {
      if (kDebugMode) {
        print(data.toString());
      }
    });

    _socketIO.on(SocketConstants.connectUser, (data) {
      isUserConnected = true;
      if (kDebugMode) {
        print("User Connected --------------->  $data");
      }
    });
  }

  io.Socket getSocket() => _socketIO;

  void connectUser() {
    if (DbHelper.getUserModel()?.id == null) {
      return;
    }
    _socketIO.off(SocketConstants.connectUser);
    _socketIO.on(SocketConstants.connectUser, (data) {
      isUserConnected = true;
      Provider.of<ChatVM>(AppPages.rootNavigatorKey.currentContext!, listen: false).initListeners();
      if (kDebugMode) {
        print("User Connected --------------->  $data");
      }
    });

    Map<String, dynamic> map = {};
    map['user_id'] = DbHelper.getUserModel()?.id;
    _socketIO.emit(SocketConstants.connectUser, map);
  }

  void disconnectUser() {
    _socketIO.off("disconnect_user");
    Map<String, dynamic> map = {};
    map['userId'] = DbHelper.getUserModel()?.id;
    _socketIO.emit("disconnect_user", map);
    _socketIO.on("disconnect_user", (data) {
      if (kDebugMode) {
        print("User disconnected successfully : $data");
      }
      isUserConnected = false;
    });
  }

  /// Closes the socket connection and cleans up listeners.
  void close() {
    if (_socketIO.connected) {
      _socketIO.disconnect();
      if (kDebugMode) {
        print("Socket disconnected");
      }
    }
    _socketIO.close();
    _socketIO.clearListeners();
    isConnected = false;
    isUserConnected = false;
    if (kDebugMode) {
      print("Socket connection closed and listeners cleared");
    }
  }

  void updateChatScreenId() {
    if (DbHelper.getUserModel()?.id == null) {
      return;
    }
    Map<String, dynamic> map = {
      "sender_id": DbHelper.getUserModel()?.id,
      "room_id": null,
    };
    _socketIO.emit(SocketConstants.updateChatScreenId, map);
    debugPrint("updateChatScreenId $map");
  }
}
