import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/notification_v_m.dart';

class NotificationView extends BaseView<NotificationVM> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, NotificationVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: viewModel.notificationList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              viewModel.notificationList[index].title ?? '',
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              viewModel.notificationList[index].timeStamp ?? '',
                              style: context.textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const Gap(10),
                        Text(viewModel.notificationList[index].description ??
                            ''),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: CircleAvatar(
                radius: 25,
                backgroundImage:
                    AssetImage(viewModel.notificationList[index].icon ?? ''),
              ))
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}
