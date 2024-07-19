import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/message_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../../../chat_bubble/bubble_normal_message.dart';
import '../../../chat_bubble/bubble_offer_message.dart';
import '../../../chat_bubble/message_bar_with_suggetion.dart';
import '../../../helpers/date_helper.dart';
import '../../../network/api_constants.dart';
import '../../../res/font_res.dart';

class MessageView extends BaseView<ChatVM> {
  final InboxModel? chat;
  const MessageView({super.key, this.chat});

  @override
  Widget build(BuildContext context, ChatVM viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((d) =>
        viewModel.getMessageList(
            receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                ? chat?.receiverDetail?.id
                : chat?.senderDetail?.id,
            productId: chat?.productId));
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ImageView.rect(
                  height: 60,
                  width: 60,
                  image:
                      "${ApiConstants.imageUrl}/${chat?.productDetail?.image}",
                ),
                ImageView.circle(
                  height: 25,
                  width: 25,
                  borderColor: context.theme.primaryColor,
                  image:
                      "${ApiConstants.imageUrl}/${chat?.senderId == DbHelper.getUserModel()?.id ? chat?.receiverDetail?.profilePic ?? '' : chat?.senderDetail?.profilePic ?? ''}",
                ),
              ],
            ),
            const Gap(5),
            Text(chat?.senderId == DbHelper.getUserModel()?.id
                ? "${chat?.receiverDetail?.name} ${chat?.receiverDetail?.lastName}"
                : "${chat?.senderDetail?.name} ${chat?.senderDetail?.lastName}"),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert_outlined),
            offset: const Offset(0, 40),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            onSelected: (int item) {
              switch (item) {
                case 1:

                  /// Delete User
                  showDialog(
                      context: context,
                      builder: (context) => AppAlertDialogWithLottie(
                            description:
                                'Are you sure want to delete this chat?',
                            onTap: () {
                              context.pop();
                              context.pop();
                            },
                            lottieIcon: AssetsRes.DELETE_LOTTIE,
                            showCancelButton: true,
                            cancelButtonText: 'No',
                            title: 'Delete Chat',
                            buttonText: 'Yes',
                          ));
                  return;
                case 2:

                  ///Report User
                  showDialog(
                      context: context,
                      builder: (context) => AppAlertDialogWithWidget(
                            description: '',
                            onTap: () {
                              if (viewModel.reportTextController.text
                                  .trim()
                                  .isEmpty) {
                                DialogHelper.showToast(
                                    message: "Please enter reason of report.");
                                return;
                              }
                              context.pop();
                              viewModel.reportBlockUser(
                                  report: true,
                                  reason: viewModel.reportTextController.text,
                                  userId:
                                      "${chat?.senderId == DbHelper.getUserModel()?.id ? chat?.receiverDetail?.id : chat?.senderDetail?.id}");
                            },
                            icon: AssetsRes.IC_REPORT_USER,
                            showCancelButton: true,
                            isTextDescription: false,
                            content: AppTextField(
                              controller: viewModel.reportTextController,
                              lines: 4,
                              hint: 'Reason...',
                            ),
                            cancelButtonText: 'No',
                            title: 'Report User',
                            buttonText: 'Yes',
                          ));
                  return;
                case 3:
                  showDialog(
                      context: context,
                      builder: (context) => AppAlertDialogWithWidget(
                            description:
                                'Are you sure want to block this user?',
                            onTap: () {
                              context.pop();
                              viewModel.reportBlockUser(
                                  userId:
                                      "${chat?.senderId == DbHelper.getUserModel()?.id ? chat?.receiverDetail?.id : chat?.senderDetail?.id}");
                              context.pop();
                            },
                            icon: AssetsRes.IC_BLOCK_USER,
                            showCancelButton: true,
                            cancelButtonText: 'No',
                            title: 'Block User',
                            buttonText: 'Yes',
                          ));
                  return;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem(
                value: 1,
                child: Text('Delete Chat'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Report User'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('Block User'),
              ),
            ],
          ),
        ],
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
                stream: viewModel.messageStreamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MessageModel> data = snapshot.data ?? [];
                    return ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: data.length,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return data[index].messageType == 1
                              ? BubbleNormalMessage(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  timeStamp: true,
                                  createdAt: DateHelper.getTimeAgo(
                                      DateTime.parse(data[index].updatedAt ??
                                              '2021-01-01 00:00:00')
                                          .millisecondsSinceEpoch),
                                  text: data[index].message ?? '',
                                  isSender: data[index].senderId ==
                                      DbHelper.getUserModel()?.id,
                                  color: data[index].senderId ==
                                          DbHelper.getUserModel()?.id
                                      ? Colors.black
                                      : const Color(0xff5A5B55),
                                )
                              : BubbleOfferMessage(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: FontRes.MONTSERRAT_SEMIBOLD),
                                  timeStamp: true,
                                  createdAt: DateHelper.getChatTime(
                                      DateTime.parse(data[index].createdAt ??
                                              '2021-01-01 00:00:00')
                                          .microsecondsSinceEpoch),
                                  text: data[index].message ?? '',
                                  isSender: data[index].senderId ==
                                      DbHelper.getUserModel()?.id,
                                  color: data[index].senderId ==
                                          DbHelper.getUserModel()?.id
                                      ? Colors.black
                                      : const Color(0xff5A5B55),
                                );
                        });
                  }
                  if (snapshot.hasError) {
                    return const AppErrorWidget();
                  }
                  return const AppLoadingWidget();
                }),
          ),
          MessageBarWithSuggestions(
            suggestions: const ['Hello', 'How are you?'],
            onSuggestionSelected: (value) {
              viewModel.messageTextController.text = value;
            },
            onOfferMade: (value) {
              viewModel.sendMessage(
                  message: '$value',
                  type: 2,
                  receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                      ? chat?.receiverDetail?.id
                      : chat?.senderDetail?.id,
                  productId: chat?.productId);
            },
            textController: viewModel.messageTextController,
            onSubmitted: (value) {
              viewModel.sendMessage(
                  message: value,
                  type: 1,
                  receiverId: chat?.senderId == DbHelper.getUserModel()?.id
                      ? chat?.receiverDetail?.id
                      : chat?.senderDetail?.id,
                  productId: chat?.productId);
              viewModel.messageTextController.clear();
            },
            onPickImageClick: () {},
            onRecordingClick: () {},
          ),
        ],
      ),
    );
  }
}
