import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/notification_data_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/skeletons/blocked_users_skeleton.dart';
import 'package:list_and_life/widgets/app_empty_notification_wiidget.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/image_view.dart';

import '../../base/helpers/date_helper.dart';
import '../../base/helpers/string_helper.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  Future<List<NotificationDataModel>> getNotificationList() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getNotificationUrl(), requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<NotificationListModel> model =
        MapResponse<NotificationListModel>.fromJson(
            response, (json) => NotificationListModel.fromJson(json));

    return model.body?.data ?? [];
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);

    return DateHelper.getWalletDate(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringHelper.notifications),
          centerTitle: true,
        ),
        body: FutureBuilder<List<NotificationDataModel>>(
            future: getNotificationList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<NotificationDataModel> notifications = snapshot.data ?? [];
                return notifications.isEmpty
                    ? const AppEmptyNotificationWidget()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: const ImageView.rect(
                                  image: AssetsRes.IC_NOTIFICATION,
                                  width: 50,
                                  height: 50),
                              title: Text(notifications[index].title ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(notifications[index].body ?? ''),
                                  Text(
                                    getCreatedAt(
                                        time: notifications[index].updatedAt),
                                    style: context.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Gap(10);
                        },
                        itemCount: notifications.length);
              }
              if (snapshot.hasError) {
                return const AppErrorWidget();
              }
              return BlockedUsersSkeleton(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting);
            })
        /*ListView.separated(
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
      )*/
        );
  }
}
