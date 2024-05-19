import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/card_swipe_widget.dart';

import '../../../widgets/app_product_item_widget.dart';

class HomeView extends BaseView<HomeVM> {
  const HomeView({Key? key}) : super(key: key);

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
            Text(
              viewModel.currentLocation,
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          Container(
              padding: const EdgeInsets.all(05),
              margin: const EdgeInsets.symmetric(horizontal: 05),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Image.asset(AssetsRes.IC_BELL_ICON))
        ],
      ),
      body: SingleChildScrollView(
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xffd5d5d5))),
                      hintStyle: context.textTheme.labelMedium,
                      hintText: 'Find Cars, Mobile Phones and more...'),
                )),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color(0xffd5d5d5),
                      borderRadius: BorderRadius.circular(8)),
                  child: Image.asset(
                    AssetsRes.IC_FILTER_ICON,
                    height: 25,
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
                  return Column(
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
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
