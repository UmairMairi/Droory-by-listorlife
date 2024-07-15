import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../res/assets_res.dart';
import '../res/font_res.dart';

class ProductDetailSkeleton extends StatelessWidget {
  final bool isLoading;
  const ProductDetailSkeleton({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(0, 1),
                  blurRadius: 6,
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Image.asset(AssetsRes.DUMMY_CAR_IMAGE1),
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
                    'Maruti Suzuki Swift 1.2 VXI (O), 2015, Petrol',
                    style: context.textTheme.titleMedium,
                  ),
                  const Gap(5),
                  const Text('2015 - 48000 km'),
                  const Gap(10),
                  Text(
                    'EGP300',
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
                  const Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                  Card(
                    color: const Color(0xfff5f5f5),
                    elevation: 0,
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
                                style: context.textTheme.titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              Text(
                                'John Marker',
                                style: context.textTheme.titleLarge
                                    ?.copyWith(
                                    fontFamily:
                                    FontRes.MONTSERRAT_SEMIBOLD),
                              ),
                              Text(
                                'Posted On:30/03/2024',
                                style: context.textTheme.titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const Gap(10),
                              Text(
                                'See Profile',
                                style: context.textTheme.titleSmall
                                    ?.copyWith(
                                    color: Colors.red,
                                    decorationColor: Colors.red,
                                    decoration:
                                    TextDecoration.underline),
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
                          Text(
                            'Get Direction',
                            style: context.textTheme.titleSmall?.copyWith(
                                color: Colors.red,
                                decorationColor: Colors.red,
                                decoration: TextDecoration.underline),
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
                  const Gap(30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
