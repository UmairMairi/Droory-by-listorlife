import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../models/setting_item_model.dart';

class SettingView extends BaseView<SettingVM> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, SettingVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DbHelper?.getIsGuest()
                ? Flexible(
                    child: Container(
                      width: context.width,
                      padding: const EdgeInsets.all(20),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ImageView.circle(
                            image: AssetsRes.IC_USER_ICON,
                            borderColor: Colors.black,
                            borderWidth: 4,
                            height: 120,
                            width: 120,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Guest User',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontFamily: FontRes.POPPINS_REGULAR,
                              fontSize: 18,
                            ),
                          ),
                          AppElevatedButton(
                            onTap: () {
                              context.push(Routes.login);
                            },
                            height: 30,
                            width: 100,
                            title: 'Login',
                          )
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: Container(
                      width: context.width,
                      padding: const EdgeInsets.all(20),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ImageView.circle(
                            image: AssetsRes.DUMMY_PROFILE,
                            height: 120,
                            width: 120,
                          ),
                          IconButton(
                              onPressed: () {
                                context.read<ProfileVM>().imagePath = '';
                                context.push(Routes.editProfile);
                              },
                              icon: const Icon(CupertinoIcons.square_pencil)),
                          Text(
                            'john@gmail.com',
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontFamily: FontRes.POPPINS_REGULAR,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            const Gap(20),
            if (!DbHelper.getIsGuest()) ...{
              Container(
                width: context.width,
                padding: const EdgeInsets.all(10),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AssetsRes.IC_NOTIFICATION,
                          width: 40,
                        ),
                        const Gap(10),
                        Text(
                          'Notifications',
                          style: context.textTheme.titleMedium
                              ?.copyWith(fontFamily: FontRes.POPPINS_MEDIUM),
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 0.6,
                      child: CupertinoSwitch(
                          value: viewModel.isActiveNotification,
                          activeColor: Colors.black,
                          onChanged: viewModel.onSwitchChanged),
                    )
                  ],
                ),
              ),
              const Gap(20),
            },
            Container(
              width: context.width,
              padding: const EdgeInsets.all(10),
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
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: viewModel.settingList[index].onTap,
                        child: SettingItemView(
                            item: viewModel.settingList[index]));
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: viewModel.settingList.length),
            )
          ],
        ),
      ),
    );
  }
}

class SettingItemView extends StatelessWidget {
  final SettingItemModel item;
  const SettingItemView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              item.icon ?? '',
              width: 40,
            ),
            const Gap(10),
            Text(
              item.title ?? '',
              style: context.textTheme.titleMedium
                  ?.copyWith(fontFamily: FontRes.POPPINS_MEDIUM),
            ),
          ],
        ),
        item.isArrow ?? false
            ? const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.grey,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
