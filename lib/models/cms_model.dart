class CmsModel {
  final String? createdAt;
  final String? description;
  final num? id;
  final String? title;
  final num? type;
  final num? status;
  final String? updatedAt;

  CmsModel({
    this.createdAt,
    this.description,
    this.id,
    this.title,
    this.type,
    this.status,
    this.updatedAt,
  });

  factory CmsModel.fromJson(Map<String, dynamic> json) {
    return CmsModel(
      createdAt: json['createdAt'],
      description: json['description'],
      id: json['id'],
      title: json['title'],
      type: json['type'],
      status: json['status'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,
        'description': description,
        'id': id,
        'title': title,
        'type': type,
        'status': status,
        'updatedAt': updatedAt,
      };
}
