import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';

class SettingView extends BaseView<SettingVM> {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, SettingVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(AssetsRes.DUMMY_PROFILE),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(CupertinoIcons.square_pencil)),
                  Text('john@gmail.com')
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
                      Gap(10),
                      Text(
                        'Notifications',
                        style: context.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                      value: viewModel.isActiveNotification,
                      onChanged: viewModel.onSwitchChanged)
                ],
              ),
            ),
            Gap(20),
            ListView.builder(
                itemCount: viewModel.settingList.length,
                itemBuilder: (context, index) {
                  return Container(
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
                            Gap(10),
                            Text(
                              'Notifications',
                              style: context.textTheme.titleSmall,
                            ),
                          ],
                        ),
                        CupertinoSwitch(
                            value: viewModel.isActiveNotification,
                            onChanged: viewModel.onSwitchChanged)
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
