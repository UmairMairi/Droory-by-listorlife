import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:share_plus/share_plus.dart';

import '../../helpers/dialog_helper.dart';
import '../../routes/app_routes.dart';
import '../../widgets/card_swipe_widget.dart';
import '../../widgets/favorite_button.dart';

class ProductDetailView extends BaseView<ProductVM> {
  final SettingItemModel? data;
  const ProductDetailView({super.key, required this.data});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
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
                          context.pop();
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
                            child: FavoriteButton(
                              isFav: data?.isFav ?? false,
                              onTap: () {},
                            ),
                          ),
                          InkWell(
                            onTap: () => Share.share(
                                'Check my this product on List or lift app url: www.google.com'),
                            child: Container(
                              padding: const EdgeInsets.all(08),
                              margin: const EdgeInsets.all(08),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.share_outlined),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                  /*Card(
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
                                  const Gap(05),
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
                                  const Gap(05),
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
                                const Gap(05),
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
                                  const Gap(05),
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
                                  const Gap(05),
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
                                  const Gap(10),
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
                  ),*/
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
                  Text(
                    'Description',
                    style: context.textTheme.titleMedium,
                  ),
                  const Gap(05),
                  Text(data?.longDescription ?? ''),
                  const Gap(10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage(AssetsRes.DUMMY_PROFILE),
                          ),
                          const Gap(20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posted by',
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                              Text(
                                'John Marker',
                                style: context.textTheme.titleLarge,
                              ),
                              Text(
                                'Posted On:30/03/2024',
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  context.push(Routes.seeProfile);
                                },
                                child: Text(
                                  'See Profile',
                                  style: context.textTheme.titleSmall?.copyWith(
                                      color: Colors.red,
                                      decorationColor: Colors.red,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AssetsRes.IC_LOACTION_ICON,
                                height: 24,
                              ),
                              const Gap(05),
                              Text(
                                'New York',
                                style: context.textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const Gap(05),
                          Text(
                            'City',
                            style: context.textTheme.titleLarge,
                          ),
                          const Gap(25),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Get Direction',
                              style: context.textTheme.titleSmall?.copyWith(
                                  color: Colors.red,
                                  decorationColor: Colors.red,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                      const Gap(10),
                      Expanded(
                          child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AssetsRes.DUMMY_MAP_IMAGE),
                          Image.asset(
                            AssetsRes.DUMMY_CIRCLE_MAP,
                            height: 60,
                          ),
                        ],
                      )),
                    ],
                  ),
                  const Gap(20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => DialogHelper.goToUrl(
                                uri: Uri.parse("tel://+919876543210")),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 08),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_CALL_ICON,
                                    height: 16,
                                  ),
                                  const Gap(05),
                                  Text(
                                    'Call',
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(08),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context.push(
                                Routes.message,
                                extra: SettingItemModel(
                                  icon: AssetsRes.DUMMY_CHAT_IMAGE2,
                                  title: 'John Marker',
                                  subTitle: 'Lorem Ipsum is simply dummy text.',
                                  timeStamp: '1 min ago',
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 08),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_CHAT_ICON,
                                    height: 16,
                                  ),
                                  const Gap(05),
                                  Text(
                                    'Chat',
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(08),
                        Expanded(
                          child: InkWell(
                            onTap: () => DialogHelper.goToUrl(
                                uri: Uri.parse(
                                    'https://wa.me/+919876543210?text=Hii, I am from List & Live app and interested in your ad.')),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 08),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_WHATSAPP_ICON,
                                    height: 18,
                                  ),
                                  const Gap(05),
                                  Text(
                                    'Whatsapp',
                                    style:
                                        context.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
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
