// lib/widgets/profile_location_screen.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/helpers/LocationService.dart'; //
import 'package:list_and_life/base/helpers/string_helper.dart'; //
import 'package:list_and_life/models/city_model.dart'; //

class ProfileLocationScreen extends StatefulWidget {
  // UPDATED CALLBACK SIGNATURE
  final Function(
    String displayLocationName, // Localized name for display
    double lat,
    double lng,
    String? cityEn, // English city name
    String? districtEn, // English district name (nullable)
    String? neighborhoodEn, // English neighborhood name (nullable)
  ) onLocationSelected;

  const ProfileLocationScreen({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<ProfileLocationScreen> createState() => _ProfileLocationScreenState();
}

class _ProfileLocationScreenState extends State<ProfileLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults =
      []; // Changed to List<Map<String, dynamic>>
  String _currentView = 'main';
  CityModel? _selectedCityForDetails;
  DistrictModel? _selectedDistrictForDetails;
  // bool _isSearching = false; // Not strictly needed with current logic

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isArabic() {
    // Ensure this reflects your app's current language setting
    return Directionality.of(context) == TextDirection.rtl;
  }

  String _getEmptySearchMessage() {
    bool isArabic =
        _isArabic(); // Assuming _isArabic() is defined in this class
    if (_selectedDistrictForDetails != null) {
      return '${StringHelper.noAreasFoundIn} ${isArabic ? _selectedDistrictForDetails!.arabicName : _selectedDistrictForDetails!.name}'; //
    } else if (_selectedCityForDetails != null) {
      return '${StringHelper.noDistrictsOrAreasFoundIn} ${isArabic ? _selectedCityForDetails!.arabicName : _selectedCityForDetails!.name}'; //
    }
    return StringHelper.trySearchingWithDifferentKeywords; //
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        // _isSearching = false;
        // Revert to the view before search, not always 'main'
        if (_currentView == 'search') {
          _currentView = _selectedDistrictForDetails != null
              ? 'district_neighborhoods'
              : _selectedCityForDetails != null
                  ? 'city_districts'
                  : 'main';
        }
      });
      return;
    }

    setState(() {
      // _isSearching = true;
      _currentView = 'search'; // Switch to search view when typing

      List<dynamic> rawResults;
      if (_selectedDistrictForDetails != null) {
        rawResults = _searchInDistrict(query, _selectedDistrictForDetails!);
      } else if (_selectedCityForDetails != null) {
        rawResults = _searchInCity(query, _selectedCityForDetails!);
      } else {
        rawResults = LocationService.searchInCityDistricts(query); //
      }
      // Ensure results are of the correct type
      _searchResults = List<Map<String, dynamic>>.from(
          rawResults.whereType<Map<String, dynamic>>());
    });
  }

  List<dynamic> _searchInCity(String query, CityModel city) {
    List<Map<String, dynamic>> results = []; // Ensure correct type
    final lowerQuery = query.toLowerCase();

    if (city.districts != null) {
      for (var district in city.districts!) {
        if (district.name.toLowerCase().contains(lowerQuery) ||
            district.arabicName.contains(query)) {
          results.add({
            'type': 'district',
            'city': city,
            'district': district,
            'displayName': _isArabic()
                ? '${district.arabicName}، ${city.arabicName}'
                : '${district.name}, ${city.name}',
            'cityEn': city.name,
            'districtEn': district.name,
            'neighborhoodEn': null,
            'latitude': district.latitude,
            'longitude': district.longitude,
          });
        }
        if (district.neighborhoods != null) {
          for (var neighborhood in district.neighborhoods!) {
            if (neighborhood.name.toLowerCase().contains(lowerQuery) ||
                neighborhood.arabicName.contains(query)) {
              results.add({
                'type': 'neighborhood',
                'city': city,
                'district': district,
                'neighborhood': neighborhood,
                'displayName': _isArabic()
                    ? '${neighborhood.arabicName}، ${district.arabicName}، ${city.arabicName}'
                    : '${neighborhood.name}, ${district.name}, ${city.name}',
                'cityEn': city.name,
                'districtEn': district.name,
                'neighborhoodEn': neighborhood.name,
                'latitude': neighborhood.latitude,
                'longitude': neighborhood.longitude,
              });
            }
          }
        }
      }
    }
    return results;
  }

  List<dynamic> _searchInDistrict(String query, DistrictModel district) {
    List<Map<String, dynamic>> results = []; // Ensure correct type
    final lowerQuery = query.toLowerCase();

    if (district.neighborhoods != null && _selectedCityForDetails != null) {
      for (var neighborhood in district.neighborhoods!) {
        if (neighborhood.name.toLowerCase().contains(lowerQuery) ||
            neighborhood.arabicName.contains(query)) {
          results.add({
            'type': 'neighborhood',
            'city': _selectedCityForDetails,
            'district': district,
            'neighborhood': neighborhood,
            'displayName': _isArabic()
                ? '${neighborhood.arabicName}، ${district.arabicName}، ${_selectedCityForDetails!.arabicName}'
                : '${neighborhood.name}, ${district.name}, ${_selectedCityForDetails!.name}',
            'cityEn': _selectedCityForDetails!.name,
            'districtEn': district.name,
            'neighborhoodEn': neighborhood.name,
            'latitude': neighborhood.latitude,
            'longitude': neighborhood.longitude,
          });
        }
      }
    }
    return results;
  }

  // UPDATED to use all parts of the callback
  void _selectLocationFromSearch(Map<String, dynamic> result) {
    String displayLocationName = result['displayName'] as String;
    double lat = result['latitude'] as double? ?? 0.0;
    double lng = result['longitude'] as double? ?? 0.0;
    String? cityEn = result['cityEn'] as String?;
    String? districtEn = result['districtEn'] as String?;
    String? neighborhoodEn = result['neighborhoodEn'] as String?;

    widget.onLocationSelected(
        displayLocationName, lat, lng, cityEn, districtEn, neighborhoodEn);
    Navigator.pop(context); // Pop after selection
  }

  void _showCityDistricts(CityModel city) {
    setState(() {
      _selectedCityForDetails = city;
      _selectedDistrictForDetails = null;
      _currentView = 'city_districts';
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _showDistrictNeighborhoods(DistrictModel district) {
    setState(() {
      _selectedDistrictForDetails = district;
      // _selectedCityForDetails should already be set if we got here
      _currentView = 'district_neighborhoods';
      _searchController.clear();
      _searchResults = [];
    });
  }

  // UPDATED to use all parts of the callback
  void _selectCity(CityModel city) {
    String locationName = _isArabic() ? city.arabicName : city.name;
    widget.onLocationSelected(
        locationName,
        city.latitude,
        city.longitude,
        city.name, // English city name
        null,
        null);
    Navigator.pop(context); // Pop after selection
  }

  // UPDATED to use all parts of the callback
  void _selectDistrict(DistrictModel district, CityModel city) {
    String locationName = _isArabic()
        ? '${district.arabicName}، ${city.arabicName}'
        : '${district.name}, ${city.name}';
    widget.onLocationSelected(
        locationName,
        district.latitude,
        district.longitude,
        city.name, // English city name
        district.name, // English district name
        null);
    Navigator.pop(context); // Pop after selection
  }

  // UPDATED to use all parts of the callback
  void _selectNeighborhood(
      NeighborhoodModel neighborhood, DistrictModel district, CityModel city) {
    String locationName = _isArabic()
        ? '${neighborhood.arabicName}، ${district.arabicName}، ${city.arabicName}'
        : '${neighborhood.name}, ${district.name}, ${city.name}';
    widget.onLocationSelected(
        locationName,
        neighborhood.latitude,
        neighborhood.longitude,
        city.name, // English city name
        district.name, // English district name
        neighborhood.name // English neighborhood name
        );
    Navigator.pop(context); // Pop after selection
  }

  void _goBack() {
    setState(() {
      _searchController.clear(); // Clear search text on any back navigation
      _searchResults = []; // Clear search results

      if (_currentView == 'search') {
        // Determine what the previous view was before search started
        if (_selectedDistrictForDetails != null) {
          _currentView = 'district_neighborhoods';
        } else if (_selectedCityForDetails != null) {
          _currentView = 'city_districts';
        } else {
          _currentView = 'main';
        }
      } else if (_currentView == 'district_neighborhoods') {
        _currentView = 'city_districts';
        _selectedDistrictForDetails = null; // Clear district selection
      } else if (_currentView == 'city_districts') {
        _currentView = 'main';
        _selectedCityForDetails = null; // Clear city selection
      } else {
        // If in 'main' view, then pop the screen
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5, // Slight shadow for definition
        leading: IconButton(
          onPressed: _goBack,
          icon: Icon(
            _isArabic() ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: Text(
          _getHeaderTitle(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600, // Adjusted for clarity
                fontSize: _isArabic() ? 18 : 17, // Adjusted for balance
                color: Colors.black87,
              ),
        ),
        centerTitle: true, // Common practice for inner screens
        actions: [
          if (_shouldShowSeeAllButton())
            Padding(
              padding: EdgeInsets.only(
                right: _isArabic() ? 8 : 16, // Adjusted padding
                left: _isArabic() ? 16 : 8,
              ),
              child: _buildSeeAllButton(),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  bool _shouldShowSeeAllButton() {
    return false;
  }

  Widget _buildSeeAllButton() {
    String buttonText = "";
    if (_currentView == 'city_districts' && _selectedCityForDetails != null) {
      buttonText =
          '${StringHelper.seeAll} ${_isArabic() ? _selectedCityForDetails!.arabicName : _selectedCityForDetails!.name}';
    } else if (_currentView == 'district_neighborhoods' &&
        _selectedDistrictForDetails != null) {
      buttonText =
          '${StringHelper.seeAll} ${_isArabic() ? _selectedDistrictForDetails!.arabicName : _selectedDistrictForDetails!.name}';
    }

    return TextButton(
      onPressed: () {
        if (_currentView == 'city_districts' &&
            _selectedCityForDetails != null) {
          _selectCity(_selectedCityForDetails!);
        } else if (_currentView == 'district_neighborhoods' &&
            _selectedDistrictForDetails != null &&
            _selectedCityForDetails != null) {
          _selectDistrict(
              _selectedDistrictForDetails!, _selectedCityForDetails!);
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: _isArabic() ? 13 : 12,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Added top padding
      color: Colors.white, // To make shadow visible if AppBar had no elevation
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: _getSearchHint(),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon:
                      Icon(Icons.clear, color: Colors.grey.shade500, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged(''); // This will trigger the state update
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade100, // Softer fill
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0), // More rounded
            borderSide: BorderSide.none, // No border line
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5), // Highlight when focused
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12), // Adjusted padding
          hintStyle: TextStyle(
            color: Colors.grey.shade400, // Lighter hint text
            fontSize: _isArabic() ? 15 : 13,
          ),
        ),
        style: TextStyle(
          fontSize: _isArabic() ? 16 : 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  String _getHeaderTitle() {
    bool isArabic = _isArabic();
    switch (_currentView) {
      case 'search':
        if (_selectedDistrictForDetails != null) {
          return '${StringHelper.searchResultsIn} ${isArabic ? _selectedDistrictForDetails!.arabicName : _selectedDistrictForDetails!.name}';
        } else if (_selectedCityForDetails != null) {
          return '${StringHelper.searchResultsIn} ${isArabic ? _selectedCityForDetails!.arabicName : _selectedCityForDetails!.name}';
        }
        return StringHelper.searchResults; //
      case 'city_districts':
        return _selectedCityForDetails != null
            ? (isArabic
                ? _selectedCityForDetails!.arabicName
                : _selectedCityForDetails!.name)
            : StringHelper.districts; //
      case 'district_neighborhoods':
        return _selectedDistrictForDetails != null
            ? (isArabic
                ? _selectedDistrictForDetails!.arabicName
                : _selectedDistrictForDetails!.name)
            : StringHelper.areas; //
      default:
        return StringHelper.chooseLocation; //
    }
  }

  String _getSearchHint() {
    bool isArabic = _isArabic();
    if (_selectedDistrictForDetails != null) {
      return '${StringHelper.searchAreasIn} ${isArabic ? _selectedDistrictForDetails!.arabicName : _selectedDistrictForDetails!.name}...';
    } else if (_selectedCityForDetails != null) {
      return '${StringHelper.searchDistrictsAndAreasIn} ${isArabic ? _selectedCityForDetails!.arabicName : _selectedCityForDetails!.name}...';
    }
    return StringHelper.searchCitiesDistrictsOrAreas; //
  }

  Widget _buildContent() {
    // If searching, always show search results.
    if (_currentView == 'search') {
      return _buildSearchResults();
    }
    // Otherwise, show the relevant view.
    switch (_currentView) {
      case 'city_districts':
        return _buildCityDistricts();
      case 'district_neighborhoods':
        return _buildDistrictNeighborhoods();
      default: // 'main'
        return _buildMainView();
    }
  }

  Widget _buildMainView() {
    return ListView(
      // Changed to ListView for better scrollability if "Use Current Location" is added
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Gap(12), // Space from search bar
        _buildSectionHeader(
          StringHelper.majorCities, //
          StringHelper.searchAboveToFindSpecificAreas, //
        ),
        const Gap(12),
        _buildCitiesList(),
        const Gap(20),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, // Slightly bolder
                color: Colors.black87,
                fontSize: _isArabic() ? 17 : 15,
              ),
        ),
        if (subtitle.isNotEmpty) ...[
          const Gap(2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: _isArabic() ? 13 : 11,
                ),
          ),
        ]
      ],
    );
  }

  Widget _buildCitiesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: LocationService.majorEgyptianCities.length, //
      itemBuilder: (context, index) {
        final city = LocationService.majorEgyptianCities[index]; //
        final hasDistricts =
            city.districts != null && city.districts!.isNotEmpty;
        return _buildLocationTile(
          title: _isArabic() ? city.arabicName : city.name,
          subtitle: _isArabic() ? city.name : city.arabicName,
          icon: Icons.location_city_outlined,
          iconColor: Colors.orange.shade700,
          tagText: hasDistricts
              ? '${city.districts!.length} ${StringHelper.districts}'
              : null, //
          tagColor: Colors.blue,
          showArrow: hasDistricts,
          onTap: hasDistricts
              ? () => _showCityDistricts(city)
              : () => _selectCity(city),
        );
      },
      separatorBuilder: (context, index) => const Gap(10),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 60, color: Colors.grey.shade300),
            const Gap(16),
            Text(
              StringHelper.noResultsFound, //
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: _isArabic() ? 17 : 15,
                  ),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _getEmptySearchMessage(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: _isArabic() ? 14 : 12,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Added vertical padding
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Gap(10),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final type = result['type'] as String;
        final displayName = result['displayName'] as String;
        // Extract English names for subtitle logic
        final cityEn = result['cityEn'] as String?;
        final districtEn = result['districtEn'] as String?;
        final neighborhoodEn = result['neighborhoodEn'] as String?;

        String subtitle = "";
        if (_isArabic()) {
          if (type == 'neighborhood' && districtEn != null && cityEn != null) {
            subtitle = "$districtEn, $cityEn";
          } else if (type == 'district' && cityEn != null) {
            subtitle = cityEn;
          }
        } else {
          // For English UI, build subtitle from Arabic names if available
          CityModel? cityModel = result['city'] as CityModel?;
          DistrictModel? districtModel = result['district'] as DistrictModel?;
          if (type == 'neighborhood' &&
              districtModel != null &&
              cityModel != null) {
            subtitle = "${districtModel.arabicName}، ${cityModel.arabicName}";
          } else if (type == 'district' && cityModel != null) {
            subtitle = cityModel.arabicName;
          }
        }

        IconData icon;
        Color iconBgColor;
        Color iconFgColor;
        String typeLabel;

        switch (type) {
          case 'city':
            icon = Icons.location_city_outlined;
            iconBgColor = Colors.orange.shade50;
            iconFgColor = Colors.orange.shade700;
            typeLabel = StringHelper.city; //
            break;
          case 'district':
            icon = Icons.holiday_village_outlined;
            iconBgColor = Colors.blue.shade50;
            iconFgColor = Colors.blue.shade700;
            typeLabel = StringHelper.district; //
            break;
          case 'neighborhood':
            icon = Icons.home_work_outlined;
            iconBgColor = Colors.green.shade50;
            iconFgColor = Colors.green.shade700;
            typeLabel = StringHelper.area; //
            break;
          default:
            icon = Icons.location_on_outlined;
            iconBgColor = Colors.grey.shade100;
            iconFgColor = Colors.grey.shade700;
            typeLabel = StringHelper.location; //
        }

        return _buildLocationTile(
          title: displayName,
          subtitle: subtitle,
          icon: icon,
          iconColor: iconFgColor,
          iconBackgroundColor: iconBgColor,
          tagText: typeLabel,
          tagColor: iconFgColor,
          onTap: () => _selectLocationFromSearch(result),
        );
      },
    );
  }

  Widget _buildCityDistricts() {
    if (_selectedCityForDetails == null ||
        _selectedCityForDetails!.districts == null ||
        _selectedCityForDetails!.districts!.isEmpty) {
      return Center(
        child: Text(StringHelper.noDistrictsAvailable,
            style: TextStyle(fontSize: _isArabic() ? 16 : 14)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _selectedCityForDetails!.districts!.length,
      separatorBuilder: (context, index) => const Gap(10),
      itemBuilder: (context, index) {
        final district = _selectedCityForDetails!.districts![index];
        final hasNeighborhoods = district.neighborhoods != null &&
            district.neighborhoods!.isNotEmpty;
        return _buildLocationTile(
          title: _isArabic() ? district.arabicName : district.name,
          subtitle: _isArabic() ? district.name : district.arabicName,
          icon: Icons.holiday_village_outlined,
          iconColor: Colors.blue.shade700,
          tagText: hasNeighborhoods
              ? '${district.neighborhoods!.length} ${StringHelper.areas}'
              : null, //
          tagColor: Colors.green,
          showArrow: hasNeighborhoods,
          onTap: hasNeighborhoods
              ? () => _showDistrictNeighborhoods(district)
              : () => _selectDistrict(district, _selectedCityForDetails!),
        );
      },
    );
  }

  Widget _buildDistrictNeighborhoods() {
    if (_selectedDistrictForDetails == null ||
        _selectedDistrictForDetails!.neighborhoods == null ||
        _selectedDistrictForDetails!.neighborhoods!.isEmpty) {
      return Center(
        child: Text(StringHelper.noAreasAvailable,
            style: TextStyle(fontSize: _isArabic() ? 16 : 14)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _selectedDistrictForDetails!.neighborhoods!.length,
      separatorBuilder: (context, index) => const Gap(10),
      itemBuilder: (context, index) {
        final neighborhood = _selectedDistrictForDetails!.neighborhoods![index];
        return _buildLocationTile(
          title: _isArabic() ? neighborhood.arabicName : neighborhood.name,
          subtitle: _isArabic() ? neighborhood.name : neighborhood.arabicName,
          icon: Icons.home_work_outlined,
          iconColor: Colors.green.shade700,
          onTap: () => _selectNeighborhood(neighborhood,
              _selectedDistrictForDetails!, _selectedCityForDetails!),
        );
      },
    );
  }

  Widget _buildLocationTile({
    required String title,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    String? tagText,
    Color? tagColor,
    bool showArrow = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 16), // Adjusted padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.grey.shade200, width: 0.8), // Subtler border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100.withOpacity(0.7),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconBackgroundColor ?? iconColor?.withOpacity(0.1)) ??
                    Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(10), // More rounded icon background
              ),
              child: Icon(icon,
                  color: iconColor ?? Colors.grey.shade700, size: 20),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center align text vertically
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: _isArabic() ? 15 : 14, // Adjusted font size
                          color: Colors.black87,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const Gap(2), // Small gap
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade500, // Lighter subtitle
                            fontSize: _isArabic() ? 12 : 11,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                ],
              ),
            ),
            if (tagText != null) ...[
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5), // Adjusted padding
                decoration: BoxDecoration(
                  color: (tagColor ?? Colors.grey).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12), // Rounded tag
                ),
                child: Text(
                  tagText,
                  style: TextStyle(
                    color: tagColor ?? Colors.grey.shade700,
                    fontSize: _isArabic() ? 12 : 10, // Smaller tag text
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (showArrow) ...[
              const Gap(8),
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey.shade400, size: 16),
            ] else ...[
              // Add some space if no arrow to keep alignment consistent, or specific icon
              const Gap(8),
              Icon(Icons.circle,
                  color: Colors.transparent,
                  size: 16), // Placeholder to maintain row height
            ]
          ],
        ),
      ),
    );
  }
}
