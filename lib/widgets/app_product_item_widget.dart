import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/date_helper.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/res/font_res.dart';
import 'package:list_and_life/widgets/card_swipe_widget.dart';
import 'package:list_and_life/widgets/communication_buttons.dart';
import 'package:list_and_life/widgets/like_button.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/models/city_model.dart';
import '../base/helpers/db_helper.dart';
import '../base/helpers/string_helper.dart';
import '../base/utils/utils.dart';
import '../models/common/map_response.dart';
import '../base/network/api_constants.dart';
import '../base/network/api_request.dart';
import '../base/network/base_client.dart';

class AppProductItemWidget extends StatelessWidget {
  final ProductDetailModel? data;
  final Function()? onLikeTapped;
  final Function() onItemTapped;
  final bool showImage;
  final String screenType;
  final bool isLastItem; // Add this parameter
  final int totalItems; // Add this parameter

  const AppProductItemWidget({
    super.key,
    this.data,
    this.onLikeTapped,
    required this.onItemTapped,
    this.showImage = true,
    this.screenType = "home",
    this.isLastItem = false, // Default to false
    this.totalItems = 0, // Default to 0
  });

  @override
  Widget build(BuildContext context) {
    // Special handling for job listings without images in FilterItemView (original simple design)
    if (!showImage && data?.categoryId == 9 && screenType == "filter") {
      return _buildOriginalJobCard(context);
    }

    // All other cases use modern card design (including jobs in HomeView)
    return _buildModernCard(context);
  }

  // Modern card design for all products (Home + Filter) - Full width with thick borders like reference
  Widget _buildModernCard(BuildContext context) {
    // Special handling for job listings without images in HomeView
    if (!showImage && data?.categoryId == 9) {
      return _buildJobCard(context);
    }

    return InkWell(
      onTap: onItemTapped,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showImage)
                  Stack(
                    children: [
                      CardSwipeWidget(
                        onItemTapped: onItemTapped,
                        screenType: "home",
                        data: data,
                        imagesList: data?.productMedias,
                        height: 250,
                        borderRadius: BorderRadius.zero,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data?.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Price for non-job products
                          if (data?.categoryId != 9 &&
                              _getNumericPrice(data?.price) > 0)
                            Text(
                              "${StringHelper.egp} ${Utils.formatPrice(_getNumericPrice(data?.price).toString())}",
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          // Salary for jobs
                          if (data?.categoryId == 9)
                            Text(
                              getSalaryDisplayText(data),
                              style: context.textTheme.titleMedium?.copyWith(
                                  color: context.theme.colorScheme.error),
                            ),
                        ],
                      ),
                      const Gap(6),
                      Text(
                        data?.description ?? '',
                        maxLines: 1,
                        style: context.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(8),
                      getSpecifications(context: context, data: data),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const Gap(4),
                                Expanded(
                                  child: Text(
                                    getLocalizedLocation(context, data),
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        context.textTheme.labelMedium?.copyWith(
                                      fontFamily: FontRes.MONTSERRAT_REGULAR,
                                      color: Colors.grey.shade600,
                                      fontSize:
                                          _isCurrentLanguageArabic(context)
                                              ? 16
                                              : 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            getCreatedAt(
                                time: data?.createdAt, context: context),
                            style: context.textTheme.labelMedium?.copyWith(
                              fontFamily: FontRes.MONTSERRAT_REGULAR,
                              color: Colors.grey.shade600,
                              fontSize:
                                  _isCurrentLanguageArabic(context) ? 14 : 13,
                            ),
                          )
                        ],
                      ),
                      const Gap(8),
                      if (data?.userId != DbHelper.getUserModel()?.id)
                        CommunicationButtons2(
                          data: data,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Full width border separator - only show if not last item OR if there's more than one item
          if (!isLastItem && totalItems > 1)
            Container(
              height: 8,
              color: Colors.grey.shade200,
            ),
        ],
      ),
    );
  }

  // Modern job card design for HomeView with darker specs
  Widget _buildJobCard(BuildContext context) {
    final bool isArabic = _isCurrentLanguageArabic(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: InkWell(
        onTap: onItemTapped,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Job Title
              Text(
                data?.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isArabic ? 19 : 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),

              const Gap(8),

              // Salary with icon - Red color
              if (getSalaryDisplayText(data).isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      size: 20,
                      color: Colors.black87,
                    ),
                    const Gap(4),
                    Text(
                      getSalaryDisplayText(data),
                      style: TextStyle(
                        fontSize: isArabic ? 17 : 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
              ],

              // Job specifications - using same method as other categories for dark styling
              getSpecifications(context: context, data: data),

              const Gap(8),

              // Location and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            getLocalizedLocation(context, data),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isArabic ? 16 : 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Time Posted
                  Text(
                    getCreatedAt(time: data?.createdAt, context: context)
                        .replaceAll('|', '')
                        .trim(),
                    style: TextStyle(
                      fontSize: isArabic ? 16 : 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Communication buttons if needed
              if (data?.userId != DbHelper.getUserModel()?.id) ...[
                const Gap(8),
                CommunicationButtons2(
                  data: data,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Original job card design for FilterItemView (exactly as it was)
  Widget _buildOriginalJobCard(BuildContext context) {
    final bool isArabic = _isCurrentLanguageArabic(context);

    return Column(
      children: [
        InkWell(
          onTap: onItemTapped,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Job Title
                  Text(
                    data?.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isArabic ? 19 : 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),

                  const Gap(12),

                  // Salary with icon - Red color
                  if (getSalaryDisplayText(data).isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          size: 20,
                          color: Colors.grey.shade700,
                        ),
                        const Gap(4),
                        Text(
                          getSalaryDisplayText(data),
                          style: TextStyle(
                            fontSize: isArabic ? 17 : 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                  ],

                  // Job specifications with icons (original style)
                  Wrap(
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      // Experience
                      if (data?.workExperience != null &&
                          data!.workExperience!.isNotEmpty)
                        _buildOriginalJobSpec(
                          Icons.school_outlined,
                          Utils.getWorkExperience(data?.workExperience),
                          isArabic,
                        ),

                      // Education/Specialty (from brand field)
                      if (data?.brand != null &&
                          (data?.brand?.name ?? "").isNotEmpty)
                        _buildOriginalJobSpec(
                          Icons.work_outline,
                          data!.brand!.name!,
                          isArabic,
                        ),

                      // Position Type
                      if ((data?.positionType ?? "").isNotEmpty)
                        _buildOriginalJobSpec(
                          Icons.schedule,
                          Utils.getCommon(
                              Utils.transformToSnakeCase(data?.positionType)),
                          isArabic,
                        ),
                    ],
                  ),

                  const Gap(12),

                  // Location and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.grey.shade700,
                            ),
                            const Gap(4),
                            Expanded(
                              child: Text(
                                getLocalizedLocation(context, data),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: isArabic ? 16 : 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Time Posted
                      Text(
                        getCreatedAt(time: data?.createdAt, context: context)
                            .replaceAll('|', '')
                            .trim(),
                        style: TextStyle(
                          fontSize: isArabic ? 16 : 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // Communication buttons if needed
                  if (data?.userId != DbHelper.getUserModel()?.id) ...[
                    const Gap(12),
                    CommunicationButtons2(
                      data: data,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Thick border separator like modern cards - only show if not last item OR if there's more than one item
        if (!isLastItem && totalItems > 1)
          Container(
            height: 8,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }

  // Helper method for original job specs (FilterItemView)
  Widget _buildOriginalJobSpec(IconData icon, String text, bool isArabic) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),
        const Gap(4),
        Text(
          text,
          style: TextStyle(
            fontSize: isArabic ? 15 : 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
          ),
        ),
      ],
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

  // Helper method to safely get numeric price
  double _getNumericPrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return double.tryParse(price.toString()) ?? 0.0;
  }

  String getCreatedAt({String? time, BuildContext? context}) {
    if (time == null || time.isEmpty) {
      return "";
    }

    try {
      DateTime dateTime = DateTime.parse(time);
      int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
      String relativeTime = DateHelper.getTimeAgo(timestamp);
      return "| $relativeTime";
    } catch (e) {
      String dateTimeString = "2024-06-25T01:01:47.000Z";
      DateTime dateTime = DateTime.parse(dateTimeString);
      int timestamp = dateTime.millisecondsSinceEpoch ~/ 1000;
      return "| ${DateHelper.getFormateDDMMMYYYY(timestamp)}";
    }
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
      if (data?.year != null && data!.year != 0) {
        specs.add(_buildSpecRow(context, "${data.year}", Icons.event));
      }
      if (data?.kmDriven != null) {
        specs.add(
          _buildSpecRow(context, '${data?.kmDriven}', Icons.speed),
        );
      }
      if (data?.fuel != null && data!.fuel!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context, Utils.getFuel('${data.fuel}'), Icons.local_gas_station));
      }
    }

    if (data?.categoryId == 11) {
      if (data?.bedrooms != null && data!.bedrooms != 0) {
        final bedroomsText = Utils.getBedroomsText('${data.bedrooms}');
        final isStudio = bedroomsText == "Studio" || bedroomsText == "استوديو";
        specs.add(_buildSpecRow(
            context,
            isStudio ? bedroomsText : "$bedroomsText ${StringHelper.beds}",
            Icons.king_bed));
      }
      if (data?.bathrooms != null && data!.bathrooms != 0) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getBathroomsText('${data.bathrooms}')} ${StringHelper.baths}",
            Icons.bathtub));
      }
      if (data?.area != null && data!.area != 0) {
        specs.add(_buildSpecRow(
            context, "${data.area} ${StringHelper.sqft}", Icons.square_foot));
      }
    }

    if (data?.categoryId == 9) {
      // Experience with school icon (swapped)
      if (data?.workExperience != null && data!.workExperience!.isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            Utils.getWorkExperience(data?.workExperience),
            Icons.school_outlined));
      }
      // Position Type with schedule icon
      if ((data?.positionType ?? "").isNotEmpty) {
        specs.add(_buildSpecRow(
            context,
            "${Utils.getCommon(Utils.transformToSnakeCase(data?.positionType))}",
            Icons.schedule));
      }
    }

    if (specs.isNotEmpty) {
      return Wrap(
        spacing: 12,
        runSpacing: 8,
        children: specs,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSpecRow(BuildContext context, String specValue, IconData icon) {
    // For job-related icons, use the Material icons directly
    if (icon == Icons.school_outlined ||
        icon == Icons.work_outline ||
        icon == Icons.schedule) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.black87,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              specValue,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      );
    }

    // For other icons, use SVG mapping as before
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
    } else if (icon == Icons.work) {
      svgPath = 'assets/icons/position.svg';
    } else if (icon == Icons.work_history) {
      svgPath = 'assets/icons/experience.svg';
    } else if (icon == Icons.category) {
      svgPath = 'assets/icons/specialty.svg';
    } else {
      svgPath = 'assets/icons/default.svg';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(
            Colors.black87,
            BlendMode.srcIn,
          ),
          placeholderBuilder: (context) => Icon(
            icon,
            size: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            specValue,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
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
