import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/setting_item_model.dart';
import '../../res/assets_res.dart';
import '../../widgets/card_swipe_widget.dart';

class MyProductView extends StatelessWidget {
  final SettingItemModel? data;
  const MyProductView({super.key, this.data});

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
                        icon: const Icon(
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
                          InkWell(
                              onTap: () => Share.share(
                                  'Check my this product on List or lift app url: www.google.com'),
                              child: const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                              )),
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
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
                  const Gap(5),
                  Text(data?.description ?? ''),
                  const Gap(10),
                  Text(
                    data?.title ?? '',
                    style: context.textTheme.titleLarge
                        ?.copyWith(color: Colors.red),
                  ),
                  const Gap(10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 15, right: 10),
                    child: Table(
                      children: [
                        TableRow(children: [
                          Row(
                            children: [
                              Image.asset(
                                AssetsRes.IC_PETROL_ICON,
                                height: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Petrol',
                                style: context.textTheme.titleSmall,
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
                                '7000 KM',
                                style: context.textTheme.titleSmall,
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
                                'Automatic',
                                style: context.textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
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
                                  style: context.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
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
                                  'New York',
                                  style: context.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
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
                                  style: context.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ]),
                        const TableRow(children: [
                          Padding(
                            padding: EdgeInsets.only(left: 18, top: 5),
                            child: Text(
                              '2nd',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18, top: 5),
                            child: Text(
                              'City',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18, top: 5),
                            child: Text(
                              '30-Mar-24',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  const Gap(10),
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
                            style: context.textTheme.labelLarge?.copyWith(
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
