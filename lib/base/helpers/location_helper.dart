import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'dialog_helper.dart';

class LocationHelper {
  static const double cairoLatitude = 31.2341262;
  static const double cairoLongitude = 30.0282809;

  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      DialogHelper.showLocationServiceEnable(
          message: "Daroory would like to access your location",
          onTap: () async {
            await Geolocator.openLocationSettings();
          });
      throw 'Location services are disabled.';
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      DialogHelper.showLocationServiceEnable(
          message: "Daroory would like to access your location",
          onTap: () async {
            await Geolocator.openAppSettings();
          });
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (permission == LocationPermission.deniedForever) {
          DialogHelper.showLocationServiceEnable(
              message: "Daroory would like to access your location",
              onTap: () async {
                await Geolocator.openAppSettings();
              });
          throw 'Location permissions are permanently denied, we cannot request permissions.';
        }
        throw 'Location permissions are denied (actual value: $permission).';
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

    // Validate if the location is within Egypt (latitude: 22.0 - 31.7, longitude: 25.0 - 35.0)
    if (position.latitude < 22.0 ||
        position.latitude > 31.7 ||
        position.longitude < 25.0 ||
        position.longitude > 35.0) {
      // Return null if location is outside Egypt
      return null;
    }

    // Return the position if it's inside Egypt
    return position;
  }


  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placeMarks.first;
      return "${place.name},${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "";
    }
  }

  static Future<bool> checkLocationIsEgypt(
      {required double latitude, required double longitude}) async {
    try {
      String address = await getAddressFromCoordinates(latitude, longitude);
      if (address.contains("Egypt")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return false;
  }

  static Future<void> showPopupIsEgypt(
      BuildContext context, VoidCallback onTap) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Alert"),
          content: const Text(
              "Please note that our app is currently only available for users in Egypt. To get started, please allow us to set your current location to Egypt."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                onTap(); // Call the callback function
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showPopupAddProduct(
      BuildContext context, VoidCallback onTap) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(StringHelper.locationAlert),
          content:  Text(
              StringHelper.locationAlertMsg),
          actions: [
            TextButton(
              child:  Text(StringHelper.ok),
              onPressed: () {
                Navigator.pop(context);
                onTap(); // Call the callback function
              },
            ),
          ],
        );
      },
    );
  }

  // New function: Get latitude and longitude from an address
  static Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return Position(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }

  // New function: Get latitude and longitude from a place ID
  static Future<Position?> getCoordinatesFromPlaceId(String placeId) async {
    try {
      // This functionality would usually involve a Google Places API request
      // and parsing the result to get the location. Assuming the necessary API
      // call is made, the resulting coordinates would be returned like this:

      // Simulating an API response with dummy coordinates for now
      double latitude =
          30.0444; // Replace with actual data from the API response
      double longitude =
          31.2357; // Replace with actual data from the API response

      return Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
    return null;
  }
}
