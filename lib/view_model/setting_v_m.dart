import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:provider/provider.dart';
import '../view_model/home_vm.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:dio/dio.dart';
import '../models/setting_item_model.dart';

class SettingVM extends BaseViewModel {
  bool _isActiveNotification = DbHelper.getUserModel()?.notificationStatus == 1;
  bool get isActiveNotification => _isActiveNotification;

  bool _isGuest = DbHelper.getIsGuest();
  bool get isGuest => _isGuest;
  set isGuest(bool value) {
    _isGuest = value;
    notifyListeners();
  }

  void _resetNotificationCount(BuildContext context) {
    try {
      if (context.mounted) {
        final homeVM = Provider.of<HomeVM>(context, listen: false);
        homeVM.countMessage = 0;
      }
    } catch (e) {
      print('Could not reset notification count: $e');
    }
  }

  bool _isAccountSettings = false;
  bool get isAccountSettings => _isAccountSettings;
  set isAccountSettings(bool value) {
    _isAccountSettings = value;
    notifyListeners();
  }

  bool _isSupport = false;
  bool get isSupport => _isSupport;
  set isSupport(bool value) {
    _isSupport = value;
    notifyListeners();
  }

  bool _isAppSetting = false;
  bool get isAppSetting => _isAppSetting;
  set isAppSetting(bool value) {
    _isAppSetting = value;
    notifyListeners();
  }

  @override
  void onInit() {
    DbHelper.box.listenKey('isGuest', (value) {
      isGuest = DbHelper.getIsGuest();
    });
    if (!isGuest) getProfile();
    super.onInit();
  }

  set isActiveNotification(bool value) {
    _isActiveNotification = value;
    notifyListeners();
  }

  void onSwitchChanged(bool? value) {
    isActiveNotification = value ?? true;
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.logoutUrl(), requestType: RequestType.get);
      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse model = MapResponse.fromJson(response, (json) => null);
      DialogHelper.hideLoading();
      if (model.success ?? false) {
        _resetNotificationCount(context);
        DbHelper.eraseData();
        if (context.mounted) context.go(Routes.login);
      }
    } catch (e) {
      // If logout API fails, still do local logout
      DialogHelper.hideLoading();
      _resetNotificationCount(context);
      DbHelper.eraseData();
      if (context.mounted) context.go(Routes.login);
    }
  }

  Future<void> deleteAccount() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deleteAccountUrl(), requestType: RequestType.delete);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);
    DialogHelper.hideLoading();
    if (model.success ?? false) {
      DbHelper.eraseData();
      if (context.mounted) context.go(Routes.login);
    }
  }

  Future<void> deleteAccountImmediate(BuildContext context,
      {String? reason}) async {
    try {
      var body = <String, dynamic>{};
      if (reason != null && reason.isNotEmpty) {
        body['reason'] = reason;
      }

      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.deleteAccountImmediateUrl(),
        requestType: RequestType.delete,
        body: body,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse model = MapResponse.fromJson(response, (json) => null);

      DialogHelper.hideLoading();

      if (model.message != null && !model.message!.contains('error')) {
        _resetNotificationCount(context);
        DbHelper.saveUserModel(null);
        DbHelper.saveToken(null);
        DbHelper.saveIsLoggedIn(false);
        DbHelper.saveIsGuest(true);

        DialogHelper.showToast(
          message: "Account deleted successfully",
          error: false,
        );

        if (context.mounted) {
          context.go('/login');
        }
      } else {
        DialogHelper.showToast(
          message: model.message ?? "Failed to delete account",
          error: true,
        );
      }
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(
        message: "Account deleted but please restart app",
        error: false,
      );

      DbHelper.saveUserModel(null);
      DbHelper.saveToken(null);
      DbHelper.saveIsLoggedIn(false);
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> requestScheduledDeletion(BuildContext context,
      {String? reason}) async {
    try {
      var body = <String, dynamic>{};
      if (reason != null && reason.isNotEmpty) {
        body['reason'] = reason;
      }

      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.requestAccountDeletionUrl(),
        requestType: RequestType.post,
        body: body,
      );

      var response = await BaseClient.handleRequest(apiRequest);
      DialogHelper.hideLoading();

      var responseData = response is Response ? response.data : response;
      String message = responseData['message'] ?? StringHelper.unknownError;

      if (responseData['success'] == true) {
        _showSuccessModal(context);
      } else {
        if (message.toLowerCase().contains("wait") ||
            message.toLowerCase().contains("minute") ||
            message.toLowerCase().contains("restoring")) {
          _showCooldownModal(context, StringHelper.cooldownMessage);
        } else {
          _showErrorModal(context, message);
        }
      }
    } catch (e) {
      DialogHelper.hideLoading();
      _showCooldownModal(context, StringHelper.cooldownMessage);
    }
  }

  void _showCooldownModal(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  color: Colors.orange.shade600,
                  size: 32,
                ),
              ),
              SizedBox(height: 20),
              Text(
                StringHelper.pleaseWaitTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue.shade600, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        StringHelper.preventAccidentalDeletion,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    StringHelper.iUnderstandButton,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessModal(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    // Calculate the date 90 days from now
    final DateTime deletionDate = DateTime.now().add(Duration(days: 90));

    // Use intl package for proper localization
    final DateFormat dateFormatter = DateFormat.yMMMEd(locale.toString());
    final String formattedDate = dateFormatter.format(deletionDate);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green.shade600,
                  size: 32,
                ),
              ),
              SizedBox(height: 20),
              Text(
                StringHelper.accountDeactivatedTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "${StringHelper.scheduledDeletionSuccess} $formattedDate. ${StringHelper.restoreBeforeDate}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue.shade600, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        StringHelper.restoreAccountInfo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _performLogoutAfterScheduledDeletion(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    StringHelper.continueButton,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorModal(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  color: Colors.red.shade600,
                  size: 32,
                ),
              ),
              SizedBox(height: 20),
              Text(
                StringHelper.pleaseWaitTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    StringHelper.iUnderstandButton,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showScheduledDeletionSuccessModal(
      BuildContext context, String message) {
    final locale = Localizations.localeOf(context);
    final DateTime deletionDate = DateTime.now().add(Duration(days: 90));

    // Use intl package for proper localization
    final DateFormat dateFormatter = DateFormat.yMMMd(locale.toString());
    final String formattedDate = dateFormatter.format(deletionDate);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.schedule, color: Colors.orange, size: 32),
              ),
              Gap(16),
              Text(
                StringHelper.accountDeactivatedTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                StringHelper.scheduledDeletionSuccess,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              Gap(16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
              Gap(16),
              Text(
                StringHelper.restoreBeforeDate,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _performLogoutAfterScheduledDeletion(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  StringHelper.ok,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogoutAfterScheduledDeletion(BuildContext context) async {
    _resetNotificationCount(context);
    DbHelper.saveUserModel(null);
    DbHelper.saveToken(null);
    DbHelper.saveIsLoggedIn(false);
    DbHelper.saveIsGuest(true);

    if (context.mounted) {
      context.go('/login');
    }
  }

  Future<void> cancelScheduledDeletion(BuildContext context) async {
    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.cancelAccountDeletionUrl(),
        requestType: RequestType.post,
        body: {},
      );

      var response = await BaseClient.handleRequest(apiRequest);
      MapResponse model = MapResponse.fromJson(response, (json) => null);

      DialogHelper.hideLoading();

      if (model.message != null && !model.message!.contains('error')) {
        DialogHelper.showToast(
          message: model.message ?? StringHelper.accountDeletionCancelled,
          error: false,
        );
        notifyListeners();
      } else {
        DialogHelper.showToast(
          message: model.message ?? StringHelper.accountDeletionCancelFailed,
          error: true,
        );
      }
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showToast(
        message: StringHelper.accountDeletionCancelError + ': ${e.toString()}',
        error: true,
      );
    }
  }

  Future<void> getProfile() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProfileUrl(), requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<UserModel> model = MapResponse<UserModel>.fromJson(
        response, (json) => UserModel.fromJson(json));
    DbHelper.saveUserModel(model.body);
    notifyListeners();
  }
}
