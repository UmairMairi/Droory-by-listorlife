enum RequestType { POST, GET, DELETE, PUT }

class ApiRequest {
  final String url;
  final RequestType requestType;
  final Map<String, dynamic>? headers;
  final dynamic body;

  ApiRequest(
      {required this.url, this.headers, required this.requestType, this.body});
}
