import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/skeletons/my_product_skeleton.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:provider/provider.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';
import "package:list_and_life/view/product/product_location_map_view.dart";
import '../../base/helpers/dialog_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../base/helpers/string_helper.dart';
import 'package:list_and_life/widgets/utilities_display_widget.dart';
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
    super.initState();
    viewModel = ProductVM();
    // Call the method that fetches fresh metrics
    _refreshProductData();
  }

  // Updated method to get fresh metrics from the same API as MyAdsView
  Future<void> _refreshProductData() async {
    // Use the new method that fetches from user products API (with fresh metrics)
    await viewModel.getMyProductDetailsWithFreshMetrics(id: widget.data?.id);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // --- Location Helper Methods (now correctly inside the class and declared once) ---
  bool _isCurrentLanguageArabic() {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String getLocalizedLocationFromCoordinates(
      BuildContext context, double? lat, double? lng) {
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      return _isCurrentLanguageArabic() ? "كل مصر" : "All Egypt";
    }

    bool isArabic = _isCurrentLanguageArabic();
    CityModel? nearestCity = LocationService.findNearestCity(lat, lng);

    if (nearestCity != null) {
      if (nearestCity.districts != null) {
        for (var district in nearestCity.districts!) {
          if (district.neighborhoods != null) {
            for (var neighborhood in district.neighborhoods!) {
              double distance = LocationService.calculateDistance(
                  lat, lng, neighborhood.latitude, neighborhood.longitude);
              if (distance <= (neighborhood.radius ?? 2.0)) {
                return isArabic
                    ? "${neighborhood.arabicName}، ${district.arabicName}، ${nearestCity.arabicName}"
                    : "${neighborhood.name}, ${district.name}, ${nearestCity.name}";
              }
            }
          }
          double distanceToDistrict = LocationService.calculateDistance(
              lat, lng, district.latitude, district.longitude);
          if (distanceToDistrict <= (district.radius ?? 5.0)) {
            return isArabic
                ? "${district.arabicName}، ${nearestCity.arabicName}"
                : "${district.name}, ${nearestCity.name}";
          }
        }
      }
      return isArabic ? nearestCity.arabicName : nearestCity.name;
    }
    return isArabic ? "كل مصر" : "All Egypt";
  }

  String getLocalizedLocation(ProductDetailModel? data) {
    bool isArabic = _isCurrentLanguageArabic();

    if (data == null) {
      return isArabic ? "مصر" : "Egypt";
    }

    // Priority 1: Use stored English names
    if (data.city != null && data.city!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(data.city!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;
        String districtName = "";
        String neighborhoodName = "";

        if (data.districtName != null && data.districtName!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, data.districtName!);
          if (districtModel != null) {
            districtName =
                isArabic ? districtModel.arabicName : districtModel.name;

            if (data.neighborhoodName != null &&
                data.neighborhoodName!.isNotEmpty) {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, data.neighborhoodName!);
              if (neighborhoodModel != null) {
                neighborhoodName = isArabic
                    ? neighborhoodModel.arabicName
                    : neighborhoodModel.name;
                return "$neighborhoodName، $districtName، $cityName";
              }
            }
            return "$districtName، $cityName";
          }
        }
        return cityName;
      }
    }

    // Priority 2: Coordinates
    if (data.latitude != null && data.longitude != null) {
      double? lat = double.tryParse(data.latitude!);
      double? lng = double.tryParse(data.longitude!);

      if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
        return getLocalizedLocationFromCoordinates(context, lat, lng);
      }
    }

    // Priority 3: Nearby
    if (data.nearby != null && data.nearby!.isNotEmpty) {
      return data.nearby!;
    }

    return isArabic ? "مصر" : "Egypt";
  }
  // --- End of Location Helper Methods ---

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductVM>.value(
      value: viewModel,
      child: Consumer<ProductVM>(
        builder: (context, vm, child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                StreamBuilder<ProductDetailModel?>(
                  stream: vm.productStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProductDetailModel? productDetails = snapshot.data;
                      final bool isJobListing = productDetails?.categoryId == 9;
                      return SingleChildScrollView(
                        controller: vm.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Only show image carousel if NOT a job listing
                            if (!isJobListing)
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
                                    left: Directionality.of(context) ==
                                            TextDirection.ltr
                                        ? 0
                                        : null,
                                    right: Directionality.of(context) ==
                                            TextDirection.rtl
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
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
                                                ? LineAwesomeIcons
                                                    .arrow_left_solid
                                                : LineAwesomeIcons
                                                    .arrow_right_solid,
                                            size: 28,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 0,
                                  //   left: Directionality.of(context) ==
                                  //           TextDirection.rtl
                                  //       ? 60
                                  //       : null,
                                  //   right: Directionality.of(context) ==
                                  //           TextDirection.ltr
                                  //       ? 60
                                  //       : null,
                                  //   child: SafeArea(
                                  //     child: Container(
                                  //       margin: const EdgeInsets.all(8),
                                  //       width: 40,
                                  //       height: 40,
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         shape: BoxShape.circle,
                                  //         boxShadow: [
                                  //           BoxShadow(
                                  //             color:
                                  //                 Colors.black.withOpacity(0.1),
                                  //             spreadRadius: 1,
                                  //             blurRadius: 3,
                                  //             offset: const Offset(0, 1),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       child: IconButton(
                                  //         padding: EdgeInsets.zero,
                                  //         constraints: const BoxConstraints(),
                                  //         onPressed: () {
                                  //           Utils.onShareProduct(
                                  //             context,
                                  //             "Hello, Please check this useful product on following link",
                                  //           );
                                  //         },
                                  //         icon: const Icon(
                                  //           Icons.share,
                                  //           size: 22,
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Positioned(
                                    top: 0,
                                    left: Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? 10
                                        : null,
                                    right: Directionality.of(context) ==
                                            TextDirection.ltr
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: PopupMenuButton<int>(
                                          offset: const Offset(0, 40),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                          ),
                                          onSelected: (int value) async {
                                            var myAdsVm =
                                                context.read<MyAdsVM>();

                                            if (value == 1) {
                                              // Edit option
                                              await myAdsVm
                                                  .navigateToEditProduct(
                                                context: context,
                                                item: productDetails,
                                              );
                                              // Refresh the data after edit
                                              await viewModel
                                                  .getMyProductDetailsWithFreshMetrics(
                                                id: productDetails?.id,
                                              );
                                            } else {
                                              // Handle other options normally
                                              await myAdsVm
                                                  .handelPopupMenuItemClick(
                                                context: context,
                                                index: value,
                                                item: productDetails,
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<int>>[
                                            if ("${productDetails?.status}" ==
                                                    "1" &&
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
                                                "${productDetails?.status}" ==
                                                    "0" &&
                                                productDetails?.sellStatus
                                                        ?.toLowerCase() !=
                                                    StringHelper.sold
                                                        .toLowerCase()) ...{
                                              PopupMenuItem(
                                                value: 2,
                                                child: Text(
                                                    StringHelper.deactivate),
                                              ),
                                            },
                                            if ("${productDetails?.adStatus}" ==
                                                    "deactivate" &&
                                                "${productDetails?.status}" ==
                                                    "0" &&
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

                            // For job listings, show a simple header without image
                            if (isJobListing)
                              SafeArea(
                                child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          context.pop();
                                        },
                                        icon: Icon(
                                          Directionality.of(context) ==
                                                  TextDirection.ltr
                                              ? LineAwesomeIcons.arrow_left_solid
                                              : LineAwesomeIcons
                                                  .arrow_right_solid,
                                          size: 28,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Share Button
                                      // Container(
                                      //   width: 40,
                                      //   height: 40,
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.grey.shade100,
                                      //     shape: BoxShape.circle,
                                      //   ),
                                      //   child: IconButton(
                                      //     padding: EdgeInsets.zero,
                                      //     constraints: const BoxConstraints(),
                                      //     onPressed: () {
                                      //       Utils.onShareProduct(
                                      //         context,
                                      //         "Hello, Please check this useful product on following link",
                                      //       );
                                      //     },
                                      //     icon: const Icon(
                                      //       Icons.share,
                                      //       size: 22,
                                      //       color: Colors.black,
                                      //     ),
                                      //   ),
                                      // ),
                                      const Gap(8),
                                      // More options menu
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: PopupMenuButton<int>(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.more_vert_outlined,
                                            size: 24,
                                            color: Colors.black,
                                          ),
                                          offset: const Offset(0, 40),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                          ),
                                          onSelected: (int value) async {
                                            var myAdsVm = context.read<MyAdsVM>();

                                            if (value == 1) {
                                              // Edit option
                                              await myAdsVm.navigateToEditProduct(
                                                context: context,
                                                item: productDetails,
                                              );
                                              // Refresh the data after edit
                                              await viewModel.getMyProductDetailsWithFreshMetrics(id: productDetails?.id,);
                                            } else {
                                              // Handle other options normally
                                              await myAdsVm
                                                  .handelPopupMenuItemClick(
                                                context: context,
                                                index: value,
                                                item: productDetails,
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<int>>[
                                            if ("${productDetails?.status}" ==
                                                    "1" &&
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
                                                "${productDetails?.status}" ==
                                                    "0" &&
                                                productDetails?.sellStatus
                                                        ?.toLowerCase() !=
                                                    StringHelper.sold
                                                        .toLowerCase()) ...{
                                              PopupMenuItem(
                                                value: 2,
                                                child:
                                                    Text(StringHelper.deactivate),
                                              ),
                                            },
                                            if ("${productDetails?.adStatus}" ==
                                                    "deactivate" &&
                                                "${productDetails?.status}" ==
                                                    "0" &&
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            Padding(
                              padding: EdgeInsets.only(
                                top: isJobListing ? 0 : 10,
                                right: 20,
                                left: 20,
                                bottom: 40,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isJobListing) const Gap(20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              StringHelper.sold
                                                  .toLowerCase()) ...{
                                        vm.getRemainDays(item: productDetails)
                                      }
                                    ],
                                  ),
                                  if (isJobListing) ...{
                                    const Gap(8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        StringHelper.lookingFor,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  },
                                  if (productDetails?.categoryId == 11 &&
                                      productDetails?.propertyFor != null) ...{
                                    const Gap(8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        Utils.getPropertyType(
                                            "${productDetails?.propertyFor ?? ""}"),
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  },
                                  // Reduced spacing for categories without badges/specs
                                  Gap(productDetails?.categoryId == 9 ||
                                          productDetails?.categoryId == 11 ||
                                          productDetails?.categoryId == 4
                                      ? 8
                                      : 5),
                                  if (productDetails?.categoryId == 9) ...{
                                    getJobSpecifications(
                                        context: context,
                                        productData: productDetails),
                                    const Gap(12),
                                  },
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/location.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const Gap(12),
                                      Flexible(
                                        child: Text(
                                          getLocalizedLocation(productDetails),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),

                                  if (productDetails?.categoryId == 9) ...{
                                    Text(
                                      getSalaryDisplayText(
                                          productDetails), // Use the new helper method
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

                                  const Gap(15),

                                  // AD METRICS SECTION - ADDED HERE
                                  Text(
                                    StringHelper
                                        .adPerformance, // Add this to StringHelper if needed
                                    style:
                                        context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(10),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildMetricItem(
                                          context,
                                          Icons.favorite,
                                          '${productDetails?.favouritesCount ?? 0}',
                                          StringHelper.likes,
                                          Colors.red,
                                        ),
                                        _buildVerticalDivider(),
                                        _buildMetricItem(
                                          context,
                                          Icons.visibility,
                                          '${productDetails?.countViews ?? 0}',
                                          StringHelper.views,
                                          Colors.blue,
                                        ),
                                        _buildVerticalDivider(),
                                        _buildMetricItem(
                                          context,
                                          Icons.call,
                                          '${productDetails?.callCount ?? 0}',
                                          StringHelper.call,
                                          Colors.green,
                                        ),
                                        _buildVerticalDivider(),
                                        _buildMetricItem(
                                          context,
                                          Icons.chat,
                                          '${productDetails?.chatCount ?? 0}',
                                          StringHelper.chat,
                                          Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(15),

                                  // EXISTING ACTION BUTTONS
                                  productDetails?.sellStatus !=
                                          StringHelper.soldText
                                      ? Row(
                                          children: [
                                            if ("${productDetails?.adStatus}" !=
                                                    "deactivate" &&
                                                productDetails?.sellStatus !=
                                                    StringHelper.sold
                                                        .toLowerCase() &&
                                                "${productDetails?.status}" !=
                                                    "0" &&
                                                "${productDetails?.status}" !=
                                                    "2") ...{
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    DialogHelper.showLoading();
                                                    await vm.markAsSoldApi(
                                                        product:
                                                            productDetails!);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 08),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      StringHelper.markAsSold,
                                                      style: context
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Gap(10),
                                            },
                                            if ("${productDetails?.adStatus}" !=
                                                    "deactivate" &&
                                                ("${productDetails?.status}" ==
                                                        "0" ||
                                                    "${productDetails?.status}" ==
                                                        "2")) ...[
                                              // Corrected condition
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    var myAdsVm =
                                                        context.read<MyAdsVM>();

                                                    await myAdsVm
                                                        .navigateToEditProduct(
                                                      context: context,
                                                      item: productDetails,
                                                    );
                                                    // Refresh the data after edit
                                                    await viewModel
                                                        .getMyProductDetailsWithFreshMetrics(
                                                      id: productDetails?.id,
                                                    );
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 08),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              08),
                                                    ),
                                                    child: Text(
                                                      StringHelper.edit,
                                                      style: context
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
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
                                    if (vm
                                        .getSpecifications(
                                            context: context,
                                            data: productDetails)
                                        .isNotEmpty) ...{
                                      Text(StringHelper.specifications,
                                          style: context.textTheme.titleSmall),
                                      const SizedBox(height: 10),
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Wrap(
                                            spacing: 20,
                                            runSpacing: 15,
                                            children: vm
                                                .getSpecifications(
                                                    context: context,
                                                    data: productDetails)
                                                .map((spec) =>
                                                    SizedBox(child: spec))
                                                .toList(),
                                          )),
                                    }
                                  },
                                  if (productDetails?.categoryId == 11) ...{
                                    Text(
                                      StringHelper.propertyInformation,
                                      style: context.titleMedium,
                                    ),
                                    Gap(10),
                                    getPropertyInformation(
                                            context: context,
                                            data: productDetails) ??
                                        SizedBox.shrink(),
                                  },
                                  if ((productDetails?.accessToUtilities ?? "")
                                      .isNotEmpty) ...[
                                    Divider(),
                                    Text(
                                      StringHelper.accessToUtilities,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    Gap(10),
                                    UtilitiesDisplayWidget(
                                      utilitiesString:
                                          productDetails?.accessToUtilities ??
                                              "",
                                      isDetailView: false,
                                    ),
                                  ],
                                  if (productDetails?.categoryId == 11 &&
                                      (productDetails?.productAmenities ?? [])
                                          .isNotEmpty) ...[
                                    Divider(),
                                    Text(
                                      StringHelper.amenities,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Gap(15),
                                    Selector<ProductVM, bool>(
                                      selector: (_, vm) => vm.showAll,
                                      builder: (context, showAll, _) {
                                        final totalAmenities = productDetails
                                                ?.productAmenities?.length ??
                                            0;
                                        final visibleItemCount = showAll
                                            ? totalAmenities
                                            : totalAmenities < 6
                                                ? totalAmenities
                                                : 6;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GridView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio:
                                                    2.2, // Reduced from 2.5 to 2.2
                                                crossAxisSpacing:
                                                    8, // Reduced from 12 to 8
                                                mainAxisSpacing:
                                                    8, // Reduced from 12 to 8
                                              ),
                                              itemCount: visibleItemCount,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var amenity = productDetails
                                                    ?.productAmenities?[index];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // Reduced from 12 to 10
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 1,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.04),
                                                        spreadRadius: 0,
                                                        blurRadius: 8,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(
                                                        10.0), // Reduced from 12 to 10
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width:
                                                              40, // Reduced from 48 to 40
                                                          height:
                                                              40, // Reduced from 48 to 40
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8), // Reduced from 10 to 8
                                                          ),
                                                          child: Center(
                                                            child: SvgPicture
                                                                .asset(
                                                              getAmenitySvgPath(
                                                                  amenity?.amnity
                                                                          ?.name ??
                                                                      ''),
                                                              width:
                                                                  22, // Reduced from 28 to 22
                                                              height:
                                                                  22, // Reduced from 28 to 22
                                                              colorFilter:
                                                                  ColorFilter
                                                                      .mode(
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                BlendMode.srcIn,
                                                              ),
                                                              placeholderBuilder:
                                                                  (context) =>
                                                                      Icon(
                                                                getAmenityFallbackIcon(amenity
                                                                        ?.amnity
                                                                        ?.name ??
                                                                    ''),
                                                                size:
                                                                    18, // Reduced from 24 to 18
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                8), // Reduced from 14 to 8
                                                        Expanded(
                                                          child: Text(
                                                            DbHelper.getLanguage() ==
                                                                    'en'
                                                                ? "${amenity?.amnity?.name}"
                                                                : "${amenity?.amnity?.nameAr}",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  12, // Reduced from 13 to 12
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors.grey
                                                                  .shade800,
                                                              height: 1.2,
                                                            ),
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Gap(10), // Reduced from 15 to 10
                                            Gap(15),
                                            if (totalAmenities > 6)
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<ProductVM>()
                                                        .showAll = !showAll;
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              22),
                                                      border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          showAll
                                                              ? StringHelper
                                                                  .seeLess
                                                              : StringHelper
                                                                  .seeMore,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Gap(6),
                                                        Icon(
                                                          showAll
                                                              ? Icons
                                                                  .keyboard_arrow_up
                                                              : Icons
                                                                  .keyboard_arrow_down,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                  Divider(),
                                  Text(
                                    StringHelper.description,
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Gap(05),
                                  Text(productDetails?.description ?? ''),
                                  const Gap(20),
                                  const Divider(),
                                  Text(
                                    StringHelper.mapView,
                                    style: context.titleMedium,
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AssetsRes.IC_LOACTION_ICON,
                                        height: 16,
                                      ),
                                      const Gap(05),
                                      Expanded(
                                        child: Text(
                                          getLocalizedLocation(productDetails),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(05),
                                  InkWell(
                                    onTap: () async {
                                      if (DbHelper.getIsGuest()) {
                                        DialogHelper.showLoginDialog(
                                          context: context,
                                        );
                                        return;
                                      }

                                      // Navigate to in-app map view
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductLocationMapView(
                                            productData: productDetails!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      StringHelper.getDirection,
                                      style: context.textTheme.titleSmall
                                          ?.copyWith(
                                        color: Colors.red,
                                        decorationColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                  const Gap(5),
                                  InkWell(
                                    onTap: () {
                                      if (DbHelper.getIsGuest()) {
                                        DialogHelper.showLoginDialog(
                                          context: context,
                                        );
                                        return;
                                      }

                                      // Navigate to in-app map view
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductLocationMapView(
                                            productData: productDetails!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: SizedBox(
                                            height: 150,
                                            width: context.width,
                                            child: AbsorbPointer(
                                              absorbing:
                                                  true, // Prevents map gestures
                                              child: AddressMapWidget(
                                                latLng: LatLng(
                                                  double.tryParse(productDetails
                                                              ?.latitude ??
                                                          '0') ??
                                                      0.0,
                                                  double.tryParse(productDetails
                                                              ?.longitude ??
                                                          '0') ??
                                                      0.0,
                                                ),
                                                address:
                                                    productDetails?.nearby ??
                                                        "",
                                              ),
                                            ),
                                          ),
                                        ),
                                        // View Full Map overlay (clickable)
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.fullscreen,
                                                  size: 16,
                                                  color: Colors.black87,
                                                ),
                                                const Gap(4),
                                                Text(
                                                  StringHelper.viewFullMap,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(10),
                                  const Gap(10),
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
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String getSalaryDisplayText(ProductDetailModel? productData) {
    if (productData?.categoryId != 9) return "";

    // Get the raw values directly from the model
    String fromValue = productData?.salleryFrom?.toString() ?? "";
    String toValue = productData?.salleryTo?.toString() ?? "";

    // Parse to numbers for comparison, treating empty/null as 0
    num fromNum = num.tryParse(fromValue) ?? 0;
    num toNum = num.tryParse(toValue) ?? 0;

    // Format for display (only if > 0)
    String fromFormatted =
        fromNum > 0 ? Utils.formatPrice(fromNum.toStringAsFixed(0)) : "";
    String toFormatted =
        toNum > 0 ? Utils.formatPrice(toNum.toStringAsFixed(0)) : "";

    // Both values exist and are not zero
    if (fromNum > 0 && toNum > 0) {
      return "${StringHelper.egp} $fromFormatted - ${StringHelper.egp} $toFormatted";
    }
    // Only salary from exists
    else if (fromNum > 0 && toNum == 0) {
      return "${StringHelper.salaryFrom}: ${StringHelper.egp} $fromFormatted";
    }
    // Only salary to exists
    else if (fromNum == 0 && toNum > 0) {
      return "${StringHelper.salaryTo}: ${StringHelper.egp} $toFormatted";
    }

    // Both are zero or empty - fallback
    return "${StringHelper.egp} 0";
  }

  // NEW METRICS METHODS - ADDED HERE
  Widget _buildMetricItem(
    BuildContext context,
    IconData icon,
    String count,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const Gap(8),
        Text(
          count,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Gap(4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return Utils.formatPrice(num.parse("${amount ?? 0}").toStringAsFixed(0));
  }

  Widget getJobSpecifications({
    required BuildContext context,
    ProductDetailModel? productData,
  }) {
    List<Widget> specs = [];

    if ((productData?.positionType ?? "").isNotEmpty) {
      specs.add(_buildJobSpecRow(
        context,
        "${Utils.getCommon(Utils.transformToSnakeCase(productData?.positionType))}",
        Icons.work,
      ));
    }
    // Show brand/specialty if available, otherwise show category
    if (productData?.brand != null &&
        (productData?.brand?.name ?? "").isNotEmpty) {
      specs.add(_buildJobSpecRow(
        context,
        "${productData?.brand?.name}",
        Icons.category,
      ));
    } else if (productData?.subCategory?.name != null) {
      specs.add(_buildJobSpecRow(
        context,
        "${productData?.subCategory?.name}",
        Icons.category,
      ));
    }

    if (specs.isNotEmpty) {
      return SizedBox(
        height: 20,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: specs.length,
          itemBuilder: (context, index) => specs[index],
          separatorBuilder: (context, index) => VerticalDivider(
            width: 30,
            thickness: 2,
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildJobSpecRow(
      BuildContext context, String specValue, IconData icon) {
    String svgPath;

    if (icon == Icons.work) {
      svgPath = 'assets/icons/position.svg';
    } else if (icon == Icons.work_history) {
      svgPath = 'assets/icons/experience.svg';
    } else if (icon == Icons.category) {
      svgPath = 'assets/icons/specialty.svg';
    } else {
      svgPath = 'assets/icons/default.svg';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            Colors.black87,
            BlendMode.srcIn,
          ),
          placeholderBuilder: (context) => Icon(
            icon,
            size: 20,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            specValue,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget? getPropertyInformation(
      // Changed to nullable return type
      {required BuildContext context,
      ProductDetailModel? data}) {
    List<Widget> specs = [];

    if ((data?.propertyFor ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          Utils.getPropertyType("${data?.propertyFor ?? ""}"),
          '🏠',
          StringHelper.propertyFor));
    }
    if ((data?.area ?? 0) != 0) {
      specs.add(_buildInfoRow(context, "${data?.area} ${StringHelper.sqft}",
          '📏', StringHelper.area));
    }
    if ((data?.bedrooms ?? 0) != 0) {
      specs.add(_buildInfoRow(
          context,
          Utils.getBedroomsText("${data?.bedrooms}"),
          '🛏️',
          StringHelper.bedrooms));
    }
    if ((data?.bathrooms ?? 0) != 0) {
      specs.add(_buildInfoRow(
          context,
          Utils.getBathroomsText("${data?.bathrooms}"),
          '🚽',
          StringHelper.bathrooms));
    }
    if ((data?.furnishedType ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          Utils.getFurnished("${data?.furnishedType ?? ""}"),
          '🛋️',
          StringHelper.furnishedType));
    }
    if ((data?.ownership ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          "${Utils.getCommon(data?.ownership ?? "").capitalized}",
          '📜',
          StringHelper.ownership));
    }
    if ((data?.paymentType ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          "${Utils.getPaymentTyp(Utils.transformToSnakeCase(data?.paymentType ?? "")).capitalized}",
          '💳',
          StringHelper.paymentType));
    }
    if ((data?.deliveryTerm ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          Utils.getCommon(data?.deliveryTerm ?? "").capitalized,
          '🚚',
          StringHelper.deliveryTerm));
    }
    if ((data?.type ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(context, Utils.getProperty("${data?.type ?? ""}"),
          '💳', StringHelper.propertyType));
    }
    if ((data?.level ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          "${Utils.getCommon(data?.level)?.capitalized}",
          '✅',
          StringHelper.level));
    }
    if ((data?.buildingAge ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(context, "${data?.buildingAge?.capitalized}", '✅',
          StringHelper.buildingAge));
    }
    if ((data?.listedBy ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          "${Utils.getCommon(data?.listedBy ?? "").capitalized}",
          '✅',
          StringHelper.listedBy));
    }
    if ((data?.rentalPrice ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          num.parse("${data?.rentalPrice ?? 0}").toStringAsFixed(0),
          '✅',
          StringHelper.rentalPrice));
    }
    if ((data?.rentalTerm ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          Utils.carRentalTerm("${data?.rentalTerm ?? ""}"),
          '✅',
          StringHelper.rentalTerm));
    }
    if ((data?.deposit ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
          context,
          num.parse("${data?.deposit ?? 0}").toStringAsFixed(0),
          '✅',
          StringHelper.deposit));
    }
    if ((data?.insurance ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(context, "${data?.insurance?.capitalized}", '✅',
          StringHelper.insurance));
    }

    if (specs.isEmpty) return null; // Return null if no specs to show

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: specs,
    );
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

  String getAmenitySvgPath(String amenityName) {
    final Map<String, String> amenitySvgMap = {
      "Intercom": "assets/amenities/intercom.svg",
      "Security": "assets/amenities/security.svg",
      "Storage": "assets/amenities/storage.svg",
      "Broadband Internet": "assets/amenities/wifi.svg",
      "Garage Parking": "assets/amenities/garage_parking.svg",
      "Elevator": "assets/amenities/elevator.svg",
      "Landline": "assets/amenities/landline.svg",
      "Natural Gas": "assets/amenities/natural_gas.svg",
      "Water Meter": "assets/amenities/water_meter.svg",
      "Electricity Meter": "assets/amenities/electricity_meter.svg",
      "Pool": "assets/amenities/pool.svg",
      "Pets Allowed": "assets/amenities/pets.svg",
      "Maids Room": "assets/amenities/maids_room.svg",
      "Parking": "assets/amenities/parking.svg",
      "Central A/C and Heating": "assets/amenities/ac_heating.svg",
      "Private Garden": "assets/amenities/garden.svg",
      "Installed Kitchen": "assets/amenities/kitchen.svg",
      "Balcony": "assets/amenities/balcony.svg",
    };

    return amenitySvgMap[(amenityName).replaceAll('\n', '')] ??
        "assets/amenities/default.svg";
  }

  IconData getAmenityFallbackIcon(String amenityName) {
    final cleanName = amenityName.replaceAll('\n', '').trim();

    final Map<String, IconData> fallbackIconMap = {
      "Intercom": Icons.phone_outlined,
      "Security": Icons.security_outlined,
      "Storage": Icons.inventory_2_outlined,
      "Broadband Internet": Icons.wifi_outlined,
      "Garage Parking": Icons.local_parking_outlined,
      "Elevator": Icons.elevator_outlined,
      "Landline": Icons.phone_in_talk_outlined,
      "Natural Gas": Icons.local_fire_department_outlined,
      "Water Meter": Icons.water_drop_outlined,
      "Electricity Meter": Icons.bolt_outlined,
      "Pool": Icons.pool_outlined,
      "Pets Allowed": Icons.pets_outlined,
      "Maids Room": Icons.bed_outlined,
      "Parking": Icons.directions_car_outlined,
      "Central A/C and Heating": Icons.ac_unit_outlined,
      "Private Garden": Icons.grass_outlined,
      "Installed Kitchen": Icons.kitchen_outlined,
      "Balcony": Icons.balcony_outlined,
    };

    return fallbackIconMap[cleanName] ?? Icons.check_circle_outline;
  }

  Icon getAmenityIcon(String amenityName) {
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
      "Central A/C and Heating": Icons.ac_unit,
      "Private Garden": Icons.grass,
      "Installed Kitchen": Icons.kitchen,
      "Balcony": Icons.balcony,
    };

    return Icon(
      amenityIconMap[(amenityName).replaceAll('\n', '')] ?? Icons.help_outline,
      color: Colors.blueGrey,
    );
  }
}

class AddressMapWidget extends StatelessWidget {
  final LatLng latLng;
  final String address;
  const AddressMapWidget({
    super.key,
    required this.latLng,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      scrollGesturesEnabled: false,
      mapToolbarEnabled: false,
      liteModeEnabled: false,
      onMapCreated: (gController) {
        gController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(zoom: 15, target: latLng),
          ),
        );
      },
      initialCameraPosition: CameraPosition(
        zoom: 15,
        target: latLng,
      ),
      myLocationButtonEnabled: false,
      markers: {
        Marker(
          markerId: const MarkerId("1"),
          position: latLng,
          onTap: () async {
            final availableMaps = await MapLauncher.installedMaps;
            if (availableMaps.isNotEmpty) {
              await availableMaps.first.showMarker(
                coords: Coords(latLng.latitude, latLng.longitude),
                title: address,
              );
            }
          },
        ),
      },
      circles: {
        Circle(
          circleId: const CircleId("1"),
          center: latLng,
          radius: 120,
          strokeWidth: 5,
          strokeColor: const Color(0xff6468E3),
          fillColor: const Color(0xFF6468E3).withOpacity(0.5),
        ),
      },
    );
  }
}
