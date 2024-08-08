import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../res/assets_res.dart';
import '../res/font_res.dart';
import '../widgets/like_button.dart';

class ProductListSkeleton extends StatelessWidget {
  final bool isLoading;
  const ProductListSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: const Offset(0, 5), // Offset from the top
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      AssetsRes.DUMMY_CAR_IMAGE1,
                      height: 160,
                      width: context.width,
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(08),
                          margin: const EdgeInsets.all(08),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: LikeButton(
                            isFav: true,
                            onTap: () {},
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'EGP300',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.titleSmall,
                            ),
                          ),
                          Text(
                            'Apple iPhone 15 Pro',
                            style: context.textTheme.titleMedium?.copyWith(
                                color: context.theme.colorScheme.error),
                          ),
                        ],
                      ),
                      const Gap(5),
                      Text(
                        'Open Box iPhone 15 & 14 Plus Pro Max 128GB 256GB 512GB 1TB Warranty 76',
                        maxLines: 1,
                        style: context.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                AssetsRes.IC_ITEM_LOCATION,
                                scale: 2.5,
                              ),
                              const Gap(05),
                              Text(
                                'New York City',
                                style: context.textTheme.labelMedium?.copyWith(
                                    fontFamily: FontRes.MONTSERRAT_REGULAR),
                              ),
                            ],
                          ),
                          Text(
                            'Today',
                            style: context.textTheme.labelMedium?.copyWith(
                                fontFamily: FontRes.MONTSERRAT_REGULAR),
                          )
                        ],
                      ),
                      const Gap(10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 08),
                                decoration: BoxDecoration(
                                  color: const Color(0xff5A5B55),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      AssetsRes.IC_CALL_ICON,
                                      height: 16,
                                    ),
                                    const Gap(05),
                                    Text(
                                      'Call',
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(7.8),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 08),
                                decoration: BoxDecoration(
                                  color: const Color(0xff5A5B55),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      AssetsRes.IC_CHAT_ICON,
                                      height: 16,
                                    ),
                                    const Gap(05),
                                    Text(
                                      'Chat',
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(7.8),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 08),
                                decoration: BoxDecoration(
                                  color: const Color(0xff5A5B55),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      AssetsRes.IC_WHATSAPP_ICON,
                                      height: 18,
                                    ),
                                    const Gap(05),
                                    Text(
                                      'Alok',
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      const Gap(10),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Gap(20);
        },
      ),
    );
  }
}
