import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static void goToUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<String?> getFcmToken() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice) {
        return await FirebaseMessaging.instance.getToken();
      } else {
        return await FirebaseMessaging.instance.getAPNSToken();
      }
    }
    return await FirebaseMessaging.instance.getToken();
  }
}
