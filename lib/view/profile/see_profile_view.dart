import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/like_button.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../../base/helpers/date_helper.dart';
import '../../models/common/map_response.dart';
import '../../models/home_list_model.dart';
import '../../models/user_model.dart';
import '../../base/network/api_request.dart';
import '../../base/network/base_client.dart';
import '../../routes/app_routes.dart';
import '../../skeletons/other_product_skeleton.dart';

class SeeProfileView extends StatefulWidget {
  final UserModel? user;
  const SeeProfileView({super.key, required this.user});

  @override
  State<SeeProfileView> createState() => _SeeProfileViewState();
}

class _SeeProfileViewState extends State<SeeProfileView> {
  late RefreshController _refreshController;

  bool _isLoading = true;
  final List<ProductDetailModel> _productsList = [];
  final int _limit = 30;
  int _page = 1;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> onLikeButtonTapped({required num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addFavouriteUrl(),
        requestType: RequestType.post,
        body: {'product_id': id});

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);

    log("Fav Message => ${model.message}");
  }

  Future<void> _getProductsApi({bool loading = false}) async {
    if (loading) _isLoading = loading;
    setState(() {});

    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getUsersProductsUrl(
            limit: _limit, page: _page, userId: "${widget.user?.id}"),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));
    _productsList.addAll(model.body?.data ?? []);
    if (loading) _isLoading = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    _page = 1;
    _productsList.clear();
    await _getProductsApi(loading: true);
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    ++_page;
    await _getProductsApi(loading: false);

    _refreshController.loadComplete();
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

    return DateHelper.getTimeAgo(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("See Profile"),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
              offset: const Offset(0, 40),
              icon: const Icon(Icons.more_vert),
              onSelected: (int value) {
                switch (value) {
                  case 1:
                    Share.share(
                        "Check this user profile in List or Lift app url: www.google.com");
                    return;
                  case 2:
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          int selectedReport = 0;
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              right: 10,
                              left: 10,
                              bottom: context.viewInsets.bottom,
                            ),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Report User',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  RadioListTile<int?>(
                                      value: 1,
                                      title: const Text(
                                          'Inappropriate profile picture'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 2,
                                      title: const Text(
                                          'This user is threatening me'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 3,
                                      title: const Text(
                                          'This User is insulting me'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 4,
                                      title: const Text('Spam'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 5,
                                      title: const Text('Fraud'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 6,
                                      title: const Text('Other'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: AppTextField(
                                      animation: false,
                                      lines: 3,
                                      title: 'Comment',
                                      hint: 'Write here...',
                                    ),
                                  ),
                                  const Gap(10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: AppOutlineButton(
                                          onTap: () {
                                            context.pop();
                                          },
                                          title: 'Cancel',
                                        )),
                                        const Gap(20),
                                        Expanded(
                                            child: AppElevatedButton(
                                          onTap: () {
                                            context.pop();
                                          },
                                          title: 'Send',
                                        ))
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                ],
                              );
                            }),
                          );
                        });

                    return;
                  case 3:
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          int selectedReport = 0;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Block User',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Text(
                                        'Block John Marker? Blocked contacts will no longer be able to send you messages.'),
                                  ),
                                  const Gap(10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: AppOutlineButton(
                                          height: 40,
                                          onTap: () {
                                            context.pop();
                                          },
                                          title: 'Cancel',
                                        )),
                                        const Gap(20),
                                        Expanded(
                                            child: AppElevatedButton(
                                          onTap: () {
                                            context.pop();
                                            context.pop();
                                          },
                                          height: 40,
                                          title: 'Block',
                                        ))
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                ],
                              );
                            }),
                          );
                        });
                    return;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Share Profile'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Report User'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Block User'),
                    ),
                  ]),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                ImageView.circle(
                  image:
                      "${ApiConstants.imageUrl}/${widget.user?.profilePic}" ??
                          AssetsRes.DUMMY_PROFILE,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.user?.name} ${widget.user?.lastName}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 15,
                          ),
                          const Gap(05),
                          Text(
                            "Member since ${DateFormat('MMM yyyy').format(DateTime.parse("${widget.user?.createdAt}"))}",
                            style: const TextStyle(
                                color: Color(0xff7E8392), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: _isLoading
                    ? OtherProductSkeleton(isLoading: _isLoading)
                    : _productsList.isNotEmpty
                        ? ListView.builder(
                            itemCount: _productsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  context.push(
                                    Routes.productDetails,
                                    extra: _productsList[index],
                                  );
                                },
                                child: Card(
                                  elevation: 4,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 10, left: 5, right: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ImageView.rect(
                                            image:
                                                "${ApiConstants.imageUrl}/${_productsList[index].productMedias?.first.media}",
                                            borderRadius: 15,
                                            width: 90,
                                            height: 100),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "EGP${_productsList[index].price}",
                                                    style: context
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontFamily: FontRes
                                                                .MONTSERRAT_BOLD),
                                                  ),
                                                  LikeButton(
                                                    onTap: () async =>
                                                        onLikeButtonTapped(
                                                            id: _productsList[
                                                                    index]
                                                                .id),
                                                    isFav: _productsList[index]
                                                            .isFavourite ==
                                                        1,
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "${_productsList[index].description}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          AssetsRes
                                                              .IC_LOACTION_ICON,
                                                          height: 14,
                                                          width: 14,
                                                        ),
                                                        const Gap(8),
                                                        Expanded(
                                                          child: Text(
                                                            "${_productsList[index].nearby}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Gap(05),
                                                  Text(
                                                    getCreatedAt(
                                                        time:
                                                            _productsList[index]
                                                                .createdAt),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : const AppEmptyWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
