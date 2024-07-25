import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_pages.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';
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
  static showToast({required String? message, bool error = false}) {
    if (message == null) {
      return;
    }
    log("Toast message => $message");
    toastification.show(
      description: Text(message),
      alignment: Alignment.bottomCenter,
      icon: const Icon(Icons.notifications),
      style: ToastificationStyle.minimal,
      type: error ? ToastificationType.error : ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 2),
    );
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

  static void showLoginDialog({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) => AppAlertDialogWithWidget(
              title: 'Login Required',
              description: 'You need to log in to perform this action.',
              buttonText: 'Login',
              icon: AssetsRes.IC_LOCK_LOGIN,
              onTap: () {
                context.pop();
                context.push(Routes.guestLogin);
              },
            ));
  }
}

class AppAlertDialogWithLottie extends StatelessWidget {
  final String? lottieIcon;
  final String? title;
  final String description;
  final VoidCallback onTap;
  final VoidCallback? onCancelTap;

  final bool showCancelButton;

  final String? buttonText;
  final String? cancelButtonText;
  const AppAlertDialogWithLottie({
    super.key,
    this.lottieIcon,
    this.title,
    required this.description,
    required this.onTap,
    this.onCancelTap,
    this.showCancelButton = false,
    this.buttonText,
    this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color(0xFFEEEEEE),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(lottieIcon ?? AssetsRes.TICK_MARK_LOTTIE,
                repeat: false, height: 120),
            Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title ?? 'Alert',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          width: context.width,
                          onTap: onTap,
                          title: buttonText ?? ' Ok',
                        ),
                      ),
                      if (showCancelButton) ...{
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: AppElevatedButton(
                          width: context.width,
                          backgroundColor: const Color(0xffeeeeee),
                          onTap: onCancelTap ??
                              () {
                                context.pop();
                              },
                          tittleColor: Colors.black,
                          title: cancelButtonText ?? ' Cencel',
                        )),
                      }
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class AppAlertDialogWithWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? description;
  final VoidCallback onTap;
  final VoidCallback? onCancelTap;

  final bool showCancelButton;
  final Color? glowColor;
  final String? buttonText;
  final String? cancelButtonText;
  final Widget? content;
  final bool isTextDescription;
  const AppAlertDialogWithWidget({
    super.key,
    this.icon,
    this.title,
    this.glowColor,
    this.description,
    required this.onTap,
    this.onCancelTap,
    this.content,
    this.showCancelButton = false,
    this.isTextDescription = true,
    this.buttonText,
    this.cancelButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color(0xFFEEEEEE),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Lottie.asset(lottieIcon ?? AssetsRes.TICK_MARK_LOTTIE,
                repeat: false, height: 120),*/
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: AvatarGlow(
                startDelay: const Duration(milliseconds: 300),
                glowColor: glowColor ?? Colors.black12,
                glowShape: BoxShape.circle,
                curve: Curves.fastOutSlowIn,
                repeat: false,
                child: Material(
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage(icon ?? AssetsRes.IC_BLOCK_USER),
                    radius: 40.0,
                  ),
                ),
              ),
            ),
            Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title ?? 'Alert',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isTextDescription
                      ? Text(
                          description ??
                              'Your Profile has been created successfully!',
                          textAlign: TextAlign.center,
                        )
                      : content != null
                          ? content!
                          : const SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          width: context.width,
                          onTap: onTap,
                          title: buttonText ?? ' Ok',
                        ),
                      ),
                      if (showCancelButton) ...{
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: AppElevatedButton(
                          width: context.width,
                          backgroundColor: const Color(0xffeeeeee),
                          onTap: onCancelTap ??
                              () {
                                context.pop();
                              },
                          tittleColor: Colors.black,
                          title: cancelButtonText ?? ' Cencel',
                        )),
                      }
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
