import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:lottie/lottie.dart';

import '../../../../models/setting_item_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../product/my_product_view.dart';

class PostAddedFinalView extends StatelessWidget {
  const PostAddedFinalView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                  Text("Congratulations!", style: context.textTheme.titleLarge),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your Ad will go live shortly...",
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
                    "List or Lift allows 2 free ads 180 days for cars",
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
                "Reach more buyers and sell faster",
                style: context.textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Upgrading an ad helps you to reach more buyers",
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
              title: "Sell Faster Now",
              width: context.width,
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 20, bottom: 0),
            ),
            AppOutlineButton(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyProductView(
                              data: SettingItemModel(
                                  imageList: [
                                    AssetsRes.DUMMY_CAR_IMAGE1,
                                    AssetsRes.DUMMY_CAR_IMAGE2,
                                    AssetsRes.DUMMY_CAR_IMAGE3,
                                    AssetsRes.DUMMY_CAR_IMAGE4,
                                  ],
                                  title: 'EGP300',
                                  subTitle:
                                      'Maruti Suzuki Swift 1.2 VXI (O), 2015, Petrol',
                                  description: '2015 - 48000 km',
                                  location: 'New York City',
                                  likes: '5',
                                  views: '10',
                                  timeStamp: 'Today',
                                  isFav: true,
                                  longDescription:
                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                            )));
              },
              title: "Review Ad",
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
