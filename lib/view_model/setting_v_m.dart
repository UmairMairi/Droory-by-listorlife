import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/animations/bouncing_animation.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';

import '../models/setting_item_model.dart';
import '../widgets/app_elevated_button.dart';

class SettingVM extends BaseViewModel {
  bool _isActiveNotification = true;

  bool get isActiveNotification => _isActiveNotification;
  List<SettingItemModel> settingList = [];

  @override
  void onInit() {
    settingList = [
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_PRIVCY_POLICY,
          title: 'Privacy Policy',
          onTap: () {
            context.push(Routes.termsOfUse, extra: 1);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_T_AND_C,
          title: 'Terms & Conditions',
          onTap: () {
            context.push(Routes.termsOfUse, extra: 2);
          }),
      SettingItemModel(
          icon: AssetsRes.IC_DELETE_ACCOUNT,
          title: 'Delete Account',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AppAlertDialogWithLottie(
                  lottieIcon: AssetsRes.DELETE_LOTTIE,
                  title: 'Account Delete',
                  description: 'Are you sure you want to delete this account?',
                  onTap: () {},
                  onCancelTap: () {
                    context.pop();
                  },
                  buttonText: 'Yes',
                  cancelButtonText: 'No',
                  showCancelButton: true,
                );
              },
            );
          }),
      SettingItemModel(
          icon: AssetsRes.IC_LOGOUT,
          title: 'Logout',
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                    backgroundColor: const Color(0xFFEEEEEE),
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        BouncingAnimation(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              AssetsRes.IC_LOGOUT_ICON,
                              height: 80,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: context.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Logout',
                                style: context.textTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Are you sure you want to logout this account?',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppElevatedButtonWithoutAnimation(
                                      width: context.width,
                                      onTap: () {},
                                      title: ' Yes',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: AppElevatedButtonWithoutAnimation(
                                    width: context.width,
                                    backgroundColor: Color(0xffeeeeee),
                                    onTap: () {
                                      context.pop();
                                    },
                                    titleColor: Colors.black,
                                    title: ' No',
                                  )),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ));

                /*AppAlertDialog(
                  lottieIcon: AssetsRes.DELETE_LOTTIE,
                  title: 'Logout',
                  description: 'Are you sure you want to logout this account?',
                  onTap: () {},
                  onCancelTap: () {
                    context.pop();
                  },
                  buttonText: 'Yes',
                  cancelButtonText: 'No',
                  showCancelButton: true,
                )*/
                ;
              },
            );
          }),
    ];
    super.onInit();
  }

  set isActiveNotification(bool value) {
    _isActiveNotification = value;
    notifyListeners();
  }

  void onSwitchChanged(bool? value) {
    isActiveNotification = value ?? true;
  }
}
