import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'dialog_helper.dart';

class LocationHelper {
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

    /// Get current position
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

  /*
  *  SearchAddressField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji))
                  ],
                  hintText: 'Enter Location',
                  textEditingController:
                      swipeController.groupLocationController,
                  itmClick: (prediction) {
                    swipeController.groupLocationController.text =
                        prediction.description ?? "";
                    swipeController.groupLocationController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: prediction.description?.length ?? 0));
                  },
                  getPlaceDetailWithLatLng: (prediction) {
                    swipeController.latitude.value = prediction.lat.toString();
                    swipeController.longitude.value = prediction.lng.toString();
                  },
                )
*/
}
