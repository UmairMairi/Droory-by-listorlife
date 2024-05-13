import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../routes/app_routes.dart';
import 'db_helper.dart';

class DialogHelper {
  /// Show Loading
  static void showLoading() {
    hideKeyboard(AppPages.rootNavigatorKey.currentContext);
    AppPages.rootNavigatorKey.currentContext?.loaderOverlay.show();
  }

  /// Hide Loading
  static void hideLoading() {
    AppPages.rootNavigatorKey.currentContext?.loaderOverlay.hide();
  }

  /// Show Toast
  static showToast({required String? message}) {
    if (message == null) {
      return;
    }
    log("Toast message => $message");
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: 'linear-gradient(to right, #206D00, #3FC200)');
  }

  /// Hide the soft keyboard.
  static void hideKeyboard(BuildContext? context) {
    if (context != null) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  /// Success Dialog
  static void showSuccessDialog(
      {required BuildContext context,
      required String message,
      String? title,
      VoidCallback? onTap}) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: message,
      title: title,
      confirmBtnColor: context.theme.primaryColor,
      onConfirmBtnTap: onTap,
    );
  }

  /// Error Dialog
  static void showErrorDialog(
      {required BuildContext context,
      required String message,
      VoidCallback? onTap}) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      text: message,
      onConfirmBtnTap: onTap,
    );
  }

  /// Location service enable Dialog
  static void showLocationServiceEnable(
      {String? message, VoidCallback? onTap}) {
    CoolAlert.show(
      context: AppPages.rootNavigatorKey.currentContext!,
      title: "Location Services",
      showCancelBtn: true,
      type: CoolAlertType.info,
      text: message,
      onConfirmBtnTap: onTap,
    );
  }

  static String getGreeting() {
    DateTime currentTime = DateTime.now();
    int hour = currentTime.hour;

    if (hour >= 5 && hour < 12) {
      return "Good morning!";
    } else if (hour >= 12 && hour < 17) {
      return "Good afternoon!";
    } else {
      return "Good evening!";
    }
  }

  static Future<void> goToUrl({required Uri uri}) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }

  static void startFirstScreen({String? message}) {
    DbHelper.eraseData();
    AppPages.rootNavigatorKey.currentContext?.go(Routes.root);
    showToast(message: message);
  }
}
