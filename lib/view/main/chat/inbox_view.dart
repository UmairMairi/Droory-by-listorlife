import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/chat_vm.dart';

class InboxView extends BaseView<ChatVM> {
  const InboxView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ChatVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        centerTitle: true,
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                context.push(Routes.message,
                    extra: viewModel.inboxItems[index]);
              },
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      foregroundImage: AssetImage(
                          viewModel.inboxItems[index].icon ??
                              AssetsRes.DUMMY_PROFILE),
                    ),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.inboxItems[index].title ?? '',
                            style: context.textTheme.titleSmall,
                          ),
                          const Gap(02),
                          Text(
                            viewModel.inboxItems[index].subTitle ?? '',
                            style: context.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 12,
                        ),
                        Gap(02),
                        Text(
                          viewModel.inboxItems[index].timeStamp ?? '',
                          style: context.textTheme.labelSmall,
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
          itemCount: viewModel.inboxItems.length),
    );
  }
}
