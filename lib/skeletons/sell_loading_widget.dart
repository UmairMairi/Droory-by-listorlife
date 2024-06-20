import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../res/assets_res.dart';

class SellLoadingWidget extends StatelessWidget {
  final bool isLoading;
  const SellLoadingWidget({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          padding: const EdgeInsets.only(bottom: 50),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              mainAxisExtent: 130),
          itemBuilder: (buildContext, index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                color: const Color(0xffFCFCFD),
                elevation: 0.3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsRes.IC_IMAGE_PLACEHOLDER,
                        height: 38,
                        width: 46,
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        'Home Living',
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
