class MapResponse<TModel> {
  bool? success;
  String? message;
  TModel? body;
  int? code;

  MapResponse({this.success, this.message, this.body, this.code});

  factory MapResponse.fromJson(
      Map<String, dynamic> json, TModel Function(dynamic json) fromJsonT) {
    return MapResponse<TModel>(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      body: fromJsonT(json['body']),
      code: json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson(dynamic Function(TModel? value) toJsonT) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['body'] = toJsonT(body);
    data['code'] = code;
    return data;
  }
}
