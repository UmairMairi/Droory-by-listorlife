
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/providers/language_provider.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
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
    viewModel.appSettingList = [
      SettingItemModel(
          isArrow: null,
          icon: AssetsRes.IC_LANG_CHANGE,
          title: StringHelper.language,
          onTap: () {
            languageDialog(context,viewModel);
          }),
    ];
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
          isArrow: null,
          icon: AssetsRes.IC_NOTIFICATION,
          title: StringHelper.notifications,
          onTap: () {}),
      SettingItemModel(
          isArrow: true,
          title: StringHelper.howToConnect,
          icon: AssetsRes.IC_COMMUNICATION,
          onTap: () {
            howToConnect(context,viewModel);
          }),
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
            deleteAccountDialog(context,viewModel);
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
                ? guestDetails(context, viewModel)
                : userDetails(context, viewModel),
            const Divider(),
            if (!viewModel.isGuest) ...{
              CustomExpansionTile(
                label: StringHelper.manageYourAccountAndPrivacy,
                title: StringHelper.accountSettings,
                isExpanded: viewModel.isAccountSettings,
                onExpansionChanged: (val) => viewModel.isAccountSettings = val,
                items: viewModel.accountSettingsList,
                widget: Transform.scale(
                  scale: 0.6,
                  child: CupertinoSwitch(
                      value: viewModel.isActiveNotification,
                      activeTrackColor: Colors.black,
                      onChanged: viewModel.onSwitchChanged
                  ),
                ),
              ),
              const Divider(),
            },
            CustomExpansionTile(
              label: StringHelper.customizeYourAppExperience,
              title: StringHelper.appSettings,
              isExpanded: viewModel.isAppSetting,
              onExpansionChanged: (val) => viewModel.isAppSetting = val,
              items: viewModel.appSettingList,
              widget:Text(DbHelper.getLanguage() == 'en' ? 'English' : 'عربي'),
            ),
            const Divider(),
            CustomExpansionTile(
              label: StringHelper.getHelpAndLearnMoreAboutTheApp,
              title: StringHelper.supportInformation,
              isExpanded: viewModel.isSupport,
              onExpansionChanged: (val) => viewModel.isSupport = val,
              items: viewModel.supportList,
            ),
            if (!viewModel.isGuest) ...{
              const Divider(),
              Gap(10),
              InkWell(
                  onTap: (){
                    logoutDialog(context,viewModel);
                  },
                  child: SettingItemView(
                    item:SettingItemModel(
                        icon: AssetsRes.IC_LOGOUT,
                        title: StringHelper.logout,
                        onTap: () {}),)),
            }
          ],
        ),
      ),
    );
  }

  String getImageUrl() {
    String url = DbHelper.getUserModel()?.profilePic??"";
    if(url.isEmpty){
      return AssetsRes.IC_USER_ICON;
    }
    if (url.contains('http')) {
      return url;
    }
    return "${ApiConstants.imageUrl}/$url";
  }

  userDetails(BuildContext context, SettingVM viewModel) {
    return Container(
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
          Visibility(
            visible: false,
            child: IconButton(
                onPressed: () {
                  context.read<ProfileVM>().imagePath = '';
                  context.push(Routes.editProfile);
                },
                icon: const Icon(
                  CupertinoIcons.square_pencil,
                  size: 20,
                )),
          ),
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
          Visibility(
            visible: DbHelper.getIsVerifiedEmailOrPhone(),
            child: Icon(
              Icons.verified,
              color: Colors.green,
            ),
          ),
          AppElevatedButton(
            onTap: () {
              context.read<ProfileVM>().imagePath = '';
              context.push(Routes.editProfile);
            },
            height: 30,
            width: 100,
            title: StringHelper.editProfile,
          )
        ],
      ),
    );
  }

  guestDetails(BuildContext context, SettingVM viewModel) {
    return Container(
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
    );
  }

  void logoutDialog(BuildContext context, SettingVM viewModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppAlertDialogWithWidget(
          title: StringHelper.logout,
          description: StringHelper.logoutMsg,
          onTap: () {
            context.pop();
            DialogHelper.showLoading();
            viewModel.logoutUser(context);
          },
          icon: AssetsRes.IC_LOGOUT_ICON,
          onCancelTap: () {
            context.pop();
          },
          buttonText: StringHelper.yes,
          cancelButtonText: StringHelper.no,
          showCancelButton: true,
        );
      },
    );
  }

  void languageDialog(BuildContext context, SettingVM viewModel) {
    final currentLang = DbHelper.getLanguage();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(StringHelper.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageTile(
                context,
                languageCode: 'en',
                languageLabel: 'Switch to English',
                isSelected: currentLang == 'en',
              ),
              _buildLanguageTile(
                context,
                languageCode: 'ar',
                languageLabel: 'Switch to Arabic',
                isSelected: currentLang == 'ar',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(StringHelper.cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageTile(
      BuildContext context, {
        required String languageCode,
        required String languageLabel,
        required bool isSelected,
      }) {
    return ListTile(
      title: Text(languageLabel),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () {
        if (!isSelected) {
          DbHelper.saveLanguage(languageCode);
          context.read<LanguageProvider>().updateLanguage(
            context: context,
            lang: languageCode,
          );
          Navigator.of(context).pop();
        }
      },
    );
  }

  void howToConnect(BuildContext context, SettingVM viewModel) {
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
                child: Text(StringHelper.cancel),
              ),
              TextButton(
                onPressed: () => {
                  vm.updateProfileApi(),
                  Navigator.of(context).pop()
                },
                child: Text(StringHelper.update),
              ),
            ],
          );
        });
  }

  void deleteAccountDialog(BuildContext context, SettingVM viewModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppAlertDialogWithLottie(
          lottieIcon: AssetsRes.DELETE_LOTTIE,
          title: StringHelper.accountDelete,
          description: StringHelper.accountDeleteMsg,
          onTap: () {
            context.pop();
            DialogHelper.showLoading();
            viewModel.deleteAccount();
          },
          onCancelTap: () {
            context.pop();
          },
          buttonText: StringHelper.yes,
          cancelButtonText: StringHelper.no,
          showCancelButton: true,
        );
      },
    );
  }

}


class SettingItemView extends StatelessWidget {
  final SettingItemModel item;
  final Widget? widget;

  const SettingItemView({super.key, required this.item, this.widget});

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
        if (item.isArrow == null)... {
     widget??SizedBox.shrink()
    }
        else if (item.isArrow == true)... {
     const Icon(
    Icons.arrow_forward_ios,
       size: 15,
       color: Colors.grey,
     )
    }
        else... {
     const SizedBox.shrink()
    }

      ],
    );
  }





}


class CustomExpansionTile extends StatelessWidget {
  final String label;
  final String title;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final List<SettingItemModel> items;

  final Widget? widget;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.items,
    this.widget,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: true,
      shape: const RoundedRectangleBorder(),
      tilePadding: EdgeInsets.zero,
      title: Text(
        label,
        style: context.titleMedium,
      ),
      subtitle: Text(
        title,
        style: context.titleSmall,
      ),
      trailing: Icon(
        isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
        size: isExpanded ? 25 : 15,
        color: Colors.grey,
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
      expandedAlignment: Alignment.topLeft,
      onExpansionChanged: onExpansionChanged,
      children: List.generate(items.length, (index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SettingItemView(
              item: item,
              widget: widget,
            ),
          ),
        );
      }),
    );
  }
}

