import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'dart:developer';
import "package:list_and_life/view/product/product_location_map_view.dart";
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:provider/provider.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/communication_buttons.dart';
import 'package:list_and_life/widgets/image_view.dart';
import '../../base/helpers/date_helper.dart';
import '../../base/helpers/db_helper.dart';
import '../../base/helpers/dialog_helper.dart';
import 'package:list_and_life/widgets/utilities_display_widget.dart';
import '../../base/helpers/string_helper.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../skeletons/product_detail_skeleton.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/card_swipe_widget.dart';
import '../../widgets/common_grid_view.dart';
import '../../widgets/like_button.dart';

class ProductDetailView extends StatefulWidget {
  final ProductDetailModel? productDetails;
  const ProductDetailView({super.key, required this.productDetails});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late ProductVM viewModel;
  late InboxModel? chat;
  late ChatVM _chatViewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ProductVM();
    _chatViewModel = context.read<ChatVM>();
    chat = InboxModel(
      senderId: DbHelper.getUserModel()?.id,
      receiverId: widget.productDetails?.userId,
      productId: widget.productDetails?.id,
      productDetail: widget.productDetails,
      receiverDetail: SenderDetail(
        id: widget.productDetails?.userId,
        lastName: widget.productDetails?.user?.lastName,
        profilePic: widget.productDetails?.user?.profilePic,
        name: widget.productDetails?.user?.name,
      ),
      senderDetail: SenderDetail(
        id: DbHelper.getUserModel()?.id,
        profilePic: DbHelper.getUserModel()?.profilePic,
        lastName: DbHelper.getUserModel()?.lastName,
        name: DbHelper.getUserModel()?.name,
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  bool _isCurrentLanguageArabic(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String _getProfileImageUrl(String? profilePic) {
    if (profilePic == null || profilePic.isEmpty) {
      return "";
    }
    if (profilePic.contains('http')) {
      return profilePic;
    }
    return "${ApiConstants.imageUrl}/$profilePic";
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductVM>.value(
      value: viewModel,
      child: Consumer<ProductVM>(
        builder: (context, vm, child) {
          return Scaffold(
            extendBodyBehindAppBar: false,
            body: Stack(
              children: [
                FutureBuilder<ProductDetailModel?>(
                  future: vm.getProductDetails(id: widget.productDetails?.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProductDetailModel? productData = snapshot.data;
                      final bool isJobListing = productData?.categoryId == 9;

                      return SingleChildScrollView(
                        controller: vm.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Only show image carousel if NOT a job listing
                            if (!isJobListing)
                              Stack(
                                children: [
                                  CardSwipeWidget(
                                    radius: 0,
                                    height: 350,
                                    data: productData,
                                    fit: BoxFit.cover,
                                    imagesList: productData?.productMedias,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  // Back Button with white container
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

                                  // Like Button
                                  Positioned(
                                    top: 0,
                                    right: Directionality.of(context) ==
                                            TextDirection.ltr
                                        ? 60
                                        : null,
                                    left: Directionality.of(context) ==
                                            TextDirection.rtl
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
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: LikeButton(
                                          isFav: productData?.isFavourite == 1,
                                          onTap: () async {
                                            await vm.onLikeButtonTapped(
                                                id: productData?.id);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: Directionality.of(context) ==
                                            TextDirection.ltr
                                        ? 10
                                        : null,
                                    left: Directionality.of(context) ==
                                            TextDirection.rtl
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
                                        child:
                                        IconButton(
                                          icon:
                                          const Icon(Icons.more_vert, color: Colors.black87, size: 24),
                                          onPressed: ()=>_showBlockReportActionSheet(context),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Share Button
                                  // Positioned(
                                  //   top: 0,
                                  //   right: Directionality.of(context) ==
                                  //           TextDirection.ltr
                                  //       ? 10
                                  //       : null,
                                  //   left: Directionality.of(context) ==
                                  //           TextDirection.rtl
                                  //       ? 10
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
                                  //             "📍 ${productData?.name}\n💰 ${StringHelper.egp} ${parseAmount(productData?.price)}\n\nView this listing on Daroory:\nhttps://daroory.com/listing/${productData?.id}",
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
                                  // )
                                ],
                              ),

                            // For job listings, show a simple header without image
                            if (isJobListing)
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top + 8,
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                ),
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
                                    // Like Button
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: LikeButton(
                                        isFav: productData?.isFavourite == 1,
                                        onTap: () async {
                                          await vm.onLikeButtonTapped(
                                              id: productData?.id);
                                        },
                                      ),
                                    ),
                                    const Gap(8),
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
                                  ],
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
                                  if (isJobListing) const Gap(12),
                                  Text(
                                    "${productData?.name}",
                                    style: context.textTheme.titleMedium,
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
                                  if (productData?.categoryId == 11 &&
                                      productData?.propertyFor != null) ...{
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
                                            "${productData?.propertyFor ?? ""}"),
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  },
                                  // Dynamic spacing based on whether specs exist
                                  const Gap(8),
                                  getSpecifications(
                                    context: context,
                                    productData: productData,
                                  ),
                                  const Gap(8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/location.svg', // SVG location icon
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const Gap(10),
                                      Flexible(
                                        child: Text(
                                          getLocalizedLocationForProduct(
                                              context, productData),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  if (productData?.categoryId == 9) ...{
                                    Text(
                                      getSalaryDisplayText(
                                          productData), // Use the new helper method
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  } else ...{
                                    Text(
                                      "${StringHelper.egp} ${parseAmount(productData?.price)}",
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  },
                                  const Gap(12),
                                  const Divider(),
                                  const Gap(8),
                                  Text(
                                    StringHelper.description,
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Gap(5),
                                  // Updated description with "Read More"
                                  _buildDescription(
                                    context,
                                    productData?.description ?? '',
                                  ),
                                  const Divider(),
                                  if (productData?.categoryId != 11) ...{
                                    if (vm
                                        .getSpecifications(
                                          context: context,
                                          data: productData,
                                        )
                                        .isNotEmpty) ...{
                                      Text(
                                        StringHelper.specifications,
                                        style: context.textTheme.titleSmall,
                                      ),
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
                                                data: widget.productDetails,
                                              )
                                              .map((spec) =>
                                                  SizedBox(child: spec))
                                              .toList(),
                                        ),
                                      ),
                                    }
                                  },
                                  if (productData?.categoryId == 11) ...{
                                    Text(
                                      StringHelper.propertyInformation,
                                      style: context.titleMedium,
                                    ),
                                    const Gap(10),
                                    getPropertyInformation(
                                          context: context,
                                          data: productData,
                                        ) ??
                                        const SizedBox.shrink(),
                                  },
                                  if ((widget.productDetails
                                              ?.accessToUtilities ??
                                          "")
                                      .isNotEmpty) ...[
                                    Divider(),
                                    Text(
                                      StringHelper.accessToUtilities,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    Gap(10),
                                    UtilitiesDisplayWidget(
                                      utilitiesString: widget.productDetails
                                              ?.accessToUtilities ??
                                          "",
                                      isDetailView: false,
                                    ),
                                  ],
                                  if (productData?.categoryId == 11 &&
                                      (productData?.productAmenities ?? [])
                                          .isNotEmpty) ...[
                                    const Divider(),
                                    Text(
                                      StringHelper.amenities,
                                      style: context.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Gap(8),
                                    Consumer<ProductVM>(
                                      builder: (context, vm, child) {
                                        final totalAmenities = productData
                                                ?.productAmenities?.length ??
                                            0;
                                        final visibleItemCount = vm.showAll
                                            ? totalAmenities
                                            : totalAmenities < 6
                                                ? totalAmenities
                                                : 6;

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Improved Grid Layout with better aspect ratio
                                            GridView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 2.8, // Increased to make items wider and shorter
                                                crossAxisSpacing: 6, // Reduced spacing
                                                mainAxisSpacing: 6, // Reduced spacing
                                              ),
                                              itemCount: visibleItemCount,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                var amenity = productData
                                                    ?.productAmenities?[index];
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(
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
                                                        offset:
                                                            const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(padding: const EdgeInsets.all(
                                                        6.0), // Further reduced padding
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Icon Container
                                                        Container(
                                                          width:
                                                              32, // Smaller icon container
                                                          height:
                                                              32, // Smaller icon container
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
                                                                        8),
                                                          ),
                                                          child: Center(
                                                            child: SvgPicture
                                                                .asset(
                                                              getAmenitySvgPath(
                                                                  amenity?.amnity
                                                                          ?.name ??
                                                                      ''),
                                                              width:
                                                                  18, // Smaller icon
                                                              height:
                                                                  18, // Smaller icon
                                                              colorFilter:
                                                                  ColorFilter
                                                                      .mode(
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                BlendMode.srcIn,
                                                              ),
                                                              // Enhanced fallback with better error handling
                                                              placeholderBuilder:
                                                                  (context) =>
                                                                      Icon(
                                                                getAmenityFallbackIcon(amenity
                                                                        ?.amnity
                                                                        ?.name ??
                                                                    ''),
                                                                size:
                                                                    16, // Smaller fallback icon
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width:
                                                                6), // Further reduced spacing
                                                        // Improved Text Layout with no wrapping
                                                        Expanded(
                                                          child: FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              DbHelper.getLanguage() ==
                                                                      'en'
                                                                  ? "${amenity?.amnity?.name}"
                                                                  : "${amenity?.amnity?.nameAr}",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    13, // Increased font size
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors.grey
                                                                    .shade800,
                                                              ),
                                                              maxLines: 1, // Force single line
                                                              overflow:
                                                                  TextOverflow.visible,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const Gap(10),
                                            // Show More/Less Button
                                            if (totalAmenities > 6)
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    vm.showAll = !vm.showAll;
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
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
                                                          vm.showAll
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
                                                        const Gap(4),
                                                        Icon(
                                                          vm.showAll
                                                              ? Icons
                                                                  .keyboard_arrow_up
                                                              : Icons
                                                                  .keyboard_arrow_down,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 18,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],

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
                                          getLocalizedLocationForProduct(
                                              context, productData),
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

                                      // Navigate to in-app map view instead of launching external maps
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductLocationMapView(
                                            productData: productData!,
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
                                            productData: productData!,
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
                                                  double.parse(
                                                      productData?.latitude ??
                                                          '0'),
                                                  double.parse(
                                                      productData?.longitude ??
                                                          '0'),
                                                ),
                                                address:
                                                    productData?.nearby ?? "",
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
                                  // "Posted by" section without grey background
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ImageView.circle(
                                          placeholder: AssetsRes.IC_USER_ICON,
                                          image: _getProfileImageUrl(productData?.user?.profilePic),
                                          width: 65,
                                          height: 65,
                                        ),
                                        const Gap(20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              StringHelper.postedBy,
                                              style: context
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                      color: Colors.grey),
                                            ),
                                            Text(
                                              "${productData?.user?.name} ${productData?.user?.lastName}",
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                fontFamily:
                                                    FontRes.MONTSERRAT_SEMIBOLD,
                                              ),
                                            ),
                                            Text(
                                              '${StringHelper.postedOn} ${DateHelper.joiningDate(DateTime.parse('${productData?.createdAt}'))}',
                                              style: context
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                      color: Colors.grey),
                                            ),
                                            const Gap(10),
                                            InkWell(
                                              onTap: () {
                                                if (DbHelper.getIsGuest()) {
                                                  DialogHelper.showLoginDialog(
                                                    context: context,
                                                  );
                                                  return;
                                                }
                                                productData?.user?.id = productData.userId;
                                                context.push(Routes.seeProfile, extra: {"user":productData?.user,"chat":chat});

                                              },
                                              child: Text(
                                                StringHelper.seeProfile,
                                                style: context
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: Colors.red,
                                                  decorationColor: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Safety guidelines section
                                  const Divider(),
                                  Text(
                                    StringHelper.safetyTips,
                                    style:
                                        context.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Gap(10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              StringHelper.doNotTransact,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              StringHelper.meetInPublic,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              StringHelper.inspectItems,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              StringHelper.avoidSharing,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.warning,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              StringHelper.reportSuspicious,
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  const Divider(),
                                  const Gap(30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const AppErrorWidget();
                    }
                    return ProductDetailSkeleton(
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),

                // -- Sticky Header Added Here --
                // Smooth fade in/out once the user scrolls ~350 px
                // No changes to your existing code; it just sits atop in the same Stack.
                // -- Sticky Header Added Here --
                AnimatedBuilder(
                  animation: vm.scrollController,
                  builder: (context, child) {
                    final offset = vm.scrollController.hasClients
                        ? vm.scrollController.offset
                        : 0.0;
                    final bool showHeader = offset >= 350.0;
                    return IgnorePointer(
                      ignoring:
                          !showHeader, // Allows taps to pass through when header is hidden
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: showHeader ? 1.0 : 0.0,
                        child: Container(
                          height: 60 +
                              MediaQuery.of(context)
                                  .padding
                                  .top, // Adjust height for status bar
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: MediaQuery.of(context).padding.top +
                                8, // Add status bar padding + 8
                            bottom: 8,
                          ),
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
                                      : LineAwesomeIcons.arrow_right_solid,
                                  size: 28,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.productDetails?.name ?? '',
                                  style: context.textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // IconButton(
                              //   padding: EdgeInsets.zero,
                              //   constraints: const BoxConstraints(),
                              //   onPressed: () {
                              //     Utils.onShareProduct(
                              //       context,
                              //       "📍 ${widget.productDetails?.name}\n💰 ${StringHelper.egp} ${parseAmount(widget.productDetails?.price)}\n\nView this listing on Daroory:\nhttps://daroory.com/listing/${widget.productDetails?.id}",
                              //     );
                              //   },
                              //   icon: const Icon(
                              //     Icons.share,
                              //     size: 22,
                              //     color: Colors.black,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Communication buttons with white container
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: CommunicationButtons(
                      data: widget.productDetails,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // All the helper methods remain exactly the same as in your original code
  Widget _buildDescription(BuildContext context, String description) {
    const int maxLength = 200;
    if (description.length > maxLength) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${description.substring(0, maxLength)}...',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showFullDescription(context, description),
            child: Text(
              StringHelper.readMore,
              style: const TextStyle(
                color: Color.fromARGB(255, 239, 55, 41),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(
        description,
        style: context.textTheme.bodyMedium,
      );
    }
  }

  void _showFullDescription(BuildContext context, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringHelper.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return Utils.formatPrice(num.parse("${amount ?? 0}").toStringAsFixed(0));
  }

  Widget getSpecifications({
    required BuildContext context,
    ProductDetailModel? productData,
  }) {
    List<Widget> specs = [];

    if (productData?.categoryId == 4) {
      if (productData?.year != null && productData!.year != 0) {
        specs.add(_buildSpecRow(context, "${productData.year}", Icons.event));
      }
      if (productData?.kmDriven != null) {
        specs.add(
          _buildSpecRow(context, '${productData?.kmDriven}', Icons.speed),
        );
      }
      if (productData?.fuel != null && productData!.fuel!.isNotEmpty) {
        specs.add(_buildSpecRow(
          context,
          Utils.getFuel('${productData.fuel}'),
          Icons.local_gas_station,
        ));
      }
    }
    if (productData?.categoryId == 9) {
      if ((productData?.positionType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
          context,
          "${Utils.getCommon(Utils.transformToSnakeCase(productData?.positionType))}",
          Icons.work,
        ));
      }
      // Show brand/specialty if available, otherwise show category
      if (productData?.brand != null &&
          (productData?.brand?.name ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
          context,
          "${productData?.brand?.name}",
          Icons.category,
        ));
      } else if (productData?.subCategory?.name != null) {
        specs.add(_buildSpecRow(
          context,
          "${productData?.subCategory?.name}",
          Icons.category,
        ));
      }
    }

    if (productData?.categoryId == 11) {
      if (productData?.bedrooms != null && productData!.bedrooms != 0) {
        final bedroomsText = Utils.getBedroomsText('${productData.bedrooms}');
        // Check if it's "Studio" in either English or Arabic
        final isStudio = bedroomsText == "Studio" || bedroomsText == "استوديو";
        specs.add(_buildSpecRow(
          context,
          isStudio ? bedroomsText : "$bedroomsText ${StringHelper.beds}",
          Icons.king_bed,
        ));
      }
      if (productData?.bathrooms != null && productData!.bathrooms != 0) {
        specs.add(_buildSpecRow(
          context,
          "${Utils.getBathroomsText('${productData.bathrooms}')} ${StringHelper.baths}",
          Icons.bathtub,
        ));
      }

      if (productData?.area != null && productData!.area != 0) {
        specs.add(_buildSpecRow(
          context,
          "${productData.area} ${StringHelper.sqft}",
          Icons.square_foot,
        ));
      }
    }

    if (specs.isNotEmpty) {
      return SizedBox(
        height: 20, // Enough height to display icon and text
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: specs.length,
          itemBuilder: (context, index) => specs[index],
          separatorBuilder: (context, index) => VerticalDivider(
            width: 30, // The horizontal spacing between spec items
            thickness: 2, // How thick you want the divider line
            color: Colors.grey.shade400,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// The spec row has no fixed width, so items can sit closer together.
  Widget _buildSpecRow(BuildContext context, String specValue, IconData icon) {
    String svgPath;

    if (icon == Icons.event) {
      svgPath = 'assets/icons/calendar.svg';
    } else if (icon == Icons.speed) {
      svgPath = 'assets/icons/speedometer.svg';
    } else if (icon == Icons.local_gas_station) {
      svgPath = 'assets/icons/fuel.svg';
    } else if (icon == Icons.king_bed) {
      svgPath = 'assets/icons/bed.svg';
    } else if (icon == Icons.bathtub) {
      svgPath = 'assets/icons/bathtub.svg';
    } else if (icon == Icons.square_foot) {
      svgPath = 'assets/icons/area.svg';
    } else if (icon == Icons.work) {
      svgPath = 'assets/icons/position.svg'; // Add this SVG
    } else if (icon == Icons.work_history) {
      svgPath = 'assets/icons/experience.svg'; // Add this SVG
    } else if (icon == Icons.category) {
      svgPath = 'assets/icons/specialty.svg'; // Add this SVG
    } else {
      svgPath = 'assets/icons/default.svg';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: 20, // Slightly bigger for detail view
          height: 20,
          colorFilter: ColorFilter.mode(
            Colors.black87,
            BlendMode.srcIn,
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

  Widget getPropertyInformation({
    required BuildContext context,
    ProductDetailModel? data,
  }) {
    List<Widget> specs = [];

    // Build the list of specifications
    if ((data?.propertyFor ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.getPropertyType("${data?.propertyFor ?? ""}"),
        '🏠',
        StringHelper.listingType,
      ));
    }
    if ((data?.area ?? 0) != 0) {
      specs.add(_buildInfoRow(
        context,
        "${data?.area} ${StringHelper.sqft}",
        '📏',
        StringHelper.area,
      ));
    }
    if ((data?.bedrooms ?? 0) != 0) {
      specs.add(_buildInfoRow(
        context,
        Utils.getBedroomsText("${data?.bedrooms}"),
        '🛏️',
        StringHelper.bedrooms,
      ));
    }
    if ((data?.bathrooms ?? 0) != 0) {
      specs.add(_buildInfoRow(
        context,
        Utils.getBathroomsText("${data?.bathrooms}"),
        '🚽',
        StringHelper.bathrooms,
      ));
    }
    if ((data?.furnishedType ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.getFurnished("${data?.furnishedType ?? ""}"),
        '🛋️',
        StringHelper.furnishedType,
      ));
    }
    if ((data?.ownership ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getCommon(data?.ownership ?? "").capitalized}",
        '📜',
        StringHelper.ownership,
      ));
    }
    if ((data?.paymentType ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getPaymentTyp(Utils.transformToSnakeCase(data?.paymentType ?? ""))}",
        '💳',
        StringHelper.paymentType,
      ));
    }
    if ((data?.completionStatus ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getUtilityTyp(data?.completionStatus ?? "").capitalized}",
        '✅',
        StringHelper.completionStatus,
      ));
    }
    if ((data?.deliveryTerm ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.getCommon(data?.deliveryTerm ?? "").capitalized,
        '🚚',
        StringHelper.deliveryTerm,
      ));
    }
    if ((data?.type ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.getProperty("${data?.type ?? ""}"),
        '💳',
        StringHelper.propertyType,
      ));
    }
    if ((data?.level ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${data?.level?.capitalized}",
        '✅',
        StringHelper.level,
      ));
    }
    if ((data?.buildingAge ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${data?.buildingAge?.capitalized}",
        '✅',
        StringHelper.buildingAge,
      ));
    }
    if ((data?.listedBy ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getCommon(data?.listedBy ?? "").capitalized}",
        '✅',
        StringHelper.listedBy,
      ));
    }
    if ((data?.rentalPrice ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        num.parse("${data?.rentalPrice ?? 0}").toStringAsFixed(0),
        '✅',
        StringHelper.rentalPrice,
      ));
    }
    if ((data?.rentalTerm ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.carRentalTerm("${data?.rentalTerm ?? ""}"),
        '✅',
        StringHelper.rentalTerm,
      ));
    }
    if ((data?.deposit ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        num.parse("${data?.deposit ?? 0}").toStringAsFixed(0),
        '✅',
        StringHelper.deposit,
      ));
    }
    if ((data?.insurance ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${data?.insurance?.capitalized}",
        '✅',
        StringHelper.insurance,
      ));
    }

    // If more than 6 entries, display first 6 with "Read More" that opens a full-screen modal.
    if (specs.length > 6) {
      List<Widget> displayedSpecs = specs.sublist(0, 6);
      displayedSpecs.add(
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header with title and X button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringHelper.propertyInformation,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 198, 195, 195),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: specs
                                .map(
                                  (spec) => Column(
                                    children: [
                                      spec,
                                      const Divider(
                                        color:
                                            Color.fromARGB(255, 198, 195, 195),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              StringHelper.readMore,
              style: const TextStyle(
                color: Color.fromARGB(255, 239, 55, 41),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: displayedSpecs,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: specs,
      );
    }
  }

  // REPLACE the getSalaryDisplayText method in BOTH files with this:

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

// Helper method to build each specification row
  Widget _buildInfoRow(
    BuildContext context,
    String? label,
    String icon,
    String? value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value ?? "",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            label ?? "",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }


  void _showBlockReportActionSheet(BuildContext context) {
    bool isArabic = _isCurrentLanguageArabic(context);

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showReportDialog();
              },
              isDestructiveAction: true,
              child: Text(
                StringHelper.reportAd,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              StringHelper.cancel,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.report, color: Colors.red),
                  title: Text(
                    StringHelper.reportAd,
                    style: TextStyle(color: Colors.red),
                    textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialogWithWidget(
        description: '',
        onTap: () {
          if (_chatViewModel.reportTextController.text.trim().isEmpty) {
            DialogHelper.showToast(
                message: StringHelper.pleaseEnterReasonOfReport);
            return;
          }
          context.pop();
          _chatViewModel.reportBlockUser(
              report: true,
              reason: _chatViewModel.reportTextController.text,
              userId: "${chat?.senderId == DbHelper.getUserModel()?.id ? chat?.receiverDetail?.id : chat?.senderDetail?.id}");
        },
        icon: AssetsRes.IC_REPORT_USER,
        showCancelButton: true,
        isTextDescription: false,
        content: AppTextField(
          controller: _chatViewModel.reportTextController,
          maxLines: 4,
          hint: StringHelper.reason,
        ),
        cancelButtonText: StringHelper.no,
        title: StringHelper.reportAd,
        buttonText: StringHelper.yes,
      ),
    );
  }

}

String _getDetailedLocalizedAddressFromCoordinates(
    BuildContext context, double lat, double lng) {
  bool isArabic = Directionality.of(context) == TextDirection.rtl;
  CityModel? nearestCity = LocationService.findNearestCity(lat, lng); //
  if (nearestCity != null) {
    String cityName = isArabic ? nearestCity.arabicName : nearestCity.name;
    if (nearestCity.districts != null) {
      for (var district in nearestCity.districts!) {
        if (district.neighborhoods != null) {
          for (var neighborhood in district.neighborhoods!) {
            double distanceToNeighborhood = LocationService.calculateDistance(
                //
                lat,
                lng,
                neighborhood.latitude,
                neighborhood.longitude);
            // Adjust radius check as needed, or use a more sophisticated point-in-polygon if available
            if (distanceToNeighborhood <= (neighborhood.radius ?? 2.0)) {
              // Default radius 2km
              String districtName =
                  isArabic ? district.arabicName : district.name;
              String neighborhoodName =
                  isArabic ? neighborhood.arabicName : neighborhood.name;
              return "$neighborhoodName، $districtName، $cityName";
            }
          }
        }
        double distanceToDistrict = LocationService.calculateDistance(
            //
            lat,
            lng,
            district.latitude,
            district.longitude);
        // Adjust radius check as needed
        if (distanceToDistrict <= (district.radius ?? 5.0)) {
          // Default radius 5km
          String districtName = isArabic ? district.arabicName : district.name;
          return "$districtName، $cityName";
        }
      }
    }
    return cityName; // Fallback to city name if no district/neighborhood match from coordinates
  }
  return isArabic
      ? "موقع غير محدد"
      : "Unknown Location"; // Fallback if no city found
}

bool _isCurrentLanguageArabic(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl;
}

// Inside _ProductDetailViewState class
String getLocalizedLocationFromCoordinates(
    // Renamed from _getDetailedLocalizedAddressFromCoordinates
    BuildContext context,
    double? lat,
    double? lng) {
  if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
    return _isCurrentLanguageArabic(context) ? "كل مصر" : "All Egypt";
  }

  bool isArabic = _isCurrentLanguageArabic(context);
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

String getLocalizedLocationForProduct(
    BuildContext context, ProductDetailModel? data) {
  bool isArabic = _isCurrentLanguageArabic(context);

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
      // If only city was found via structured fields, AND 'nearby' is available,
      // AND structured D/N fields from DB were null/empty (which is why we are here),
      // then attempt to parse 'nearby' for translation IF IT HAS ENGLISH COMPONENTS.
      if ((data.districtName == null ||
              data.districtName!
                  .isEmpty) && // Check if specific fields were missing
          (data.neighborhoodName == null || data.neighborhoodName!.isEmpty) &&
          data.nearby != null &&
          data.nearby!.isNotEmpty) {
        print(
            "ProductDetailView: Structured D/N missing. Trying to parse 'nearby' for translation: ${data.nearby}");
        List<String> parts =
            data.nearby!.split(',').map((e) => e.trim()).toList();
        String nearbyCityEng = "";
        String nearbyDistrictEng = "";
        String nearbyNeighborhoodEng = "";

        if (parts.length == 3) {
          // N, D, C
          nearbyNeighborhoodEng = parts[0];
          nearbyDistrictEng = parts[1];
          nearbyCityEng = parts[2];
        } else if (parts.length == 2) {
          // D, C
          nearbyDistrictEng = parts[0];
          nearbyCityEng = parts[1];
        } else if (parts.length == 1) {
          // C
          nearbyCityEng = parts[0];
        }

        if (nearbyCityEng.isNotEmpty &&
            nearbyCityEng.toLowerCase() == cityModel.name.toLowerCase()) {
          if (nearbyDistrictEng.isNotEmpty) {
            DistrictModel? districtFromNearby =
                LocationService.findDistrictByName(
                    cityModel, nearbyDistrictEng);
            if (districtFromNearby != null) {
              String districtNearbyLocalized = isArabic
                  ? districtFromNearby.arabicName
                  : districtFromNearby.name;
              if (nearbyNeighborhoodEng.isNotEmpty) {
                NeighborhoodModel? neighborhoodFromNearby =
                    LocationService.findNeighborhoodByName(
                        districtFromNearby, nearbyNeighborhoodEng);
                if (neighborhoodFromNearby != null) {
                  String neighborhoodNearbyLocalized = isArabic
                      ? neighborhoodFromNearby.arabicName
                      : neighborhoodFromNearby.name;
                  return "$neighborhoodNearbyLocalized، $districtNearbyLocalized، $cityName";
                }
              }
              return "$districtNearbyLocalized، $cityName";
            }
          }
        }
      }
      // Fallback to just city name if other conditions not met
      return cityName;
    }
  }

  // Priority 2: Coordinates (if data.city was null or cityModel not found)
  if (data.latitude != null && data.longitude != null) {
    double? lat = double.tryParse(data.latitude!);
    double? lng = double.tryParse(data.longitude!);

    if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
      return getLocalizedLocationFromCoordinates(context, lat, lng);
    }
  }

  // Priority 3: Nearby (if structured names and coordinates failed)
  if (data.nearby != null && data.nearby!.isNotEmpty) {
    // At this stage, if 'nearby' is Arabic, it will be shown as is.
    // If 'nearby' is English, it will be shown as is.
    // To translate 'nearby' if its components are English and structured names failed earlier:
    // This path is now reached if data.city was null or cityModel was not found.
    print(
        "ProductDetailView: data.city was null/empty. Trying to parse 'nearby' directly for translation: ${data.nearby}");
    List<String> parts = data.nearby!.split(',').map((e) => e.trim()).toList();
    String finalCityEng = "";
    String finalDistrictEng = "";
    String finalNeighborhoodEng = "";

    if (parts.length == 3) {
      finalNeighborhoodEng = parts[0];
      finalDistrictEng = parts[1];
      finalCityEng = parts[2];
    } else if (parts.length == 2) {
      finalDistrictEng = parts[0];
      finalCityEng = parts[1];
    } else if (parts.length == 1) {
      finalCityEng = parts[0];
    }

    if (finalCityEng.isNotEmpty) {
      CityModel? cityModelFromNearby =
          LocationService.findCityByName(finalCityEng);
      if (cityModelFromNearby != null) {
        String cityNearbyLocalized = isArabic
            ? cityModelFromNearby.arabicName
            : cityModelFromNearby.name;
        if (finalDistrictEng.isNotEmpty) {
          DistrictModel? districtModelFromNearby =
              LocationService.findDistrictByName(
                  cityModelFromNearby, finalDistrictEng);
          if (districtModelFromNearby != null) {
            String districtNearbyLocalized = isArabic
                ? districtModelFromNearby.arabicName
                : districtModelFromNearby.name;
            if (finalNeighborhoodEng.isNotEmpty) {
              NeighborhoodModel? neighborhoodModelFromNearby =
                  LocationService.findNeighborhoodByName(
                      districtModelFromNearby, finalNeighborhoodEng);
              if (neighborhoodModelFromNearby != null) {
                String neighborhoodNearbyLocalized = isArabic
                    ? neighborhoodModelFromNearby.arabicName
                    : neighborhoodModelFromNearby.name;
                return "$neighborhoodNearbyLocalized، $districtNearbyLocalized، $cityNearbyLocalized";
              }
            }
            return "$districtNearbyLocalized، $cityNearbyLocalized";
          }
        }
        return cityNearbyLocalized;
      }
    }
    // If parsing and translating 'nearby' fails, return it as is.
    return data.nearby!;
  }

  return isArabic ? "مصر" : "Egypt";
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
            await availableMaps.first.showMarker(
              coords: Coords(latLng.latitude, latLng.longitude),
              title: address,
            );
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
