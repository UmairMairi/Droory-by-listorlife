import 'package:list_and_life/base/base.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:lottie/lottie.dart';

class AppEmptyWidget extends StatelessWidget {
  final String? text;
  final double? height;
  final double? width;
  const AppEmptyWidget({super.key, this.text, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AssetsRes.EMPTY_LOTTIE,
              repeat: false, height: height ?? 250, width: width),
          const SizedBox(
            height: 10,
          ),
          Text(
            text ?? StringHelper.noData,
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
