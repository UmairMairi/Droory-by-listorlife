import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/skeletons/inbox_skeleton.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../../../res/assets_res.dart';

class InboxView extends BaseView<ChatVM> {
  const InboxView({super.key});



  @override
  Widget build(BuildContext context, ChatVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.myChats),
        centerTitle: true,
      ),
      body: StreamBuilder<List<InboxModel>>(
          stream: viewModel.inboxStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  children: [
                    AppTextField(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      controller: viewModel.inboxSearchTextController,
                      hint: StringHelper.search,
                      validator: (value){
                        return null;
                      },
                      onChanged: (String text) {
                        viewModel.searchInbox(text);
                      },
                      suffix: const Icon(Icons.search),
                    ),
                    const Gap(20),
                    Expanded(
                      child: viewModel.filteredInboxList.isEmpty
                          ? const AppEmptyWidget()
                          : ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                InboxModel data =
                                    viewModel.filteredInboxList[index];
                                SenderDetail? sender = data.senderDetail;
                                SenderDetail? receiver = data.receiverDetail;
                                var userImage = data.senderId == DbHelper.getUserModel()?.id ? receiver?.profilePic ?? '' : sender?.profilePic ?? '';
                                return InkWell(
                                  onTap: () {
                                    context.push(Routes.message,
                                        extra:
                                            viewModel.filteredInboxList[index]).then((value){
                                      // viewModel.readChatStatus(receiverId: data.senderId == DbHelper.getUserModel()?.id
                                      //     ? data.receiverDetail?.id
                                      //     : data.senderDetail?.id,
                                      //   roomId: data.lastMessageDetail?.roomId);
                                      viewModel.initListeners();
                                      viewModel.updateChatScreenId(roomId: null);
                                    });
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ImageView.rect(
                                            height: 60,
                                            width: 60,
                                            image:
                                                "${ApiConstants.imageUrl}/${data.productDetail?.image}",
                                          ),
                                          ImageView.circle(
                                            height: 25,
                                            width: 25,
                                            borderColor: context.theme.primaryColor,
                                            placeholder: AssetsRes.IC_USER_ICON,
                                            image:getImageUrl(url: userImage),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.senderId ==
                                                          DbHelper.getUserModel()
                                                              ?.id
                                                      ? "${receiver?.name} ${receiver?.lastName}"
                                                      : "${sender?.name} ${sender?.lastName}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: FontRes
                                                            .MONTSERRAT_MEDIUM,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                    ),
                                                  maxLines: 2,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                     Icon(
                                                      Icons.remove_red_eye_outlined,
                                                      size: 12,
                                                      color: data.unread_count != 0?Colors.red:Colors.black,
                                                    ),
                                                    const Gap(02),
                                                    Text(
                                                      viewModel.getCreatedAt(
                                                          time: data.updatedAt),
                                                      style: context
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontFamily: FontRes
                                                                  .MONTSERRAT_MEDIUM,
                                                              fontSize: 10),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Gap(02),
                                            Text(
                                              data.productDetail?.name ?? '',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: FontRes
                                                      .MONTSERRAT_MEDIUM,
                                                  color: Colors.black
                                              ),
                                              maxLines: 2,
                                            ),
                                            const Gap(02),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${viewModel.getLastMessage(message: data.lastMessageDetail)}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: context
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                            fontFamily: FontRes
                                                                .MONTSERRAT_MEDIUM),
                                                  ),
                                                ),
                                                Gap(10),
                                                Visibility(
                                                  visible: data.unread_count != 0,
                                                  child: CircleAvatar(
                                                    radius: 10, // Adjust based on UI needs
                                                    backgroundColor: Colors.red, // Unread count indicator
                                                    child: Center(
                                                      child: Text(
                                                        "${(data.unread_count??0) > 9 ? '9+' : data.unread_count}", // Limit to 99+
                                                        style: context.textTheme.labelSmall?.copyWith(
                                                          color: Colors.white, // Ensure contrast
                                                          fontSize:(data.unread_count??0) > 9? 8:9,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: FontRes.MONTSERRAT_MEDIUM,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: viewModel.filteredInboxList.length),
                    ),
                    const Gap(40),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return const AppErrorWidget();
            }

            return InboxSkeleton(
              isLoading: snapshot.connectionState == ConnectionState.waiting,
            );
          }),
    );
  }

  String getImageUrl({required String url}) {
    if (url.contains('http')) {
      return url;
    }
    if (!url.contains('http')) {
      return "${ApiConstants.imageUrl}/$url";
    }
    return AssetsRes.IC_USER_ICON;
  }
}
