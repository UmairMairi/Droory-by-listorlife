import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:list_and_life/base/utils/utils.dart';

import '../helpers/db_helper.dart';
import '../helpers/dialog_helper.dart';
import 'notification_entity.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

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
//AIzaSyAmZTH749kcHqE3G5ZYRIXNUI-gcXK29uY
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
              debugPrint(notificationResponse.payload);

      NotificationEntity? notificationEntity =
          DbHelper.convertStringToNotificationEntity(
              notificationResponse.payload);

      pushNextScreenFromForeground(notificationEntity);

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

    String? deviceToken = await Utils.getFcmToken();
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
      pushNextScreenFromForeground(entity);
    });
  }

  Future? onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    if (DbHelper.getToken() == null) {
      return null;
    }

    debugPrint(payload);
    NotificationEntity? entity =
        DbHelper.convertStringToNotificationEntity(payload);
    debugPrint(
        "notification onDidReceiveLocalNotification ${entity.toString()}");
    pushNextScreenFromForeground(entity);
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
      notificationEntity.title = notificationEntity.title ?? "Daroory";
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
    math.Random random = math.Random();
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
      NotificationEntity? notificationEntity) async {
    // Utils.showLoader();
    debugPrint("Notificaion data => ${notificationEntity?.toJson()}");

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

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "list-and-life",
      "private_key_id": "efdddd1332350362c035c7e8194863754358152e",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDyQcffUDZ2pji9\nYSGO9WISeqmPTox3S7TcDzyM7ApiHOlsLZmaYMWtemYt6DniX2md/Yq/hmjR+RSy\nd80OXMJvJIeLdpWimvsZSGVIkPWMggYeDd1lJN/0V8Op13kvdvkme649jPkOzV17\nI5leJCm7EvKT6WOQJjlI4+zuWUKjtSqzS+RNP8OMQy+IwM9ENp6DHaay/Q4AaP/A\nkvd+v0zTzuC19y7QeArxrDq+evx4sKmfCWaQR7TvNcvI/L3XRN1NWoIE075jjciM\njAhAthQqhxH4b2aUvsQNKW15FdBgJpHZrhQatwHFAzbXfzAyMem+ol5bVRY5CJcf\nmNoKY9FXAgMBAAECggEAJrJcP28cLAq0MIgF6MSIlGQUlqgY5utoaehjJy2DIRX2\nMUn9abwAh4vwK3AXYvITuGFqGtrY/oVXiYR6dEtb4Y4Hur7H+y/fYTP/vb4uAvI4\nEO/tB/2CapDkV8pr+Kl79eo2tG1C0Vr7jjJrCq8jHVdS+U6EEWARsXN7Ar2uV+DG\nb2J+XA9vfIl2R0QubFMgiAyjCcRh0exPBoGJmY9p9ue0Y1Dba0m3mrIDr5V6edgX\nlPZYIKzZiXXVLjiPYSgEWxKmOcdVLGyo0KGZolsTvXLRzyUB8IvyWFdSfsg8lcgR\nhSfWKNhvWwaqjsoTDR4YbQ1e1mQzquhcdBPxuhJmiQKBgQD7wxJrbx4A9f84IB2P\nepSvhPYB9fVDv7r8pzg1BepDdTtWWCjPeYa3lrSt7hUmQkuU3J3LPGU6H5Ug74cO\ndWExNL5Yd3USJ3duHrq2AyqVaSNY05Q9OzhpPD74ZFn3lbG58EHcB5mrsVvCbOai\nkeFHoqdIsdF48n2HWd44LXpITwKBgQD2Vb+S2V5IjGMgMWV5ElvD8un61QjHP+G/\nGJttL2hirleYhmTxsfVTlvy5nKkiMkXLKbFWBg8zlIyWQfJ19VbTy6bzm5asocW+\n9z2imS6qCffvPN/tlQAgrl66uW2MIEmNSLNDasGtMjvUSmYI1aiR5Hl3m4Z5XJmt\nLI/arqEceQKBgQCSVNPD9hXuYQ0yxhfoaUs6qYGDqj4gXrSEXX1h9EoxY1ZV3W/7\nB5ux4bqqzZMlZasgnwpoMnZzzh+TwSUy1i7jttBcAzLclmvoaZwEZtq9dRrCalfj\nLySephHDtjBEo5Fljav6A8Dh9nhrDXkQTNIwHO42ZoRmVCt6HFX5ORW2KQKBgEtN\nVyzK6fl/gOXcc8qZBBhYb5JQAUj3jEjgetLbxSs1ZG2p173Sys3swAD1lPZxK8i5\nTA6h94+q/3cHXdkVUJ+aB8U8cMkBAvQnnF3SOeOc/H/Tuhhkjg9vfmHSQVyumg1o\nhfQ79Ey/qG5y99IHjmpaz47yqh77YbcAglE1RObxAoGAXj9H9y1MHVNQAxssVuG4\nxOf9djEzmvdLAcEqfXQ+MAO74MySacRSPOQ2ygWJqjdKNA6xb6k1h/BpIGoKGVjn\n/xziZZRLiHIeDl/tezFW6jvIoY/vG3XoK/y4I+sreuq6SLFP2hUWtvw6pB2YymQn\nxGGGI4R0bWVglFQGIFIB2x8=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "notification-list-and-lift@list-and-life.iam.gserviceaccount.com",
      "client_id": "101357525492092534117",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/notification-list-and-lift%40list-and-life.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    var client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    //get the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      {required String title, required String body}) async {
    Dio dio = Dio();
    final String serverAccessTokenKey =
        await getAccessToken(); // Your FCM server access token key
    log("Api Key => $serverAccessTokenKey");
    String deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
    log("Device token => $deviceToken");
    // String endpointFirebaseCloudMessaging = 'https://fom.googleapis.com/v1/projects/security-task/messages:send';
    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/list-and-life/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {"title": title, "body": body}
      },
    };

    try {
      final response = await dio.post(
        endpointFirebaseCloudMessaging,
        data: jsonEncode(message),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverAccessTokenKey',
          },
        ),
      );

      // Handle the response
      debugPrint(response.data);
    } on DioException catch (e) {
      // Handle error
      debugPrint('Error: $e');
    }
    DialogHelper.hideLoading();
  }
}
