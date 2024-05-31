import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/widgets/card_swipe_widget.dart';
import 'package:list_and_life/widgets/favorite_button.dart';

import '../routes/app_routes.dart';

class AppProductItemWidget extends StatelessWidget {
  final SettingItemModel? data;
  const AppProductItemWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                imagesList: data?.imageList,
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
                    child: FavoriteButton(
                      isFav: data?.isFav ?? false,
                      onTap: () {},
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
                Text(
                  data?.title ?? '',
                  style: context.textTheme.titleLarge
                      ?.copyWith(color: context.theme.colorScheme.error),
                ),
                const Gap(10),
                Text(
                  data?.subTitle ?? '',
                  style: context.textTheme.titleMedium,
                ),
                const Gap(5),
                Text(data?.description ?? ''),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AssetsRes.IC_ITEM_LOCATION,
                          scale: 2.5,
                        ),
                        const Gap(05),
                        Text(
                          data?.location ?? '',
                          style: context.textTheme.labelLarge?.copyWith(
                              fontFamily: FontRes.MONTSERRAT_REGULAR),
                        ),
                      ],
                    ),
                    Text(
                      data?.timeStamp ?? 'Today',
                      style: context.textTheme.labelLarge
                          ?.copyWith(fontFamily: FontRes.MONTSERRAT_REGULAR),
                    )
                  ],
                ),
                const Gap(20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => DialogHelper.goToUrl(
                              uri: Uri.parse("tel://+919876543210")),
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
                      const Gap(7.8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.push(
                              Routes.message,
                              extra: SettingItemModel(
                                icon: AssetsRes.DUMMY_CHAT_IMAGE2,
                                title: 'John Marker',
                                subTitle: 'Lorem Ipsum is simply dummy text.',
                                timeStamp: '1 min ago',
                              ),
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
                      const Gap(7.8),
                      Expanded(
                        child: InkWell(
                          onTap: () => DialogHelper.goToUrl(
                              uri: Uri.parse(
                                  'https://wa.me/+919876543210?text=Hii, I am from List & Live app and interested in your ad.')),
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
                const Gap(10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
