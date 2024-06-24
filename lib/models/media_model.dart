class MediaModel {
  String? media;

  MediaModel({this.media});

  MediaModel.fromJson(Map<String, dynamic> json) {
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['media'] = media;
    return data;
  }
}
