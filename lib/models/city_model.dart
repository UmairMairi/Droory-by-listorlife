// lib/models/city_model.dart - MODIFY your existing file
class CityModel {
  final String name;
  final String arabicName;
  final double latitude;
  final double longitude;
  final double defaultRadius;
  final List<DistrictModel>? districts; // ADD THIS LINE

  const CityModel({
    required this.name,
    required this.arabicName,
    required this.latitude,
    required this.longitude,
    this.defaultRadius = 30.0,
    this.districts, // ADD THIS LINE
  });

  // ADD fromJson and toJson if you don't have them
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      arabicName: json['arabic_name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      defaultRadius: (json['default_radius'] ?? 30.0).toDouble(),
      districts: (json['districts'] as List<dynamic>?)
          ?.map((district) => DistrictModel.fromJson(district))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabic_name': arabicName,
      'latitude': latitude,
      'longitude': longitude,
      'default_radius': defaultRadius,
      'districts': districts?.map((d) => d.toJson()).toList(),
    };
  }
}

// ADD these new classes to the same file
class DistrictModel {
  final String name;
  final String arabicName;
  final double latitude;
  final double longitude;
  final double radius;
  final List<NeighborhoodModel>? neighborhoods;

  const DistrictModel({
    required this.name,
    required this.arabicName,
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
    this.neighborhoods,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      name: json['name'] ?? '',
      arabicName: json['arabic_name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      radius: (json['radius'] ?? 10.0).toDouble(),
      neighborhoods: (json['neighborhoods'] as List<dynamic>?)
          ?.map((neighborhood) => NeighborhoodModel.fromJson(neighborhood))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabic_name': arabicName,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'neighborhoods': neighborhoods?.map((n) => n.toJson()).toList(),
    };
  }
}

class NeighborhoodModel {
  final String name;
  final String arabicName;
  final double latitude;
  final double longitude;
  final double radius;

  const NeighborhoodModel({
    required this.name,
    required this.arabicName,
    required this.latitude,
    required this.longitude,
    this.radius = 5.0,
  });

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return NeighborhoodModel(
      name: json['name'] ?? '',
      arabicName: json['arabic_name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      radius: (json['radius'] ?? 5.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabic_name': arabicName,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }
}
