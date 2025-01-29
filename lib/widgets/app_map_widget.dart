import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/location_helper.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:map_picker/map_picker.dart';

import '../../res/assets_res.dart';
import '../base/helpers/dialog_helper.dart';

class AppMapWidget extends StatefulWidget {
  const AppMapWidget({super.key});

  @override
  State<AppMapWidget> createState() => _AppMapWidgetState();
}

class _AppMapWidgetState extends State<AppMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746);

  TextEditingController searchController = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  MapPickerController mapPickerController = MapPickerController();

  LatLng? latlng;
  CameraPosition? _cameraPosition;
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    _getLastKnownLocation();
    _getCurrentLocation();
    super.initState();
  }

  bool isMapDrag = false;

  Set<Marker> markers = {};

  double? latitude, longitude;

  Position? _currentPosition;

  String _currentAddress = '',
      lat = '',
      lng = '',
      city = '',
      placeName = '',
      state = '',
      postalCode = '',
      country = '';

  Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.error('Location services are disabled.');
      return false;
    }
    return true;
  }

  void _getLastKnownLocation() async {
    searchController.text = "Determine current location...";
    if (await hasLocationPermission() == false) {
      return null;
    }
    Position? position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      return;
    }
    _animateCameraAndFindAddress(position);
  }

  void _getCurrentLocation() async {
    searchController.text = "Determine current location...";

    if (await hasLocationPermission() == false) {
      return null;
    }
    Position position = await LocationHelper.getCurrentLocation();

    bool isEgypt = await LocationHelper.checkLocationIsEgypt(
        latitude: position.latitude, longitude: position.longitude);
    if (isEgypt) {
      _animateCameraAndFindAddress(position);
    } else {
      _animateCameraAndFindAddress(Position(
          longitude: LocationHelper.cairoLongitude,
          latitude: LocationHelper.cairoLatitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0));
    }
  }

  Future<void> _animateCameraAndFindAddress(Position position) async {
    setState(() {
      _currentPosition = position;
      debugPrint('CURRENT POS: $_currentPosition');
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
    });
    await _getAddress(position.latitude, position.longitude);
  }

  Future<void> _getAddress(double latitude, double longitude,
      {isSelectedFromList = false}) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = p[0];
      setState(() {
        if (!isSelectedFromList) {
          searchController.text = "Determine address...";
          lat = _currentPosition!.latitude.toString();
          lng = _currentPosition!.longitude.toString();
        }
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        placeName = place.name!;
        city = place.locality!;
        country = place.country!;

        postalCode = place.postalCode!;
        state = place.administrativeArea!;

        searchController.text = _currentAddress;

        debugPrint(
            " _get address Place-mark ==> ${place..toJson().toString()}");
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Create LatLngBounds for India and Egypt
  final LatLngBounds indiaBounds = LatLngBounds(
    southwest: const LatLng(8.4, 68.7), // Southwestern point of India
    northeast: const LatLng(37.6, 97.25), // Northeastern point of India
  );

  final LatLngBounds egyptBounds = LatLngBounds(
    southwest: const LatLng(22.0, 25.0), // Southwestern point of Egypt
    northeast: const LatLng(31.6, 37.0), // Northeastern point of Egypt
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: Stack(
        children: [
          MapPicker(
            mapPickerController: mapPickerController,
            iconWidget: Image.asset(
              AssetsRes.IC_LOCATION_PIN,
              height: 35,
              width: 35,
              fit: BoxFit.contain,
            ),
            child: GoogleMap(
              markers: Set<Marker>.from(markers),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: _kGooglePlex,
              cameraTargetBounds: CameraTargetBounds(egyptBounds),
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _googleMapController = controller;
                _googleMapController!
                    .moveCamera(CameraUpdate.newLatLngBounds(egyptBounds, 0));
              },
              onCameraMove: (cameraPosition) {
                debugPrint("onCameraMove called");

                if (isMapDrag) {
                  _currentAddress = '';
                  searchController.text = "Determine current location...";
                } else {
                  Future.delayed(const Duration(seconds: 3), () {
                    isMapDrag = true;
                  });
                }

                _cameraPosition = cameraPosition;
              },
              onCameraIdle: () async {
                debugPrint("onCameraIdle called");
                if (isMapDrag) {
                  _currentAddress = '';
                  searchController.text = "Determine address...";

                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving!();
                  List<Placemark> p = await placemarkFromCoordinates(
                    _cameraPosition!.target.latitude,
                    _cameraPosition!.target.longitude,
                  );

                  Placemark place = p[0];

                  setState(() {
                    _currentAddress =
                    "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
                    searchController.text = _currentAddress;
                    placeName = place.name!;
                    city = place.locality!;
                    state = place.administrativeArea!;
                    country = place.country!;
                    lat = _cameraPosition!.target.latitude.toString();
                    lng = _cameraPosition!.target.longitude.toString();

                    debugPrint("------------>$_currentAddress");
                  });
                } else {
                  Future.delayed(const Duration(seconds: 3), () {
                    isMapDrag = true;
                  });
                }
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: GooglePlaceAutoCompleteTextField(
                textEditingController: searchController,
                countries: const ['eg'],
                boxDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black,width: 1)
                ),
                googleAPIKey: "AIzaSyBDLT4xDcywIynEnoHJn6GdPisZLr4G5TU",
                inputDecoration:  InputDecoration(
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                ),
                debounceTime: 400,
                // default 600 ms,
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  isMapDrag = false;
            
                  lat = "${prediction.lat??0.0}";
                  lng = "${prediction.lng??0.0}";

                  log(
                      "getPlaceDetailWithLatLng ${prediction.toJson().toString()} latitude ==>> $lng  longitude ==>> $lat");
                  // _getAddress(double.parse(lat), double.parse(lng),
                  //     isSelectedFromList: true);
                  Map<String, String> locationData = extractLocationData(prediction.toJson());
                   placeName = locationData["location"]??"";
                  city = locationData["city"]??"";
                  state = locationData["state"]??"";
                  country = locationData["country"]??"";
                  _googleMapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(double.parse(prediction.lat!),
                            double.parse(prediction.lng!)),
                        zoom: 18.0,
                      ),
                    ),
                  );
                  setState(() {});
                },
                itemClick: (Prediction prediction) async {
                  isMapDrag = false;
                    searchController.text = prediction.description??"";
                  _currentAddress = searchController.text;
                  searchController.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 0));
                  _googleMapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(double.parse("${prediction.lat??0.0}"),
                            double.parse("${prediction.lng??0.0}")),
                        zoom: 18.0,
                      ),
                    ),
                  );
                  setState(() {});
                  FocusScope.of(context).requestFocus(FocusNode());
                }),
          ),
          Positioned.fill(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      _getCurrentLocation();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.20),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.my_location,
                          color: Colors.black, size: 25),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppElevatedButton(
                    width: context.width,
                    height: 50,
                    title: 'Continue',
                    onTap: () {
                      if (_currentAddress.isEmpty) {
                        DialogHelper.showToast(
                            message: "Please select valid location.");
                        return;
                      }
                      var data = {
                        'latitude': lat,
                        'longitude': lng,
                        'location': placeName,
                        'city': city,
                        'state': state,
                        'country': country
                      };
                      Navigator.pop(context, data);
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Map<String, String> extractLocationData(Map<String, dynamic> data) {
    List terms = data['terms'];

    String placeName = data['structured_formatting']['main_text'];
    String city = terms.length > 1 ? terms[1]['value'] : '';
    String state = terms.length > 2 ? terms[2]['value'] : '';
    String country = terms.isNotEmpty ? terms.last['value'] : '';

    return {
      'location': placeName,
      'city': city,
      'state': state,
      'country': country,
    };
  }
  // Map<String, String> extractLocationData(Map<String, dynamic> data) {
  //   List terms = data['terms'];
  //
  //   String placeName = data['structured_formatting']['main_text'];
  //   String city = terms.isNotEmpty ? terms[0]['value'] : '';
  //   String state = terms.length > 2 ? terms[1]['value'] : ''; // Check if state exists
  //   String country = terms.isNotEmpty ? terms.last['value'] : '';
  //
  //   return {
  //     'location': placeName,
  //     'city': city,
  //     'state': state,
  //     'country': country,
  //   };
  // }


}
