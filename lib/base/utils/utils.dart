import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../res/assets_res.dart';

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
      } else {
        // add a delay and retry getting APN token
        await Future<void>.delayed(const Duration(
          seconds: 3,
        ));
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          fcmToken = await FirebaseMessaging.instance.getToken();
        }
      }
    } else {
      // android platform
      fcmToken = await FirebaseMessaging.instance.getToken();
    }
    debugPrint("getFcmToken $fcmToken");
    return fcmToken;
  }

  // static Future<String?> getFcmToken() async {
  //   return await FirebaseMessaging.instance.getToken()??"";
  // }

  static void shareProduct(
      {required String title,
      required String image,
      required BuildContext context}) async {
    final box = context.findRenderObject() as RenderBox?;
    Directory tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/daroory.jpeg';
    await Dio().download(image, path);
    await Share.shareXFiles(
      [XFile(path)],
      text: title,
      subject: 'Check out this listing on Daroory',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  static void onShareProduct(BuildContext context, String title) async {
    final box = context.findRenderObject() as RenderBox?;
    try {
      final data = await rootBundle.load(AssetsRes.APP_LOGO);
      final buffer = data.buffer;
      await Share.shareXFiles(
        [
          XFile.fromData(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            name: AssetsRes.APP_LOGO,
            mimeType: 'image/png',
          ),
        ],
        text: title,
        subject: 'Check out this listing on Daroory',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      debugPrint("share error $e");
    }
  }

  static void showColorPickerDialog(
      {required Function(Color) onColorSelected,
      required BuildContext context,
      Color initialColor = const Color(0xffff0004)}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = initialColor;
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Select Color"),
                ColorPicker(
                  pickerColor: selectedColor,
                  paletteType: PaletteType.hsv,
                  onColorChanged: (Color color) {
                    selectedColor = color;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () {
                        onColorSelected(selectedColor);
                        Navigator.pop(context);
                      },
                      child: const Text("Select"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
