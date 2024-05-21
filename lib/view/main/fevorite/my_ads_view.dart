import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view/product/my_product_view.dart';

import '../../../view_model/my_ads_v_m.dart';

class MyAdsView extends BaseView<MyAdsVM> {
  const MyAdsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, MyAdsVM viewModel) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: 1,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyProductView(data: viewModel.favItemList[index + 1])));
          },
          child: Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.grey.shade200, width: 2.0),
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From:25 APR 2024 TO 25 MAY 2024',
                        style: context.textTheme.titleSmall,
                      ),
                      Icon(Icons.more_horiz),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            AssetsRes.DUMMY_CAR_IMAGE1,
                            width: 150,
                          ),
                        ),
                      ),
                      Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Maruti Suzuki Swift',
                            style: context.textTheme.titleSmall,
                          ),
                          Text(
                            '2015 - 48000.0 km',
                            style: context.textTheme.labelSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          Text(
                            'EGP300',
                            style: context.textTheme.titleLarge
                                ?.copyWith(color: Colors.red),
                          ),
                          const Gap(10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 05),
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
                                  style: context.textTheme.labelSmall,
                                ),
                                const Gap(10),
                                const Icon(
                                  Icons.visibility,
                                  size: 12,
                                ),
                                const Gap(02),
                                Text(
                                  'Views: 10',
                                  style: context.textTheme.labelSmall,
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Gap(20),
                  Container(
                    width: context.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Active '),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white),
                        ),
                        const Gap(05),
                        Text(
                          'This ad is currently live',
                          style: context.textTheme.labelSmall,
                        ),
                        const Gap(05),
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
                              child: InkWell(
                                onTap: () => context.push(Routes.planList),
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
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Gap(20);
      },
    );
  }
}
