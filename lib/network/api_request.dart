enum RequestType { post, get, delete, put }

enum BodyType { formData, raw, json, multipart }

class ApiRequest {
  final String url;
  final RequestType requestType;
  final Map<String, dynamic>? headers;
  final dynamic body;
  final BodyType bodyType;

  ApiRequest({
    required this.url,
    this.headers,
    required this.requestType,
    this.body,
    this.bodyType = BodyType.formData, // Default to formData
  });
}
