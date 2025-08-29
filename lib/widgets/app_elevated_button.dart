import 'package:list_and_life/base/base.dart';
import 'package:flutter/material.dart';

import '../res/font_res.dart';

class AppElevatedButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  final Color? backgroundColor;

  final Color? tittleColor;
  const AppElevatedButton(
      {super.key,
      this.title,
      this.onTap,
      this.backgroundColor,
      this.width,
      this.padding,
      this.tittleColor,
      this.textStyle,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? context.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(width ?? 150, height ?? 50),
            foregroundColor: Colors.white),
        child: Text(
          title ?? '',
          style: textStyle ??
              context.textTheme.titleSmall?.copyWith(
                  color: tittleColor ?? Colors.white,
                  fontFamily: FontRes.MONTSERRAT_BOLD),
        ),
      ),
    );
  }
}

class AppElevatedButtonWithIcon extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;
  final Color? tittleColor;

  final Widget icon;
  const AppElevatedButtonWithIcon(
      {super.key,
      this.title,
      required this.icon,
      this.onTap,
      this.backgroundColor,
      this.width,
      this.padding,
      this.tittleColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton.icon(
        icon: icon,
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor:
                backgroundColor ?? context.theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(width ?? 150, height ?? 50),
            foregroundColor: context.theme.cardColor),
        label: Text(
          title ?? '',
          style: context.textTheme.titleSmall
              ?.copyWith(color: tittleColor ?? Colors.white),
        ),
      ),
    );
  }
}
