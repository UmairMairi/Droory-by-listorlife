import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../base/helpers/app_string.dart';
import '../../../../models/prodect_detail_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../product/my_product_view.dart';

class PostAddedFinalView extends StatelessWidget {
  final ProductDetailModel? data;
  const PostAddedFinalView({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 318,
              color: const Color(0xffEFEFEF),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Lottie.asset(
                    AssetsRes.TICK_MARK_LOTTIE,
                    repeat: false,
                    height: 120,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(AppString.congratulations, style: context.textTheme.titleLarge),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppString.yourAdWillGoLiveShortly,
                    style: context.textTheme.titleMedium
                        ?.copyWith(color: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            Container(
                width: double.infinity,
                height: 42,
                color: const Color(0xffFF385C),
                child: Center(
                  child: Text(
                    AppString.listOrLiftAllowsFreeAds,
                    style: context.textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              AssetsRes.IC_CONGRATULATION_IMAGE,
              scale: 2.5,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppString.reachMoreBuyersAndSellFaster,
                style: context.textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                AppString.upgradingAnAdHelpsYouToReachMoreBuyers,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.black.withOpacity(0.5)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppElevatedButton(
              onTap: () {
                context.push(Routes.planList);
              },
              title: AppString.sellFasterNow,
              width: context.width,
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 0),
            ),
            AppOutlineButton(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyProductView(
                              data: data,
                            )));
              },
              title: AppString.reviewAd,
              width: context.width,
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 20),
            ),
          ],
        ),
      ),
    );
  }
}
