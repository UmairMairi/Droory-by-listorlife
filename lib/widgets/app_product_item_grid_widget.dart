import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/date_helper.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/widgets/card_swipe_widget.dart';
import 'package:list_and_life/widgets/like_button.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/models/city_model.dart';
import '../base/helpers/db_helper.dart';
import '../base/helpers/string_helper.dart';
import '../base/helpers/dialog_helper.dart';
import '../base/utils/utils.dart';
import '../models/common/map_response.dart';
import '../base/network/api_constants.dart';
import '../base/network/api_request.dart';
import '../base/network/base_client.dart';
import '../models/inbox_model.dart';
import '../routes/app_routes.dart';

class AppProductItemGridWidget extends StatelessWidget {
  final ProductDetailModel? data;
  final Function()? onLikeTapped;
  final Function() onItemTapped;

  const AppProductItemGridWidget({
    super.key,
    this.data,
    this.onLikeTapped,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemTapped,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with like button - Fixed height
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: CardSwipeWidget(
                      onItemTapped: onItemTapped,
                      screenType: "home",
                      data: data,
                      imagesList: data?.productMedias,
                      height: 160,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: LikeButton(
                          isFav: data?.isFavourite == 1,
                          onTap: () async {
                            if (!DbHelper.getIsGuest()) {
                              await onLikeButtonTapped(id: data?.id);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content section - Fixed height
            SizedBox(
              height: 130,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(4),
                        if (data?.categoryId == 9) ...{
                          Text(
                            "${StringHelper.egp} ${parseAmount(data?.salleryFrom)} - ${parseAmount(data?.salleryTo)}",
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.theme.colorScheme.error,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        } else ...{
                          Text(
                            "${StringHelper.egp} ${parseAmount(data?.price)}",
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.theme.colorScheme.error,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        },
                      ],
                    ),

                    const Gap(4),

                    // Specifications (compact)
                    getSpecifications(context: context, data: data),

                    const Spacer(),

                    // Location and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/location.svg',
                              width: 14,
                              height: 14,
                              colorFilter: ColorFilter.mode(
                                Colors.grey.shade600,
                                BlendMode.srcIn,
                              ),
                            ),
                            const Gap(4),
                            Expanded(
                              child: Text(
                                getLocalizedLocation(context, data),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: context.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(2),
                        Text(
                          getCreatedAt(time: data?.createdAt),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        // Add compact communication buttons for grid
                        if (data?.userId != DbHelper.getUserModel()?.id) ...[
                          const Gap(6),
                          _buildCompactCommunicationButtons(context),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCommunicationButtons(BuildContext context) {
    String selectedChoice = data?.communicationChoice ?? '';
    List<Widget> buttons = [];

    if (selectedChoice.contains('call')) {
      buttons.add(_buildCompactButton(
        context,
        icon: Icons.phone,
        color: Colors.red,
        onTap: () async {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          DialogHelper.showLoading();
          await _callClickedApi(productId: "${data?.id}");
          String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
          DialogHelper.goToUrl(uri: Uri.parse("tel://$phone"));
        },
      ));
    }

    if (selectedChoice.contains('chat')) {
      buttons.add(_buildCompactButton(
        context,
        icon: Icons.chat_bubble_outline,
        color: Colors.blue,
        onTap: () {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          context.push(
            Routes.message,
            extra: InboxModel(
              senderId: DbHelper.getUserModel()?.id,
              receiverId: data?.userId,
              productId: data?.id,
              productDetail: data,
              receiverDetail: SenderDetail(
                id: data?.userId,
                lastName: data?.user?.lastName,
                profilePic: data?.user?.profilePic,
                name: data?.user?.name,
              ),
              senderDetail: SenderDetail(
                id: DbHelper.getUserModel()?.id,
                profilePic: DbHelper.getUserModel()?.profilePic,
                lastName: DbHelper.getUserModel()?.lastName,
                name: DbHelper.getUserModel()?.name,
              ),
            ),
          );
        },
      ));
    }

    if (selectedChoice.contains('whatsapp')) {
      buttons.add(_buildCompactButton(
        context,
        icon: Icons.chat,
        color: Colors.green,
        onTap: () {
          if (DbHelper.getIsGuest()) {
            DialogHelper.showLoginDialog(context: context);
            return;
          }
          String phone = "${data?.user?.countryCode}${data?.user?.phoneNo}";
          DialogHelper.goToUrl(
            uri: Uri.parse(
              'https://wa.me/$phone?text=Hi, I am interested in your ad.',
            ),
          );
        },
      ));
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    );
  }

  Widget _buildCompactButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 14,
            color: color,
          ),
        ),
      ),
    );
  }

  Future<void> _callClickedApi({required String productId}) async {
    ApiRequest apiRequest = ApiRequest(
      url: ApiConstants.callOnUrl(productId: productId),
      requestType: RequestType.get,
    );
    var response = await BaseClient.handleRequest(apiRequest);
    debugPrint("$response");
    DialogHelper.hideLoading();
  }

  String parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return Utils.formatPrice(num.parse("${amount ?? 0}").toStringAsFixed(0));
  }

  String getCreatedAt({String? time}) {
    String dateTimeString = "2024-06-25T01:01:47.000Z";
    DateTime dateTime = DateTime.parse(time ?? dateTimeString);
    int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;

    return DateHelper.getFormateDDMMMYYYY(timestamp);
  }

  Future<void> onLikeButtonTapped({required num? id}) async {
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.addFavouriteUrl(),
        requestType: RequestType.post,
        body: {'product_id': id});

    var response = await BaseClient.handleRequest(apiRequest);
    MapResponse model = MapResponse.fromJson(response, (json) => null);

    if (onLikeTapped != null) {
      Future.delayed(const Duration(milliseconds: 25), () => onLikeTapped!());
    }

    log("Fav Message => ${model.message}");
  }

  Widget getSpecifications({
    required BuildContext context,
    ProductDetailModel? data,
  }) {
    List<Widget> specs = [];

    if (data?.categoryId == 4) {
      // Vehicles category
      if (data?.year != null && data!.year != 0) {
        specs.add(_buildSpecChip(context, "${data.year}", Icons.event));
      }
      if (data?.kmDriven != null) {
        specs.add(_buildSpecChip(context, '${data?.kmDriven}', Icons.speed));
      }
      if (data?.fuel != null && data!.fuel!.isNotEmpty) {
        specs.add(_buildSpecChip(
            context, Utils.getFuel('${data.fuel}'), Icons.local_gas_station));
      }
    }

    if (data?.categoryId == 11) {
      // Real Estate category
      if (data?.bedrooms != null && data!.bedrooms != 0) {
        final bedroomsText = Utils.getBedroomsText('${data.bedrooms}');
        final isStudio = bedroomsText == "Studio" || bedroomsText == "استوديو";
        specs.add(_buildSpecChip(
            context,
            isStudio ? bedroomsText : "$bedroomsText ${StringHelper.beds}",
            Icons.king_bed));
      }
      if (data?.bathrooms != null && data!.bathrooms != 0) {
        specs.add(_buildSpecChip(
            context,
            "${Utils.getBathroomsText('${data.bathrooms}')} ${StringHelper.baths}",
            Icons.bathtub));
      }
      if (data?.area != null && data!.area != 0) {
        specs.add(_buildSpecChip(
            context, "${data.area} ${StringHelper.sqft}", Icons.square_foot));
      }
    }

    if (specs.isEmpty) {
      return const SizedBox.shrink();
    }

    // For grid layout, show only the first 2 specs to save space
    final visibleSpecs = specs.take(2).toList();

    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: visibleSpecs,
    );
  }

  Widget _buildSpecChip(BuildContext context, String specValue, IconData icon) {
    String svgPath;

    if (icon == Icons.event) {
      svgPath = 'assets/icons/calendar.svg';
    } else if (icon == Icons.speed) {
      svgPath = 'assets/icons/speedometer.svg';
    } else if (icon == Icons.local_gas_station) {
      svgPath = 'assets/icons/fuel.svg';
    } else if (icon == Icons.king_bed) {
      svgPath = 'assets/icons/bed.svg';
    } else if (icon == Icons.bathtub) {
      svgPath = 'assets/icons/bathtub.svg';
    } else if (icon == Icons.square_foot) {
      svgPath = 'assets/icons/area.svg';
    } else {
      svgPath = 'assets/icons/default.svg';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade700,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            specValue,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  String getLocalizedLocationFromCoordinates(
      BuildContext context, double? lat, double? lng) {
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      return _isCurrentLanguageArabic(context) ? "كل مصر" : "All Egypt";
    }

    bool isArabic = _isCurrentLanguageArabic(context);
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

  bool _isCurrentLanguageArabic(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String getLocalizedLocation(BuildContext context, ProductDetailModel? data) {
    bool isArabic = _isCurrentLanguageArabic(context);

    if (data == null) {
      return isArabic ? "مصر" : "Egypt";
    }

    if (data.city != null && data.city!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(data.city!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;
        String districtName = "";
        String neighborhoodName = "";

        if (data.districtName != null && data.districtName!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, data.districtName!);
          if (districtModel != null) {
            districtName =
                isArabic ? districtModel.arabicName : districtModel.name;

            if (data.neighborhoodName != null &&
                data.neighborhoodName!.isNotEmpty) {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, data.neighborhoodName!);
              if (neighborhoodModel != null) {
                neighborhoodName = isArabic
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

    if (data.latitude != null && data.longitude != null) {
      double? lat = double.tryParse(data.latitude!);
      double? lng = double.tryParse(data.longitude!);

      if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
        return getLocalizedLocationFromCoordinates(context, lat, lng);
      }
    }

    if (data.nearby != null && data.nearby!.isNotEmpty) {
      return data.nearby!;
    }

    return isArabic ? "مصر" : "Egypt";
  }
}
