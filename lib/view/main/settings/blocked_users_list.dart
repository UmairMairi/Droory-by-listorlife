import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/blocked_user_model.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/skeletons/blocked_users_skeleton.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../base/sockets/socket_constants.dart';
import '../../../base/sockets/socket_helper.dart';

class BlockedUsersList extends StatefulWidget {
  const BlockedUsersList({super.key});

  @override
  State<BlockedUsersList> createState() => _BlockedUsersListState();
}

class _BlockedUsersListState extends State<BlockedUsersList> {
  List<BlockedUserModel> blockList = [];
  final Socket _socketIO = SocketHelper().getSocket();

  Future<List<BlockedUserModel>> getBlockedUsers() async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getBlockListUrl(), requestType: RequestType.get);

    var response = await BaseClient.handleRequest(apiRequest);

    MapResponse<BlockedListModel> model =
        MapResponse<BlockedListModel>.fromJson(
            response, (json) => BlockedListModel.fromJson(json));
    return model.body?.data ?? [];
  }

  void unBlockUser({required BlockedUserModel data}) {
    Map<String, dynamic> map = {
      "block_by": data.blockBy,
      "block_to": data.blockTo,
      "type": "block",
      "reason": ''
    };
    log("Socket call => ${SocketConstants.blockOrReportUser} with $map",
        name: "SOCKET");
    _socketIO.emit(SocketConstants.blockOrReportUser, map);
    DialogHelper.hideLoading();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Blocked'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: getBlockedUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                blockList = snapshot.data ?? [];
                return blockList.isEmpty
                    ? const AppEmptyWidget()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: blockList.length,
                        itemBuilder: (context, index) {
                          var item = blockList[index];

                          return Card(
                            child: ListTile(
                              leading: ImageView.rect(
                                  image:
                                      "${ApiConstants.imageUrl}/${item.user?.profilePic}",
                                  width: 100,
                                  height: 120),
                              title: Text(
                                  "${item.user?.name} ${item.user?.lastName}"),
                              trailing: TextButton(
                                child: const Text('Unblock'),
                                onPressed: () {
                                  DialogHelper.showLoading();
                                  unBlockUser(data: item);
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Gap(20);
                        },
                      );
              }
              if (snapshot.hasError) {
                log("${snapshot.error}", name: 'BASEX');
                return const AppErrorWidget();
              }
              return BlockedUsersSkeleton(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting);
            }));
  }
}
