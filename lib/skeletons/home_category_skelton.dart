import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeCategorySkelton extends StatelessWidget {
  final bool isLoading;
  const HomeCategorySkelton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        enabled: isLoading,
        child: SizedBox(
          height: 100,
          child: ListView.builder(
              itemCount: 12,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(
                            AssetsRes.IC_CAT_CAR,
                            height: 70,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'Cars',
                          style: context.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const Gap(18),
                  ],
                );
              }),
        ));
  }
}
