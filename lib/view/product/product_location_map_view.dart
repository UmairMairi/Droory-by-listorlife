import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:list_and_life/models/product_detail_model.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/utils/utils.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/models/city_model.dart';

class ProductLocationMapView extends StatefulWidget {
  final ProductDetailModel productData;

  const ProductLocationMapView({super.key, required this.productData});

  @override
  State<ProductLocationMapView> createState() => _ProductLocationMapViewState();
}

class _ProductLocationMapViewState extends State<ProductLocationMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? _googleMapController;

  // Default to Cairo if no coordinates
  static const double defaultLat = 30.0444;
  static const double defaultLng = 31.2357;

  late double latitude;
  late double longitude;
  late Set<Marker> markers;

  @override
  void initState() {
    super.initState();
    // Parse coordinates from product data
    latitude = double.tryParse(widget.productData.latitude ?? '') ?? defaultLat;
    longitude =
        double.tryParse(widget.productData.longitude ?? '') ?? defaultLng;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize marker here where context is available
    _initializeMarkers();
  }

  void _initializeMarkers() {
    // Create marker for the product location with localized snippet
    markers = {
      Marker(
        markerId: const MarkerId('product_location'),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: widget.productData.name ?? 'Product Location',
          snippet: _getLocationSnippet(),
        ),
      ),
    };
  }

  String _getLocationSnippet() {
    // Use the same localized location logic as in product detail view
    return _getLocalizedLocation(widget.productData);
  }

  // Copy the same location helper methods from product detail view
  bool _isCurrentLanguageArabic() {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String _getLocalizedLocationFromCoordinates(double? lat, double? lng) {
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      return _isCurrentLanguageArabic() ? "كل مصر" : "All Egypt";
    }

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

  String _getLocalizedLocation(ProductDetailModel? data) {
    bool isArabic = _isCurrentLanguageArabic();

    if (data == null) {
      return isArabic ? "مصر" : "Egypt";
    }

    // Priority 1: Use stored English names
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

    // Priority 2: Coordinates
    if (data.latitude != null && data.longitude != null) {
      double? lat = double.tryParse(data.latitude!);
      double? lng = double.tryParse(data.longitude!);

      if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
        return _getLocalizedLocationFromCoordinates(lat, lng);
      }
    }

    // Priority 3: Nearby
    if (data.nearby != null && data.nearby!.isNotEmpty) {
      return data.nearby!;
    }

    return isArabic ? "مصر" : "Egypt";
  }

  String _getPriceDisplay() {
    // For job category (categoryId == 9), show salary range
    if (widget.productData.categoryId == 9) {
      String fromAmount = _parseAmount(widget.productData.salleryFrom);
      String toAmount = _parseAmount(widget.productData.salleryTo);

      if (fromAmount != "0" || toAmount != "0") {
        return "${StringHelper.egp} $fromAmount - ${StringHelper.egp} $toAmount";
      }
      return "";
    } else {
      // For other categories, show regular price
      String price = _parseAmount(widget.productData.price);
      if (price != "0") {
        return "${StringHelper.egp} $price";
      }
      return "";
    }
  }

  String _parseAmount(dynamic amount) {
    if ("${amount ?? ""}".isEmpty) return "0";
    return Utils.formatPrice(num.parse("${amount ?? 0}").toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    final priceDisplay = _getPriceDisplay();

    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.location),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15.0,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled:
                true, // This enables the Google Maps toolbar with directions
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _googleMapController = controller;
            },
          ),
          // Location info card at the bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productData.name ?? '',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getLocationSnippet(),
                            style: context.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (priceDisplay.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        priceDisplay,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
