import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/skeletons/product_list_skeleton.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
            Text(
              viewModel.currentLocation,
              style: context.textTheme.bodySmall,
            )
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  autofocus: false,
                  focusNode: viewModel.searchFocusNode,
                  onChanged: viewModel.onSearchChanged,
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
          ),
        ),
      ),
      body: InkWell(
        onTap: () => viewModel.searchFocusNode.unfocus,
        child: SmartRefresher(
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
                if (viewModel.isLoading) ...{
                  ProductListSkeleton(isLoading: viewModel.isLoading)
                } else ...{
                  viewModel.productsList.isEmpty
                      ? const AppEmptyWidget()
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.productsList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (viewModel.productsList[index].userId ==
                                    DbHelper.getUserModel()?.id) {
                                  context.push(Routes.myProduct,
                                      extra: viewModel.productsList[index]);
                                  return;
                                }

                                context.push(Routes.productDetails,
                                    extra: viewModel.productsList[index]);
                              },
                              child: AppProductItemWidget(
                                data: viewModel.productsList[index],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Gap(20);
                          },
                        )
                },
                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
