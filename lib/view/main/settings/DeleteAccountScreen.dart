import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends BaseView<SettingVM> {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, SettingVM viewModel) {
    // Get the current locale
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Define font size multiplier for Arabic (e.g., 1.2x larger)
    final double fontSizeMultiplier = isArabic ? 1.2 : 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          StringHelper.deleteAccountTitle,
          style: TextStyle(
            fontSize: 20 * fontSizeMultiplier,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  Gap(20),
                  Text(
                    StringHelper.sorryToSeeYouGo,
                    style: TextStyle(
                      fontSize: 24 * fontSizeMultiplier,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontRes.POPPINS_SEMIBOLD,
                    ),
                  ),
                  Gap(12),
                  Text(
                    StringHelper.chooseDeleteOption,
                    style: TextStyle(
                      fontSize: 16 * fontSizeMultiplier,
                      color: Colors.grey[600],
                      fontFamily: FontRes.POPPINS_REGULAR,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Gap(40),

            // Option 1: Delete Now
            _buildDeleteOption(
              context: context,
              icon: Icons.delete_forever,
              iconColor: Colors.red,
              backgroundColor: Colors.red.shade50,
              borderColor: Colors.red.shade200,
              title: StringHelper.deleteAccountNow,
              subtitle: StringHelper.deleteAccountImmediately,
              details: [
                StringHelper.accountDeletedInstantly,
                StringHelper.allDataPermanentlyRemoved,
                StringHelper.cannotBeUndone,
                StringHelper.profileDisappearsImmediately,
              ],
              buttonText: StringHelper.deleteNowButton,
              buttonColor: Colors.red,
              isImmediate: true,
              fontSizeMultiplier: fontSizeMultiplier,
            ),

            Gap(24),

            // Option 2: Schedule Deletion
            _buildDeleteOption(
              context: context,
              icon: Icons.schedule,
              iconColor: Colors.orange,
              backgroundColor: Colors.orange.shade50,
              borderColor: Colors.orange.shade200,
              title: StringHelper.deactivateFor90Days,
              subtitle: StringHelper.hideProfileAndDeleteLater,
              details: [
                StringHelper.accountHiddenImmediately,
                StringHelper.deletedAfter90Days,
                StringHelper.canRestoreAnytime,
                StringHelper.dataSafeDuringPeriod,
              ],
              buttonText: StringHelper.deactivateAccountButton,
              buttonColor: Colors.orange,
              isImmediate: false,
              fontSizeMultiplier: fontSizeMultiplier,
            ),

            Gap(40),

            // Bottom info
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 24),
                  Gap(12),
                  Expanded(
                    child: Text(
                      StringHelper.contactSupportInstead,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 14 * fontSizeMultiplier,
                        fontFamily: FontRes.POPPINS_REGULAR,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Add bottom padding for safe area
            Gap(40),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required Color borderColor,
    required String title,
    required String subtitle,
    required List<String> details,
    required String buttonText,
    required Color buttonColor,
    required bool isImmediate,
    required double fontSizeMultiplier,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18 * fontSizeMultiplier,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontRes.POPPINS_SEMIBOLD,
                        color: iconColor.withOpacity(0.9),
                      ),
                    ),
                    Gap(4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14 * fontSizeMultiplier,
                        color: Colors.grey[700],
                        fontFamily: FontRes.POPPINS_REGULAR,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Gap(16),

          // Details list
          ...details
              .map((detail) => Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 16, color: iconColor),
                        Gap(8),
                        Expanded(
                          child: Text(
                            detail,
                            style: TextStyle(
                              fontSize: 13 * fontSizeMultiplier,
                              color: Colors.grey[700],
                              fontFamily: FontRes.POPPINS_REGULAR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),

          Gap(20),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (isImmediate) {
                  _showImmediateDeletionConfirmation(
                      context, fontSizeMultiplier);
                } else {
                  _showScheduledDeletionConfirmation(
                      context, fontSizeMultiplier);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16 * fontSizeMultiplier,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontRes.POPPINS_SEMIBOLD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImmediateDeletionConfirmation(
      BuildContext context, double fontSizeMultiplier) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.red, size: 28),
              Gap(12),
              Text(
                StringHelper.deleteForever,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 20 * fontSizeMultiplier,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringHelper.permanentActionWarning,
                style: TextStyle(fontSize: 16 * fontSizeMultiplier),
                textAlign: TextAlign.center,
              ),
              Gap(16),
              Text(
                StringHelper.areYouSure,
                style: TextStyle(
                  fontSize: 18 * fontSizeMultiplier,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringHelper.cancel,
                style: TextStyle(fontSize: 16 * fontSizeMultiplier),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                DialogHelper.showLoading();
                context.read<SettingVM>().deleteAccountImmediate(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                StringHelper.deleteForeverButton,
                style: TextStyle(fontSize: 16 * fontSizeMultiplier),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showScheduledDeletionConfirmation(
      BuildContext context, double fontSizeMultiplier) {
    final DateTime deletionDate = DateTime.now().add(Duration(days: 90));
    final String formattedDate =
        "${deletionDate.day}/${deletionDate.month}/${deletionDate.year}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.schedule_rounded, color: Colors.orange, size: 28),
              Gap(12),
              Text(
                StringHelper.scheduledDeletionTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                  fontSize: 20 * fontSizeMultiplier,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      StringHelper.scheduledDeletionDate,
                      style: TextStyle(fontSize: 14 * fontSizeMultiplier),
                      textAlign: TextAlign.center,
                    ),
                    Gap(8),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 20 * fontSizeMultiplier,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16),
              Text(
                StringHelper.restoreBeforeDate,
                style: TextStyle(
                  fontSize: 16 * fontSizeMultiplier,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                StringHelper.cancel,
                style: TextStyle(fontSize: 16 * fontSizeMultiplier),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                DialogHelper.showLoading();
                context.read<SettingVM>().requestScheduledDeletion(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(
                StringHelper.deactivateAccountButton,
                style: TextStyle(fontSize: 16 * fontSizeMultiplier),
              ),
            ),
          ],
        );
      },
    );
  }
}
