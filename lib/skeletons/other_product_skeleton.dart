import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../res/font_res.dart';
import '../widgets/like_button.dart';

class OtherProductSkeleton extends StatelessWidget {
  final bool isLoading;
  const OtherProductSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 10, left: 5, right: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          AssetsRes.DUMMY_CAR_IMAGE1,
                          fit: BoxFit.fill,
                          height: 100,
                          width: 150,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "EGP300",
                                style: context.textTheme.titleMedium?.copyWith(
                                    fontFamily: FontRes.MONTSERRAT_BOLD),
                              ),
                              LikeButton(
                                onTap: () {},
                                isFav: false,
                              )
                            ],
                          ),
                          const Text(
                            "Hyundai i20 N Line 1.0 N8 Tu...",
                          ),
                          const Text(
                            "2022 - 17000 KM",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_LOACTION_ICON,
                                    height: 14,
                                    width: 14,
                                  ),
                                  const Gap(8),
                                  const Text(
                                    "New York City",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const Text(
                                "Today",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
