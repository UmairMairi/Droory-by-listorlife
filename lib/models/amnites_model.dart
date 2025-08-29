class AmenitiesModel {
  int? id;
  String? name;
  String? nameAr; // Arabic name
  int? status;
  String? createdAt;
  String? updatedAt;

  AmenitiesModel({
    this.id,
    this.name,
    this.nameAr,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Deserialize JSON to ParkingModel
  AmenitiesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  // Serialize ParkingModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
