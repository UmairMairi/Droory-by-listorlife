import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  bool _showAll = false; // Track expanded/collapsed state
  final int _initialDisplayCount = 6;

  @override
  void initState() {
    _fetchAmenities();

    super.initState();
    // Fetch amenities on init
  }

  IconData getAmenityIconData(String amenityName) {
    final Map<String, IconData> amenityIconMap = {
      "Intercom": Icons.doorbell_outlined,
      "Security": Icons.security_outlined,
      "Storage": Icons.inventory_2_outlined,
      "Broadband Internet": Icons.wifi_outlined,
      // "Garage Parking": Icons.garage_outlined,
      "Elevator": Icons.elevator_outlined,
      "Landline": Icons.phone_outlined,
      "Natural Gas": Icons.local_fire_department_outlined,
      "Water Meter": Icons.water_drop_outlined,
      "Electricity Meter": Icons.electric_bolt_outlined,
      "Pool": Icons.pool_outlined,
      "Pets Allowed": Icons.pets_outlined,
      "Maids Room": Icons.bedroom_child_outlined,
      "Parking": Icons.local_parking_outlined,
      "Central A/C and Heating": Icons.ac_unit_outlined,
      "Private Garden": Icons.yard_outlined,
      "Installed Kitchen": Icons.kitchen_outlined,
      "Balcony": Icons.balcony_outlined,
      "Washer": Icons.local_laundry_service_outlined,
      "Dryer": Icons.dry_cleaning_outlined,
      "Hot tub": Icons.hot_tub_outlined,
      "Wifi": Icons.wifi_outlined,
      "Air conditioning": Icons.ac_unit_outlined,
    };

    return amenityIconMap[(amenityName).replaceAll('\n', '')] ??
        Icons.check_box_outline_blank;
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

    // Determine which amenities to display based on show all state
    final displayedAmenities =
        _showAll ? _amenities : _amenities.take(_initialDisplayCount).toList();

    // Check if we need a "Show More" button
    final hasMoreToShow = _amenities.length > _initialDisplayCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Wrap(
            spacing: 12, // Horizontal gap between items
            runSpacing: 16, // Vertical gap between rows
            children: displayedAmenities.map((amenity) {
              final isSelected = amenitiesChecked.contains(amenity.id);
              final amenityName = DbHelper.getLanguage() == 'en'
                  ? (amenity.name ?? '').replaceAll('\n', '')
                  : (amenity.nameAr ?? '').replaceAll('\n', '');

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      amenitiesChecked.remove(amenity.id);
                    } else {
                      amenitiesChecked.add(amenity.id);
                    }
                    widget.selectedAmenities.call(amenitiesChecked);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? Colors.black
                          : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getAmenityIconData(amenity.name ?? ''),
                        size: 20,
                        color: isSelected ? Colors.black : Colors.black54,
                      ),
                      SizedBox(width: 10),
                      Text(
                        amenityName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Colors.black : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Show More/Less button if there are more amenities
        if (hasMoreToShow)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showAll ? StringHelper.seeLess : StringHelper.seeMore,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 42, 46, 50),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    _showAll
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color.fromARGB(255, 30, 34, 38),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
