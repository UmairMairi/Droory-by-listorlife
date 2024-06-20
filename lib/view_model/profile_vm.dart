import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/helpers/image_picker_helper.dart';
import 'package:list_and_life/network/api_request.dart';
import 'package:list_and_life/view_model/setting_v_m.dart';
import 'package:provider/provider.dart';

import '../helpers/dialog_helper.dart';
import '../models/common/map_response.dart';
import '../models/user_model.dart';
import '../network/api_constants.dart';
import '../network/base_client.dart';

class ProfileVM extends BaseViewModel {
  TextEditingController nameTextController =
      TextEditingController(text: DbHelper.getUserModel()?.name);
  TextEditingController lastNameController =
      TextEditingController(text: DbHelper.getUserModel()?.lastName);
  TextEditingController emailTextController =
      TextEditingController(text: DbHelper.getUserModel()?.email);
  TextEditingController phoneTextController = TextEditingController(
      text:
          "${DbHelper.getUserModel()?.countryCode}-${DbHelper.getUserModel()?.phoneNo}");
  TextEditingController bioTextController =
      TextEditingController(text: DbHelper.getUserModel()?.bio);

  String _imagePath = '';
  bool _agreedToTerms = false;
  String get imagePath => _imagePath;

  bool get agreedToTerms => _agreedToTerms;

  final FocusNode nodeText = FocusNode();

  set agreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  set imagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void pickImage() async {
    imagePath = await ImagePickerHelper.openImagePicker(context: context) ?? '';
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  Future<void> updateProfileApi() async {
    Map<String, dynamic> body = {
      'name': nameTextController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'email': emailTextController.text.trim(),
      'bio': bioTextController.text.trim(),
    };

    if (imagePath.isNotEmpty) {
      body['profile_pic'] = await BaseClient.getMultipartImage(path: imagePath);
    }

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.editProfileUrl(),
        requestType: RequestType.PUT,
        body: body);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<UserModel> model =
        MapResponse.fromJson(response, (json) => UserModel.fromJson(json));

    DbHelper.saveUserModel(model.body);
    if (context.mounted) {
      context.read<SettingVM>().isActiveNotification =
          model.body?.notificationStatus == 1;
    }
    DialogHelper.hideLoading();
    DialogHelper.showToast(message: "Profile updated successfully");
    if (context.mounted) context.pop();
  }
}
