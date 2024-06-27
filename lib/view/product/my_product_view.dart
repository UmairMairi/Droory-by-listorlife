import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/date_helper.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/skeletons/product_detail_skeleton.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/setting_item_model.dart';
import '../../res/assets_res.dart';
import '../../widgets/card_swipe_widget.dart';

class MyProductView extends BaseView<ProductVM> {
  final ProductDetailModel? data;
  const MyProductView({super.key, this.data});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<ProductDetailModel?>(
              future: viewModel.getProductDetails(id: data?.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ProductDetailModel? data = snapshot.data;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CardSwipeWidget(
                          height: 300,
                          imagesList: data?.productMedias,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 20,
                            left: 20,
                            bottom: 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data?.name ?? '',
                                style: context.textTheme.titleMedium,
                              ),
                              const Gap(5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                  ),
                                  Gap(05),
                                  Text(data?.nearby ?? ''),
                                ],
                              ),
                              const Gap(10),
                              Text(
                                "EGP ${data?.price}",
                                style: context.textTheme.titleLarge
                                    ?.copyWith(color: Colors.red),
                              ),
                              const Gap(10),
                              if (data?.category?.name?.contains('Cars') ??
                                  false) ...{
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20, left: 15, right: 10),
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(4),
                                      2: FlexColumnWidth(4),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              AssetsRes.IC_PETROL_ICON,
                                              height: 15,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              data?.fuel ?? '',
                                              style:
                                                  context.textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AssetsRes.IC_SPEED_ICON,
                                              width: 17,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${data?.kmDriven}",
                                              style:
                                                  context.textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AssetsRes.IC_GEAR_ICON,
                                              height: 13,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${data?.transmission}',
                                              style:
                                                  context.textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AssetsRes.IC_USER_ICON,
                                                height: 15,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Owner',
                                                style: context
                                                    .textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AssetsRes.IC_LOACTION_ICON,
                                                height: 15,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'City',
                                                style: context
                                                    .textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AssetsRes.IC_CALENDER_ICON,
                                                height: 13,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Posting Date',
                                                style: context
                                                    .textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 18, top: 5),
                                          child: Text(
                                            '${data?.numberOfOwner}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 18, top: 5),
                                          child: Text(
                                            '${data?.city}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: 18, top: 5),
                                          child: Text(
                                            "${DateHelper.joiningDate(DateTime.parse('${data?.createdAt}'))}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                              },
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 08),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Mark as Sold',
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 08),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'Sell Faster Now',
                                        style: context.textTheme.labelLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              Text(
                                'Description',
                                style: context.textTheme.titleMedium,
                              ),
                              const Gap(05),
                              Text(data?.description ?? ''),
                              const Gap(20),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const AppErrorWidget();
                }
                return ProductDetailSkeleton(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                );
              }),
          Positioned(
              top: 10,
              left: 10,
              child: SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )),
          Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black26),
                      child: IconButton(
                          onPressed: () => Share.share(
                              'Check my this product on List or lift app url: www.google.com'),
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                          )),
                    ),
                    const Gap(05),
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black26),
                      child: PopupMenuButton<int>(
                        icon: const Icon(
                          Icons.more_vert_outlined,
                          color: Colors.white,
                        ),
                        offset: const Offset(0, 40),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        onSelected: (int item) {},
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text('Deactivate'),
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Text('Remove'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
