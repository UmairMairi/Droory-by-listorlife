import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/skeletons/my_product_skeleton.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:list_and_life/base/utils/utils.dart';
import '../../base/helpers/dialog_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../res/assets_res.dart';
import '../../view_model/my_ads_v_m.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/card_swipe_widget.dart';
import '../../widgets/common_grid_view.dart';

class MyProductView extends StatefulWidget {
  final ProductDetailModel? data;
  const MyProductView({super.key, this.data});

  @override
  State<MyProductView> createState() => _MyProductViewState();
}

class _MyProductViewState extends State<MyProductView> {
  late ProductVM viewModel;

  @override
  void initState() {
    viewModel = context.read<ProductVM>();
    viewModel.getMyProductDetails(id: widget.data?.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: !viewModel.isAppBarVisible?AppBar(backgroundColor: Colors.transparent,automaticallyImplyLeading: false,toolbarHeight: 0,elevation: 0,):null,
      body: SafeArea(
        child: StreamBuilder<ProductDetailModel?>(
            stream: viewModel.productStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ProductDetailModel? productDetails = snapshot.data;
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
                            height: 350,
                            radius: 0,
                            data: productDetails,
                            imagesList: productDetails?.productMedias,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left:
                                Directionality.of(context) == TextDirection.ltr
                                    ? 0
                                    : null,
                            right:
                                Directionality.of(context) == TextDirection.rtl
                                    ? 0
                                    : null,
                            child: SafeArea(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: Icon(
                                    Directionality.of(context) ==
                                            TextDirection.ltr
                                        ? LineAwesomeIcons.arrow_left_solid
                                        : LineAwesomeIcons.arrow_right_solid,
                                    size: 28,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Share Button
                          Positioned(
                            top: 0,
                            left:
                                Directionality.of(context) == TextDirection.rtl
                                    ? 60
                                    : null,
                            right:
                                Directionality.of(context) == TextDirection.ltr
                                    ? 60
                                    : null,
                            child: SafeArea(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    Utils.onShareProduct(
                                      context,
                                      "Hello, Please check this useful product on following link",
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    size: 22,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Popup Menu Button
                          Positioned(
                            top: 0,
                            left:
                                Directionality.of(context) == TextDirection.rtl
                                    ? 10
                                    : null,
                            right:
                                Directionality.of(context) == TextDirection.ltr
                                    ? 10
                                    : null,
                            child: SafeArea(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: PopupMenuButton<int>(
                                  offset: const Offset(0, 40),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  onSelected: (int value) {
                                    var vm = context.read<MyAdsVM>();
                                    vm.handelPopupMenuItemClick(
                                        context: context,
                                        index: value,
                                        item: productDetails);
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<int>>[
                                    if ("${productDetails?.status}" == "1" &&
                                        productDetails?.sellStatus
                                                ?.toLowerCase() !=
                                            StringHelper.sold
                                                .toLowerCase()) ...{
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text(StringHelper.edit),
                                      )
                                    },
                                    if ("${productDetails?.adStatus}" !=
                                            "deactivate" &&
                                        "${productDetails?.status}" == "0" &&
                                        productDetails?.sellStatus
                                                ?.toLowerCase() !=
                                            StringHelper.sold
                                                .toLowerCase()) ...{
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text(StringHelper.deactivate),
                                      ),
                                    },
                                    if ("${productDetails?.adStatus}" ==
                                            "deactivate" &&
                                        "${productDetails?.status}" == "0" &&
                                        productDetails?.sellStatus
                                                ?.toLowerCase() !=
                                            StringHelper.sold
                                                .toLowerCase()) ...{
                                      PopupMenuItem(
                                        value: 4,
                                        child: Text("Republish"),
                                      ),
                                    },
                                    PopupMenuItem(
                                      value: 3,
                                      child: Text(StringHelper.remove),
                                    ),
                                  ],
                                  child: const Icon(
                                    Icons.more_vert_outlined,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                    productDetails?.name ?? '',
                                    style: context.textTheme.titleMedium,
                                  ),
                                ),
                                if ("${productDetails?.status}" != "0" &&
                                    productDetails?.sellStatus !=
                                        StringHelper.sold.toLowerCase()) ...{
                                  viewModel.getRemainDays(item: productDetails)
                                }
                              ],
                            ),
                            const Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  AssetsRes.IC_ITEM_LOCATION,
                                  scale: 2.5,
                                  color: Colors.black,
                                ),
                                const Gap(10),
                                Flexible(
                                  child: Text(
                                    productDetails?.nearby ?? '',
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                            if (productDetails?.categoryId == 9) ...{
                              Text(
                                "${StringHelper.egp} ${parseAmount(productDetails?.salleryFrom)} - ${StringHelper.egp} ${parseAmount(productDetails?.salleryTo)}",
                                style: context.textTheme.titleLarge
                                    ?.copyWith(color: Colors.red),
                              ),
                            } else ...{
                              Text(
                                "${StringHelper.egp} ${parseAmount(productDetails?.price)}",
                                style: context.textTheme.titleLarge
                                    ?.copyWith(color: Colors.red),
                              ),
                            },
                            const Gap(10),
                            productDetails?.sellStatus != StringHelper.soldText
                                ? Row(
                                    children: [
                                      if ("${productDetails?.adStatus}" !=
                                              "deactivate" &&
                                          productDetails?.sellStatus !=
                                              StringHelper.sold.toLowerCase() &&
                                          "${productDetails?.status}" != "0" &&
                                          "${productDetails?.status}" !=
                                              "2") ...{
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              DialogHelper.showLoading();
                                              await viewModel.markAsSoldApi(
                                                  product: productDetails!);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 08),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                StringHelper.markAsSold,
                                                style: context
                                                    .textTheme.labelLarge
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
                                      },
                                      if ("${productDetails?.adStatus}" !=
                                                  "deactivate" &&
                                              "${productDetails?.status}" ==
                                                  "0" ||
                                          "${productDetails?.status}" ==
                                              "2") ...[
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              var vm = context.read<MyAdsVM>();

                                              vm.handelPopupMenuItemClick(
                                                  context: context,
                                                  item: productDetails,
                                                  index: 1);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 08),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(08),
                                              ),
                                              child: Text(
                                                StringHelper.edit,
                                                style: context
                                                    .textTheme.labelLarge
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]

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
                            if (productDetails?.categoryId != 11) ...{
                              if (viewModel
                                  .getSpecifications(
                                      context: context, data: productDetails)
                                  .isNotEmpty) ...{
                                Text(StringHelper.specifications,
                                    style: context.textTheme.titleSmall),
                                const SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Wrap(
                                      spacing:
                                          20, // Horizontal spacing between items
                                      runSpacing:
                                          15, // Vertical spacing between items
                                      children: viewModel
                                          .getSpecifications(
                                              context: context,
                                              data: productDetails)
                                          .map((spec) => SizedBox(child: spec))
                                          .toList(),
                                    )
                                    // child: GridView(
                                    //   shrinkWrap: true,
                                    //   physics: const NeverScrollableScrollPhysics(),
                                    //   padding: const EdgeInsets.all(10),
                                    //   gridDelegate:
                                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                                    //           crossAxisCount: 3,
                                    //           mainAxisExtent: 50,
                                    //           mainAxisSpacing: 5,
                                    //           crossAxisSpacing: 20),
                                    //   children: viewModel.getSpecifications(
                                    //       context: context, data: productDetails),
                                    // ),
                                    ),
                              }
                            },
                            if (productDetails?.categoryId == 11) ...{
                              Text(
                                StringHelper.propertyInformation,
                                style: context.titleMedium,
                              ),
                              Gap(10),
                              getPropertyInformation(
                                      context: context, data: productDetails) ??
                                  SizedBox.shrink(),
                            },
                            if (productDetails?.categoryId == 11) ...{
                              Divider(),
                              Text(
                                StringHelper.amenities,
                                style: context.textTheme.titleMedium,
                              ),
                              Gap(10),
                              Visibility(
                                  visible: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        productDetails
                                                ?.productAmenities?.length ??
                                            0, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            getAmenityIcon(productDetails
                                                    ?.productAmenities?[index]
                                                    .amnity
                                                    ?.name ??
                                                ''),
                                            Gap(05),
                                            Text(DbHelper.getLanguage() == 'en'
                                                ? "${productDetails?.productAmenities?[index].amnity?.name}"
                                                : "${productDetails?.productAmenities?[index].amnity?.nameAr}"),
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
                                childAspectRatio: 16 / 16,
                                itemCount: viewModel.showAll
                                    ? productDetails
                                            ?.productAmenities?.length ??
                                        0
                                    : (productDetails?.productAmenities
                                                    ?.length ??
                                                0) <
                                            5
                                        ? productDetails
                                                ?.productAmenities?.length ??
                                            0
                                        : 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    color: Colors.grey.shade300,
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getAmenityIcon(productDetails
                                                  ?.productAmenities?[index]
                                                  .amnity
                                                  ?.name ??
                                              ''),
                                          Gap(05),
                                          Text(
                                            DbHelper.getLanguage() == 'en'
                                                ? "${productDetails?.productAmenities?[index].amnity?.name}"
                                                : "${productDetails?.productAmenities?[index].amnity?.nameAr}",
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Gap(10),
                              Visibility(
                                  visible: (productDetails
                                              ?.productAmenities?.length ??
                                          0) >
                                      5,
                                  child: GestureDetector(
                                      onTap: () {
                                        viewModel.showAll = !viewModel.showAll;
                                      },
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            viewModel.showAll
                                                ? StringHelper.seeLess
                                                : StringHelper.seeMore,
                                            style: context.textTheme.titleSmall,
                                          )))),
                            },
                            Divider(),
                            Text(
                              StringHelper.description,
                              style: context.textTheme.titleMedium,
                            ),
                            const Gap(05),
                            Text(productDetails?.description ?? ''),
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
      ),
    );
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return num.parse("${amount ?? 0}").toStringAsFixed(0);
  }

  getPropertyInformation(
      {required BuildContext context, ProductDetailModel? data}) {
    {
      List<Widget> specs = [];

      if ((data?.propertyFor ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(context, "${data?.propertyFor?.capitalized}",
            '🏠', 'Property For'));
      }
      if ((data?.area ?? 0) != 0) {
        specs.add(_buildInfoRow(context, "${data?.area} sqft", '📏', 'Area'));
      }
      if ((data?.bedrooms ?? 0) != 0) {
        specs.add(
            _buildInfoRow(context, "${data?.bedrooms}", '🛏️', 'Bedrooms'));
      }
      if ((data?.bathrooms ?? 0) != 0) {
        specs.add(
            _buildInfoRow(context, "${data?.bathrooms}", '🚽', 'Bathrooms'));
      }
      if ((data?.furnishedType ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(context, "${data?.furnishedType?.capitalized}",
            '🛋️', 'Furnished Type'));
      }
      if ((data?.ownership ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.ownership?.capitalized}", '📜', 'Ownership'));
      }
      if ((data?.paymentType ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(context, "${data?.paymentType?.capitalized}",
            '💳', 'Payment Type'));
      }
      if ((data?.completionStatus ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context,
            "${data?.completionStatus?.capitalized}",
            '✅',
            'Completion Status'));
      }

      if ((data?.deliveryTerm ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(context, (data?.deliveryTerm ?? "").capitalized,
            '🚚', 'Delivery Term'));
      }

      /// new data add without icon
      if ((data?.type ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.type?.capitalized}", '💳', 'Property Type'));
      }
      if ((data?.level ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.level?.capitalized}", '✅', 'Level'));
      }
      if ((data?.buildingAge ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.buildingAge?.capitalized}", '✅', 'Building Age'));
      }
      if ((data?.listedBy ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.listedBy?.capitalized}", '✅', 'Listed By'));
      }
      if ((data?.rentalPrice ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context,
            num.parse("${data?.rentalPrice ?? 0}").toStringAsFixed(0),
            '✅',
            'Rental Price'));
      }
      if ((data?.rentalTerm ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.rentalTerm?.capitalized}", '✅', 'Rental Term'));
      }
      if ((data?.deposit ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context,
            num.parse("${data?.deposit ?? 0}").toStringAsFixed(0),
            '✅',
            'Deposit'));
      }
      if ((data?.insurance ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${data?.insurance?.capitalized}", '✅', 'Insurance'));
      }
      if ((data?.accessToUtilities ?? "").isNotEmpty) {
        specs.add(_buildInfoRow(
            context,
            "${data?.accessToUtilities?.capitalized}",
            '✅',
            'Access To Utilities'));
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: specs,
      );
    }
  }

  // getPropertyInformation(
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

  // Widget getSpecifications({
  //   required BuildContext context,
  //   ProductDetailModel? productData,
  // }) {
  //   List<Widget> specs = [];

  //   if (productData?.categoryId == 4) {
  //     if (productData?.year != null && productData!.year != 0) {
  //       specs.add(_buildSpecRow(context, "${productData.year}", Icons.event));
  //     }
  //     if (productData?.kmDriven != null) {
  //       specs.add(
  //         _buildSpecRow(context, '${productData?.kmDriven}', Icons.speed),
  //       );
  //     }
  //     if (productData?.fuel != null && productData!.fuel!.isNotEmpty) {
  //       specs.add(_buildSpecRow(
  //         context,
  //         '${productData.fuel}',
  //         Icons.local_gas_station,
  //       ));
  //     }
  //   }

  //   if (productData?.categoryId == 11) {
  //     if (productData?.bedrooms != null && productData!.bedrooms != 0) {
  //       specs.add(_buildSpecRow(
  //         context,
  //         "${productData.bedrooms} Beds",
  //         Icons.king_bed,
  //       ));
  //     }
  //     if (productData?.bathrooms != null && productData!.bathrooms != 0) {
  //       specs.add(_buildSpecRow(
  //         context,
  //         "${productData.bathrooms} Baths",
  //         Icons.bathtub,
  //       ));
  //     }
  //     if (productData?.area != null && productData!.area != 0) {
  //       specs.add(_buildSpecRow(
  //         context,
  //         "${productData.area} Sqft",
  //         Icons.square_foot,
  //       ));
  //     }
  //   }

  //   if (specs.isNotEmpty) {
  //     return SizedBox(
  //       height: 20, // Enough height to display icon and text
  //       child: ListView.separated(
  //         scrollDirection: Axis.horizontal,
  //         shrinkWrap: true,
  //         itemCount: specs.length,
  //         itemBuilder: (context, index) => specs[index],
  //         separatorBuilder: (context, index) => VerticalDivider(
  //           width: 8, // The horizontal spacing between spec items
  //           thickness: 2, // How thick you want the divider line
  //           color: Colors.grey.shade400,
  //         ),
  //       ),
  //     );
  //   }

  //   return const SizedBox.shrink();
  // }

  // /// The spec row has no fixed width, so items can sit closer together.
  // Widget _buildSpecRow(BuildContext context, String specValue, IconData icon) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min, // Ensures the row is as small as needed
  //     children: [
  //       Icon(
  //         icon,
  //         size: 16.0,
  //         color: Colors.black87,
  //       ),
  //       const SizedBox(width: 4),
  //       Flexible(
  //         child: Text(
  //           specValue,
  //           style: const TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.black87,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
