import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../base/helpers/dialog_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../res/assets_res.dart';
import '../../widgets/app_elevated_button.dart';

class NotFoundView extends StatefulWidget {
  final String? message;
  const NotFoundView({super.key, this.message});

  @override
  State<NotFoundView> createState() => _NotFoundViewState();
}

class _NotFoundViewState extends State<NotFoundView> {
  @override
  void initState() {
    // TODO: implement initState
    DialogHelper.hideLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(AssetsRes.PAGE_NOT_FOUND),
            const Gap(20),
            Text(widget.message ?? StringHelper.somethingWantWrong),
            const Gap(20),
            AppElevatedButton(
                onTap: () {
                  context.pop();
                },
                title: StringHelper.goBack)
          ],
        ),
      ),
    );
  }
}
