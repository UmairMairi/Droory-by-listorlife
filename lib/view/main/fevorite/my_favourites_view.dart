import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/my_ads_v_m.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/app_product_item_widget.dart';

class MyFavouritesView extends BaseView<MyAdsVM> {
  const MyFavouritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        return const Gap(20);
      },
    );
  }
}
