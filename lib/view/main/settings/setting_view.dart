import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/providers/language_provider.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view/profile/my_profile_view.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'rate_us_modal.dart'; // Add this line
import '../../../base/helpers/dialog_helper.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../models/setting_item_model.dart';
import '../../../widgets/multi_select_category.dart';
// Import the MyProfilePreviewView

class SettingView extends BaseView<SettingVM> {
  const SettingView({super.key});

  Widget _buildUserAvatar(ProfileVM profileVM) {
    final user = DbHelper.getUserModel();

    // If image was deleted, always show placeholder
    if (profileVM.isImageDeleted) {
      return _buildPlaceholderAvatar();
    }

    // Check for local image first (newly selected)
    final hasLocalImage = profileVM.imagePath.isNotEmpty;
    if (hasLocalImage) {
      final file = File(profileVM.imagePath);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderAvatar();
            },
          ),
        );
      }
    }

    // Check for database image
    final hasDatabaseImage = (user?.profilePic?.isNotEmpty == true);
    if (hasDatabaseImage && !profileVM.isImageDeleted) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: ClipOval(
          child: Image.network(
            getImageUrl(),
            fit: BoxFit.cover,
            width: 60,
            height: 60,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              // Show a subtle loading state instead of initials
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderAvatar();
            },
          ),
        ),
      );
    }

    // No image - show placeholder
    return _buildPlaceholderAvatar();
  }

  Widget _buildPlaceholderAvatar() {
    final user = DbHelper.getUserModel();
    final firstName = user?.name ?? '';
    final lastName = user?.lastName ?? '';

    // If we have names, show initials
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      String initials = "";
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        initials = '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
      } else if (firstName.isNotEmpty) {
        initials = firstName[0].toUpperCase();
      } else if (lastName.isNotEmpty) {
        initials = lastName[0].toUpperCase();
      }

      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.shade600,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Fallback to person icon when no name is available
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade600,
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, SettingVM viewModel) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(StringHelper.myProfile),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: viewModel.isGuest
                  ? guestDetails(context, viewModel)
                  : userDetails(context, viewModel),
            ),

            const Gap(24),

            // Account Settings Section
            if (!viewModel.isGuest) ...[
              _buildSectionHeader(StringHelper.account),
              const Gap(8),
              _buildSection([
                _buildSettingTile(
                  icon: Icons.person_outline,
                  title: StringHelper.editProfileTile,
                  onTap: () {
                    // Don't clear the image path - preserve the ProfileVM state
                    context.push(Routes.editProfile);
                  },
                ),
                // NEW: Preview My Profile option
                _buildSettingTile(
                  icon: Icons.visibility_outlined,
                  title: StringHelper
                      .previewMyProfile, // Better name - shows it's a preview
                  onTap: () => _showMyProfile(context),
                ),
                _buildSettingTile(
                  icon: Icons.notifications_outlined,
                  title: StringHelper.notificationSettings,
                  onTap: () => _openNotificationSettings(),
                ),
                _buildSettingTile(
                  icon: Icons.block_outlined,
                  title: StringHelper.blockedUsers,
                  onTap: () => context.push(Routes.blockedUserList),
                ),
              ]),
              const Gap(24),
            ],

            // App Settings Section
            _buildSectionHeader(StringHelper.preferences),
            const Gap(8),
            _buildSection([
              _buildSettingTile(
                icon: Icons.language_outlined,
                title: StringHelper.language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DbHelper.getLanguage() == 'en' ? 'English' : 'عربي',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: FontRes.POPPINS_REGULAR,
                      ),
                    ),
                    const Gap(8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                onTap: () => languageDialog(context, viewModel),
              ),
            ]),

            const Gap(24),

            // Support Section
            _buildSectionHeader(StringHelper.support),
            const Gap(8),
            _buildSection([
              _buildSettingTile(
                icon: Icons.help_outline,
                title: StringHelper.faqs,
                onTap: () => context.push(Routes.faqView),
              ),
              _buildSettingTile(
                icon: Icons.headset_mic_outlined,
                title: StringHelper.contactUs,
                onTap: () => context.push(Routes.contactUsView),
              ),
              _buildSettingTile(
                icon: Icons.description_outlined,
                title: StringHelper.termsConditions,
                onTap: () => context.push(Routes.termsOfUse, extra: 2),
              ),
              _buildSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: StringHelper.privacyPolicy,
                onTap: () => context.push(Routes.termsOfUse, extra: 1),
              ),
            ]),

            // Account Actions Section
            if (!viewModel.isGuest) ...[
              const Gap(24),
              _buildSectionHeader(StringHelper.accountActions),
              const Gap(8),
              _buildSection([
                _buildSettingTile(
                  icon: Icons.logout_outlined,
                  title: StringHelper.logout,
                  onTap: () => logoutDialog(context, viewModel),
                ),
              ]),
            ],

            const Gap(40),
          ],
        ),
      ),
    );
  }

  void _showMyProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyProfilePreviewView(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final isArabic =
        DbHelper.getLanguage() == 'ar'; // Check if language is Arabic

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: isArabic
            ? Alignment.centerRight
            : Alignment.centerLeft, // Right for Arabic, Left for others
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: FontRes.POPPINS_SEMIBOLD,
            color: Colors.black,
          ),
          textDirection: isArabic
              ? TextDirection.rtl
              : TextDirection.ltr, // Ensure RTL for Arabic
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> tiles) {
    return Container(
      color: Colors.white,
      child: Column(
        children: tiles.asMap().entries.map((entry) {
          int index = entry.key;
          Widget tile = entry.value;
          return Column(
            children: [
              tile,
              if (index < tiles.length - 1) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(
        icon,
        size: 24,
        color: Colors.grey[700],
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: FontRes.POPPINS_REGULAR,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 64, // Aligns with text after icon
      endIndent: 20,
    );
  }

  // Open device notification settings directly
  void _openNotificationSettings() async {
    await openAppSettings();
  }

  String getImageUrl() {
    String url = DbHelper.getUserModel()?.profilePic ?? "";

    if (url.isEmpty) {
      return AssetsRes.IC_USER_ICON;
    }

    if (url.contains('http')) {
      return url;
    }

    String fullUrl = "${ApiConstants.imageUrl}/$url";
    return fullUrl;
  }

  userDetails(BuildContext context, SettingVM viewModel) {
    return Consumer<ProfileVM>(
      builder: (context, profileVM, child) {
        final user = DbHelper.getUserModel();
        final firstName = user?.name ?? '';
        final lastName = user?.lastName ?? '';

        return Row(
          children: [
            _buildUserAvatar(profileVM),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$firstName $lastName".trim(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: FontRes.POPPINS_MEDIUM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontRes.POPPINS_REGULAR,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (DbHelper.getIsVerifiedEmailOrPhone()) ...[
                    const Gap(4),
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 16,
                        ),
                        const Gap(4),
                        Text(
                          StringHelper.verified,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontFamily: FontRes.POPPINS_REGULAR,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  guestDetails(BuildContext context, SettingVM viewModel) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade600,
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringHelper.guestUser,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: FontRes.POPPINS_MEDIUM,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const Gap(8),
              SizedBox(
                width: 100,
                height: 42,
                child: AppElevatedButton(
                  onTap: () {
                    context.push(Routes.guestLogin);
                  },
                  title: StringHelper.login,
                ),
              ),
            ],
          ),
        ),
      ],
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
              _buildLanguageTileDialog(
                context,
                languageCode: 'en',
                languageLabel: 'English',
                isSelected: currentLang == 'en',
              ),
              _buildLanguageTileDialog(
                context,
                languageCode: 'ar',
                languageLabel: 'عربي',
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

  Widget _buildLanguageTileDialog(
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
              onSelectedCommunicationChoice: (CommunicationChoice value) {
                vm.communicationChoice = value.name;
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(StringHelper.cancel),
              ),
              TextButton(
                onPressed: () =>
                    {vm.updateProfileApi(), Navigator.of(context).pop()},
                child: Text(StringHelper.update),
              ),
            ],
          );
        });
  }
}

void _showRateUsModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RateUsModal();
    },
  );
}
