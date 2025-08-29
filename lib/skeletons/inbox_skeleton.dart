import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../res/font_res.dart';
import '../widgets/app_text_field.dart';
import '../widgets/image_view.dart';

class InboxSkeleton extends StatelessWidget {
  final bool isLoading;
  const InboxSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            const AppTextField(
              padding: EdgeInsets.symmetric(horizontal: 20),
              hint: 'Search...',
              suffix: Icon(Icons.search),
            ),
            const Gap(20),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ImageView.rect(
                            height: 60,
                            width: 60,
                            image: AssetsRes.DUMMY_CAR_IMAGE1,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Alok Dubey",
                                  style: context.textTheme.titleMedium,
                                ),
                                const Gap(02),
                                Text(
                                  'This is Cars collaction',
                                  style: context.textTheme.labelLarge?.copyWith(
                                      fontFamily: FontRes.MONTSERRAT_MEDIUM,
                                      color: Colors.black),
                                ),
                                const Gap(02),
                                Text(
                                  "🎁 This is last message",
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                          fontFamily:
                                              FontRes.MONTSERRAT_MEDIUM),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.remove_red_eye_outlined,
                                size: 12,
                              ),
                              const Gap(02),
                              Text(
                                "Just Now",
                                style: context.textTheme.labelMedium?.copyWith(
                                    fontFamily: FontRes.MONTSERRAT_MEDIUM),
                              ),
                            ],
                          )
                        ],
                      ),
                    ));
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                  itemCount: 12),
            ),
          ],
        ),
      ),
    );
  }
}
