import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';

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
            Flexible(
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
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(AssetsRes.DUMMY_PROFILE),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.square_pencil)),
                    Text('john@gmail.com')
                  ],
                ),
              ),
            ),
            Gap(20),
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
                        style: context.textTheme.titleSmall,
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
            Gap(20),
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
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
            return SettingItemView(item: viewModel.settingList[index]);
          }, separatorBuilder: (context, index){
            return Divider();
          }, itemCount: viewModel.settingList.length),
        )
          ],
        ),
      ),
    );
  }
}

class SettingItemView extends StatelessWidget{
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
              item.icon,
              width: 40,
            ),
            Gap(10),
            Text(
              item.title,
              style: context.textTheme.titleSmall,
            ),
          ],
        ),
        item.isArrow ?
        const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Colors.grey,
        ): const SizedBox.shrink()
      ],
    );
  }
}
