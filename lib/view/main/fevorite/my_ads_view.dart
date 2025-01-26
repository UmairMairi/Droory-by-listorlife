import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/skeletons/my_ads_skeleton.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/helpers/db_helper.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../res/assets_res.dart';
import '../../../view_model/my_ads_v_m.dart';
import '../../../widgets/app_elevated_button.dart';
import '../../../widgets/unauthorised_view.dart';

class MyAdsView extends BaseView<MyAdsVM> {
  const MyAdsView({super.key});

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return viewModel.isGuest
        ? const UnauthorisedView()
        : Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(
                          '${StringHelper.allAds} (${viewModel.allAds.length})'),
                      selected: viewModel.selectedFilter == 0,
                      onSelected: (bool selected) {
                        viewModel.changeFilter(0); // All Ads
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                          '${StringHelper.liveAds} (${viewModel.liveAds.length})'),
                      selected: viewModel.selectedFilter == 1,
                      onSelected: (bool selected) {
                        viewModel.changeFilter(1); // Live Ads
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                          '${StringHelper.underReview} (${viewModel.underReviewAds.length})'),
                      selected: viewModel.selectedFilter == 2,
                      onSelected: (bool selected) {
                        viewModel.changeFilter(2); // Under Review
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                          '${StringHelper.expiredAds} (${viewModel.expiredAds.length})'),
                      selected: viewModel.selectedFilter == 4,
                      onSelected: (bool selected) {
                        viewModel.changeFilter(4); // Expired Ads
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                          '${StringHelper.rejectedAds} (${viewModel.rejectedAds.length})'),
                      selected: viewModel.selectedFilter == 5,
                      onSelected: (bool selected) {
                        viewModel.changeFilter(5); // Rejected Ads
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SmartRefresher(
                  controller: viewModel.refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    complete: Platform.isAndroid
                        ? const CircularProgressIndicator()
                        : const CupertinoActivityIndicator(),
                  ),
                  onRefresh: viewModel.onRefresh,
                  onLoading: viewModel.onLoading,
                  child: viewModel.isLoading
                      ? MyAdsSkeleton(isLoading: viewModel.isLoading)
                      : viewModel.productsList.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              itemCount: viewModel.productsList.length,
                              itemBuilder: (context, index) {
                                var productDetails =
                                    viewModel.productsList[index];
                                var soldStatus = productDetails.sellStatus?.toLowerCase() != StringHelper.sold.toLowerCase();
                                var productStatus = "${productDetails.status}" == "0";
                                return InkWell(
                                  onTap: () async {
                                    await context.push(Routes.myProduct,
                                        extra: productDetails);
                                    viewModel.onRefresh();
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    elevation: 0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                viewModel.getCreatedAt(
                                                    time: productDetails
                                                        .createdAt),
                                                style: context
                                                    .textTheme.titleSmall,
                                              ),
                                              PopupMenuButton<int>(
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.black,
                                                ),
                                                offset: const Offset(0, 40),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                onSelected: (int value) {
                                                  viewModel
                                                      .handelPopupMenuItemClick(
                                                          context: context,
                                                          index: value,
                                                          item: productDetails);
                                                },
                                                itemBuilder:
                                                    (BuildContext context) => <PopupMenuEntry<int>>[
                                                  if (productStatus && soldStatus) ...{
                                                    // PopupMenuItem(
                                                    //   value: 1,
                                                    //   child: Text(
                                                    //       StringHelper.edit),
                                                    // )
                                                    PopupMenuItem(
                                                      value: 2,
                                                      child: Text(StringHelper
                                                          .deactivate),
                                                    ),
                                                  },

                                                  PopupMenuItem(
                                                    value: 3,
                                                    child: Text(
                                                        StringHelper.remove),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const Gap(20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 6,
                                                  child: ImageView.rect(
                                                    placeholder:
                                                        AssetsRes.APP_LOGO,
                                                    image:
                                                        "${ApiConstants.imageUrl}/${productDetails.image}",
                                                    width: 250,
                                                    height: 100,
                                                    borderRadius: 10,
                                                  )),
                                              const Gap(10),
                                              Expanded(
                                                flex: 7,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      productDetails.name ?? '',
                                                      style: context.textTheme
                                                          .titleMedium,
                                                    ),
                                                    Text(
                                                      productDetails
                                                              .description ??
                                                          '',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: context
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontFamily: FontRes
                                                                  .MONTSERRAT_SEMIBOLD,
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    Text(
                                                      "${StringHelper.egp} ${productDetails.price}",
                                                      style: context
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Gap(10),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 05, vertical: 03),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(05)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.favorite,
                                                      size: 12,
                                                    ),
                                                    const Gap(02),
                                                    Text(
                                                      '${StringHelper.likes} ${productDetails.favouritesCount}',
                                                      style: context
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontFamily: FontRes
                                                                  .MONTSERRAT_MEDIUM),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.visibility,
                                                      size: 12,
                                                    ),
                                                    const Gap(02),
                                                    Text(
                                                      '${StringHelper.views} ${productDetails.countViews}',
                                                      style: context
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontFamily: FontRes
                                                                  .MONTSERRAT_MEDIUM),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.call,
                                                      size: 12,
                                                    ),
                                                    const Gap(02),
                                                    Text(
                                                      '${StringHelper.call}: ${productDetails.callCount}',
                                                      style: context
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontFamily: FontRes
                                                                  .MONTSERRAT_MEDIUM),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.chat,
                                                      size: 12,
                                                    ),
                                                    const Gap(02),
                                                    Text(
                                                      '${StringHelper.chat}: ${productDetails.chatCount}',
                                                      style: context
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontFamily: FontRes
                                                                  .MONTSERRAT_MEDIUM),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Gap(20),
                                        detailsWidget(
                                            context, viewModel, productDetails)
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Gap(20);
                              },
                            )
                          : const AppEmptyWidget(),
                ),
              ),
            ],
          );
  }

  detailsWidget(
    BuildContext context,
    MyAdsVM viewModel,
    ProductDetailModel productDetails,
  ) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              viewModel.getStatus(context: context,productDetails: productDetails),
              if (productDetails.sellStatus !=
                  StringHelper.sold.toLowerCase()) ...{
                viewModel.getRemainDays(item: productDetails)
              }
            ],
          ),
          const Gap(10),
          productDetails.sellStatus != StringHelper.sold.toLowerCase()
              ? Visibility(
                  visible: false,
                  child: Text(
                    StringHelper.thisAdisCurrentlyLive,
                    style: context.textTheme.labelMedium
                        ?.copyWith(fontFamily: FontRes.MONTSERRAT_MEDIUM),
                  ),
                )
              : Text(
                  StringHelper.thisAdisSold,
                  style: context.textTheme.labelMedium
                      ?.copyWith(fontFamily: FontRes.MONTSERRAT_MEDIUM),
                ),
          if("${productDetails.status}" == "0")...{
            AppElevatedButton(
              onTap: () {
                viewModel
                    .handelPopupMenuItemClick(
                    context: context,
                    index: 1,
                    item: productDetails);
              },
              title: StringHelper.edit,
              height: 30,
              width: context.width,
              backgroundColor: Colors.grey,
            ),
          }else...{
            if (productDetails.sellStatus != StringHelper.sold.toLowerCase()) ...{
              const Gap(10),
              InkWell(
                onTap: () async {
                  DialogHelper.showLoading();
                  await viewModel.markAsSoldApi(product: productDetails);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 08),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(08),
                  ),
                  child: Text(
                    StringHelper.markAsSold,
                    style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: InkWell(
              //         onTap: () async {
              //           DialogHelper.showLoading();
              //           await viewModel.markAsSoldApi(product: productDetails);
              //         },
              //         child: Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 08),
              //           decoration: BoxDecoration(
              //             color: Colors.black54,
              //             borderRadius: BorderRadius.circular(08),
              //           ),
              //           child: Text(
              //             StringHelper.markAsSold,
              //             style: context.textTheme.labelLarge?.copyWith(
              //                 color: Colors.white,
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const Gap(15),
              //     Expanded(
              //       child: InkWell(
              //         onTap: () => context.push(Routes.planList),
              //         child: Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 08),
              //           decoration: BoxDecoration(
              //             color: Colors.black54,
              //             borderRadius: BorderRadius.circular(08),
              //           ),
              //           child: Text(
              //             StringHelper.sellFasterNow,
              //             style: context.textTheme.labelLarge?.copyWith(
              //                 color: Colors.white,
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w600),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            }
          }
        ],
      ),
    );
  }
}
