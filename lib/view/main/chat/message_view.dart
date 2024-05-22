import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';
import 'package:list_and_life/models/setting_item_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/chat_vm.dart';

import '../../../chat_bubble/bubble_normal_message.dart';
import '../../../chat_bubble/message_bar_with_suggetion.dart';
import '../../../helpers/date_helper.dart';

class MessageView extends BaseView<ChatVM> {
  final SettingItemModel? chat;
  const MessageView({super.key, this.chat});

  @override
  Widget build(BuildContext context, ChatVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              foregroundImage: AssetImage(chat?.icon ?? ''),
            ),
            const Gap(5),
            Text(chat?.title ?? ''),
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
                            onTap: () {},
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
                      builder: (context) => AppAlertDialogWithLottie(
                            description:
                                'Are you sure want to delete this chat?',
                            onTap: () {},
                            lottieIcon: AssetsRes.DELETE_LOTTIE,
                            showCancelButton: true,
                            cancelButtonText: 'No',
                            title: 'Delete Chat',
                            buttonText: 'Yes',
                          ));
                  return;
                case 3:
                  showDialog(
                      context: context,
                      builder: (context) => AppAlertDialogWithWidget(
                            description:
                                'Are you sure want to delete this block user?',
                            onTap: () {},
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
            child: ListView.builder(
                itemCount: viewModel.chatItems.length,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BubbleNormalMessage(
                    textStyle: TextStyle(
                      color: viewModel.chatItems[index].isSender!
                          ? Colors.white
                          : Colors.white,
                    ),
                    timeStamp: true,
                    createdAt: DateHelper.getChatTime(
                        viewModel.chatItems[index].timeStamp!),
                    text: viewModel.chatItems[index].message ?? '',
                    isSender: viewModel.chatItems[index].isSender ?? false,
                    color: viewModel.chatItems[index].isSender!
                        ? Colors.black
                        : Colors.grey,
                  );
                }),
          ),
          MessageBarWithSuggestions(
            suggestions: const ['Hello', 'How are you?'],
            onSuggestionSelected: (value) {
              viewModel.messageTextController.text = value;
            },
            onOfferMade: (value) {},
            textController: viewModel.messageTextController,
            onSubmitted: (value) {
              viewModel.sendMessage(value);
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
