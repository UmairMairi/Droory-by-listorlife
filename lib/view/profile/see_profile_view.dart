import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'
    hide TextDirection; // Hide TextDirection from intl
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_empty_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:list_and_life/widgets/like_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../base/helpers/date_helper.dart';
import '../../base/helpers/string_helper.dart';
import '../../base/network/api_request.dart';
import '../../base/network/base_client.dart';
import '../../base/utils/utils.dart';
import '../../models/common/map_response.dart';
import '../../models/home_list_model.dart';
import '../../models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../skeletons/other_product_skeleton.dart';
import '../../base/helpers/LocationService.dart';
import '../../models/city_model.dart';

class SeeProfileView extends StatefulWidget {
  final UserModel? user;
  final InboxModel? chat;
  const SeeProfileView({super.key, required this.user,this.chat});

  @override
  State<SeeProfileView> createState() => _SeeProfileViewState();
}

class _SeeProfileViewState extends State<SeeProfileView> {
  late RefreshController _refreshController;

  bool _isLoading = true;
  final List<ProductDetailModel> _productsList = [];
  final int _limit = 30;
  int _page = 1;
  late ChatVM viewModel;

  @override
  void initState() {
    log("${widget.user?.toJson()}", name: "USER");
    _refreshController = RefreshController(initialRefresh: true);
    viewModel = context.read<ChatVM>();
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

  // Helper method to get filler image based on category
  String _getFillerImageForCategory(dynamic categoryId) {
    int? normalizedId;
    if (categoryId != null) {
      if (categoryId is int) {
        normalizedId = categoryId;
      } else {
        normalizedId = int.tryParse(categoryId.toString());
      }
    }

    switch (normalizedId) {
      case 8:
        return AssetsRes.SERVICE_FILLER_IMAGE;
      case 9:
        return AssetsRes.JOB_FILLER_IMAGE;
      default:
        return AssetsRes.APP_LOGO;
    }
  }

  bool _isCurrentLanguageArabic() {
    return Directionality.of(context) == TextDirection.rtl;
  }

  // Helper method to get localized location for user profile
  String _getLocalizedLocationForUser(UserModel? user) {
    if (user == null) {
      return _isCurrentLanguageArabic() ? "مصر" : "Egypt";
    }

    bool isArabic = _isCurrentLanguageArabic();

    // Priority 1: Use structured English names if available for full N, D, C
    if (user.cityEn != null && user.cityEn!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(user.cityEn!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;

        if (user.districtEn != null && user.districtEn!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, user.districtEn!);
          if (districtModel != null) {
            String districtName =
                isArabic ? districtModel.arabicName : districtModel.name;

            if (user.neighborhoodEn != null &&
                user.neighborhoodEn!.isNotEmpty) {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, user.neighborhoodEn!);
              if (neighborhoodModel != null) {
                String neighborhoodName = isArabic
                    ? neighborhoodModel.arabicName
                    : neighborhoodModel.name;
                return "$neighborhoodName، $districtName، $cityName";
              }
            }
            return "$districtName، $cityName";
          }
        }
        return cityName;
      }
    }

    // Priority 2: Try coordinates for full location lookup
    if (user.latitude != null && user.longitude != null) {
      double? lat = double.tryParse("${user.latitude}");
      double? lng = double.tryParse("${user.longitude}");

      if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
        return _getLocalizedLocationFromCoordinates(lat, lng);
      }
    }

    // Priority 3: Fallback to user.address (if available)
    if (user.address != null && user.address!.toString().isNotEmpty) {
      return user.address!.toString();
    }

    return _isCurrentLanguageArabic() ? "مصر" : "Egypt";
  }

  String _getLocalizedLocationFromCoordinates(double lat, double lng) {
    bool isArabic = _isCurrentLanguageArabic();
    CityModel? nearestCity = LocationService.findNearestCity(lat, lng);

    if (nearestCity != null) {
      if (nearestCity.districts != null) {
        for (var district in nearestCity.districts!) {
          if (district.neighborhoods != null) {
            for (var neighborhood in district.neighborhoods!) {
              double distance = LocationService.calculateDistance(
                  lat, lng, neighborhood.latitude, neighborhood.longitude);
              if (distance <= (neighborhood.radius ?? 2.0)) {
                return isArabic
                    ? "${neighborhood.arabicName}، ${district.arabicName}، ${nearestCity.arabicName}"
                    : "${neighborhood.name}, ${district.name}, ${nearestCity.name}";
              }
            }
          }
          double distanceToDistrict = LocationService.calculateDistance(
              lat, lng, district.latitude, district.longitude);
          if (distanceToDistrict <= (district.radius ?? 5.0)) {
            return isArabic
                ? "${district.arabicName}، ${nearestCity.arabicName}"
                : "${district.name}, ${nearestCity.name}";
          }
        }
      }
      return isArabic ? nearestCity.arabicName : nearestCity.name;
    }
    return isArabic ? "كل مصر" : "All Egypt";
  }

  // Helper method to get localized location for products - FIXED VERSION
  String _getLocalizedLocationForProduct(ProductDetailModel? data) {
    bool isArabic = _isCurrentLanguageArabic();

    if (data == null) {
      return isArabic ? "مصر" : "Egypt";
    }

    // Priority 1: Use stored English names
    if (data.city != null && data.city!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(data.city!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;

        if (data.districtName != null && data.districtName!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, data.districtName!);
          if (districtModel != null) {
            String districtName =
                isArabic ? districtModel.arabicName : districtModel.name;

            // Check for both null and 'null' string
            if (data.neighborhoodName != null &&
                data.neighborhoodName!.isNotEmpty &&
                data.neighborhoodName != 'null') {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, data.neighborhoodName!);
              if (neighborhoodModel != null) {
                String neighborhoodName = isArabic
                    ? neighborhoodModel.arabicName
                    : neighborhoodModel.name;
                return "$neighborhoodName، $districtName، $cityName";
              }
            }
            return "$districtName، $cityName";
          }
        }
        return cityName;
      }
    }

    // Priority 2: Coordinates
    if (data.latitude != null && data.longitude != null) {
      double? lat = double.tryParse(data.latitude!);
      double? lng = double.tryParse(data.longitude!);

      if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
        return _getLocalizedLocationFromCoordinates(lat, lng);
      }
    }

    // Priority 3: Parse 'nearby' directly if city was null
    if (data.nearby != null && data.nearby!.isNotEmpty) {
      List<String> parts =
          data.nearby!.split(',').map((e) => e.trim()).toList();
      String finalCityEng = "";
      String finalDistrictEng = "";
      String finalNeighborhoodEng = "";

      if (parts.length == 3) {
        finalNeighborhoodEng = parts[0];
        finalDistrictEng = parts[1];
        finalCityEng = parts[2];
      } else if (parts.length == 2) {
        finalDistrictEng = parts[0];
        finalCityEng = parts[1];
      } else if (parts.length == 1) {
        finalCityEng = parts[0];
      }

      if (finalCityEng.isNotEmpty) {
        CityModel? cityModelFromNearby =
            LocationService.findCityByName(finalCityEng);
        if (cityModelFromNearby != null) {
          String cityNearbyLocalized = isArabic
              ? cityModelFromNearby.arabicName
              : cityModelFromNearby.name;
          if (finalDistrictEng.isNotEmpty) {
            DistrictModel? districtModelFromNearby =
                LocationService.findDistrictByName(
                    cityModelFromNearby, finalDistrictEng);
            if (districtModelFromNearby != null) {
              String districtNearbyLocalized = isArabic
                  ? districtModelFromNearby.arabicName
                  : districtModelFromNearby.name;
              if (finalNeighborhoodEng.isNotEmpty) {
                NeighborhoodModel? neighborhoodModelFromNearby =
                    LocationService.findNeighborhoodByName(
                        districtModelFromNearby, finalNeighborhoodEng);
                if (neighborhoodModelFromNearby != null) {
                  String neighborhoodNearbyLocalized = isArabic
                      ? neighborhoodModelFromNearby.arabicName
                      : neighborhoodModelFromNearby.name;
                  return "$neighborhoodNearbyLocalized، $districtNearbyLocalized، $cityNearbyLocalized";
                }
              }
              return "$districtNearbyLocalized، $cityNearbyLocalized";
            }
          }
          return cityNearbyLocalized;
        }
      }
      // If parsing fails, return nearby as is
      return data.nearby!;
    }

    return isArabic ? "مصر" : "Egypt";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.seeProfile),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageView.circle(
                  placeholder: AssetsRes.IC_USER_ICON,
                  image: "${ApiConstants.imageUrl}/${widget.user?.profilePic}",
                  height: 60,
                  width: 60,
                ),
                const SizedBox(width: 15),
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
                      const SizedBox(height: 2),
                      // Location with icon
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/location.svg',
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                              Colors.grey.shade600,
                              BlendMode.srcIn,
                            ),
                          ),
                          const Gap(5),
                          Expanded(
                            child: Text(
                              _isCurrentLanguageArabic()
                                  ? "مصر"
                                  : "Egypt", // Fixed location
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 15,
                            color: Color(0xff7E8392),
                          ),
                          const Gap(5),
                          Text(
                            "${StringHelper.memberSince} ${DateFormat('MMM yyyy').format(DateTime.parse("${widget.user?.createdAt}"))}",
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
            // Display Bio if available
            if (widget.user?.bio != null && widget.user!.bio!.isNotEmpty) ...[
              const SizedBox(height: 15),
              Text(
                StringHelper.bio,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.user!.bio!,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  complete: Platform.isAndroid
                      ? const CircularProgressIndicator()
                      : const CupertinoActivityIndicator(),
                ),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: _isLoading
                    ? OtherProductSkeleton(isLoading: _isLoading)
                    : _productsList.isNotEmpty
                        ? ListView.builder(
                            itemCount: _productsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final product = _productsList[index];
                              final hasValidImage = product.image != null &&
                                  product.image!.trim().isNotEmpty;

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
                                          placeholder:
                                              _getFillerImageForCategory(
                                                  product.categoryId),
                                          image: hasValidImage
                                              ? "${ApiConstants.imageUrl}/${product.image}"
                                              : "",
                                          borderRadius: 15,
                                          width: 90,
                                          height: 100,
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    _productsList[index]
                                                                .categoryId ==
                                                            9
                                                        ? getSalaryDisplayText(
                                                            _productsList[
                                                                index])
                                                        : "${StringHelper.egp}${parseAmount(_productsList[index].price)}",
                                                    style: context
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontFamily: FontRes
                                                                .MONTSERRAT_BOLD),
                                                  ),
                                                  Spacer(),
                                                  LikeButton(
                                                    color: Colors.black,
                                                    onTap: () async =>
                                                        onLikeButtonTapped(
                                                            id: _productsList[
                                                                    index]
                                                                .id),
                                                    isFav: _productsList[index]
                                                            .isFavourite ==
                                                        1,
                                                  ),
                                                  IconButton(
                                                    icon:
                                                    const Icon(Icons.more_vert, color: Colors.black87, size: 24),
                                                    onPressed: _showBlockReportActionSheet,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${_productsList[index].description}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/icons/location.svg',
                                                          height: 14,
                                                          width: 14,
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                            Colors
                                                                .grey.shade600,
                                                            BlendMode.srcIn,
                                                          ),
                                                        ),
                                                        const Gap(8),
                                                        Expanded(
                                                          child: Text(
                                                            _getLocalizedLocationForProduct(
                                                                product),
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
                                                  const Gap(5),
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

  String getSalaryDisplayText(ProductDetailModel? productData) {
    if (productData?.categoryId != 9) return "";

    // Get the raw values directly from the model
    String fromValue = productData?.salleryFrom?.toString() ?? "";
    String toValue = productData?.salleryTo?.toString() ?? "";

    // Parse to numbers for comparison, treating empty/null as 0
    num fromNum = num.tryParse(fromValue) ?? 0;
    num toNum = num.tryParse(toValue) ?? 0;

    // Format for display (only if > 0)
    String fromFormatted =
        fromNum > 0 ? Utils.formatPrice(fromNum.toStringAsFixed(0)) : "";
    String toFormatted =
        toNum > 0 ? Utils.formatPrice(toNum.toStringAsFixed(0)) : "";

    // Both values exist and are not zero
    if (fromNum > 0 && toNum > 0) {
      return "${StringHelper.egp} $fromFormatted - ${StringHelper.egp} $toFormatted";
    }
    // Only salary from exists
    else if (fromNum > 0 && toNum == 0) {
      return "${StringHelper.salaryFrom}: ${StringHelper.egp} $fromFormatted";
    }
    // Only salary to exists
    else if (fromNum == 0 && toNum > 0) {
      return "${StringHelper.salaryTo}: ${StringHelper.egp} $toFormatted";
    }

    // Both are zero or empty - fallback
    return "${StringHelper.egp} 0";
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return Utils.formatPrice(num.parse("${amount ?? 0}").toStringAsFixed(0));
  }



  // Show native block/report action sheet
  void _showBlockReportActionSheet() {
    bool isArabic = _isCurrentLanguageArabic();

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showReportDialog();
              },
              isDestructiveAction: true,
              child: Text(
                StringHelper.reportUser,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showBlockDialog();
              },
              isDestructiveAction: true,
              child: Text(
                viewModel.blockedUser
                    ? StringHelper.unblockUser
                    : StringHelper.blockUser,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              StringHelper.cancel,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.report, color: Colors.red),
                  title: Text(
                    StringHelper.reportUser,
                    style: TextStyle(color: Colors.red),
                    textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block, color: Colors.red),
                  title: Text(
                    viewModel.blockedUser
                        ? StringHelper.unblockUser
                        : StringHelper.blockUser,
                    style: TextStyle(color: Colors.red),
                    textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showBlockDialog();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialogWithWidget(
        description: '',
        onTap: () {
          if (viewModel.reportTextController.text.trim().isEmpty) {
            DialogHelper.showToast(
                message: StringHelper.pleaseEnterReasonOfReport);
            return;
          }
          context.pop();
          viewModel.reportBlockUser(
              report: true,
              reason: viewModel.reportTextController.text,
              userId: "${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.id : widget.chat?.senderDetail?.id}");
        },
        icon: AssetsRes.IC_REPORT_USER,
        showCancelButton: true,
        isTextDescription: false,
        content: AppTextField(
          controller: viewModel.reportTextController,
          maxLines: 4,
          hint: StringHelper.reason,
        ),
        cancelButtonText: StringHelper.no,
        title: StringHelper.reportUser,
        buttonText: StringHelper.yes,
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialogWithWidget(
        description: viewModel.blockedUser
            ? StringHelper.areYouSureWantToUnblockThisUser
            : StringHelper.areYouSureWantToBlockThisUser,
        onTap: () {
          context.pop();
          viewModel.reportBlockUser(
              productId: widget.chat?.productId,
              userId:
              "${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.id : widget.chat?.senderDetail?.id}");
        },
        icon: AssetsRes.IC_BLOCK_USER,
        showCancelButton: true,
        cancelButtonText: StringHelper.no,
        title: viewModel.blockedUser
            ? StringHelper.unblockUser
            : StringHelper.blockUser,
        buttonText: StringHelper.yes,
      ),
    );
  }
}
