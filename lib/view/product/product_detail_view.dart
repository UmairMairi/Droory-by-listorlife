import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/view_model/product_v_m.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../base/helpers/date_helper.dart';
import '../../base/helpers/db_helper.dart';
import '../../base/helpers/dialog_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../routes/app_routes.dart';
import '../../skeletons/product_detail_skeleton.dart';
import '../../widgets/app_error_widget.dart';
import '../../widgets/card_swipe_widget.dart';
import '../../widgets/like_button.dart';

class ProductDetailView extends BaseView<ProductVM> {
  final ProductDetailModel? data;
  const ProductDetailView({super.key, required this.data});

  @override
  Widget build(BuildContext context, ProductVM viewModel) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<ProductDetailModel?>(
              future: viewModel.getProductDetails(id: data?.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CardSwipeWidget(
                          height: 300,
                          imagesList: data?.productMedias,
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
                                "${data?.name}",
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
                                      ?.toLowerCase()
                                      .contains(StringHelper.cars) ??
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
                                              style:
                                                  context.textTheme.titleSmall,
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
                                              style:
                                                  context.textTheme.titleSmall,
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
                                              style:
                                                  context.textTheme.titleSmall,
                                            ),
                                          ],
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
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
                                                style: context
                                                    .textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
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
                                                style: context
                                                    .textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
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
                                                style: context
                                                    .textTheme.titleSmall,
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
                                            DateHelper.joiningDate(
                                                DateTime.parse(
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: viewModel.getSpecifications(
                                    context: context, data: data),
                              ),
                              const Gap(10),
                              const Gap(10),
                              Text(
                                StringHelper.description,
                                style: context.textTheme.titleMedium,
                              ),
                              const Gap(05),
                              Text(data?.description ?? ''),
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
                                              "${ApiConstants.imageUrl}/${data?.user?.profilePic}",
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
                                            "${data?.user?.name} ${data?.user?.lastName}",
                                            style: context.textTheme.titleLarge
                                                ?.copyWith(
                                                    fontFamily: FontRes
                                                        .MONTSERRAT_SEMIBOLD),
                                          ),
                                          Text(
                                            '${StringHelper.postedOn} ${DateHelper.joiningDate(DateTime.parse('${data?.createdAt}'))}',
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

                                              data?.user?.id = data?.userId;

                                              context.push(Routes.seeProfile,
                                                  extra: data?.user);
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
                              const Gap(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AssetsRes.IC_LOACTION_ICON,
                                              height: 20,
                                            ),
                                            const Gap(05),
                                            Expanded(
                                              child: Text(
                                                data?.city ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: context
                                                    .textTheme.titleLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(05),
                                        Text(
                                          StringHelper.city,
                                          style: context.textTheme.titleMedium,
                                        ),
                                        const Gap(25),
                                        InkWell(
                                          onTap: () {
                                            if (DbHelper.getIsGuest()) {
                                              DialogHelper.showLoginDialog(
                                                  context: context);
                                              return;
                                            }
                                            print(data?.toJson());
                                            MapsLauncher.launchQuery(
                                                data?.nearby ?? '');
                                          },
                                          child: Text(
                                            StringHelper.getDirection,
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: Colors.red,
                                                    decorationColor: Colors.red,
                                                    decoration: TextDecoration
                                                        .underline),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: AddressMapWidget(
                                          latLng: LatLng(
                                            double.parse(data?.latitude ?? '0'),
                                            double.parse(
                                                data?.longitude ?? '0'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
          Positioned(
              top: 10,
              left: 10,
              child: SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )),
          Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(08),
                      margin: const EdgeInsets.all(08),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: LikeButton(
                        isFav: data?.isFavourite == 1,
                        onTap: () async {
                          await viewModel.onLikeButtonTapped(id: data?.id);
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () => Share.share(StringHelper.checkProductUrl),
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
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 30,
              child: Row(
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
                  ]),
            ),
          )
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
            onTap: () {
              MapsLauncher.launchCoordinates(latLng.latitude, latLng.longitude);
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
