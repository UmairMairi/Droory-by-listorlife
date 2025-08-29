import 'package:list_and_life/base/base.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:lottie/lottie.dart';

class AppEmptyNotificationWidget extends StatelessWidget {
  final String? text;
  const AppEmptyNotificationWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AssetsRes.NO_NOTIFICATION_LOTTIE, repeat: false),
          const SizedBox(
            height: 10,
          ),
          Text(
            text ?? "No Notification",
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
