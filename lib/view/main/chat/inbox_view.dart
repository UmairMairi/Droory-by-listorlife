import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_text_field.dart';

class InboxView extends BaseView<ChatVM> {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context, ChatVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            AppTextField(
              hint: 'Search...',
              suffix: Icon(Icons.search),
            ),
            const Gap(20),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                                  style: context.textTheme.titleMedium,
                                ),
                                const Gap(02),
                                Text(
                                  viewModel.inboxItems[index].subTitle ?? '',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                          fontFamily:
                                              FontRes.MONTSERRAT_MEDIUM),
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
                                style: context.textTheme.labelMedium?.copyWith(
                                    fontFamily: FontRes.MONTSERRAT_MEDIUM),
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
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
