import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/date_helper.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/models/product_detail_model.dart';
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
import '../../widgets/common_grid_view.dart';
import '../../widgets/like_button.dart';

class MyProductView extends BaseView<ProductVM> {
  final ProductDetailModel? data;
  const MyProductView({super.key, this.data});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
    return Scaffold(
      appBar: !viewModel.isAppBarVisible?AppBar(backgroundColor: Colors.transparent,automaticallyImplyLeading: false,toolbarHeight: 0,elevation: 0,):null,

      /*appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              */ /*   final dynamicLink =
                  await DynamicLinkHelper.createDynamicLink("${data?.id}");
              debugPrint(dynamicLink.toString());

              Share.share(
                  'Hello, Please check this useful product on following link \n$dynamicLink',
                  subject: 'Check this issue');*/ /*

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
      ),*/
      body: FutureBuilder<ProductDetailModel?>(
          future: viewModel.getProductDetails(id: data?.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ProductDetailModel? data = snapshot.data;
              data?.productMedias?.insert(0, ProductMedias(media: data.image));

              return SingleChildScrollView(
                controller: viewModel.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CardSwipeWidget(
                          height: 300,
                          data: data,
                          imagesList: data?.productMedias,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: SafeArea(
                              child: IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white)),
                            )),
                        Positioned(
                            top: 0,
                            right: 50,
                            child: SafeArea(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.share, color: Colors.white)),
                            )),
                        Positioned(
                            top: 0,
                            right: 10,
                            child: SafeArea(
                              child: PopupMenuButton<int>(
                                icon: const Icon(
                                  Icons.more_vert_outlined,
                                  color: Colors.white,
                                ),
                                offset: const Offset(0, 40),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                onSelected: (int value) {
                                  var vm = context.read<MyAdsVM>();

                                  vm.handelPopupMenuItemClick(
                                      context: context,
                                      index: value,
                                      item: data);
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
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
                              ),
                            )),
                      ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  data?.name ?? '',
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                              if (data?.sellStatus !=
                                  StringHelper.sold.toLowerCase()) ...{
                                viewModel.getRemainDays(item: data)
                              }
                            ],
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
                          if (data?.categoryId == 9) ...{
                            Text(
                              "${StringHelper.egp} ${data?.salleryFrom} - ${data?.salleryTo}",
                              style: context.textTheme.titleLarge
                                  ?.copyWith(color: Colors.red),
                            ),
                          } else ...{
                            Text(
                              "${StringHelper.egp} ${data?.price}",
                              style: context.textTheme.titleLarge
                                  ?.copyWith(color: Colors.red),
                            ),
                          },
                          const Gap(10),
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
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          var vm = context.read<MyAdsVM>();

                                          vm.navigateToEditProduct(
                                              context: context, item: data);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 08),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(08),
                                          ),
                                          child: Text(
                                            StringHelper.edit,
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
                          Divider(),
                          if (data?.categoryId != 11) ...{
                            if (viewModel
                                .getSpecifications(context: context, data: data)
                                .isNotEmpty) ...{
                              Text('Specifications',
                                  style: context.textTheme.titleMedium),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
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
                            }
                          },
                          if (data?.categoryId == 11) ...{
                            Text(
                              'Property Information',
                              style: context.titleMedium,
                            ),
                            Gap(10),
                            getPropertyInformation(
                                    context: context, data: data) ??
                                SizedBox.shrink(),
                          },
                          if (data?.categoryId == 11) ...{
                            Divider(),
                            Text(
                              StringHelper.amenities,
                              style: context.textTheme.titleMedium,
                            ),
                            Gap(10),
                            Visibility(
                              visible: false,
                                child:Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  data?.productAmenities?.length ?? 0, (index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      getAmenityIcon(data
                                              ?.productAmenities?[index]
                                              .amnity
                                              ?.name ??
                                          ''),
                                      Gap(05),
                                      Text(DbHelper.getLanguage() == 'en'
                                          ? "${data?.productAmenities?[index].amnity?.name}"
                                          : "${data?.productAmenities?[index].amnity?.nameAr}"),
                                    ],
                                  ),
                                );
                              }),
                            )),
                            CommonGridView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              //mainAxisExtent: 120,
                              crossAxisCount: 3,
                              childAspectRatio: 16/16,
                              itemCount: data?.productAmenities?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: Colors.grey.shade300,
                                  elevation: 0,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        getAmenityIcon(data
                                            ?.productAmenities?[index]
                                            .amnity
                                            ?.name ??
                                            ''),
                                        Gap(05),
                                        Text(DbHelper.getLanguage() == 'en'
                                            ? "${data?.productAmenities?[index].amnity?.name}"
                                            : "${data?.productAmenities?[index].amnity?.nameAr}",textAlign: TextAlign.center,),
                                      ],
                                    ),
                                  ),
                                );
                              },)
                          },
                          Divider(),
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

  getPropertyInformation(
      {required BuildContext context, ProductDetailModel? data}) {
    {
      List<Widget> specs = [];

      if (data?.propertyFor != null && data!.propertyFor!.isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data.propertyFor?.capitalized}", '🏠', 'Property For'));
      }
      if (data?.area != null && data!.area != 0) {
        specs.add(_buildInfoRow(context, "${data.area} sqft", '📏', 'Area'));
      }
      if (data?.bedrooms != null && data!.bedrooms != 0) {
        specs
            .add(_buildInfoRow(context, "${data.bedrooms}", '🛏️', 'Bedrooms'));
      }
      if (data?.bathrooms != null && data!.bathrooms != 0) {
        specs.add(
            _buildInfoRow(context, "${data.bathrooms}", '🚽', 'Bathrooms'));
      }
      if (data?.furnishedType != null && data!.furnishedType!.isNotEmpty) {
        specs.add(_buildInfoRow(context, "${data.furnishedType?.capitalized}",
            '🛋️', 'Furnished Type'));
      }
      if (data?.ownership != null && data!.ownership!.isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data.ownership?.capitalized}", '📜', 'Ownership'));
      }
      if (data?.paymentType != null && data!.paymentType!.isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data.paymentType?.capitalized}", '💳', 'Payment Type'));
      }
      if (data?.completionStatus != null &&
          data!.completionStatus!.isNotEmpty) {
        specs.add(_buildInfoRow(context,
            "${data.completionStatus?.capitalized}", '✅', 'Completion Status'));
      }
      if (data?.deliveryTerm != null && data!.deliveryTerm!.isNotEmpty) {
        specs.add(_buildInfoRow(context, "${data.deliveryTerm?.capitalized}",
            '🚚', 'Delivery Term'));
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: specs,
      );
    }
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: context.titleSmall,
          ),
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Icon getAmenityIcon(String amenityName) {
    // Define a map that links each amenity name to an icon
    final Map<String, IconData> amenityIconMap = {
      "Intercom": Icons.phone,
      "Security": Icons.security,
      "Storage": Icons.store_mall_directory,
      "Broadband Internet": Icons.wifi,
      "Garage Parking": Icons.local_parking,
      "Elevator": Icons.elevator,
      "Landline": Icons.phone_in_talk,
      "Natural Gas": Icons.local_fire_department,
      "Water Meter": Icons.water_drop,
      "Electricity Meter": Icons.bolt,
      "Pool": Icons.pool,
      "Pets Allowed": Icons.pets,
      "Maids Room": Icons.bed,
      "Parking": Icons.directions_car,
      "Central A/C and Heating":
          Icons.ac_unit, // Can use separate icons if needed
      "Private Garden": Icons.grass,
      "Installed Kitchen": Icons.kitchen,
      "Balcony": Icons.balcony,
    };

    // Return the icon if found in the map, otherwise return a default icon
    return Icon(
      amenityIconMap[amenityName] ?? Icons.help_outline,
      color: Colors.blueGrey, // "help_outline" as a default icon
    );
  }
}
