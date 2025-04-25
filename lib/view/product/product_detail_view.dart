import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/communication_buttons.dart';
import 'package:list_and_life/widgets/image_view.dart';
import '../../base/helpers/date_helper.dart';
import '../../base/helpers/db_helper.dart';
import '../../base/helpers/dialog_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../routes/app_routes.dart';
import '../../skeletons/product_detail_skeleton.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/card_swipe_widget.dart';
import '../../widgets/common_grid_view.dart';
import '../../widgets/like_button.dart';

class ProductDetailView extends BaseView<ProductVM> {
  final ProductDetailModel? productDetails;
  const ProductDetailView({super.key, required this.productDetails});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<ProductDetailModel?>(
              future: viewModel.getProductDetails(id: productDetails?.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ProductDetailModel? productData = snapshot.data;
                  return SingleChildScrollView(
                    controller: viewModel.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CardSwipeWidget(
                              radius: 0,
                              height: 350,
                              data: productData,
                              fit: BoxFit.fill,
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
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: LikeButton(
                                    isFav: productData?.isFavourite == 1,
                                    onTap: () async {
                                      await viewModel.onLikeButtonTapped(
                                          id: productData?.id);
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // Share Button
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
                            )
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
                              Text(
                                "${productData?.name}",
                                style: context.textTheme.titleMedium,
                              ),
                              const Gap(5),
                              getSpecifications(
                                context: context,
                                productData: productData,
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
                                      productData?.nearby ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(10),
                              if (productData?.categoryId == 9) ...{
                                Text(
                                  "${StringHelper.egp} ${parseAmount(productData?.salleryFrom)} - ${StringHelper.egp} ${parseAmount(productData?.salleryTo)}",
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
                              const Gap(10),
                              const Divider(),
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
                                if (viewModel
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
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Wrap(
                                      spacing: 20,
                                      runSpacing: 15,
                                      children: viewModel
                                          .getSpecifications(
                                            context: context,
                                            data: productDetails,
                                          )
                                          .map((spec) => SizedBox(child: spec))
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
                              if (productData?.categoryId == 11) ...{
                                const Divider(),
                                Text(
                                  StringHelper.amenities,
                                  style: context.textTheme.titleMedium,
                                ),
                                const Gap(10),
                                Visibility(
                                  visible: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      productData?.productAmenities?.length ??
                                          0,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              getAmenityIcon(
                                                productData
                                                        ?.productAmenities?[
                                                            index]
                                                        .amnity
                                                        ?.name ??
                                                    '',
                                              ),
                                              const Gap(05),
                                              Text(
                                                DbHelper.getLanguage() == 'en'
                                                    ? "${productData?.productAmenities?[index].amnity?.name}"
                                                    : "${productData?.productAmenities?[index].amnity?.nameAr}",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                CommonGridView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  childAspectRatio: 16 / 16,
                                  itemCount: viewModel.showAll
                                      ? productData?.productAmenities?.length ??
                                          0
                                      : (productData?.productAmenities
                                                      ?.length ??
                                                  0) <
                                              5
                                          ? productData
                                                  ?.productAmenities?.length ??
                                              0
                                          : 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      color: Colors.grey.shade300,
                                      elevation: 0,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            getAmenityIcon(
                                              productData
                                                      ?.productAmenities?[index]
                                                      .amnity
                                                      ?.name ??
                                                  '',
                                            ),
                                            const Gap(05),
                                            Text(
                                              DbHelper.getLanguage() == 'en'
                                                  ? "${productData?.productAmenities?[index].amnity?.name}"
                                                  : "${productData?.productAmenities?[index].amnity?.nameAr}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Gap(10),
                                Visibility(
                                  visible:
                                      (productData?.productAmenities?.length ??
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
                                      ),
                                    ),
                                  ),
                                ),
                              },
                              const Divider(),
                              Text(
                                StringHelper.mapView,
                                style: context.titleMedium,
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AssetsRes.IC_LOACTION_ICON,
                                    height: 16,
                                  ),
                                  const Gap(05),
                                  Expanded(
                                    child: Text(
                                      productData?.nearby ?? '',
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
                                  final availableMaps =
                                      await MapLauncher.installedMaps;
                                  debugPrint("$availableMaps");
                                  await availableMaps.first.showMarker(
                                    coords: Coords(
                                      double.parse(
                                        "${productData?.latitude}",
                                      ),
                                      double.parse(
                                        "${productData?.longitude}",
                                      ),
                                    ),
                                    title: productData?.nearby ?? '',
                                  );
                                },
                                child: Text(
                                  StringHelper.getDirection,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    color: Colors.red,
                                    decorationColor: Colors.red,
                                  ),
                                ),
                              ),
                              const Gap(5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height: 150,
                                  width: context.width,
                                  child: AddressMapWidget(
                                    latLng: LatLng(
                                      double.parse(
                                          productData?.latitude ?? '0'),
                                      double.parse(
                                          productData?.longitude ?? '0'),
                                    ),
                                    address: productData?.nearby ?? "",
                                  ),
                                ),
                              ),
                              const Gap(10),
                              // "Posted by" section without grey background
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ImageView.circle(
                                      placeholder: AssetsRes.IC_USER_ICON,
                                      image:
                                          "${ApiConstants.imageUrl}/${productData?.user?.profilePic}",
                                      width: 80,
                                      height: 80,
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
                                          style: context.textTheme.titleSmall
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                        Text(
                                          "${productData?.user?.name} ${productData?.user?.lastName}",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                            fontFamily:
                                                FontRes.MONTSERRAT_SEMIBOLD,
                                          ),
                                        ),
                                        Text(
                                          '${StringHelper.postedOn} ${DateHelper.joiningDate(DateTime.parse('${productData?.createdAt}'))}',
                                          style: context.textTheme.titleSmall
                                              ?.copyWith(color: Colors.grey),
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
                                            productData?.user?.id =
                                                productData.userId;
                                            context.push(
                                              Routes.seeProfile,
                                              extra: productData?.user,
                                            );
                                          },
                                          child: Text(
                                            StringHelper.seeProfile,
                                            style: context.textTheme.titleSmall
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
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Gap(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: context.textTheme.bodyMedium,
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
                                          style: context.textTheme.bodyMedium,
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
                                          style: context.textTheme.bodyMedium,
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
                                          style: context.textTheme.bodyMedium,
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
                                          style: context.textTheme.bodyMedium,
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
            AnimatedBuilder(
              animation: viewModel.scrollController,
              builder: (context, child) {
                final offset = viewModel.scrollController.hasClients
                    ? viewModel.scrollController.offset
                    : 0.0;
                final bool showHeader = offset >= 350.0;
                return IgnorePointer(
                  ignoring:
                      !showHeader, // Allows taps to pass through when header is hidden
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: showHeader ? 1.0 : 0.0,
                    child: Container(
                      height: 60,
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
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: SafeArea(
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                context.pop();
                              },
                              icon: Icon(
                                Directionality.of(context) == TextDirection.ltr
                                    ? LineAwesomeIcons.arrow_left_solid
                                    : LineAwesomeIcons.arrow_right_solid,
                                size: 28,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                productDetails?.name ?? '',
                                style: context.textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
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
                          ],
                        ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                  data: productDetails,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build truncated description with "Read More"
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

  // Method to show full description in a modal
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

    if (productData?.categoryId == 11) {
      if (productData?.bedrooms != null && productData!.bedrooms != 0) {
        specs.add(_buildSpecRow(
          context,
          "${productData.bedrooms} ${StringHelper.beds}",
          Icons.king_bed,
        ));
      }
      if (productData?.bathrooms != null && productData!.bathrooms != 0) {
        specs.add(_buildSpecRow(
          context,
          "${productData.bathrooms} ${StringHelper.baths}",
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
            width: 8, // The horizontal spacing between spec items
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
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensures the row is as small as needed
      children: [
        Icon(
          icon,
          size: 16.0,
          color: Colors.black87,
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

  Widget getPropertyInformation({
    required BuildContext context,
    ProductDetailModel? data,
  }) {
    List<Widget> specs = [];

    // Build the list of specifications
    if ((data?.propertyFor ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.getPropertyType("${data?.propertyFor??""}"),
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
        "${data?.bedrooms}",
        '🛏️',
        StringHelper.bedrooms,
      ));
    }
    if ((data?.bathrooms ?? 0) != 0) {
      specs.add(_buildInfoRow(
        context,
        "${data?.bathrooms}",
        '🚽',
        StringHelper.bathrooms,
      ));
    }
    if ((data?.furnishedType ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        Utils.getFurnished("${data?.furnishedType??""}"),
        '🛋️',
        StringHelper.furnishedType,
      ));
    }
    if ((data?.ownership ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getCommon(data?.ownership??"").capitalized}",
        '📜',
        StringHelper.ownership,
      ));
    }
    if ((data?.paymentType ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getPaymentTyp(Utils.transformToSnakeCase(data?.paymentType??""))}",
        '💳',
        StringHelper.paymentType,
      ));
    }
    if ((data?.completionStatus ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getUtilityTyp(data?.completionStatus??"").capitalized}",
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
        Utils.getProperty("${data?.type??""}"),
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
        "${Utils.getCommon(data?.listedBy??"").capitalized}",
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
          Utils.carRentalTerm("${data?.rentalTerm??""}"),
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
    if ((data?.accessToUtilities ?? "").isNotEmpty) {
      specs.add(_buildInfoRow(
        context,
        "${Utils.getUtilityTyp(data?.accessToUtilities??"")}",
        '✅',
        StringHelper.accessToUtilities,
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
