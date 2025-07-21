import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:list_and_life/base/helpers/LocationService.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/models/city_model.dart';
import 'package:list_and_life/view_model/home_vm.dart';

class EnhancedLocationSelectionScreen extends StatefulWidget {
  final HomeVM viewModel;
  final Function(String locationName, double lat, double lng)?
      onLocationSelected;

  const EnhancedLocationSelectionScreen({
    super.key,
    required this.viewModel,
    this.onLocationSelected,
  });

  @override
  State<EnhancedLocationSelectionScreen> createState() =>
      _EnhancedLocationSelectionScreenState();
}

class _EnhancedLocationSelectionScreenState
    extends State<EnhancedLocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  String _currentView =
      'main'; // 'main', 'search', 'city_districts', 'district_neighborhoods'
  CityModel? _selectedCityForDetails;
  DistrictModel? _selectedDistrictForDetails;
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        // When search is cleared, reset to main view and clear all selections
        _currentView = 'main';
        _selectedCityForDetails = null;
        _selectedDistrictForDetails = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _currentView = 'search';

      // Context-aware search based on current view
      if (_selectedDistrictForDetails != null) {
        // Searching within a specific district - only show neighborhoods
        _searchResults = _searchInDistrict(query, _selectedDistrictForDetails!);
      } else if (_selectedCityForDetails != null) {
        // Searching within a specific city - only show districts and neighborhoods
        _searchResults = _searchInCity(query, _selectedCityForDetails!);
      } else {
        // General search - show cities, districts, and neighborhoods
        _searchResults = _localizeSearchResults(
            LocationService.searchInCityDistricts(query));
      }
    });
  }

  // Helper method to localize search results from LocationService
  List<dynamic> _localizeSearchResults(List<dynamic> results) {
    return results.map((result) {
      final Map<String, dynamic> localizedResult = Map.from(result);

      if (result['type'] == 'city' && result['city'] != null) {
        final city = result['city'] as CityModel;
        localizedResult['displayName'] =
            _isArabic() ? city.arabicName : city.name;
      } else if (result['type'] == 'district' && result['district'] != null) {
        final district = result['district'] as DistrictModel;
        localizedResult['displayName'] =
            _isArabic() ? district.arabicName : district.name;
      } else if (result['type'] == 'neighborhood' &&
          result['neighborhood'] != null) {
        final neighborhood = result['neighborhood'] as NeighborhoodModel;
        localizedResult['displayName'] =
            _isArabic() ? neighborhood.arabicName : neighborhood.name;
      }

      return localizedResult;
    }).toList();
  }
// Add these helper methods at the end of the class, before the final }

  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'),
            '') // Keep only letters, numbers, spaces, and Arabic characters
        .replaceAll(
            RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .trim();
  }

  // Enhanced normalization (update your existing method)
  String _normalizeForSearch(String text) {
    String normalized = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Remove common prefixes
    normalized = normalized
        .replaceAll(RegExp(r'^el\s+'), '')
        .replaceAll(RegExp(r'^al\s+'), '')
        .replaceAll(RegExp(r'^الـ'), '')
        .replaceAll(RegExp(r'^ال'), '');

    // COMPREHENSIVE Arabic ordinal normalizations
    normalized = normalized
        // Arabic ordinals - comprehensive list
        .replaceAll('الأول', '1')
        .replaceAll('الاول', '1')
        .replaceAll('اول', '1')
        .replaceAll('أول', '1')
        .replaceAll('الثاني', '2')
        .replaceAll('الثانى', '2')
        .replaceAll('ثاني', '2')
        .replaceAll('ثانى', '2')
        .replaceAll('الثالث', '3')
        .replaceAll('ثالث', '3')
        .replaceAll('الرابع', '4')
        .replaceAll('رابع', '4')
        .replaceAll('الخامس', '5')
        .replaceAll('خامس', '5')
        .replaceAll('السادس', '6')
        .replaceAll('سادس', '6')
        .replaceAll('السابع', '7')
        .replaceAll('سابع', '7')
        .replaceAll('الثامن', '8')
        .replaceAll('ثامن', '8')
        .replaceAll('التاسع', '9')
        .replaceAll('تاسع', '9')
        .replaceAll('العاشر', '10')
        .replaceAll('عاشر', '10')
        .replaceAll('الحادي عشر', '11')
        .replaceAll('حادي عشر', '11')
        .replaceAll('الثاني عشر', '12')
        .replaceAll('ثاني عشر', '12')
        .replaceAll('الثالث عشر', '13')
        .replaceAll('ثالث عشر', '13')
        .replaceAll('الرابع عشر', '14')
        .replaceAll('رابع عشر', '14')
        .replaceAll('الخامس عشر', '15')
        .replaceAll('خامس عشر', '15')
        .replaceAll('السادس عشر', '16')
        .replaceAll('سادس عشر', '16')
        .replaceAll('السابع عشر', '17')
        .replaceAll('سابع عشر', '17')
        .replaceAll('الثامن عشر', '18')
        .replaceAll('ثامن عشر', '18')
        .replaceAll('التاسع عشر', '19')
        .replaceAll('تاسع عشر', '19')
        .replaceAll('العشرون', '20')
        .replaceAll('عشرون', '20')

        // Common district names in Arabic
        .replaceAll('التجمع', 'tagmo')
        .replaceAll('تجمع', 'tagmo')
        .replaceAll('الحى', 'district')
        .replaceAll('حى', 'district')
        .replaceAll('الحي', 'district')
        .replaceAll('حي', 'district')
        .replaceAll('منطقة', 'area')
        .replaceAll('المنطقة', 'area')

        // English ordinals - comprehensive list
        .replaceAll('first', '1')
        .replaceAll('1st', '1')
        .replaceAll('second', '2')
        .replaceAll('2nd', '2')
        .replaceAll('third', '3')
        .replaceAll('3rd', '3')
        .replaceAll('fourth', '4')
        .replaceAll('4th', '4')
        .replaceAll('fifth', '5')
        .replaceAll('5th', '5')
        .replaceAll('sixth', '6')
        .replaceAll('6th', '6')
        .replaceAll('seventh', '7')
        .replaceAll('7th', '7')
        .replaceAll('eighth', '8')
        .replaceAll('8th', '8')
        .replaceAll('ninth', '9')
        .replaceAll('9th', '9')
        .replaceAll('tenth', '10')
        .replaceAll('10th', '10')
        .replaceAll('eleventh', '11')
        .replaceAll('11th', '11')
        .replaceAll('twelfth', '12')
        .replaceAll('12th', '12')
        .replaceAll('thirteenth', '13')
        .replaceAll('13th', '13')
        .replaceAll('fourteenth', '14')
        .replaceAll('14th', '14')
        .replaceAll('fifteenth', '15')
        .replaceAll('15th', '15')
        .replaceAll('sixteenth', '16')
        .replaceAll('16th', '16')
        .replaceAll('seventeenth', '17')
        .replaceAll('17th', '17')
        .replaceAll('eighteenth', '18')
        .replaceAll('18th', '18')
        .replaceAll('nineteenth', '19')
        .replaceAll('19th', '19')
        .replaceAll('twentieth', '20')
        .replaceAll('20th', '20')

        // Sheikh variations
        .replaceAll('sheikh', 'sheik')
        .replaceAll('shaikh', 'sheik')
        .replaceAll('shiekh', 'sheik')
        .replaceAll('seikh', 'sheik')
        .replaceAll('siekh', 'sheik')
        .replaceAll('الشيخ', 'شيخ')

        // Month handling (critical for "6 octo" -> "6th of October")
        .replaceAll('octo', 'oct')
        .replaceAll('october', 'oct')
        .replaceAll('اكتوبر', 'أكتوبر')
        .replaceAll('أوكتوبر', 'أكتوبر')
        .replaceAll('november', 'nov')
        .replaceAll('december', 'dec')
        .replaceAll('january', 'jan')
        .replaceAll('february', 'feb')
        .replaceAll('september', 'sep')

        // Common word variations
        .replaceAll('compound', 'comp')
        .replaceAll('district', 'dist')
        .replaceAll('neighbourhood', 'neighborhood')
        .replaceAll('centre', 'center')
        .replaceAll('gardens', 'garden')
        .replaceAll('heights', 'height')
        .replaceAll('towers', 'tower')
        .replaceAll('residence', 'residenc')
        .replaceAll('residential', 'residenc');

    return normalized;
  }

  double _calculateSimilarity(String str1, String str2) {
    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    int maxLength = str1.length > str2.length ? str1.length : str2.length;
    int distance = _levenshteinDistance(str1, str2);
    return (maxLength - distance) / maxLength;
  }

  int _levenshteinDistance(String str1, String str2) {
    List<List<int>> matrix = List.generate(
      str1.length + 1,
      (i) => List.filled(str2.length + 1, 0),
    );

    for (int i = 0; i <= str1.length; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= str2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= str1.length; i++) {
      for (int j = 1; j <= str2.length; j++) {
        int cost = str1[i - 1] == str2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[str1.length][str2.length];
  }

  bool _fuzzyMatch(String searchTerm, String targetText) {
    String normalizedSearch = _normalizeForSearch(searchTerm);
    String normalizedTarget = _normalizeForSearch(targetText);

    // Direct match after normalization
    if (normalizedTarget.contains(normalizedSearch)) {
      return true;
    }

    // Split into words
    List<String> targetWords =
        normalizedTarget.split(' ').where((w) => w.length >= 2).toList();
    List<String> searchWords =
        normalizedSearch.split(' ').where((w) => w.length >= 2).toList();

    if (searchWords.isEmpty || targetWords.isEmpty) return false;

    // For multi-word searches, we need most words to match
    if (searchWords.length >= 2) {
      int matchedWords = 0;

      for (String searchWord in searchWords) {
        bool foundMatch = false;
        for (String targetWord in targetWords) {
          // Only exact contains or starts with - no fuzzy similarity
          if (targetWord.contains(searchWord) ||
              searchWord.contains(targetWord)) {
            foundMatch = true;
            break;
          }
        }
        if (foundMatch) {
          matchedWords++;
        }
      }

      // For 2 words: both must match
      // For 3+ words: at least 2 must match
      int requiredMatches = searchWords.length >= 3 ? 2 : searchWords.length;
      return matchedWords >= requiredMatches;
    }

    // For single word searches, allow some flexibility
    String singleSearchWord = searchWords[0];
    for (String targetWord in targetWords) {
      if (targetWord.contains(singleSearchWord) ||
          singleSearchWord.contains(targetWord)) {
        return true;
      }
      // Only for longer words, allow small typos
      if (singleSearchWord.length >= 4 && targetWord.length >= 4) {
        if (_calculateSimilarity(singleSearchWord, targetWord) >= 0.85) {
          return true;
        }
      }
    }

    return false;
  }

// Helper method to get remaining query after removing district-matching words
  String _getRemainingQuery(List<String> queryWords, DistrictModel district) {
    List<String> remainingWords = List.from(queryWords);
    String normalizedDistrictName = _normalizeForSearch(district.name);
    String normalizedDistrictArabic = _normalizeForSearch(district.arabicName);

    // Remove words that match the district
    remainingWords.removeWhere((word) =>
        normalizedDistrictName.contains(word) ||
        normalizedDistrictArabic.contains(word) ||
        word.length < 2);

    return remainingWords.join(' ');
  }

// Smart matching method - enhanced for neighborhoods and districts
  bool _smartMatch(String searchTerm, String targetText) {
    if (searchTerm.isEmpty || targetText.isEmpty) return false;

    String normalizedSearch = _normalizeForSearch(searchTerm);
    String normalizedTarget = _normalizeForSearch(targetText);

    // Direct substring match (critical for "aeon" -> "aeon compound")
    if (normalizedTarget.contains(normalizedSearch)) {
      return true;
    }

    // Split into words
    List<String> targetWords =
        normalizedTarget.split(' ').where((w) => w.length >= 2).toList();
    List<String> searchWords =
        normalizedSearch.split(' ').where((w) => w.length >= 2).toList();

    if (searchWords.isEmpty || targetWords.isEmpty) return false;

    // For single word searches (like "aeon" or "1st")
    if (searchWords.length == 1) {
      String searchWord = searchWords[0];

      for (String targetWord in targetWords) {
        // Exact contains match
        if (targetWord.contains(searchWord) ||
            searchWord.contains(targetWord)) {
          return true;
        }

        // Prefix matching for partial words like "aeo" -> "aeon"
        if (searchWord.length >= 3 && targetWord.startsWith(searchWord)) {
          return true;
        }

        // Numerical matching (critical for "1st district")
        if (_matchesNumerical(searchWord, targetWord)) {
          return true;
        }

        // Fuzzy matching for typos
        if (searchWord.length >= 4 && targetWord.length >= 4) {
          if (_calculateSimilarity(searchWord, targetWord) >= 0.85) {
            return true;
          }
        }
      }
      return false;
    }

    // For multi-word searches
    int matchedWords = 0;
    for (String searchWord in searchWords) {
      bool foundMatch = false;
      for (String targetWord in targetWords) {
        if (targetWord.contains(searchWord) ||
            searchWord.contains(targetWord) ||
            (searchWord.length >= 3 && targetWord.startsWith(searchWord)) ||
            _matchesNumerical(searchWord, targetWord)) {
          foundMatch = true;
          break;
        }
      }
      if (foundMatch) {
        matchedWords++;
      }
    }

    int requiredMatches = searchWords.length <= 2
        ? searchWords.length
        : (searchWords.length * 0.7).ceil();

    return matchedWords >= requiredMatches;
  }

// Numerical matching helper - enhanced for districts
  bool _matchesNumerical(String search, String target) {
    Map<String, List<String>> numericalVariations = {
      '1': ['1st', 'first', 'الأول', 'اول', 'أول'],
      '2': ['2nd', 'second', 'الثاني', 'ثاني', 'الثانى', 'ثانى'],
      '3': ['3rd', 'third', 'الثالث', 'ثالث'],
      '4': ['4th', 'fourth', 'الرابع', 'رابع'],
      '5': ['5th', 'fifth', 'الخامس', 'خامس'],
      '6': ['6th', 'sixth', 'السادس', 'سادس'],
      '7': ['7th', 'seventh', 'السابع', 'سابع'],
      '8': ['8th', 'eighth', 'الثامن', 'ثامن'],
      '9': ['9th', 'ninth', 'التاسع', 'تاسع'],
      '10': ['10th', 'tenth', 'العاشر', 'عاشر'],
      '11': ['11th', 'eleventh', 'الحادي عشر', 'حادي عشر'],
      '12': ['12th', 'twelfth', 'الثاني عشر', 'ثاني عشر'],
      '13': ['13th', 'thirteenth', 'الثالث عشر', 'ثالث عشر'],
      '14': ['14th', 'fourteenth', 'الرابع عشر', 'رابع عشر'],
      '15': ['15th', 'fifteenth', 'الخامس عشر', 'خامس عشر'],
      '16': ['16th', 'sixteenth', 'السادس عشر', 'سادس عشر'],
      '17': ['17th', 'seventeenth', 'السابع عشر', 'سابع عشر'],
      '18': ['18th', 'eighteenth', 'الثامن عشر', 'ثامن عشر'],
      '19': ['19th', 'nineteenth', 'التاسع عشر', 'تاسع عشر'],
      '20': ['20th', 'twentieth', 'العشرون', 'عشرون'],
    };

    for (var entry in numericalVariations.entries) {
      String number = entry.key;
      List<String> variations = entry.value;

      if ((search == number && variations.any((v) => target.contains(v))) ||
          (target == number && variations.any((v) => search.contains(v))) ||
          (variations.any((v) => search.contains(v)) &&
              variations.any((v) => target.contains(v)))) {
        return true;
      }
    }

    return false;
  }

// Calculate match score for sorting
  double _calculateMatchScore(
      String query, String primaryName, String secondaryName) {
    double primaryScore = _getTextMatchScore(query, primaryName);
    double secondaryScore = _getTextMatchScore(query, secondaryName);

    return primaryScore > secondaryScore ? primaryScore : secondaryScore * 0.9;
  }

  double _getTextMatchScore(String query, String text) {
    if (query.isEmpty || text.isEmpty) return 0.0;

    String normalizedQuery = _normalizeForSearch(query);
    String normalizedText = _normalizeForSearch(text);

    // Exact match gets perfect score
    if (normalizedQuery == normalizedText) return 1.0;

    // Starts with gets very high score (important for "aeon" -> "aeon compound")
    if (normalizedText.startsWith(normalizedQuery)) return 0.95;

    // Contains as substring gets high score
    if (normalizedText.contains(normalizedQuery)) return 0.9;

    // Word-based scoring
    List<String> queryWords =
        normalizedQuery.split(' ').where((w) => w.length >= 2).toList();
    List<String> textWords =
        normalizedText.split(' ').where((w) => w.length >= 2).toList();

    if (queryWords.isEmpty || textWords.isEmpty) return 0.0;

    int exactWordMatches = 0;
    int partialWordMatches = 0;

    for (String queryWord in queryWords) {
      bool exactMatch = false;
      bool partialMatch = false;

      for (String textWord in textWords) {
        if (queryWord == textWord) {
          exactMatch = true;
          break;
        } else if (textWord.contains(queryWord) ||
            queryWord.contains(textWord)) {
          partialMatch = true;
        }
      }

      if (exactMatch) {
        exactWordMatches++;
      } else if (partialMatch) {
        partialWordMatches++;
      }
    }

    double wordMatchRatio =
        (exactWordMatches + partialWordMatches * 0.7) / queryWords.length;
    return wordMatchRatio * 0.8;
  }

  // Enhanced searchInCity method
  List<dynamic> _searchInCity(String query, CityModel city) {
    List<dynamic> results = [];
    final normalizedQuery = _normalizeForSearch(query);

    if (normalizedQuery.trim().isEmpty) return results;

    // Split query into words for compound searches
    final queryWords =
        normalizedQuery.split(' ').where((w) => w.length >= 2).toList();

    if (city.districts != null) {
      for (var district in city.districts!) {
        // Check if district matches directly
        bool districtMatches = _smartMatch(normalizedQuery, district.name) ||
            _smartMatch(normalizedQuery, district.arabicName);

        // For compound searches, check if any part matches the district
        bool partialDistrictMatch = false;
        if (queryWords.length > 1) {
          for (var word in queryWords) {
            if (_smartMatch(word, district.name) ||
                _smartMatch(word, district.arabicName)) {
              partialDistrictMatch = true;
              break;
            }
          }
        }

        // Check neighborhoods in this district
        List<NeighborhoodModel> matchingNeighborhoods = [];
        bool hasMatchingNeighborhood = false;

        if (district.neighborhoods != null) {
          for (var neighborhood in district.neighborhoods!) {
            bool neighborhoodMatches =
                _smartMatch(normalizedQuery, neighborhood.name) ||
                    _smartMatch(normalizedQuery, neighborhood.arabicName);

            // For compound searches like "6 october aeon compound", check if:
            // - Any part matches district (6 october -> 6th of October)
            // - Remaining parts match neighborhood (aeon compound -> Aeon Compound)
            bool compoundNeighborhoodMatch = false;
            if (queryWords.length > 1 &&
                (districtMatches || partialDistrictMatch)) {
              String remainingQuery = _getRemainingQuery(queryWords, district);
              if (remainingQuery.isNotEmpty) {
                compoundNeighborhoodMatch =
                    _smartMatch(remainingQuery, neighborhood.name) ||
                        _smartMatch(remainingQuery, neighborhood.arabicName);
              }
            }

            if (neighborhoodMatches || compoundNeighborhoodMatch) {
              matchingNeighborhoods.add(neighborhood);
              hasMatchingNeighborhood = true;
            }
          }
        }

        bool shouldShowDistrict =
            districtMatches || partialDistrictMatch || hasMatchingNeighborhood;

        // Add district if it should be shown
        if (shouldShowDistrict) {
          double matchScore = 0.0;
          if (districtMatches) {
            matchScore = _calculateMatchScore(
                normalizedQuery, district.name, district.arabicName);
          } else if (partialDistrictMatch) {
            matchScore = 0.8;
          } else {
            matchScore = 0.6;
          }

          results.add({
            'type': 'district',
            'city': city,
            'district': district,
            'displayName': _isArabic() ? district.arabicName : district.name,
            'matchScore': matchScore,
          });
        }

        // Add matching neighborhoods - THIS IS KEY for "aeon" and "1st district" searches
        for (var neighborhood in matchingNeighborhoods) {
          double neighborhoodScore = _calculateMatchScore(
              normalizedQuery, neighborhood.name, neighborhood.arabicName);

          results.add({
            'type': 'neighborhood',
            'city': city,
            'district': district,
            'neighborhood': neighborhood,
            'displayName':
                _isArabic() ? neighborhood.arabicName : neighborhood.name,
            'matchScore': neighborhoodScore,
          });
        }
      }
    }

    // Sort by match score (highest first), then by type priority
    results.sort((a, b) {
      double scoreA = a['matchScore'] ?? 0.0;
      double scoreB = b['matchScore'] ?? 0.0;

      if (scoreA != scoreB) {
        return scoreB.compareTo(scoreA);
      }

      // If scores are equal, prioritize neighborhoods over districts
      Map<String, int> typePriority = {'neighborhood': 2, 'district': 1};
      int priorityA = typePriority[a['type']] ?? 0;
      int priorityB = typePriority[b['type']] ?? 0;

      return priorityB.compareTo(priorityA);
    });

    return results.take(15).toList(); // Limit results
  }

  // Enhanced searchInDistrict method
  List<dynamic> _searchInDistrict(String query, DistrictModel district) {
    List<dynamic> results = [];
    final normalizedQuery = _normalizeForSearch(query);

    if (district.neighborhoods != null) {
      for (var neighborhood in district.neighborhoods!) {
        if (_smartMatch(normalizedQuery, neighborhood.name) ||
            _smartMatch(normalizedQuery, neighborhood.arabicName)) {
          double matchScore = _calculateMatchScore(
              normalizedQuery, neighborhood.name, neighborhood.arabicName);

          results.add({
            'type': 'neighborhood',
            'city': _selectedCityForDetails,
            'district': district,
            'neighborhood': neighborhood,
            'displayName':
                _isArabic() ? neighborhood.arabicName : neighborhood.name,
            'matchScore': matchScore,
          });
        }
      }
    }

    // Sort by match score (highest first)
    results.sort((a, b) {
      double scoreA = a['matchScore'] ?? 0.0;
      double scoreB = b['matchScore'] ?? 0.0;
      return scoreB.compareTo(scoreA);
    });

    return results;
  }

  void _selectLocationFromSearch(Map<String, dynamic> result) {
    if (widget.onLocationSelected != null) {
      // Handle callback for EditProfileView
      String locationName;
      double lat, lng;

      if (result['type'] == 'city') {
        final city = result['city'] as CityModel;
        locationName = city.name;
        lat = city.latitude;
        lng = city.longitude;
      } else if (result['type'] == 'district') {
        final district = result['district'] as DistrictModel;
        final city = result['city'] as CityModel;
        locationName = "${district.name}, ${city.name}";
        lat = district.latitude;
        lng = district.longitude;
      } else if (result['type'] == 'neighborhood') {
        final neighborhood = result['neighborhood'] as NeighborhoodModel;
        final district = result['district'] as DistrictModel;
        final city = result['city'] as CityModel;
        locationName = "${neighborhood.name}, ${district.name}, ${city.name}";
        lat = neighborhood.latitude;
        lng = neighborhood.longitude;
      } else {
        locationName = result['displayName'] as String;
        lat = 0.0;
        lng = 0.0;
      }

      widget.onLocationSelected!(locationName, lat, lng);
    } else {
      // Original logic for HomeVM
      Navigator.pop(context);

      if (result['type'] == 'city') {
        final city = result['city'] as CityModel;
        widget.viewModel.selectCity(city);
      } else if (result['type'] == 'district') {
        final district = result['district'] as DistrictModel;
        final city = result['city'] as CityModel;
        widget.viewModel.selectDistrict(district, city);
      } else if (result['type'] == 'neighborhood') {
        final neighborhood = result['neighborhood'] as NeighborhoodModel;
        final district = result['district'] as DistrictModel;
        final city = result['city'] as CityModel;
        widget.viewModel.selectNeighborhood(neighborhood, district, city);
      }
    }
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
      _currentView = 'district_neighborhoods';
      _searchController.clear();
      _searchResults = [];
    });
  }

  void _selectCity(CityModel city) {
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(city.name, city.latitude, city.longitude);
    } else {
      Navigator.pop(context);
      widget.viewModel.selectCity(city);
    }
  }

  void _selectDistrict(DistrictModel district, CityModel city) {
    if (widget.onLocationSelected != null) {
      String locationName = "${district.name}, ${city.name}";
      widget.onLocationSelected!(
          locationName, district.latitude, district.longitude);
    } else {
      Navigator.pop(context);
      widget.viewModel.selectDistrict(district, city);
    }
  }

  void _selectNeighborhood(
      NeighborhoodModel neighborhood, DistrictModel district, CityModel city) {
    if (widget.onLocationSelected != null) {
      String locationName =
          "${neighborhood.name}, ${district.name}, ${city.name}";
      widget.onLocationSelected!(
          locationName, neighborhood.latitude, neighborhood.longitude);
    } else {
      Navigator.pop(context);
      widget.viewModel.selectNeighborhood(neighborhood, district, city);
    }
  }

  void _goBack() {
    setState(() {
      if (_currentView == 'search') {
        _currentView = _selectedDistrictForDetails != null
            ? 'district_neighborhoods'
            : _selectedCityForDetails != null
                ? 'city_districts'
                : 'main';
      } else if (_currentView == 'district_neighborhoods') {
        _currentView = 'city_districts';
        _selectedDistrictForDetails = null;
      } else if (_currentView == 'city_districts') {
        _currentView = 'main';
        _selectedCityForDetails = null;
        _selectedDistrictForDetails =
            null; // Also clear district when going back to main
      } else {
        Navigator.pop(context); // Exit the screen using Navigator.pop()
      }
      _searchController.clear();
      _searchResults = [];
    });
  }

  bool _isArabic() {
    return Directionality.of(context) == TextDirection.rtl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: _goBack,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20,
          ),
        ),
        automaticallyImplyLeading:
            false, // Add this to prevent default back button
        title: Text(
          _getHeaderTitle(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: _isArabic() ? 20 : 18,
                color: Colors.black,
              ),
          overflow: TextOverflow.ellipsis, // Fix overflow in title
        ),
        centerTitle: false,
        actions: [
          if (_shouldShowSeeAllButton())
            Padding(
              padding: EdgeInsets.only(
                right: _isArabic() ? 0 : 16,
                left: _isArabic() ? 16 : 0,
              ),
              child: _buildSeeAllButton(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          _buildSearchField(),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  bool _shouldShowSeeAllButton() {
    return (_currentView == 'city_districts' &&
            _selectedCityForDetails != null) ||
        (_currentView == 'district_neighborhoods' &&
            _selectedDistrictForDetails != null);
  }

  Widget _buildSeeAllButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade600.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (_currentView == 'city_districts' &&
                _selectedCityForDetails != null) {
              _selectCity(_selectedCityForDetails!);
            } else if (_currentView == 'district_neighborhoods' &&
                _selectedDistrictForDetails != null) {
              _selectDistrict(
                  _selectedDistrictForDetails!, _selectedCityForDetails!);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.apps,
                  color: Colors.white,
                  size: 16,
                ),
                const Gap(6),
                Text(
                  StringHelper.seeAll,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: _isArabic() ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: _getSearchHint(),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade600),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: _isArabic() ? 16 : 14,
          ),
        ),
        style: TextStyle(
          fontSize: _isArabic() ? 16 : 14,
        ),
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentView) {
      case 'search':
        if (_selectedDistrictForDetails != null) {
          return '${StringHelper.searchIn} ${_isArabic() ? _selectedDistrictForDetails!.arabicName : _selectedDistrictForDetails!.name}';
        } else if (_selectedCityForDetails != null) {
          return '${StringHelper.searchIn} ${_isArabic() ? _selectedCityForDetails!.arabicName : _selectedCityForDetails!.name}';
        }
        return StringHelper.searchResults;
      case 'city_districts':
        return _isArabic()
            ? (_selectedCityForDetails?.arabicName ?? StringHelper.districts)
            : (_selectedCityForDetails?.name ?? StringHelper.districts);
      case 'district_neighborhoods':
        return _isArabic()
            ? (_selectedDistrictForDetails?.arabicName ?? StringHelper.areas)
            : (_selectedDistrictForDetails?.name ?? StringHelper.areas);
      default:
        return StringHelper.chooseLocation;
    }
  }

  String _getSearchHint() {
    if (_selectedDistrictForDetails != null) {
      return '${StringHelper.searchAreasIn} ${_selectedDistrictForDetails!.name}...';
    } else if (_selectedCityForDetails != null) {
      return '${StringHelper.searchDistrictsAndAreasIn} ${_selectedCityForDetails!.name}...';
    }
    return StringHelper.searchCitiesDistrictsOrAreas;
  }

  Widget _buildContent() {
    switch (_currentView) {
      case 'search':
        return _buildSearchResults();
      case 'city_districts':
        return _buildCityDistricts();
      case 'district_neighborhoods':
        return _buildDistrictNeighborhoods();
      default:
        return _buildMainView();
    }
  }

  Widget _buildMainView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick options
          _buildQuickOptions(),

          const Gap(24),

          // Cities section with search hint
          _buildSectionHeader(StringHelper.majorCities,
              StringHelper.searchAboveToFindSpecificAreas),
          const Gap(12),
          _buildCitiesList(),

          const Gap(20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
                fontSize: _isArabic() ? 18 : 16,
              ),
        ),
        const Gap(4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
                fontSize: _isArabic() ? 14 : 12,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickOptions() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.public,
          iconColor: Colors.blue.shade600,
          title: StringHelper.allEgypt,
          subtitle: StringHelper.showAllListingsAcrossEgypt,
          onTap: () {
            if (widget.onLocationSelected != null) {
              widget.onLocationSelected!("All Egypt", 0.0, 0.0);
            } else {
              Navigator.pop(context);
              widget.viewModel.updateLatLong(address: "All Egypt");
            }
          },
        ),
        const Gap(8),
        _buildOptionTile(
          icon: Icons.my_location,
          iconColor: Colors.green.shade600,
          title: StringHelper.useCurrentLocation,
          subtitle: StringHelper.findListingsNearYou,
          onTap: () {
            if (widget.onLocationSelected != null) {
              // For EditProfileView, we'll just close and let them handle current location
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              widget.viewModel.handleCurrentLocation();
            }
          },
        ),
      ],
    );
  }

  Widget _buildCitiesList() {
    return Column(
      children: LocationService.majorEgyptianCities.map((city) {
        final hasDistricts =
            city.districts != null && city.districts!.isNotEmpty;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: _buildCityTile(city, hasDistricts),
        );
      }).toList(),
    );
  }

  Widget _buildCityTile(CityModel city, bool hasDistricts) {
    return InkWell(
      onTap: hasDistricts
          ? () => _showCityDistricts(city)
          : () => _selectCity(city),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.location_city,
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
                    _isArabic() ? city.arabicName : city.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: _isArabic() ? 16 : 14,
                        ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                  Text(
                    _isArabic() ? city.name : city.arabicName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: _isArabic() ? 12 : 12,
                        ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ],
              ),
            ),
            if (hasDistricts) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${city.districts!.length} ${StringHelper.districts}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: _isArabic() ? 13 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(8),
              Icon(
                Icons.arrow_forward_ios, // Keep this the same for all languages
                color: Colors.grey.shade400,
                size: 16,
              ),
            ] else
              Icon(
                Icons.location_on,
                color: Colors.grey.shade400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: _isArabic() ? 16 : 14,
                        ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: _isArabic() ? 14 : 12,
                        ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const Gap(16),
            Text(
              StringHelper.noResultsFound,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: _isArabic() ? 18 : 16,
                  ),
            ),
            const Gap(8),
            Text(
              _getEmptySearchMessage(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade400,
                    fontSize: _isArabic() ? 14 : 12,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultTile(result);
      },
    );
  }

  String _getEmptySearchMessage() {
    if (_selectedDistrictForDetails != null) {
      return '${StringHelper.noAreasFoundIn} ${_selectedDistrictForDetails!.name}';
    } else if (_selectedCityForDetails != null) {
      return '${StringHelper.noDistrictsOrAreasFoundIn} ${_selectedCityForDetails!.name}';
    }
    return StringHelper.trySearchingWithDifferentKeywords;
  }

  Widget _buildSearchResultTile(Map<String, dynamic> result) {
    final type = result['type'] as String;
    final displayName = result['displayName'] as String;

    IconData icon;
    Color iconColor;
    String typeLabel;

    switch (type) {
      case 'city':
        icon = Icons.location_city;
        iconColor = Colors.orange.shade600;
        typeLabel = StringHelper.city;
        break;
      case 'district':
        icon = Icons.location_city;
        iconColor = Colors.blue.shade600;
        typeLabel = StringHelper.district;
        break;
      case 'neighborhood':
        icon = Icons.home;
        iconColor = Colors.green.shade600;
        typeLabel = StringHelper.area;
        break;
      default:
        icon = Icons.location_on;
        iconColor = Colors.grey.shade600;
        typeLabel = StringHelper.location;
    }

    return InkWell(
      onTap: () => _selectLocationFromSearch(result),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: _isArabic() ? 16 : 14,
                        ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      typeLabel,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: _isArabic() ? 12 : 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDistricts() {
    if (_selectedCityForDetails?.districts == null ||
        _selectedCityForDetails!.districts!.isEmpty) {
      return Center(
        child: Text(
          'No districts available',
          style: TextStyle(fontSize: _isArabic() ? 16 : 14),
        ),
      );
    }

    return Column(
      children: [
        // Search hint for this level
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 16),
              const Gap(8),
              Expanded(
                child: Text(
                  '${StringHelper.searchAboveForDistrictsAndAreasIn} ${_selectedCityForDetails!.name}',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: _isArabic() ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _selectedCityForDetails!.districts!.length,
            separatorBuilder: (context, index) => const Gap(8),
            itemBuilder: (context, index) {
              final district = _selectedCityForDetails!.districts![index];
              final hasNeighborhoods = district.neighborhoods != null &&
                  district.neighborhoods!.isNotEmpty;

              return InkWell(
                onTap: hasNeighborhoods
                    ? () => _showDistrictNeighborhoods(district)
                    : () => _selectDistrict(district, _selectedCityForDetails!),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.location_city,
                          color: Colors.blue.shade600,
                          size: 18,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isArabic() ? district.arabicName : district.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: _isArabic() ? 16 : 14,
                                  ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                            // Only show the alternate name if it's different and not empty
                            if ((_isArabic()
                                        ? district.name
                                        : district.arabicName)
                                    .isNotEmpty &&
                                (_isArabic()
                                        ? district.name
                                        : district.arabicName) !=
                                    (_isArabic()
                                        ? district.arabicName
                                        : district.name))
                              Text(
                                _isArabic()
                                    ? district.name
                                    : district.arabicName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                      fontSize: _isArabic() ? 12 : 12,
                                    ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                          ],
                        ),
                      ),
                      if (hasNeighborhoods) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${district.neighborhoods!.length} ${StringHelper.areas}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: _isArabic() ? 13 : 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
                          size: 16,
                        ),
                      ] else
                        Icon(
                          Icons.location_on,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDistrictNeighborhoods() {
    if (_selectedDistrictForDetails?.neighborhoods == null ||
        _selectedDistrictForDetails!.neighborhoods!.isEmpty) {
      return Center(
        child: Text(
          'No areas available',
          style: TextStyle(fontSize: _isArabic() ? 16 : 14),
        ),
      );
    }

    return Column(
      children: [
        // Search hint for this level
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.green.shade600, size: 16),
              const Gap(8),
              Expanded(
                child: Text(
                  '${StringHelper.searchAboveForAreasIn} ${_selectedDistrictForDetails!.name}',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: _isArabic() ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _selectedDistrictForDetails!.neighborhoods!.length,
            separatorBuilder: (context, index) => const Gap(8),
            itemBuilder: (context, index) {
              final neighborhood =
                  _selectedDistrictForDetails!.neighborhoods![index];

              return InkWell(
                onTap: () => _selectNeighborhood(neighborhood,
                    _selectedDistrictForDetails!, _selectedCityForDetails!),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.home,
                          color: Colors.green.shade600,
                          size: 18,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isArabic()
                                  ? neighborhood.arabicName
                                  : neighborhood.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: _isArabic() ? 16 : 14,
                                  ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                            // Only show the alternate name if it's different and not empty
                            if ((_isArabic()
                                        ? neighborhood.name
                                        : neighborhood.arabicName)
                                    .isNotEmpty &&
                                (_isArabic()
                                        ? neighborhood.name
                                        : neighborhood.arabicName) !=
                                    (_isArabic()
                                        ? neighborhood.arabicName
                                        : neighborhood.name))
                              Text(
                                _isArabic()
                                    ? neighborhood.name
                                    : neighborhood.arabicName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                      fontSize: _isArabic() ? 12 : 12,
                                    ),
                                overflow:
                                    TextOverflow.ellipsis, // Prevent overflow
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
