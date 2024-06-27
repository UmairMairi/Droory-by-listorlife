import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/view_model/my_ads_v_m.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';

import '../../../helpers/db_helper.dart';
import '../../../widgets/unauthorised_view.dart';

class MyFavouritesView extends BaseView<MyAdsVM> {
  const MyFavouritesView({super.key});

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return Scaffold(
      body: DbHelper.getIsGuest()
          ? const UnauthorisedView()
          : const AppEmptyWidget()/*ListView.separated(
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 50, top: 10),
              shrinkWrap: true,
              itemCount: viewModel.favItemList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push(Routes.productDetails,
                        extra: viewModel.favItemList[index]);
                  },
                  child: AppProductItemWidget(
                    data: ProductDetailModel(),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                    height:
                        20); // Use SizedBox instead of Gap for better control
              },
            )*/,
    );
  }
}
