import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:google_places_autocomplete_text_field/model/prediction.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
import 'package:list_and_life/base/base.dart';
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
import '../../../skeletons/home_category_skelton.dart';
import '../../../widgets/app_empty_widget.dart';
import '../../../widgets/app_product_item_widget.dart';
import '../../../widgets/image_view.dart';

class HomeView extends BaseView<HomeVM> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, HomeVM viewModel) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringHelper.location,
              style: context.textTheme.titleMedium,
            ),
            const Gap(01),
            GestureDetector(
              onTap: (){
                showLocationSheet(context,viewModel);
              },
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      viewModel.currentLocation,
                      style: context.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () async {
              /*await NotificationService.sendNotification(
                  title: "Test Notification", body: "Test Body");
              return;*/
              if (DbHelper.getIsGuest()) {
                context.push(Routes.guestLogin);
              } else {
                context.push(Routes.notifications).then((value){
                  viewModel.getChatNotifyCount();
                });
              }

              /*     await NotificationService.sendNotification(
                  title: "Test Notification", body: "Test Body");*/
            },
            child: Container(
                padding: const EdgeInsets.all(05),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Visibility(
                      visible: viewModel.countMessage != 0,
                      child: Badge(
                        child: Text("${viewModel.countMessage}",style: TextStyle(fontSize: 8,color: Colors.white),),
                      ),
                    ),
                    Image.asset(
                      AssetsRes.IC_BELL_ICON,
                      scale: 1.3,
                    ),
                  ],
                )),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              children: [
                Expanded(
                    child: AppTextField(
                  hint: '${StringHelper.search}...',
                  readOnly: true,
                  validator: (value) {},
                  controller: viewModel.searchController,
                  onTap: () async {
                    String? value = await getSearchedData(context,
                        query: viewModel.searchController.text);
                    viewModel.searchController.text = value ?? '';
                    viewModel.onSearchChanged(value ?? '');
                    // Perform the search or navigate to the results page
                  },
                  prefix: Icon(Icons.search),
                )),

                /* Expanded(
                  child: AppAutoCompleteTextField<String>(
                    onChanged: (search) => viewModel.onSearchChanged(search),
                    suggestions: viewModel.searchQueryesList
                        .map(
                          (e) => SearchFieldListItem<String>(
                            e ?? '',
                            item: e,
                            // Use child to show Custom Widgets in the suggestions
                            // defaults to Text widget
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e ?? ''),
                            ),
                          ),
                        )
                        .toList(),
                    controller: viewModel.categoryTextController,
                    onSuggestionSelected: (suggestion) {
                      viewModel.searchController.text = suggestion.searchKey;
                      DbHelper.saveSearchQuery(
                          suggestion.searchKey); // Save the selected search
                      viewModel.onSearchChanged(suggestion.searchKey);
                      // Perform the search or navigate to the results page
                    },
                    suggestionToString: (String category) => category,
                  ),
                ),*/
                const Gap(10),
                InkWell(
                  onTap: () {
                    context.push(Routes.filter,extra: FilterModel(screenFrom: "home"));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xffd5d5d5),
                        borderRadius: BorderRadius.circular(8)),
                    child: Image.asset(
                      AssetsRes.IC_FILTER_ICON,
                      height: 24,
                    ),
                  ),
                ),
                const Gap(10),
              ],
            ),
          ),
        ),
      ),
      body: SmartRefresher(
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
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              FutureBuilder<List<CategoryModel>>(
                  future: viewModel.cachedCategoryList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CategoryModel> categoryItems = snapshot.data ?? [];
                      return SizedBox(
                        height: 90,
                        width: context.width,
                        child: ListView.builder(
                            itemCount: categoryItems.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 80,
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(Routes.subCategoryView,
                                        extra: categoryItems[index]);
                                    /*context.push(Routes.filterDetails,
                                        extra: FilterModel(
                                          categoryId:
                                              "${categoryItems[index].id}",
                                          latitude: "${viewModel.latitude}",
                                          longitude: "${viewModel.longitude}",
                                        ));*/
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        radius: 30,
                                        child: ImageView.rect(
                                          image:
                                              "${ApiConstants.imageUrl}/${categoryItems[index].image}",
                                          height: 35,
                                          placeholder:
                                              AssetsRes.IC_IMAGE_PLACEHOLDER,
                                          width: 35,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const Gap(10),
                                      Text(
                                        // DbHelper.getLanguage() == 'en'
                                        //     ? categoryItems[index].name ?? ''
                                        //     : categoryItems[index].nameAr ?? '',
                                        categoryItems[index].name ?? '',
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
                            }),
                      );
                    }
                    if (snapshot.hasError) {
                      return const HomeCategorySkelton(
                        isLoading: true,
                      );
                    }
                    return HomeCategorySkelton(
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  }),
              const Gap(20),
              Text(
                StringHelper.freshRecommendations,
                style: context.textTheme.titleMedium,
              ),
              const Gap(20),
              if (viewModel.isLoading) ...{
                ProductListSkeleton(isLoading: viewModel.isLoading)
              } else ...{
                viewModel.productsList.isEmpty
                    ? const AppEmptyWidget()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.productsList.length,
                        itemBuilder: (context, index) {
                          var productDetails = viewModel.productsList[index];
                          return AppProductItemWidget(
                            data: productDetails,
                            onItemTapped: (){
                              if (productDetails.userId ==
                                  DbHelper.getUserModel()?.id) {
                                context.push(Routes.myProduct,
                                    extra: productDetails);
                              }else{
                                context.push(Routes.productDetails,
                                    extra: productDetails);
                              }
                            },
                            onLikeTapped: () {
                              if(!DbHelper.getIsGuest()){
                                if (productDetails.isFavourite == 1) {
                                  productDetails.isFavourite = 0;
                                  return;
                                }
                                productDetails.isFavourite = 1;
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Gap(20);
                        },
                      )
              },
              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }

  Future<String>? getSearchedData(BuildContext context, {String? query}) async {
    var value = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AppSearchView(
                  value: query,
                )));

    if (value != null) {
      return value.name ?? '';
    }

    return '';
  }

  void showLocationSheet(BuildContext context, HomeVM viewModel) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LocationSearchPopup(
          viewModel: viewModel,
        );
      },
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
    // TODO: implement initState
    lat = widget.viewModel.latitude;
    lng = widget.viewModel.longitude;
    super.initState();
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
                  //showError: false,
                  keyboardType: TextInputType.text,
                    textEditingController: searchController,
                    countries: const ['eg'],
                    googleAPIKey: "AIzaSyBDLT4xDcywIynEnoHJn6GdPisZLr4G5TU",
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black,width: 1)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black,width: 1)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.black,width: 1)
                      ),
                      prefixIcon: Icon(Icons.search),
                      hintText: StringHelper.search,
                    ),
                    debounceTime: 400,
                    // default 600 ms,

                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) async {
                      Navigator.pop(context);

                      searchController.text =
                          prediction.description ?? 'Cario, Egypt';
                      DbHelper.saveLocationSearchQuery(
                          "${prediction.description}");
                      widget.viewModel.updateLatLong(
                        type: "search",
                          address: prediction.description ?? 'Cario, Egypt',
                          lat: double.parse(prediction.lat ?? '$lat'),
                          long: double.parse(prediction.lng ?? '$lng'));
                    },
                    itmClick: (Prediction prediction) async {}),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.viewModel.locationTextController.text ="Cairo, Egypt";
                  //StringHelper.showAllAdsInEgypt;
                  widget.viewModel.updateLatLong(address: "Cairo, Egypt");
                      // lat: 30.0444,
                      // long: 31.2357);
                },
                child: Text(
                  '📍${StringHelper.showAllAdsInEgypt}',
                  style: context.titleMedium?.copyWith(color: Colors.blue),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  DbHelper.deleteData("userLocation");
                  widget.viewModel.updateLocation();
                },
                child: Text(
                  '📍${StringHelper.useCurrentLocation}',
                  style: context.titleMedium?.copyWith(color: Colors.blue),
                )),

            const SizedBox(height: 10),
            Text('${StringHelper.recentSearches}:', style: context.textTheme.titleMedium),
            const Divider(),
            // Add other search-related features here
            Expanded(
              child: searchHistory.isEmpty
                  ? const AppEmptyWidget()
                  : ListView(
                      shrinkWrap: true,
                      children: List.generate(
                        searchHistory.length,
                        (index) => ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(searchHistory[index]),
                          onTap: () async {
                            Navigator.pop(context);
                            // Handle location selection
                            searchController.text = searchHistory[index];

                            Position? position =
                                await LocationHelper.getCoordinatesFromAddress(
                                    searchController.text);
                            widget.viewModel.locationTextController.text =
                                searchHistory[index];
                            widget.viewModel.updateLatLong(
                              type: "history",
                                address: searchHistory[index],
                                lat: position?.latitude ?? lat,
                                long: position?.longitude ?? lng);
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
