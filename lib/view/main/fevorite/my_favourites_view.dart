import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/models/prodect_detail_model.dart';
import 'package:list_and_life/skeletons/product_list_skeleton.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/helpers/date_helper.dart';
import '../../../base/helpers/db_helper.dart';
import '../../../models/common/map_response.dart';
import '../../../models/home_list_model.dart';
import '../../../base/network/api_constants.dart';
import '../../../base/network/api_request.dart';
import '../../../base/network/base_client.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_product_item_widget.dart';
import '../../../widgets/unauthorised_view.dart';

class MyFavouritesView extends StatefulWidget {
  const MyFavouritesView({super.key});

  @override
  State<MyFavouritesView> createState() => _MyFavouritesViewState();
}

class _MyFavouritesViewState extends State<MyFavouritesView> {
  final List<ProductDetailModel> _productsList = [];
  late RefreshController refreshController;
  final int _limit = 30;
  int _page = 1;
  bool _isLoading = true;

  Future<void> _onRefresh() async {
    // monitor network fetch
    _page = 1;
    _productsList.clear();
    await _getProductsApi(loading: true);
    refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    // monitor network fetch
    ++_page;
    await _getProductsApi(loading: false);

    ///await fetchProducts();
    refreshController.loadComplete();
  }

  Future<void> _getProductsApi({bool loading = false}) async {
    if (loading) _isLoading = loading;
    setState(() {});
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getFavouritesUrl(limit: _limit, page: _page),
        requestType: RequestType.get);
    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse<HomeListModel> model =
        MapResponse.fromJson(response, (json) => HomeListModel.fromJson(json));
    _productsList.addAll(model.body?.data ?? []);

    if (loading) _isLoading = false;
    setState(() {});
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
    return DateHelper.getTimeAgo(timestamp);
  }

  @override
  void initState() {
    // TODO: implement initState
    refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DbHelper.getIsGuest()
          ? const UnauthorisedView()
          : SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropHeader(),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _isLoading
                  ? ProductListSkeleton(isLoading: _isLoading)
                  : _productsList.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: _productsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(top: index == 0 ? 25.0 : 0),
                              child: AppProductItemWidget(
                                data: _productsList[index],
                                onItemTapped: () async {
                                  await context.push(Routes.productDetails,
                                      extra: _productsList[index]);
                                  _onRefresh();
                                },
                                onLikeTapped: () {
                                  _onRefresh();
                                },
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Gap(20);
                          },
                        )
                      : const AppEmptyWidget()),
    );
  }
}
