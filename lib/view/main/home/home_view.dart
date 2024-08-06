import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/models/filter_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/skeletons/product_list_skeleton.dart';
import 'package:list_and_life/view/main/filtter/filter_item_view.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/network/api_constants.dart';
import '../../../models/category_model.dart';
import '../../../skeletons/home_category_skelton.dart';
import '../../../widgets/app_product_item_widget.dart';
import '../../../widgets/image_view.dart';

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
            onTap: () async {
              /*     await NotificationService.sendNotification(
                  title: "Test Notification", body: "Test Body");*/
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
              const Gap(20),
              FutureBuilder<List<CategoryModel>>(
                  future: viewModel.getCategoryListApi(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CategoryModel> categoryItems = snapshot.data ?? [];

                      return SizedBox(
                        height: 90,
                        width: context.width,
                        child: ListView.builder(
                            itemCount: categoryItems.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 80,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FilterItemView(
                                                    model: FilterModel(
                                                  categoryId:
                                                      "${categoryItems[index].id}",
                                                  latitude:
                                                      "${viewModel.latitude}",
                                                  longitude:
                                                      "${viewModel.longitude}",
                                                ))));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: ImageView.rect(
                                          image:
                                              "${ApiConstants.imageUrl}/${categoryItems[index].image}",
                                          height: 35,
                                          placeholder:
                                              AssetsRes.IC_IMAGE_PLACEHOLDER,
                                          width: 35,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const Gap(10),
                                      Text(
                                        categoryItems[index].name ?? '',
                                        style: context.textTheme.labelSmall
                                            ?.copyWith(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    if (snapshot.hasError) {
                      return const HomeCategorySkelton(
                        isLoading: true,
                      );
                    }
                    return HomeCategorySkelton(
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  }),
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
    );
  }
}
