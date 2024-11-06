import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/base/network/api_request.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/models/common/list_response.dart';
import '../models/amnites_model.dart';

class AmenitiesWidget extends StatefulWidget {
  const AmenitiesWidget(
      {super.key, required this.selectedAmenities, this.amenitiesChecked});
  final Function(List<int?> ids) selectedAmenities;
  final List<int?>? amenitiesChecked;

  @override
  State<AmenitiesWidget> createState() => _AmenitiesWidgetState();
}

class _AmenitiesWidgetState extends State<AmenitiesWidget> {
  List<AmenitiesModel> _amenities = [];
  List<int?> amenitiesChecked = [];

  @override
  void initState() {
    _fetchAmenities();

    super.initState();
    // Fetch amenities on init
  }

  String getAmenityEmoji(String amenityName) {
    // Define a map that links each amenity name to an emoji
    final Map<String, String> amenityEmojiMap = {
      "Intercom": "📞",
      "Security": "🛡️",
      "Storage": "📦",
      "Broadband Internet": "🌐",
      "Garage Parking": "🚗",
      "Elevator": "🛗",
      "Landline": "☎️",
      "Natural Gas": "🔥",
      "Water Meter": "💧",
      "Electricity Meter": "⚡",
      "Pool": "🏊",
      "Pets Allowed": "🐾",
      "Maids Room": "🛏️",
      "Parking": "🚗",
      "Central A/C and Heating": "❄️🔥",
      "Private Garden": "🌳",
      "Installed Kitchen": "🍳",
      "Balcony": "🌅",
    };

    // Return the emoji if found in the map, otherwise return a default symbol
    return amenityEmojiMap[amenityName] ?? "❓"; // "❓" as a default emoji
  }

  // Fetch amenities and set state only once
  Future<void> _fetchAmenities() async {
    try {
      ApiRequest apiRequest = ApiRequest(
          url: ApiConstants.getAmnitiesUrl(), requestType: RequestType.get);
      var response = await BaseClient.handleRequest(apiRequest);

      ListResponse<AmenitiesModel> model =
          ListResponse<AmenitiesModel>.fromJson(
              response, (json) => AmenitiesModel.fromJson(json));

      amenitiesChecked = widget.amenitiesChecked ?? [];
      setState(() {
        _amenities = model.body ?? [];
      });
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringHelper.amenities,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        _buildAmenitiesList(),
      ],
    );
  }

  // Build the list of checkboxes for amenities
  Widget _buildAmenitiesList() {
    if (_amenities.isEmpty) {
      return Text('No amenities available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _amenities.length,
      itemBuilder: (context, index) {
        final amenity = _amenities[index];
        return CheckboxListTile(
          title: Text(DbHelper?.getLanguage() == 'en'
              ? "${getAmenityEmoji(amenity.name ?? '')} ${amenity.name ?? ''}"
              : "${getAmenityEmoji(amenity.name ?? '')} ${amenity.nameAr ?? ''}"),
          value: amenitiesChecked.contains(amenity.id),
          onChanged: (bool? value) {
            setState(() {
              if (value ?? false) {
                amenitiesChecked.add(amenity.id);
              } else {
                amenitiesChecked.remove(amenity.id);
              }
              widget.selectedAmenities.call(amenitiesChecked);
            });
          },
        );
      },
    );
  }
}
