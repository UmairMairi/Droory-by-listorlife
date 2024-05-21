import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/my_ads_v_m.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/app_product_item_widget.dart';

class MyFavouritesView extends BaseView<MyAdsVM> {
  const MyFavouritesView({super.key});

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            ListView.separated(
              clipBehavior: Clip.antiAlias,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.favItemList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push(Routes.productDetails,
                        extra: viewModel.favItemList[index]);
                  },
                  child: AppProductItemWidget(
                    data: viewModel.favItemList[index],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                    height:
                        20); // Use SizedBox instead of Gap for better control
              },
            ),
            const SizedBox(height: 40), // Ensure this is intended
          ],
        ),
      ),
    );
  }
}
