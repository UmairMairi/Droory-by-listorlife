import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/date_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/widgets/card_swipe_widget.dart';
import 'package:list_and_life/widgets/like_button.dart';

import '../base/helpers/db_helper.dart';
import '../models/common/map_response.dart';
import '../models/inbox_model.dart';
import '../base/network/api_constants.dart';
import '../base/network/api_request.dart';
import '../base/network/base_client.dart';
import '../routes/app_routes.dart';

class AppProductItemWidget extends StatelessWidget {
  final ProductDetailModel? data;
  final VoidCallback? onLikeTapped;
  final VoidCallback? onItemTapped;

  const AppProductItemWidget(
      {super.key, this.data, this.onLikeTapped, this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    data?.productMedias?.insert(0, ProductMedias(media: data?.image));
    return InkWell(
      onTap: onItemTapped,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 5), // Offset from the top
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CardSwipeWidget(
                  data: data,
                  imagesList: data?.productMedias,
                  height: 160,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(08),
                      margin: const EdgeInsets.all(08),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: LikeButton(
                        isFav: data?.isFavourite == 1,
                        onTap: () async =>
                            await onLikeButtonTapped(id: data?.id),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      Text(
                        "EGP ${data?.price}",
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: context.theme.colorScheme.error),
                      ),
                    ],
                  ),
                  const Gap(5),
                  Text(
                    data?.description ?? '',
                    maxLines: 1,
                    style: context.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AssetsRes.IC_ITEM_LOCATION,
                              scale: 2.5,
                            ),
                            const Gap(10),
                            Expanded(
                              child: Text(
                                data?.nearby ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelMedium?.copyWith(
                                    fontFamily: FontRes.MONTSERRAT_REGULAR),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        getCreatedAt(time: data?.createdAt),
                        style: context.textTheme.labelMedium
                            ?.copyWith(fontFamily: FontRes.MONTSERRAT_REGULAR),
                      )
                    ],
                  ),
                  const Gap(10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (DbHelper.getIsGuest()) {
                                DialogHelper.showLoginDialog(context: context);
                                return;
                              }
                              String phone =
                                  "${data?.user?.countryCode}${data?.user?.phoneNo}";
                              DialogHelper.goToUrl(
                                  uri: Uri.parse("tel://$phone"));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 08),
                              decoration: BoxDecoration(
                                color: const Color(0xff5A5B55),
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
                                    'Call',
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(7.8),
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
                                        lastName:
                                            DbHelper.getUserModel()?.lastName,
                                        name: DbHelper.getUserModel()?.name)),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 08),
                              decoration: BoxDecoration(
                                color: const Color(0xff5A5B55),
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
                                    'Chat',
                                    style: context.textTheme.labelLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(7.8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (DbHelper.getIsGuest()) {
                                DialogHelper.showLoginDialog(context: context);
                                return;
                              }
                              String phone =
                                  "${data?.user?.countryCode}${data?.user?.phoneNo}";
                              DialogHelper.goToUrl(
                                  uri: Uri.parse(
                                      'https://wa.me/$phone?text=Hii, I am from List & Live app and interested in your ad.'));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 08),
                              decoration: BoxDecoration(
                                color: const Color(0xff5A5B55),
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
                                    'Whatsapp',
                                    style:
                                        context.textTheme.labelLarge?.copyWith(
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
                  const Gap(10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

    return DateHelper.getTimeAgo(timestamp);
  }

  Future<void> onLikeButtonTapped({required num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addFavouriteUrl(),
        requestType: RequestType.post,
        body: {'product_id': id});

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);

    if (onLikeTapped != null) {
      Future.delayed(const Duration(milliseconds: 25), () => onLikeTapped!());
    }

    log("Fav Message => ${model.message}");
  }
}
