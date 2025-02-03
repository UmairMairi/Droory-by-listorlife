import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/message_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:provider/provider.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../base/network/api_constants.dart';
import '../../../chat_bubble/message_bar_with_suggetion.dart';
import '../../../res/font_res.dart';
import '../../../routes/app_routes.dart';

class MessageView extends StatefulWidget {
  final InboxModel? chat;
  const MessageView({super.key, this.chat});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late ChatVM viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<ChatVM>();
      viewModel.initListeners();
    WidgetsBinding.instance.addPostFrameCallback((d) {
    if((widget.chat?.lastMessageDetail?.roomId??"").isNotEmpty){
      viewModel.currentRoomId = widget.chat?.lastMessageDetail?.roomId??"0";
    }});
      viewModel.updateChatScreenId(
        roomId: widget.chat?.lastMessageDetail?.roomId ?? viewModel.currentRoomId,
      );

      viewModel.readChatStatus(
        receiverId: widget.chat?.senderId == DbHelper.getUserModel()?.id
            ? widget.chat?.receiverDetail?.id
            : widget.chat?.senderDetail?.id,
        roomId: widget.chat?.lastMessageDetail?.roomId ?? 0,
      );
      viewModel.getMessageList(
        receiverId: widget.chat?.senderId == DbHelper.getUserModel()?.id
            ? widget.chat?.receiverDetail?.id
            : widget.chat?.senderDetail?.id,
        productId: widget.chat?.productId,
      );
  }


  @override
  Widget build(BuildContext context) {
    //viewModel = Provider.of<ChatVM>(context);
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
                  height: 50,
                  width: 50,
                  image: "${ApiConstants.imageUrl}/${widget.chat?.productDetail?.image??""}",
                ),
                ImageView.circle(
                  height: 20,
                  width: 20,
                  placeholder: AssetsRes.IC_USER_ICON,
                  borderColor: context.theme.primaryColor,
                  image: "${ApiConstants.imageUrl}/${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.profilePic ?? '' : widget.chat?.senderDetail?.profilePic ?? ''}",
                ),
              ],
            ),
            const Gap(5),
            Flexible(
              child: GestureDetector(
                onTap: (){
                  if (widget.chat?.productDetail?.userId == DbHelper.getUserModel()?.id) {
                    context.push(Routes.myProduct,
                        extra: widget.chat?.productDetail);
                    return;
                  }
              
                  context.push(Routes.productDetails,
                      extra: widget.chat?.productDetail);
                  return;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.chat?.senderId == DbHelper.getUserModel()?.id
                        ? "${widget.chat?.receiverDetail?.name} ${widget.chat?.receiverDetail?.lastName}"
                        : "${widget.chat?.senderDetail?.name} ${widget.chat?.senderDetail?.lastName}",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontRes
                              .MONTSERRAT_MEDIUM,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                      maxLines: 2,
                    ),
                    const Gap(02),
                    Text(
                      widget.chat?.productDetail?.name ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontRes
                            .MONTSERRAT_MEDIUM,
                        color: Colors.black
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
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
                                StringHelper.areYouSureWantToDeleteThisChat,
                            onTap: () {
                              context.pop();
                              viewModel.clearChat(
                                  sender: DbHelper.getUserModel()?.id,
                                  reciver: widget.chat?.senderId ==
                                          DbHelper.getUserModel()?.id
                                      ? widget.chat?.receiverDetail?.id
                                      : widget.chat?.senderDetail?.id,
                                  product: widget.chat?.productId);
                            },
                            lottieIcon: AssetsRes.DELETE_LOTTIE,
                            showCancelButton: true,
                            cancelButtonText: StringHelper.no,
                            title: StringHelper.deleteChat,
                            buttonText: StringHelper.yes,
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
                                    message:
                                        StringHelper.pleaseEnterReasonOfReport);
                                return;
                              }
                              context.pop();
                              viewModel.reportBlockUser(
                                  report: true,
                                  reason: viewModel.reportTextController.text,
                                  userId:
                                      "${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.id : widget.chat?.senderDetail?.id}");
                            },
                            icon: AssetsRes.IC_REPORT_USER,
                            showCancelButton: true,
                            isTextDescription: false,
                            content: AppTextField(
                              controller: viewModel.reportTextController,
                              maxLines: 4,
                              hint: StringHelper.reason,
                            ),
                            cancelButtonText: StringHelper.no,
                            title: StringHelper.reportUser,
                            buttonText: StringHelper.yes,
                          ));
                  return;
                case 3:
                  showDialog(
                      context: context,
                      builder: (context) => AppAlertDialogWithWidget(
                            description: viewModel.blockedUser
                                ? StringHelper.areYouSureWantToUnblockThisUser
                                : StringHelper.areYouSureWantToBlockThisUser,
                            onTap: () {
                              context.pop();
                              viewModel.reportBlockUser(
                                productId: widget.chat?.productId,
                                  userId:
                                      "${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.id : widget.chat?.senderDetail?.id}");
                              // Future.delayed(Duration(milliseconds: 500), () {
                              //   viewModel.getMessageList(
                              //       receiverId: widget.chat?.senderId ==
                              //               DbHelper.getUserModel()?.id
                              //           ? widget.chat?.receiverDetail?.id
                              //           : widget.chat?.senderDetail?.id,
                              //       productId: widget.chat?.productId);
                              // });
                            },
                            icon: AssetsRes.IC_BLOCK_USER,
                            showCancelButton: true,
                            cancelButtonText: StringHelper.no,
                            title: viewModel.blockedUser
                                ? StringHelper.unblockUser
                                : StringHelper.blockUser,
                            buttonText: StringHelper.yes,
                          ));
                  return;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Text(StringHelper.deleteChat),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(StringHelper.reportUser),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(viewModel.blockedUser
                    ? StringHelper.unblockUser
                    : StringHelper.blockUser),
              ),
            ],
          ),
        ],
        centerTitle: false,
      ),
      body: StreamBuilder<List<MessageModel>>(
          stream: viewModel.messageStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MessageModel> data = snapshot.data ?? [];
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: data.length,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return viewModel.getBubble(
                            context:context,
                              chat: widget.chat,
                              data: data[index],
                              type: data[index].messageType);
                        }),
                  ),
                  const Gap(10),
                  if((widget.chat?.productDetail?.sellStatus??"").toLowerCase() != "sold")...{
                    viewModel.blockedUser
                        ? SafeArea(
                      child: Text(
                        viewModel.blockText,
                        style:
                        context.titleLarge?.copyWith(color: Colors.red),
                      ),
                    )
                        : MessageBarWithSuggestions(
                      suggestions: [
                        StringHelper.hello,
                        StringHelper.howAreYou
                      ],
                      onSuggestionSelected: (value) {
                        viewModel.messageTextController.text = value;
                      },
                      onOfferMade: (value) {
                        viewModel.sendMessage(
                            message: '$value',
                            type: 2,
                            roomId: viewModel.currentRoomId,
                            receiverId: widget.chat?.senderId ==
                                DbHelper.getUserModel()?.id
                                ? widget.chat?.receiverDetail?.id
                                : widget.chat?.senderDetail?.id,
                            productId: widget.chat?.productId);
                      },
                      textController: viewModel.messageTextController,
                      onSubmitted: (value) {
                        viewModel.sendMessage(
                            message: value,
                            roomId: viewModel.currentRoomId,
                            type: 1,
                            receiverId: widget.chat?.senderId ==
                                DbHelper.getUserModel()?.id
                                ? widget.chat?.receiverDetail?.id
                                : widget.chat?.senderDetail?.id,
                            productId: widget.chat?.productId);
                        viewModel.messageTextController.clear();
                      },
                      onPickImageClick: () async {
                        var image = await ImagePickerHelper.openImagePicker(
                            context: context, isCropping: false);

                        if (image != null) {
                          DialogHelper.showLoading();
                          String value = await BaseClient.uploadImage(
                              imagePath: image);
                          viewModel.sendMessage(
                              roomId: viewModel.currentRoomId,
                              message: value,
                              type: 3,
                              receiverId: widget.chat?.senderId ==
                                  DbHelper.getUserModel()?.id
                                  ? widget.chat?.receiverDetail?.id
                                  : widget.chat?.senderDetail?.id,
                              productId: widget.chat?.productId);
                        }
                      },
                      onRecordingClick: () {},
                    ),
                  }else...{
                    SafeArea(
                      child: Text(
                        "Product Sold Out",
                        style:
                        context.titleLarge?.copyWith(color: Colors.red),
                      ),
                    )
                  }

                ],
              );
            }
            if (snapshot.hasError) {
              return const AppErrorWidget();
            }
            return const AppLoadingWidget();
          }),
    );
  }
}
