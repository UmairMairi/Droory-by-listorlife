import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base_view.dart';
import 'package:list_and_life/view/main/fevorite/my_ads_view.dart';
import 'package:list_and_life/view/main/fevorite/my_favourites_view.dart';
import 'package:list_and_life/view_model/my_ads_v_m.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

class AdsView extends BaseView<MyAdsVM> {
  const AdsView({super.key});

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppElevatedButton(
                  title: 'Ads',
                  height: 40,
                  tittleColor:
                      viewModel.selectIndex == 0 ? Colors.white : Colors.black,
                  backgroundColor:
                      viewModel.selectIndex == 1 ? Colors.grey : Colors.black,
                  width: 120,
                  onTap: () {
                    viewModel.selectIndex = 0;
                  },
                ),
                const Gap(10),
                AppElevatedButton(
                  title: 'Favourites',
                  height: 40,
                  tittleColor:
                      viewModel.selectIndex == 1 ? Colors.white : Colors.black,
                  backgroundColor:
                      viewModel.selectIndex == 0 ? Colors.grey : Colors.black,
                  width: 120,
                  onTap: () {
                    viewModel.selectIndex = 1;
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: viewModel.selectIndex == 0
                  ? const MyAdsView()
                  : const MyFavouritesView()),
        ],
      ),
    );
  }
}
