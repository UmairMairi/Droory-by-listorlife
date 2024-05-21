import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/res/assets_res.dart';
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
                  const Text(
                    "Congratulations!",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your Ad will go live shortly...",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.50)),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 42,
              color: const Color(0xffFF385C),
              child: const Center(
                child: Text(
                  "List or Lift allows 2 free ads 180 days for cars",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Reach more buyers and sell faster",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Upgrading an ad helps you to reach more buyers",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.50)),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              AssetsRes.IC_CONGRATULATION_IMAGE,
              scale: 3.5,
            ),
            GestureDetector(
              onTap: () {
                context.push(Routes.planList);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(
                    left: 40, right: 40, top: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  "Sell Faster Now",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            GestureDetector(
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
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  "Review Ad",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
