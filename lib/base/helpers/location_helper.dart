import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'dialog_helper.dart';

class LocationHelper {
  static const double cairoLatitude = 30.0444;
  static const double cairoLongitude = 31.2357;

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      DialogHelper.showLocationServiceEnable(
          message: "List or Life would like to access your location",
          onTap: () async {
            await Geolocator.openLocationSettings();
          });
      throw 'Location services are disabled.';
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      DialogHelper.showLocationServiceEnable(
          message: "List or Life would like to access your location",
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
              message: "List or Life would like to access your location",
              onTap: () async {
                await Geolocator.openAppSettings();
              });
          throw 'Location permissions are permanently denied, we cannot request permissions.';
        }
        throw 'Location permissions are denied (actual value: $permission).';
      }
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      return "${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Unable to get address for the provided coordinates.";
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
      print("Error: $e");
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
              child: Text("OK"),
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
          title: const Text("Location Alert"),
          content: const Text(
              "Please note that our app is currently only available for users in Egypt. Please select Egypt location for add product."),
          actions: [
            TextButton(
              child: Text("OK"),
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
}
