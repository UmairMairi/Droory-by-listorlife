import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/providers/language_provider.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/communication_buttons.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../base/helpers/dialog_helper.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../models/setting_item_model.dart';
import '../../../widgets/multi_select_category.dart';

class SettingView extends BaseView<SettingVM> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, SettingVM viewModel) {
    viewModel.supportList = [
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_CONTACT_US,
          title: StringHelper.contactUs,
          onTap: () {
            context.push(Routes.contactUsView);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_FAQ,
          title: StringHelper.faqs,
          onTap: () {
            context.push(Routes.faqView);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_PRIVCY_POLICY,
          title: StringHelper.privacyPolicy,
          onTap: () {
            context.push(Routes.termsOfUse, extra: 1);
          }),
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_T_AND_C,
          title: StringHelper.termsConditions,
          onTap: () {
            context.push(Routes.termsOfUse, extra: 2);
          }),
    ];
    viewModel.accountSettingsList = [
      SettingItemModel(
          isArrow: true,
          icon: AssetsRes.IC_BLOCS_LIST,
          title: StringHelper.blockedUsers,
          onTap: () {
            context.push(Routes.blockedUserList);
          }),
      SettingItemModel(
          icon: AssetsRes.IC_DELETE_ACCOUNT,
          title: StringHelper.deleteAccount,
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AppAlertDialogWithLottie(
                  lottieIcon: AssetsRes.DELETE_LOTTIE,
                  title: 'Account Delete',
                  description: 'Are you sure you want to delete this account?',
                  onTap: () {
                    context.pop();
                    DialogHelper.showLoading();
                    viewModel.deleteAccount();
                  },
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
          title: StringHelper.logout,
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AppAlertDialogWithWidget(
                  title: StringHelper.logout,
                  description: 'Are you sure you want to logout this account?',
                  onTap: () {
                    context.pop();
                    DialogHelper.showLoading();
                    viewModel.logoutUser();
                  },
                  icon: AssetsRes.IC_LOGOUT_ICON,
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
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.myProfile),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            viewModel.isGuest
                ? Container(
                    width: context.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ImageView.circle(
                          image: AssetsRes.IC_USER_ICON,
                          placeholder: AssetsRes.IC_USER_ICON,
                          borderColor: Colors.black,
                          borderWidth: 4,
                          height: 120,
                          width: 120,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          StringHelper.guestUser,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontFamily: FontRes.POPPINS_REGULAR,
                            fontSize: 18,
                          ),
                        ),
                        AppElevatedButton(
                          onTap: () {
                            context.push(Routes.guestLogin);
                          },
                          height: 30,
                          width: 100,
                          title: StringHelper.login,
                        )
                      ],
                    ),
                  )
                : Container(
                    width: context.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageView.circle(
                          image: getImageUrl(),
                          borderWidth: 1,
                          borderColor: Colors.black,
                          height: 120,
                          width: 120,
                        ),
                        IconButton(
                            onPressed: () {
                              context.read<ProfileVM>().imagePath = '';
                              context.push(Routes.editProfile);
                            },
                            icon: const Icon(
                              CupertinoIcons.square_pencil,
                              size: 20,
                            )),
                        Text(
                          "${DbHelper.getUserModel()?.name} ${DbHelper.getUserModel()?.lastName}",
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontFamily: FontRes.POPPINS_SEMIBOLD,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          DbHelper.getUserModel()?.email ?? '',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontFamily: FontRes.POPPINS_REGULAR,
                            fontSize: 16,
                          ),
                        ),
                        DbHelper.getIsVerifiedEmailOrPhone()
                            ? Icon(
                                Icons.verified,
                                color: Colors.green,
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
            const Divider(),
            const Gap(20),
            if (!viewModel.isGuest) ...{
              Text(
                StringHelper.accountSettings,
                style: context.titleMedium,
              ),
              const Gap(10),
              Container(
                width: context.width,
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                          StringHelper.notifications,
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
              const Gap(10),
              InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        ProfileVM vm = context.read<ProfileVM>();
                        return AlertDialog(
                          title: Text(StringHelper.howToConnect),
                          content: MultiSelectCategory(
                            inDialog: true,
                            onSelectedCommunicationChoice:
                                (CommunicationChoice value) {
                              vm.communicationChoice = value.name;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => {
                                vm.updateProfileApi(),
                                Navigator.of(context).pop()
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      });
                },
                child: SettingItemView(
                    item: SettingItemModel(
                        title: StringHelper.howToConnect,
                        icon: AssetsRes.IC_COMMUNICATION,
                        isArrow: true,
                        onTap: () async {})),
              ),
              const Divider(),
            },
            Text(
              StringHelper.support,
              style: context.titleMedium,
            ),
            const Gap(10),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: viewModel.supportList[index].onTap,
                      child:
                          SettingItemView(item: viewModel.supportList[index]));
                },
                separatorBuilder: (context, index) {
                  return const Gap(5);
                },
                itemCount: viewModel.supportList.length),
            const Divider(),
            Text(
              StringHelper.appSettings,
              style: context.titleMedium,
            ),
            const Gap(10),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Select Language'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // English language option
                            ListTile(
                              title: Text('Switch to English'),
                              trailing: DbHelper.getLanguage() == 'en'
                                  ? Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : null,
                              onTap: () {
                                if (DbHelper.getLanguage() != 'en') {
                                  DbHelper.saveLanguage(
                                      'en'); // Update to English
                                  context.read<LanguageProvider>().updateLanguage(
                                      context: context,
                                      lang:
                                          'en'); // Change app locale to Arabic
                                  // Change app locale to English
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                }
                              },
                            ),
                            // Arabic language option
                            ListTile(
                              title: Text('Switch to Arabic'),
                              trailing: DbHelper.getLanguage() == 'ar'
                                  ? Icon(Icons.check_circle,
                                      color: Colors.green)
                                  : null,
                              onTap: () {
                                if (DbHelper.getLanguage() != 'ar') {
                                  DbHelper.saveLanguage(
                                      'ar'); // Update to Arabic
                                  context.read<LanguageProvider>().updateLanguage(
                                      context: context,
                                      lang:
                                          'ar'); // Change app locale to Arabic
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                }
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AssetsRes.IC_LANG_CHANGE,
                        width: 40,
                      ),
                      const Gap(10),
                      Text(
                        StringHelper.language,
                        style: context.textTheme.titleMedium
                            ?.copyWith(fontFamily: FontRes.POPPINS_MEDIUM),
                      ),
                    ],
                  ),
                  Text(DbHelper.getLanguage() == 'en' ? 'English' : 'عربي'),
                ],
              ),
            ),
            /*  const Gap(10),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Light theme option
                          ListTile(
                            title: Text('Switch to Light Theme'),
                            trailing: DbHelper.getTheme() == 'light'
                                ? Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              if (DbHelper.getTheme() != 'light') {
                                DbHelper.saveTheme(
                                    'light'); // Update to Light Theme
                                context.read<LanguageProvider>().updateTheme(
                                      context: context,
                                      theme:
                                          'light', // Change app theme to Light
                                    );
                                Navigator.of(context).pop(); // Close the dialog
                              }
                            },
                          ),
                          // Dark theme option
                          ListTile(
                            title: Text('Switch to Dark Theme'),
                            trailing: DbHelper.getTheme() == 'dark'
                                ? Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              if (DbHelper.getTheme() != 'dark') {
                                DbHelper.saveTheme(
                                    'dark'); // Update to Dark Theme
                                context.read<LanguageProvider>().updateTheme(
                                      context: context,
                                      theme: 'dark', // Change app theme to Dark
                                    );
                                Navigator.of(context).pop(); // Close the dialog
                              }
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AssetsRes.IC_THEMES,
                        width: 40,
                      ),
                      const Gap(10),
                      Text(
                        StringHelper.theme,
                        style: context.textTheme.titleMedium
                            ?.copyWith(fontFamily: FontRes.POPPINS_MEDIUM),
                      ),
                    ],
                  ),
                  Text(DbHelper.getTheme()),
                ],
              ),
            ),*/
            const Divider(),
            if (!viewModel.isGuest) ...{
              Text(
                StringHelper.accountManagement,
                style: context.titleMedium,
              ),
              const Gap(10),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: viewModel.accountSettingsList[index].onTap,
                        child: SettingItemView(
                            item: viewModel.accountSettingsList[index]));
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(5);
                  },
                  itemCount: viewModel.accountSettingsList.length),
            }
          ],
        ),
      ),
    );
  }

  String getImageUrl() {
    String url = "${DbHelper.getUserModel()?.profilePic}";

    if (url.contains('http')) {
      return url;
    }
    return "${ApiConstants.imageUrl}/$url";
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
          //textDirection: TextDirection.ltr,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
