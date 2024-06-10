import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/extensions/num_extension.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:lottie/lottie.dart';

import '../res/assets_res.dart';

class UnauthorisedView extends StatelessWidget {
  final String? text;
  const UnauthorisedView({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AssetsRes.AUTH_REQUIRED_LOTTIE, repeat: false),
            Text(
              text ?? "Required login for access this page",
              style: context.titleLarge,
              textAlign: TextAlign.center,
            ),
            20.height,
            AppElevatedButton(
              onTap: () {
                context.push(Routes.login);
              },
              title: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
