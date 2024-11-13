import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';

import '../routes/app_routes.dart';

class CommunicationButtons extends StatelessWidget {
  final ProductDetailModel? data;

  const CommunicationButtons({
    Key? key,
    required this.data,
  }) : super(key: key);

  // Map the string values to generate corresponding buttons
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

  // Helper methods to build individual buttons (same as previous example)
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
                    name: data?.user?.name),
                senderDetail: SenderDetail(
                    id: DbHelper.getUserModel()?.id,
                    profilePic: DbHelper.getUserModel()?.profilePic,
                    lastName: DbHelper.getUserModel()?.lastName,
                    name: DbHelper.getUserModel()?.name)),
          );
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_CHAT_ICON,
          label: StringHelper.chat,
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
                  'https://wa.me/$phone?text=Hi, I am interested in your ad.'));
        },
        child: _buildButtonContainer(
          context,
          iconPath: AssetsRes.IC_WHATSAPP_ICON,
          label: StringHelper.whatsapp,
        ),
      ),
    );
  }

  Widget _buildButtonContainer(BuildContext context,
      {required String iconPath, required String label}) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff5A5B55),
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
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
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
    DialogHelper.hideLoading();
  }
}

class CommunicationButtons2 extends StatelessWidget {
  final ProductDetailModel? data;

  const CommunicationButtons2({
    super.key,
    required this.data,
  });

  // Map the string values to generate corresponding buttons
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

  // Helper methods to build individual buttons (same as previous example)
  Widget _buildCallButton(BuildContext context) {
    return InkWell(
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
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return InkWell(
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
                  name: data?.user?.name),
              senderDetail: SenderDetail(
                  id: DbHelper.getUserModel()?.id,
                  profilePic: DbHelper.getUserModel()?.profilePic,
                  lastName: DbHelper.getUserModel()?.lastName,
                  name: DbHelper.getUserModel()?.name)),
        );
      },
      child: _buildButtonContainer(
        context,
        iconPath: AssetsRes.IC_COMMENT_ICON,
        label: StringHelper.chat,
      ),
    );
  }

  Widget _buildWhatsAppButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (DbHelper.getIsGuest()) {
          DialogHelper.showLoginDialog(context: context);
          return;
        }
        String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
        DialogHelper.goToUrl(
            uri: Uri.parse(
                'https://wa.me/$phone?text=Hi, I am interested in your ad.'));
      },
      child: _buildButtonContainer(
        context,
        iconPath: AssetsRes.IC_WHATSAPP_ICON,
        label: StringHelper.whatsapp,
      ),
    );
  }

  Widget _buildButtonContainer(BuildContext context,
      {required String iconPath, required String label}) {
    return Container(
      width: 85,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 12,
            color: Colors.red,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.red,
                  fontSize: 10,
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
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildButtons(context),
    );
  }

  Future<void> callClickedApi({required String productId}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.callOnUrl(productId: productId),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    DialogHelper.hideLoading();
  }
}
