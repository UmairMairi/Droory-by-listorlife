import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static void goToUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Hide the soft keyboard.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // static Future<String?> getFcmToken() async {
  //   if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     if (iosInfo.isPhysicalDevice) {
  //       return await FirebaseMessaging.instance.getToken();
  //     } else {
  //       return await FirebaseMessaging.instance.getAPNSToken();
  //     }
  //   }
  //   return await FirebaseMessaging.instance.getToken();
  // }

  static Future<String?> getFcmToken() async {
    String? fcmToken;
    if (Platform.isIOS) {
      // On iOS we need to see an APN token is available first
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      else {
        // add a delay and retry getting APN token
        await Future<void>.delayed(const Duration(seconds: 3,));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          fcmToken = await FirebaseMessaging.instance.getToken();
        }
      }
    }
    else {
      // android platform
      fcmToken = await FirebaseMessaging.instance.getToken();
    }
    debugPrint("getFcmToken $fcmToken");
    return fcmToken;
  }

  // static Future<String?> getFcmToken() async {
  //   return await FirebaseMessaging.instance.getToken()??"";
  // }
}
