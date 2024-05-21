import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../routes/app_routes.dart';

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsRes.LOCATION_PERMISSION_ILLUSTRATIONS,
              scale: 2.5,
              width: context.width,
            ),
            const Gap(20),
            Text(
              'Hello! Welcome',
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            Text(
              "Lorem ipsum dolor sit amet, consecteturadipiscing elit.",
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(30),
            AppElevatedButtonWithIcon(
                width: context.width,
                onTap: () async {
                  if (await Permission.location.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                  }
                  if (context.mounted) context.go(Routes.main);
                },
                title: 'Use Current Location',
                icon: Icon(
                  CupertinoIcons.location_fill,
                  color: Colors.white,
                )),
            const Gap(30),
            TextButton(
                onPressed: () {
                  context.go(Routes.main);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: FontRes.MONTSERRAT_SEMIBOLD),
                ))
          ],
        ),
      ),
    );
  }
}
