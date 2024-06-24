import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';

import '../../../helpers/db_helper.dart';
import '../../../view_model/my_ads_v_m.dart';
import '../../../widgets/unauthorised_view.dart';

class MyAdsView extends BaseView<MyAdsVM> {
  const MyAdsView({super.key});

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return DbHelper.getIsGuest()
        ? const UnauthorisedView()
        : ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: 1,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.push(Routes.myProduct,
                      extra: viewModel.favItemList[index + 1]);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade200, width: 2.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'From:25 APR 2024 TO 25 MAY 2024',
                              style: context.textTheme.titleSmall,
                            ),
                            PopupMenuButton<int>(
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.black,
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
                            )
                          ],
                        ),
                      ),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  AssetsRes.DUMMY_CAR_IMAGE1,
                                ),
                              ),
                            ),
                            const Gap(10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Maruti Suzuki Swift',
                                  style: context.textTheme.titleMedium,
                                ),
                                Text(
                                  '2015 - 48000.0 km',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                          fontFamily:
                                              FontRes.MONTSERRAT_SEMIBOLD,
                                          color: Colors.grey),
                                ),
                                Text(
                                  'EGP300',
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: Colors.red),
                                ),
                                const Gap(10),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 05),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 03),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(05)),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        size: 12,
                                      ),
                                      const Gap(02),
                                      Text(
                                        'Likes: 5',
                                        style: context.textTheme.labelMedium
                                            ?.copyWith(
                                                fontFamily:
                                                    FontRes.MONTSERRAT_MEDIUM),
                                      ),
                                      const Gap(10),
                                      const Icon(
                                        Icons.visibility,
                                        size: 12,
                                      ),
                                      const Gap(02),
                                      Text(
                                        'Views: 10',
                                        style: context.textTheme.labelMedium
                                            ?.copyWith(
                                                fontFamily:
                                                    FontRes.MONTSERRAT_MEDIUM),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Gap(20),
                      Container(
                        width: context.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                            AppElevatedButton(
                              onTap: () {},
                              title: 'Active',
                              height: 30,
                              width: 100,
                              backgroundColor: Colors.red,
                            ),
                            const Gap(10),
                            Text(
                              'This ad is currently live',
                              style: context.textTheme.labelMedium?.copyWith(
                                  fontFamily: FontRes.MONTSERRAT_MEDIUM),
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
                                      borderRadius: BorderRadius.circular(08),
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
                                const Gap(15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => context.push(Routes.planList),
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 08),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(08),
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
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Gap(20);
            },
          );
  }
}
