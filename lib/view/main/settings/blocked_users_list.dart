import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
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
import '../../../res/assets_res.dart';

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
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(StringHelper.blocked),
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
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: blockList.length,
                        itemBuilder: (context, index) {
                          var item = blockList[index];
                          print("(item.user?.profilePic??"
                              ") ${(item.user?.profilePic ?? "")}");
                          var userImage = (item.user?.profilePic ?? "")
                                  .isNotEmpty
                              ? (item.user?.profilePic ?? "").contains('http')
                                  ? "${item.user?.profilePic}"
                                  : "${ApiConstants.imageUrl}/${item.user?.profilePic}"
                              : "";
                          return Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        ImageView.circle(
                                            placeholder: AssetsRes.IC_USER_ICON,
                                            image: userImage,
                                            width: 50,
                                            height: 50),
                                        SizedBox(width: 10,),
                                        Text(
                                          "${item.user?.name} ${item.user?.lastName}",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15)),
                                    child: Text(
                                      StringHelper.unblock,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AppAlertDialogWithWidget(
                                                description: StringHelper
                                                    .areYouSureWantToUnblockThisUser,
                                                onTap: () {
                                                  context.pop();
                                                  DialogHelper.showLoading();
                                                  unBlockUser(data: item);
                                                },
                                                icon: AssetsRes.IC_BLOCK_USER,
                                                showCancelButton: true,
                                                cancelButtonText:
                                                    StringHelper.no,
                                                title: StringHelper.unblockUser,
                                                buttonText: StringHelper.yes,
                                              ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // child: ListTile(
                            //   leading: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       ImageView.circle(
                            //           placeholder: AssetsRes.IC_USER_ICON,
                            //           image: userImage,
                            //           width: 100,
                            //           height: 100),
                            //       SizedBox(width: 10,),
                            //       Text(
                            //           "${item.user?.name} ${item.user?.lastName}",
                            //       style: TextStyle(fontSize: 12),
                            //       )
                            //     ],
                            //   ),
                            //   trailing: TextButton(
                            //     style: TextButton.styleFrom(
                            //       backgroundColor: Colors.black,
                            //       padding: EdgeInsets.symmetric(horizontal: 10)
                            //     ),
                            //     child:  Text(StringHelper.unblock,style: TextStyle(color: Colors.white),),
                            //     onPressed: () {
                            //       showDialog(
                            //           context: context,
                            //           builder: (context) => AppAlertDialogWithWidget(
                            //             description: StringHelper.areYouSureWantToUnblockThisUser,
                            //             onTap: () {
                            //               context.pop();
                            //               DialogHelper.showLoading();
                            //               unBlockUser(data: item);
                            //             },
                            //             icon: AssetsRes.IC_BLOCK_USER,
                            //             showCancelButton: true,
                            //             cancelButtonText: StringHelper.no,
                            //             title:  StringHelper.unblockUser,
                            //             buttonText: StringHelper.yes,
                            //           ));
                            //
                            //     },
                            //   ),
                            // ),
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
