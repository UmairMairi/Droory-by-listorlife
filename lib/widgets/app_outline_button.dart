import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

import '../animations/fade_animation.dart';

class AppOutlineButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  const AppOutlineButton({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 0.5,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(context.width, 40),
            foregroundColor: context.theme.primaryColor),
        child: Text(
          title ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
