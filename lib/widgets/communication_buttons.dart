import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../view_model/chat_vm.dart';

class CommunicationButtons extends StatelessWidget {
  final ProductDetailModel? data;

  const CommunicationButtons({
    super.key,
    required this.data,
  });

  List<Widget> _buildButtons(BuildContext context) {
    String selectedChoice = data?.communicationChoice ?? '';
    List<Widget> buttons = [];

    if (selectedChoice.contains('call')) {
      buttons.add(_buildCallButton(context));
    }
    if (selectedChoice.contains('chat')) {
      buttons.add(_buildChatButton(context));
    }
    if (selectedChoice.contains('whatsapp')) {
      buttons.add(_buildWhatsAppButton(context));
    }

    return buttons;
  }

  Widget _buildCallButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          DialogHelper.showLoading();
          await callClickedApi(productId: "${data?.id}");
          String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
          DialogHelper.goToUrl(uri: Uri.parse("tel://$phone"));
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_CALL_ICON,
          label: StringHelper.call,
          backgroundColor: Colors.red[50]!,
          textColor: Colors.red,
        ),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          context.push(
            Routes.message,
            extra: InboxModel(
              senderId: DbHelper.getUserModel()?.id,
              receiverId: data?.userId,
              productId: data?.id,
              productDetail: data,
              receiverDetail: SenderDetail(
                id: data?.userId,
                lastName: data?.user?.lastName,
                profilePic: data?.user?.profilePic,
                name: data?.user?.name,
              ),
              senderDetail: SenderDetail(
                id: DbHelper.getUserModel()?.id,
                profilePic: DbHelper.getUserModel()?.profilePic,
                lastName: DbHelper.getUserModel()?.lastName,
                name: DbHelper.getUserModel()?.name,
              ),
            ),
          );
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_CHAT_ICON,
          label: StringHelper.chat,
          backgroundColor: Colors.blue[50]!,
          textColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
          DialogHelper.goToUrl(
            uri: Uri.parse(
              'https://wa.me/$phone?text=Hi, I am interested in your ad.',
            ),
          );
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_WHATSAPP_ICON,
          label: StringHelper.whatsapp,
          backgroundColor: Colors.green[50]!,
          textColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildButtonContainer(
    BuildContext context, {
    required String iconPath,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 16,
            color: textColor,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildButtons(context),
    );
  }

  Future<void> callClickedApi({required String productId}) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.callOnUrl(productId: productId),
      requestType: RequestType.get,
    );
    var response = await BaseClient.handleRequest(apiRequest);
    debugPrint("$response");
    DialogHelper.hideLoading();
  }
}

class CommunicationButtons2 extends StatelessWidget {
  final ProductDetailModel? data;

  const CommunicationButtons2({
    super.key,
    required this.data,
  });

  List<Widget> _buildButtons(BuildContext context) {
    String selectedChoice = data?.communicationChoice ?? '';
    List<Widget> buttons = [];

    if (selectedChoice.contains('call')) {
      buttons.add(_buildCallButton(context));
    }
    if (selectedChoice.contains('chat')) {
      buttons.add(_buildChatButton(context));
    }
    if (selectedChoice.contains('whatsapp')) {
      buttons.add(_buildWhatsAppButton(context));
    }

    return buttons;
  }

  Widget _buildCallButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          DialogHelper.showLoading();
          await callClickedApi(productId: "${data?.id}");
          String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
          DialogHelper.goToUrl(uri: Uri.parse("tel://$phone"));
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_CALL_ICON,
          label: StringHelper.call,
          backgroundColor: Colors.red[50]!, // Darker red background
          textColor: Colors.red[800]!, // Darker red text/icon
        ),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          context.push(
            Routes.message,
            extra: InboxModel(
              senderId: DbHelper.getUserModel()?.id,
              receiverId: data?.userId,
              productId: data?.id,
              productDetail: data,
              receiverDetail: SenderDetail(
                id: data?.userId,
                lastName: data?.user?.lastName,
                profilePic: data?.user?.profilePic,
                name: data?.user?.name,
              ),
              senderDetail: SenderDetail(
                id: DbHelper.getUserModel()?.id,
                profilePic: DbHelper.getUserModel()?.profilePic,
                lastName: DbHelper.getUserModel()?.lastName,
                name: DbHelper.getUserModel()?.name,
              ),
            ),
          );
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_CHAT_ICON,
          label: StringHelper.chat,
          backgroundColor: Colors.blue[100]!, // Darker blue background
          textColor: Colors.blue[800]!, // Darker blue text/icon
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
          DialogHelper.goToUrl(
            uri: Uri.parse(
              'https://wa.me/$phone?text=Hi, I am interested in your ad.',
            ),
          );
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_WHATSAPP_ICON,
          label: StringHelper.whatsapp,
          backgroundColor: Colors.green[100]!, // Darker green background
          textColor:
              const Color.fromARGB(255, 79, 150, 83)!, // Darker green text/icon
        ),
      ),
    );
  }

  Widget _buildButtonContainer(
    BuildContext context, {
    required String iconPath,
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 16,
            color: textColor,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildButtons(context),
    );
  }

  Future<void> callClickedApi({required String productId}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.callOnUrl(productId: productId),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    debugPrint("$response");
    DialogHelper.hideLoading();
  }
}
