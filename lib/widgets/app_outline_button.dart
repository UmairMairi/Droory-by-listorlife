import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

import '../res/font_res.dart';

class AppOutlineButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  const AppOutlineButton(
      {super.key,
      this.title,
      this.onTap,
      this.height,
      this.width,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(width ?? 150, height ?? 50),
            foregroundColor: context.theme.primaryColor),
        child: Text(
          title ?? '',
          style: context.textTheme.titleSmall
              ?.copyWith(fontFamily: FontRes.MONTSERRAT_BOLD),
        ),
      ),
    );
  }
}
