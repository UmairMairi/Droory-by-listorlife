class CategoryModel {
  int? id;
  int? subCategoryId;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? media;
  CategoryModel(
      {this.id,
      this.subCategoryId,
      this.name,
      this.image,
      this.media,
      this.status,
      this.createdAt,
      this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['sub_category_id'];
    name = json['name'];
    image = json['image'];
    media = json['media'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_category_id'] = subCategoryId;
    data['name'] = name;
    data['image'] = image;
    data['media'] = media;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
