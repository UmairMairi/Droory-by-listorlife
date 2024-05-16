import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/card_swipe_widget.dart';
import 'package:list_and_life/widgets/favorite_button.dart';

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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(08),
                    margin: EdgeInsets.all(08),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
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
                  data?.title ?? 'EGP300',
                  style: context.textTheme.titleLarge
                      ?.copyWith(color: context.theme.colorScheme?.error),
                ),
                const Gap(10),
                Text(
                  data?.subTitle ?? 'Apple iPhone 15 Pro',
                  style: context.textTheme.titleMedium,
                ),
                const Gap(5),
                Text(data?.description ??
                    'Open Box iPhone 15 & 14 Plus Pro Max 128GB 256GB 512GB 1TB Warranty 76'),
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
                        Gap(05),
                        Text(
                          data?.location ?? 'New York City',
                          style: context.textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Text(
                      data?.timeStamp ?? 'Today',
                      style: context.textTheme.labelSmall,
                    )
                  ],
                ),
                const Gap(20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          onTap: () {},
                        ),
                      ),
                      Gap(05),
                      Expanded(
                        child: AppElevatedButton(
                          onTap: () {},
                        ),
                      ),
                      Gap(05),
                      Expanded(
                        child: AppElevatedButtonWithIcon(
                          onTap: () {},
                          title: 'WhatsApp',
                          icon: ImageIcon(
                            AssetImage(
                              AssetsRes.IC_WHATSAPP_ICON,
                            ),
                            size: 20,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
