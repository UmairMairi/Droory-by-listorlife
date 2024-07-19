import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/helpers/db_helper.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/unauthorised_view.dart';

class InboxView extends BaseView<ChatVM> {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context, ChatVM viewModel) {
    WidgetsBinding.instance
        .addPostFrameCallback((d) => viewModel.getInboxList());
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        centerTitle: true,
      ),
      body: DbHelper.getIsGuest()
          ? const UnauthorisedView()
          : StreamBuilder<List<InboxModel>>(
              stream: viewModel.inboxStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      children: [
                        const AppTextField(
                          hint: 'Search...',
                          suffix: Icon(Icons.search),
                        ),
                        const Gap(20),
                        viewModel.inboxList.isEmpty
                            ? const AppEmptyWidget()
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  InboxModel data = viewModel.inboxList[index];
                                  SenderDetail? sender = data.senderDetail;
                                  SenderDetail? receiver = data.receiverDetail;
                                  return InkWell(
                                    onTap: () {
                                      context.push(Routes.message,
                                          extra: viewModel.inboxList[index]);
                                    },
                                    child: Card(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ImageView.circle(
                                            height: 50,
                                            width: 50,
                                            image:
                                                "${ApiConstants.imageUrl}/${data.senderId == DbHelper.getUserModel()?.id ? receiver?.profilePic ?? '' : sender?.profilePic ?? ''}",
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
                                                Text(
                                                  data.senderId ==
                                                          DbHelper.getUserModel()
                                                              ?.id
                                                      ? receiver?.name ?? ''
                                                      : sender?.name ?? '',
                                                  style: context
                                                      .textTheme.titleMedium,
                                                ),
                                                const Gap(02),
                                                Text(
                                                  data.lastMessageDetail
                                                          ?.message ??
                                                      '',
                                                  style: context
                                                      .textTheme.labelMedium
                                                      ?.copyWith(
                                                          fontFamily: FontRes
                                                              .MONTSERRAT_MEDIUM),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.remove_red_eye_outlined,
                                                size: 12,
                                              ),
                                              const Gap(02),
                                              Text(
                                                viewModel.getCreatedAt(
                                                    time: data.updatedAt),
                                                style: context
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                        fontFamily: FontRes
                                                            .MONTSERRAT_MEDIUM),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Gap(10);
                                },
                                itemCount: viewModel.inboxList.length),
                        const Gap(40),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return AppErrorWidget();
                }

                return AppLoadingWidget();
              }),
    );
  }
}
