import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helpers/dialog_helper.dart';
import '../../../widgets/app_product_item_widget.dart';

class HomeView extends BaseView<HomeVM> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, HomeVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: context.textTheme.titleMedium,
            ),
            const Gap(01),
            FutureBuilder<String>(
                future: viewModel.updateLocation(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      viewModel.currentLocation,
                      style: context.textTheme.bodySmall,
                    );
                  }
                  if (snapshot.hasError) {
                    return InkWell(
                      onTap: () {
                        DialogHelper.showLocationServiceEnable(
                            message:
                                "List or Life would like to access your location",
                            onTap: () async {
                              await Geolocator.openLocationSettings();
                            });
                      },
                      child: Text(
                        "Permission Required!!",
                        style: context.textTheme.bodySmall,
                      ),
                    );
                  }
                  return const Text("- - -");
                }),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              context.push(Routes.notifications);
            },
            child: Container(
                padding: const EdgeInsets.all(05),
                margin: const EdgeInsets.symmetric(horizontal: 05),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  AssetsRes.IC_BELL_ICON,
                  scale: 1.3,
                )),
          )
        ],
      ),
      body: SmartRefresher(
        controller: viewModel.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        onRefresh: viewModel.onRefresh,
        onLoading: viewModel.onLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    autofocus: false,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xffd5d5d5))),
                        hintStyle: context.textTheme.labelSmall,
                        hintText: 'Find Cars, Mobile Phones and more...'),
                  )),
                  const Gap(10),
                  InkWell(
                    onTap: () {
                      context.push(Routes.filter);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: const Color(0xffd5d5d5),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        AssetsRes.IC_FILTER_ICON,
                        height: 25,
                      ),
                    ),
                  ),
                  const Gap(10),
                ],
              ),
              const Gap(20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      List.generate(viewModel.categoryItems.length, (index) {
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
                                viewModel.categoryItems[index].icon ?? '',
                                height: 70,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              viewModel.categoryItems[index].title ?? '',
                              style: context.textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const Gap(18),
                      ],
                    );
                  }),
                ),
              ),
              const Gap(20),
              Text(
                'Fresh recommendations',
                style: context.textTheme.titleMedium,
              ),
              const Gap(20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.homeItemList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push(Routes.productDetails,
                          extra: viewModel.homeItemList[index]);
                    },
                    child: AppProductItemWidget(
                      data: viewModel.homeItemList[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Gap(20);
                },
              ),
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }
}
