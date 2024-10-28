import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/date_helper.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/skeletons/my_product_skeleton.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../base/helpers/dialog_helper.dart';
import '../../base/helpers/dynamic_link_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../res/assets_res.dart';
import '../../view_model/my_ads_v_m.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/card_swipe_widget.dart';

class MyProductView extends BaseView<ProductVM> {
  final ProductDetailModel? data;
  const MyProductView({super.key, this.data});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              /*   final dynamicLink =
                  await DynamicLinkHelper.createDynamicLink("${data?.id}");
              debugPrint(dynamicLink.toString());

              Share.share(
                  'Hello, Please check this useful product on following link \n$dynamicLink',
                  subject: 'Check this issue');*/

              DialogHelper.showToast(message: "Coming Soon");
            },
            icon: const Icon(Icons.share_outlined),
          ),
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert_outlined,
            ),
            offset: const Offset(0, 40),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            onSelected: (int value) {
              var vm = context.read<MyAdsVM>();

              vm.handelPopupMenuItemClick(
                  context: context, index: value, item: data);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Text(StringHelper.edit),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(StringHelper.deactivate),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(StringHelper.remove),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<ProductDetailModel?>(
          future: viewModel.getProductDetails(id: data?.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ProductDetailModel? data = snapshot.data;
              data?.productMedias?.insert(0, ProductMedias(media: data.image));

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CardSwipeWidget(
                      height: 220,
                      data: data,
                      imagesList: data?.productMedias?.toList(),
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
                              const Gap(05),
                              Text(data?.nearby ?? ''),
                            ],
                          ),
                          const Gap(10),
                          Text(
                            "${StringHelper.egp} ${data?.price}",
                            style: context.textTheme.titleLarge
                                ?.copyWith(color: Colors.red),
                          ),
                          const Gap(10),
                          if (data?.category?.name
                                  ?.contains(StringHelper.cars) ??
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
                                          "${data?.kmDriven}",
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
                                          '${data?.transmission}',
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
                                            StringHelper.owner,
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
                                            StringHelper.city,
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
                                            StringHelper.postingDate,
                                            style: context.textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, top: 5),
                                      child: Text(
                                        '${data?.numberOfOwner}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, top: 5),
                                      child: Text(
                                        '${data?.city}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, top: 5),
                                      child: Text(
                                        DateHelper.joiningDate(DateTime.parse(
                                            '${data?.createdAt}')),
                                        style: const TextStyle(
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
                          data?.sellStatus != StringHelper.soldText
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          DialogHelper.showLoading();
                                          await viewModel.markAsSoldApi(
                                              product: data!);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 08),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            StringHelper.markAsSold,
                                            style: context.textTheme.labelLarge
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(10),
                                    /*Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 08),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          StringHelper.sellFasterNow,
                                          style: context.textTheme.labelLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),*/
                                  ],
                                )
                              : AppElevatedButton(
                                  title: StringHelper.soldText,
                                  height: 30,
                                  width: 100,
                                  backgroundColor: Colors.grey,
                                ),
                          const Gap(10),
                          if (viewModel
                              .getSpecifications(context: context, data: data)
                              .isNotEmpty) ...{
                            Text('Specifications',
                                style: context.textTheme.titleMedium),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              child: GridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisExtent: 50,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 20),
                                children: viewModel.getSpecifications(
                                    context: context, data: data),
                              ),
                            ),
                          },
                          const Gap(10),
                          if (data?.categoryId == 11) ...{
                            Text(
                              StringHelper.amenities,
                              style: context.textTheme.titleMedium,
                            ),
                            const Gap(10),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data?.productAmenities?.length,
                                itemBuilder: (context, index) {
                                  return Text(DbHelper.getLanguage() == 'en'
                                      ? "✧ ${data?.productAmenities?[index].amnity?.name}"
                                      : "✧ ${data?.productAmenities?[index].amnity?.nameAr}");
                                }),
                          },
                          Text(
                            StringHelper.description,
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
            return MyProductSkeleton(
              isLoading: snapshot.connectionState == ConnectionState.waiting,
            );
          }),
    );
  }
}
