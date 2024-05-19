import 'package:flutter/material.dart';
import 'package:list_and_life/base/base_view.dart';
import 'package:list_and_life/view/main/fevorite/my_ads_view.dart';
import 'package:list_and_life/view/main/fevorite/my_favourites_view.dart';
import 'package:list_and_life/view_model/my_ads_v_m.dart';

class AdsView extends BaseView<MyAdsVM> {
  const AdsView({super.key});

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SafeArea(
              child: TabBar(
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  physics: NeverScrollableScrollPhysics(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      text: 'Ads',
                    ),
                    Tab(
                      text: 'Favourites',
                    ),
                  ]),
            ),
            const Expanded(
                child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [MyAdsView(), MyFavouritesView()],
            ))
          ],
        ),
      ),
    );
  }
}
