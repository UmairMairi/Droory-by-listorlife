import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import "package:list_and_life/widgets/enhanced_location_screen.dart";
import 'package:provider/provider.dart';

import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/skeletons/product_list_skeleton.dart';
import 'package:list_and_life/view_model/home_vm.dart';
import 'package:list_and_life/widgets/app_search_view.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../base/helpers/db_helper.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../base/network/api_constants.dart';
import '../../../models/category_model.dart';
import '../../../models/filter_model.dart';
import '../../../res/font_res.dart';
import '../../../skeletons/home_category_skelton.dart';
import '../../../widgets/app_empty_widget.dart';
import '../../../widgets/app_product_item_widget.dart';
import '../../../widgets/image_view.dart';
import '../../../widgets/scroll_to_top_fab.dart';

class HomeView extends BaseView<HomeVM> {
  const HomeView({super.key});

  bool _isCurrentLanguageArabic(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String _getLocalizedNotificationCount(num count, BuildContext context) {
    bool isArabic = _isCurrentLanguageArabic(context);

    if (count > 9) {
      return isArabic ? '٩+' : '9+';
    }

    if (isArabic) {
      // Convert to Arabic numerals
      const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      return arabicNumbers[count.toInt()];
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context, HomeVM viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom header section with location and notification (STICKY)
          Container(
            padding:
                const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                // Location section
                Expanded(
                  child: GestureDetector(
                    onTap: () => showLocationSheet(context, viewModel),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.orange.shade600,
                            size: 20,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringHelper.location,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              const Gap(2),
                              Consumer<HomeVM>(
                                builder: (context, vm, child) {
                                  return Row(
                                    children: [
                                      Flexible(
                                        // Changed from Expanded to Flexible
                                        child: Text(
                                          vm.getLocalizedLocationName(),
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Add ellipsis
                                          maxLines: 1, // Ensure single line
                                        ),
                                      ),
                                      const Gap(4),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black87,
                                        size: 24,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(12), // Add some spa
                // Notification button
                InkWell(
                  onTap: () async {
                    if (DbHelper.getIsGuest()) {
                      context.push(Routes.guestLogin);
                    } else {
                      context.push(Routes.notifications).then((_) {
                        viewModel.getChatNotifyCount();
                      });
                    }
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Visibility(
                        visible: viewModel.countMessage != 0,
                        child: Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              _getLocalizedNotificationCount(
                                  viewModel.countMessage, context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search and Filter section (STICKY)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Search field
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppTextField(
                      hint: '${StringHelper.search}...',
                      readOnly: true,
                      removeTextFieldBorder: true,
                      controller: viewModel.searchController,
                      onTap: () async {
                        String? value = await getSearchedData(
                          context,
                          query: viewModel.searchController.text,
                        );
                        viewModel.searchController.text = value ?? '';
                        viewModel.onSearchChanged(value ?? '');
                      },
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.search, color: Colors.grey, size: 20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                const Gap(12),
                // Filter button
                Consumer<HomeVM>(
                  builder: (context, vm, child) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: vm.isNavigatingToFilter
                            ? Colors.grey.shade300
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: vm.isNavigatingToFilter
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54),
                                ),
                              )
                            : Icon(
                                Icons.tune,
                                color: Colors.black87,
                                size: 20,
                              ),
                        onPressed: () async {
                          // Disable the button temporarily
                          if (viewModel.isNavigatingToFilter) return;

                          viewModel.isNavigatingToFilter = true;

                          try {
                            await viewModel.navigateToFilter(context);
                          } finally {
                            // Re-enable after a short delay
                            Future.delayed(Duration(milliseconds: 500), () {
                              viewModel.isNavigatingToFilter = false;
                            });
                          }
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          const Gap(15),

          // Scrollable content area
          Expanded(
            child: SmartRefresher(
              controller: viewModel.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              scrollController: viewModel.scrollController,
              header: WaterDropHeader(
                complete: Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(),
              ),
              onRefresh: viewModel.onRefresh,
              onLoading: viewModel.onLoading,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(5),
                    FutureBuilder<List<CategoryModel>>(
                      future: viewModel.cachedCategoryList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final categoryItems = snapshot.data!;
                          return SizedBox(
                            height: 90,
                            width: context.width,
                            child: ListView.builder(
                              itemCount: categoryItems.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final cat = categoryItems[index];
                                return SizedBox(
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      Routes.subCategoryView,
                                      extra: cat,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white70,
                                            radius: 30,
                                            child: ImageView.rect(
                                              image:
                                                  "${ApiConstants.imageUrl}/${cat.image}",
                                              height: 35,
                                              placeholder: AssetsRes
                                                  .IC_IMAGE_PLACEHOLDER,
                                              width: 35,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Text(
                                          cat.name ?? '',
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const HomeCategorySkelton(isLoading: true);
                        }
                        return HomeCategorySkelton(
                          isLoading: snapshot.connectionState ==
                              ConnectionState.waiting,
                        );
                      },
                    ),
                    const Gap(15),
                    Text(
                      StringHelper.freshRecommendations,
                      style: context.textTheme.titleMedium,
                    ),
                    if (viewModel.isLoading) ...{
                      ProductListSkeleton(isLoading: viewModel.isLoading)
                    } else ...{
                      viewModel.productsList.isEmpty
                          ? const AppEmptyWidget()
                          : Transform.translate(
                              offset: const Offset(0, -20),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.productsList.length,
                                itemBuilder: (context, index) {
                                  final product = viewModel.productsList[index];
                                  return AppProductItemWidget(
                                    data: product,
                                    isLastItem: index ==
                                        viewModel.productsList.length -
                                            1, // Add this
                                    totalItems: viewModel.productsList.length,
                                    onItemTapped: () {
                                      if (product.userId ==
                                          DbHelper.getUserModel()?.id) {
                                        context.push(Routes.myProduct,
                                            extra: product);
                                      } else {
                                        context.push(Routes.productDetails,
                                            extra: product);
                                      }
                                    },
                                    onLikeTapped: () {
                                      if (!DbHelper.getIsGuest()) {
                                        product.isFavourite =
                                            product.isFavourite == 1 ? 0 : 1;
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (_, __) => const Gap(20),
                              ),
                            ),
                    },
                    const Gap(40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ScrollToTopFAB(
        controller: viewModel.scrollController,
        threshold: 50 * 100.0,
      ),
    );
  }

  Future<String>? getSearchedData(BuildContext context, {String? query}) async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppSearchView(value: query),
      ),
    );
    return value?.name ?? '';
  }

  void showLocationSheet(BuildContext context, HomeVM viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EnhancedLocationSelectionScreen(viewModel: viewModel),
      ),
    );
  }
}

// Create a widget for the location search popup
class LocationSearchPopup extends StatefulWidget {
  final HomeVM viewModel;
  const LocationSearchPopup({super.key, required this.viewModel});

  @override
  State<LocationSearchPopup> createState() => _LocationSearchPopupState();
}

class _LocationSearchPopupState extends State<LocationSearchPopup> {
  TextEditingController searchController = TextEditingController();
  List<String> searchHistory = DbHelper.getLocationSearchHistory();
  double lat = 30.0444, lng = 31.2357;

  @override
  void initState() {
    super.initState();
    lat = widget.viewModel.latitude;
    lng = widget.viewModel.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            SafeArea(
              child: Container(
                alignment: Alignment.center,
                height: 55,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: GooglePlacesAutoCompleteTextFormField(
                  keyboardType: TextInputType.text,
                  textEditingController: searchController,
                  countries: const ['eg'],
                  googleAPIKey: "AIzaSyBDLT4xDcywIynEnoHJn6GdPisZLr4G5TU",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    hintText: StringHelper.search,
                  ),
                  debounceTime: 400,
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) async {
                    Navigator.pop(context);
                    final formattedAddress = _formatAddress(Placemark(
                      name: prediction.structuredFormatting?.mainText,
                      locality: (prediction.terms?.length ?? 0) > 1
                          ? (prediction.terms?[1].value ?? '')
                          : '',
                      administrativeArea: (prediction.terms?.length ?? 0) > 2
                          ? (prediction.terms?[2].value ?? '')
                          : '',
                      country: (prediction.terms?.length ?? 0) > 3
                          ? (prediction.terms?.last.value ?? '')
                          : '',
                    ));
                    searchController.text = formattedAddress;
                    DbHelper.saveLocationSearchQuery(formattedAddress);
                    widget.viewModel.updateLatLong(
                      type: "search",
                      address: formattedAddress,
                      lat: double.parse(prediction.lat ?? '$lat'),
                      long: double.parse(prediction.lng ?? '$lng'),
                    );
                  },
                  itmClick: (Prediction prediction) async {},
                ),
              ),
            ),

            // All Egypt option
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.viewModel.updateLatLong(address: "All Egypt");
              },
              child: Text(
                '📍${StringHelper.showAllAdsInEgypt}',
                style: context.titleMedium?.copyWith(color: Colors.blue),
              ),
            ),

            // Use Current Location option
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                DbHelper.deleteData("userLocation");
                widget.viewModel.updateLocation();
              },
              child: Text(
                '📍${StringHelper.useCurrentLocation}',
                style: context.titleMedium?.copyWith(color: Colors.blue),
              ),
            ),

            // Horizontal scrollable major cities list
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Major Cities:',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: LocationService.majorEgyptianCities.length,
                      itemBuilder: (context, index) {
                        final city = LocationService.majorEgyptianCities[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            avatar: const Icon(Icons.location_city,
                                size: 16, color: Colors.blue),
                            label: Text(city.name),
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            onPressed: () {
                              Navigator.pop(context);
                              widget.viewModel.locationTextController.text =
                                  city.name;
                              widget.viewModel.updateLatLong(
                                type: "city",
                                address: city.name,
                                lat: city.latitude,
                                long: city.longitude,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Recent searches section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${StringHelper.recentSearches}:',
                    style: context.textTheme.titleMedium),
                if (searchHistory.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchHistory = [];
                        widget.viewModel.clearLocation();
                      });
                    },
                    child: Text(StringHelper.clearAll,
                        style: context.textTheme.titleSmall),
                  ),
              ],
            ),

            const Divider(),

            // Recent searches list
            Expanded(
              child: searchHistory.isEmpty
                  ? const AppEmptyWidget()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(searchHistory[index]),
                          onTap: () async {
                            Navigator.pop(context);
                            final pos =
                                await LocationHelper.getCoordinatesFromAddress(
                                    searchHistory[index]);
                            widget.viewModel.locationTextController.text =
                                searchHistory[index];
                            widget.viewModel.updateLatLong(
                              type: "history",
                              address: searchHistory[index],
                              lat: pos?.latitude ?? lat,
                              long: pos?.longitude ?? lng,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatAddress(Placemark place) {
    final buffer = StringBuffer();
    if ((place.name ?? "").isNotEmpty) buffer.write('${place.name}, ');
    if ((place.locality ?? "").isNotEmpty) buffer.write('${place.locality}, ');
    if ((place.administrativeArea ?? "").isNotEmpty)
      buffer.write('${place.administrativeArea}, ');
    if ((place.country ?? "").isNotEmpty) buffer.write('${place.country}');
    return buffer.toString().replaceAll(RegExp(r',\s*$'), '');
  }
}
