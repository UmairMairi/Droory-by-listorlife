import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import '../helpers/db_helper.dart';
import 'notification_entity.dart';

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
  );

  final StreamController<String?> selectNotificationSubject =
      StreamController<String?>();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
//AIzaSyAmZTH749kcHqE3G5ZYRIXNUI-gcXK29uY
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print(notificationResponse.payload);

      NotificationEntity? notificationEntity =
          DbHelper.convertStringToNotificationEntity(
              notificationResponse.payload);

      pushNextScreenFromForeground(notificationEntity!);

      if (notificationResponse.payload != null) {
        debugPrint('notification payload: ${notificationResponse.payload}');
      }
      selectNotificationSubject.add(notificationResponse.payload);
    });

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    String deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
    debugPrint("fcm Token = $deviceToken");
    _configureSelectNotificationSubject();

    initFirebaseListeners();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      // if (getIt<SharedPreferenceHelper>().authToken == null) {
      //   return;
      // }
      NotificationEntity? entity =
          DbHelper.convertStringToNotificationEntity(payload);
      debugPrint(
          "notification _configureSelectNotificationSubject ${entity.toString()}");
      if (entity != null) {
        pushNextScreenFromForeground(entity);
      }
    });
  }

  Future? onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (DbHelper.getToken() == null) {
      return null;
    }

    print(payload);
    NotificationEntity? entity =
        DbHelper.convertStringToNotificationEntity(payload);
    debugPrint(
        "notification onDidReceiveLocalNotification ${entity.toString()}");
    if (entity != null) {
      pushNextScreenFromForeground(entity);
    }
    return null;
  }

  void initFirebaseListeners() {
    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        pushNextScreenFromForeground(
            NotificationEntity.fromJson(initialMessage.data));
      }
    });
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint(
          "Foreground notification received  ${message.notification?.body}");
      debugPrint("Foreground messge data ${message.data}");

      if (Platform.isIOS || DbHelper.getToken() == null) {
        return;
      }

      NotificationEntity notificationEntity =
          NotificationEntity.fromJson(message.data);
      debugPrint(message.data.toString());
      notificationEntity.title = notificationEntity.title ?? "My Trade Block";
      notificationEntity.body = message.notification?.body;

      showNotifications(NotificationEntity.fromJson(message.data));
    });
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      pushNextScreenFromForeground(NotificationEntity.fromJson(message.data));
    });
  }

  Future<void> showNotifications(NotificationEntity notificationEntity) async {
    Random random = Random();
    int id = random.nextInt(900) + 10;
    await flutterLocalNotificationsPlugin.show(
        id,
        notificationEntity.title,
        notificationEntity.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "@mipmap/ic_launcher",
              channelShowBadge: true,
              playSound: true,
              priority: Priority.high,
              importance: Importance.high,
              styleInformation:
                  BigTextStyleInformation(notificationEntity.body ?? ""),
            ),
            iOS: const DarwinNotificationDetails(
              categoryIdentifier: 'plainCategory',
            )),
        payload:
            DbHelper.convertNotificationEntityToString(notificationEntity));
  }

  void pushNextScreenFromForeground(
      NotificationEntity notificationEntity) async {
    // Utils.showLoader();
    print("Notificaion data => ${notificationEntity.toJson()}");

    /*  switch ("${notificationEntity.entityName}") {
      case 'MESSAGE':
        Get.toNamed(Routes.MESSAGE,
            arguments: ProductDetailsModel(
                image: notificationEntity.jobImage,
                username: notificationEntity.dataName,
                userId: num.parse("${notificationEntity.dataId}"),
                id: num.parse("${notificationEntity.entityId}")));
        break;
      default:
        Get.toNamed(Routes.NOTIFICATIONS);
    }*/
  }
}
