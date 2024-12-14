import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/inbox_model.dart';
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
  final ProductDetailModel? data;
  const ProductDetailView({super.key, required this.data});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
    return Scaffold(
      appBar: !viewModel.isAppBarVisible?AppBar(backgroundColor: Colors.transparent,automaticallyImplyLeading: false,toolbarHeight: 0,elevation: 0,):null,
      /*appBar: AppBar(
        title: Text(StringHelper.details),
        centerTitle: true,
        actions: [
          LikeButton(
            isFav: productData?.isFavourite == 1,
            onTap: () async {
              await viewModel.onLikeButtonTapped(id: productData?.id);
            },
          ),
          InkWell(
            onTap: () async {
              // final dynamicLink =
              //           await DynamicLinkHelper.createDynamicLink("${productData?.id}");
              //       debugPrint(dynamicLink.toString());
              //
              //       Share.share(
              //           'Hello, Please check this useful product on following link \n$dynamicLink',
              //           subject: 'Check this issue');
              //
              //       DialogHelper.showToast(message: "Coming Soon");
            },
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
      ),*/
      body: Stack(
        children: [
          FutureBuilder<ProductDetailModel?>(
              future: viewModel.getProductDetails(id: data?.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ProductDetailModel? productData = snapshot.data;
                  productData?.productMedias
                      ?.insert(0, ProductMedias(media: productData.image));
                  return SingleChildScrollView(
                    controller: viewModel.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CardSwipeWidget(
                              height: 350,
                              data: productData,
                              fit: BoxFit.fill,
                              imagesList: productData?.productMedias,
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
                                      icon: Icon(Icons.arrow_back_ios,
                                          textDirection: TextDirection.ltr,
                                          color: Colors.white)),
                                )),
                            Positioned(
                                top: 0,
                                right: 50,
                                child: SafeArea(
                                  child: LikeButton(
                                      isFav: productData?.isFavourite == 1,
                                      onTap: () async => {
                                            await viewModel.onLikeButtonTapped(
                                                id: productData?.id)
                                          }),
                                )),
                            Positioned(
                                top: 0,
                                right: 10,
                                child: SafeArea(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.share,
                                          color: Colors.white)),
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
                              Text(
                                "${productData?.name}",
                                style: context.textTheme.titleMedium,
                              ),
                              const Gap(5),
                              getSpecifications(context: context, productData: productData),
                              const Gap(5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 16,
                                    ),
                                  ),
                                  const Gap(05),
                                  Flexible(child: Text(productData?.nearby ?? '')),
                                ],
                              ),
                              const Gap(10),
                              if (productData?.categoryId == 9) ...{
                                Text(
                                  "${StringHelper.egp} ${productData?.salleryFrom} - ${productData?.salleryTo}",
                                  style: context.textTheme.titleLarge
                                      ?.copyWith(color: Colors.red),
                                ),
                              } else ...{
                                Text(
                                  "${StringHelper.egp} ${productData?.price}",
                                  style: context.textTheme.titleLarge
                                      ?.copyWith(color: Colors.red),
                                ),
                              },
                              const Gap(10),
                              Divider(),
                              Text(
                                StringHelper.description,
                                style: context.textTheme.titleMedium,
                              ),
                              const Gap(05),
                              Text(productData?.description ?? ''),
                              Divider(),
                              if (productData?.categoryId != 11) ...{
                                if (viewModel
                                    .getSpecifications(
                                        context: context, data: productData)
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(10),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisExtent: 50,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 20),
                                      children: viewModel.getSpecifications(
                                          context: context, data: productData),
                                    ),
                                  ),
                                }
                              },
                              if (productData?.categoryId == 11) ...{
                                Text(
                                  'Property Information',
                                  style: context.titleMedium,
                                ),
                                Gap(10),
                                getPropertyInformation(
                                        context: context, productData: productData) ??
                                    SizedBox.shrink(),
                              },
                              if (productData?.categoryId == 11) ...{
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                        productData?.productAmenities?.length ?? 0,
                                            (index) {
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
                                                getAmenityIcon(productData
                                                    ?.productAmenities?[index]
                                                    .amnity
                                                    ?.name ??
                                                    ''),
                                                Gap(05),
                                                Text(DbHelper.getLanguage() == 'en'
                                                    ? "${productData?.productAmenities?[index].amnity?.name}"
                                                    : "${productData?.productAmenities?[index].amnity?.nameAr}"),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                CommonGridView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  //mainAxisExtent: 120,
                                  crossAxisCount: 3,
                                  childAspectRatio: 16/16,
                                  itemCount: viewModel.showAll
                                      ? productData?.productAmenities?.length ?? 0
                                      : (productData?.productAmenities?.length ?? 0) < 5
                                      ? productData?.productAmenities?.length ?? 0
                                      : 5,
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
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          getAmenityIcon(productData
                                              ?.productAmenities?[index]
                                              .amnity
                                              ?.name ??
                                              ''),
                                          Gap(05),
                                          Text(DbHelper.getLanguage() == 'en'
                                              ? "${productData?.productAmenities?[index].amnity?.name}"
                                              : "${productData?.productAmenities?[index].amnity?.nameAr}",textAlign: TextAlign.center,),
                                        ],
                                      ),
                                    ),
                                  );
                                },),
                                Gap(10),
                                Visibility(
                                    visible: (productData?.productAmenities?.length ?? 0) > 5,
                                    child:GestureDetector(
                                        onTap: (){
                                          viewModel.showAll = !viewModel.showAll;
                                        },
                                        child:Align(
                                            alignment: Alignment.topRight,
                                            child:Text(
                                              viewModel.showAll ? "See Less" : "See More",
                                              style: context.textTheme.titleSmall,
                                            )))),
                              },
                              Divider(),
                              Text(
                                'Map View',
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
                                        context: context);
                                    return;
                                  }
                                  final availableMaps =
                                      await MapLauncher.installedMaps;
                                  print(
                                      availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                                  await availableMaps.first.showMarker(
                                    coords: Coords(
                                        double.parse("${productData?.latitude}"),
                                        double.parse("${productData?.longitude}")),
                                    title: "Ocean Beach",
                                  );
                                },
                                child: Text(
                                  StringHelper.getDirection,
                                  style: context.textTheme.titleSmall?.copyWith(
                                      color: Colors.red,
                                      decorationColor: Colors.red,
                                      decoration: TextDecoration.underline),
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
                                      double.parse(productData?.latitude ?? '0'),
                                      double.parse(productData?.longitude ?? '0'),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Card(
                                color: const Color(0xfff5f5f5),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ImageView.circle(
                                          image:
                                              "${ApiConstants.imageUrl}/${productData?.user?.profilePic}",
                                          width: 80,
                                          height: 80),
                                      /*const CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                      AssetImage(AssetsRes.DUMMY_PROFILE),
                                    ),*/
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
                                            style: context.textTheme.titleLarge
                                                ?.copyWith(
                                                    fontFamily: FontRes
                                                        .MONTSERRAT_SEMIBOLD),
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
                                                    context: context);
                                                return;
                                              }

                                              productData?.user?.id = productData.userId;

                                              context.push(Routes.seeProfile,
                                                  extra: productData?.user);
                                            },
                                            child: Text(
                                              StringHelper.seeProfile,
                                              style: context
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                      color: Colors.red,
                                                      decorationColor:
                                                          Colors.red,
                                                      decoration: TextDecoration
                                                          .underline),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(30),
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
                return ProductDetailSkeleton(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 35,
              child: CommunicationButtons(
                data: data, // Pass any additional data required
              ),
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (DbHelper.getIsGuest()) {
                            DialogHelper.showLoginDialog(context: context);

                            return;
                          }

                          DialogHelper.goToUrl(
                              uri: Uri.parse("tel://+919876543210"));
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
                                AssetsRes.IC_CALL_ICON,
                                height: 16,
                              ),
                              const Gap(05),
                              Text(
                                StringHelper.call,
                                style: context.textTheme.labelLarge?.copyWith(
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
                          if (DbHelper.getIsGuest()) {
                            DialogHelper.showLoginDialog(context: context);
                            return;
                          }
                          context.push(
                            Routes.message,
                            extra: InboxModel(
                                senderId: DbHelper.getUserModel()?.id,
                                receiverId: data?.userId,
                                productId: data?.id,
                                productDetail: data,
                                receiverDetail: SenderDetail(
                                    id: data?.userId,
                                    lastName: data?.user?.lastName,
                                    profilePic: data?.user?.profilePic,
                                    name: data?.user?.name),
                                senderDetail: SenderDetail(
                                    id: DbHelper.getUserModel()?.id,
                                    profilePic:
                                        DbHelper.getUserModel()?.profilePic,
                                    lastName: DbHelper.getUserModel()?.lastName,
                                    name: DbHelper.getUserModel()?.name)),
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
                                StringHelper.chat,
                                style: context.textTheme.labelLarge?.copyWith(
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
                          if (DbHelper.getIsGuest()) {
                            DialogHelper.showLoginDialog(context: context);

                            return;
                          }
                          DialogHelper.goToUrl(
                              uri: Uri.parse(
                                  'https://wa.me/+919876543210?text=Hii, I am from List & Live app and interested in your ad.'));
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
                                AssetsRes.IC_WHATSAPP_ICON,
                                height: 18,
                              ),
                              const Gap(05),
                              Text(
                                StringHelper.whatsapp,
                                style: context.textTheme.labelLarge?.copyWith(
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
                  ])*/
            ),
          )
        ],
      ),
    );
  }

  Widget getSpecifications({
    required BuildContext context,
    ProductDetailModel? productData,
  }) {
    List<Widget> specs = [];

    if (productData?.categoryId == 4) {
      // Vehicles category
      if (productData?.year != null && productData!.year != 0) {
        specs.add(_buildSpecRow(
            context, "${productData.year}", Icons.event)); // Icon for year
      }
      if (productData?.milleage != null && productData!.milleage!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, '${productData.milleage}', Icons.speed)); // Icon for mileage
      }
      if (productData?.fuel != null && productData!.fuel!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, '${productData.fuel}', Icons.local_gas_station)); // Icon for fuel
      }
    }

    if (productData?.categoryId == 11) {
      // Real Estate category
      if (productData?.bedrooms != null && productData!.bedrooms != 0) {
        specs.add(_buildSpecRow(context, "${productData.bedrooms} Beds",
            Icons.king_bed)); // Icon for bedrooms
      }
      if (productData?.bathrooms != null && productData!.bathrooms != 0) {
        specs.add(_buildSpecRow(context, "${productData.bathrooms} Baths",
            Icons.bathtub)); // Icon for bathrooms
      }
      if (productData?.area != null && productData!.area != 0) {
        specs.add(_buildSpecRow(
            context, "${productData.area} Sqft", Icons.square_foot)); // Icon for area
      }
    }

    if (specs.isNotEmpty) {
      return SizedBox(
        height: 20,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: specs,
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildSpecRow(BuildContext context, String specValue, IconData icon) {
    return SizedBox(
      width: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.0, // A slightly larger, professional size
            color: Colors.blueGrey, // Neutral color for professionalism
          ),
          const SizedBox(width: 4), // Slightly increased spacing for balance
          Expanded(
            child: Text(
              specValue,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87, // Darker font color for readability
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
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

  getPropertyInformation(
      {required BuildContext context, ProductDetailModel? productData}) {
    {
      List<Widget> specs = [];

      if (productData?.propertyFor != null && productData!.propertyFor!.isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${productData.propertyFor?.capitalized}", '🏠', 'Property For'));
      }
      if (productData?.area != null && productData!.area != 0) {
        specs.add(_buildInfoRow(context, "${productData.area} sqft", '📏', 'Area'));
      }
      if (productData?.bedrooms != null && productData!.bedrooms != 0) {
        specs
            .add(_buildInfoRow(context, "${productData.bedrooms}", '🛏️', 'Bedrooms'));
      }
      if (productData?.bathrooms != null && productData!.bathrooms != 0) {
        specs.add(
            _buildInfoRow(context, "${productData.bathrooms}", '🚽', 'Bathrooms'));
      }
      if (productData?.furnishedType != null && productData!.furnishedType!.isNotEmpty) {
        specs.add(_buildInfoRow(context, "${productData.furnishedType?.capitalized}",
            '🛋️', 'Furnished Type'));
      }
      if (productData?.ownership != null && productData!.ownership!.isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${productData.ownership?.capitalized}", '📜', 'Ownership'));
      }
      if (productData?.paymentType != null && productData!.paymentType!.isNotEmpty) {
        specs.add(_buildInfoRow(
            context, "${productData.paymentType?.capitalized}", '💳', 'Payment Type'));
      }
      if (productData?.completionStatus != null &&
          productData!.completionStatus!.isNotEmpty) {
        specs.add(_buildInfoRow(context,
            "${productData.completionStatus?.capitalized}", '✅', 'Completion Status'));
      }
      if (productData?.deliveryTerm != null && productData!.deliveryTerm!.isNotEmpty) {
        specs.add(_buildInfoRow(context, "${productData.deliveryTerm?.capitalized}",
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
}

class AddressMapWidget extends StatelessWidget {
  final LatLng latLng;
  const AddressMapWidget({super.key, required this.latLng});

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
              CameraPosition(zoom: 15, target: latLng)),
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
                title: "Ocean Beach",
              );
            })
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
