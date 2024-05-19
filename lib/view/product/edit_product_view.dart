import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';

import '../../models/setting_item_model.dart';
import '../../res/assets_res.dart';
import '../../widgets/card_swipe_widget.dart';

class EditProductView extends StatelessWidget {
  final SettingItemModel? data;
  const EditProductView({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CardSwipeWidget(
                  height: 400,
                  imagesList: data?.imageList,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 10,
                    child: SafeArea(
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                Positioned(
                    top: 10,
                    right: 10,
                    child: SafeArea(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(08),
                            margin: const EdgeInsets.all(08),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(Icons.share_outlined),
                          ),
                          PopupMenuButton<int>(
                            icon: const Icon(Icons.more_vert_outlined),
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
                        ],
                      ),
                    )),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data?.subTitle ?? '',
                    style: context.textTheme.titleMedium,
                  ),
                  Gap(5),
                  Text(data?.description ?? ''),
                  Gap(10),
                  Text(
                    data?.title ?? '',
                    style: context.textTheme.titleLarge
                        ?.copyWith(color: Colors.red),
                  ),
                  const Gap(10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_PETROL_ICON,
                                    height: 18,
                                  ),
                                  Gap(05),
                                  Text(
                                    'Petrol',
                                    style: context.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_SPEED_ICON,
                                    height: 18,
                                  ),
                                  Gap(05),
                                  Text(
                                    '70,000.0 KM',
                                    style: context.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              Row(children: [
                                Image.asset(
                                  AssetsRes.IC_GEAR_ICON,
                                  height: 18,
                                ),
                                Gap(05),
                                Text(
                                  'Automatic',
                                  style: context.textTheme.titleMedium,
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_USER_ICON,
                                    height: 18,
                                  ),
                                  Gap(05),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Owner',
                                        style: context.textTheme.titleMedium,
                                      ),
                                      Text(
                                        '2nd',
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_LOACTION_ICON,
                                    height: 18,
                                  ),
                                  Gap(05),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'New York',
                                        style: context.textTheme.titleMedium,
                                      ),
                                      Text(
                                        'City',
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_CALENDER_ICON,
                                    height: 18,
                                  ),
                                  Gap(05),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Posting Date',
                                        style: context.textTheme.titleMedium,
                                      ),
                                      Text(
                                        '30-Mar-24',
                                        style: context.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 08),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Mark as Sold',
                            style: context.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Gap(10),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 08),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Sell Faster Now',
                            style: context.textTheme.labelLarge?.copyWith(
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
                  Text(data?.longDescription ?? ''),
                  const Gap(20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
