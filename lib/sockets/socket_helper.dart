import 'package:flutter/foundation.dart';
import 'package:list_and_life/sockets/socket_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../helpers/db_helper.dart';

class SocketHelper {
  static final SocketHelper _singleton = SocketHelper._internal();
  SocketHelper._internal();

  factory SocketHelper() => _singleton;

  late IO.Socket _socketIO;

  bool isConnected = false, isUserConnected = false;

  void init() {
    _socketIO = IO.io(
        SocketConstants.socketUrl,
        IO.OptionBuilder()
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

    //--------------------------------Connect User Listener -------------------------//

    _socketIO.on(SocketConstants.connectUser, (data) {
      isUserConnected = true;
      if (kDebugMode) {
        print("User Connected --------------->  $data");
      }
    });
  }

  IO.Socket getSocket() => _socketIO;
  //--------------------------------Connect User Emitter -------------------------//

  connectUser() {
    if (DbHelper.getUserModel()?.id == null) {
      return;
    }
    _socketIO.off(SocketConstants.connectUser);
    Map<String, dynamic> map = {};
    map['user_id'] = DbHelper.getUserModel()?.id;
    _socketIO.emit(SocketConstants.connectUser, map);
    _socketIO.on(SocketConstants.connectUser, (data) {
      isUserConnected = true;
      if (kDebugMode) {
        print("User Connected --------------->  $data");
      }
    });
  }

  //--------------------------------Disconnect User-------------------------//
  disconnectUser() {
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
}
