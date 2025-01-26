import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/media_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:mime/mime.dart';

import '../../routes/app_pages.dart';
import '../helpers/db_helper.dart';
import '../helpers/dialog_helper.dart';
import 'api_request.dart';
import 'app_exceptions.dart';
import 'no_internet_page.dart';

class BaseClient {
  static BuildContext? context = AppPages.rootNavigatorKey.currentContext;
  static final Dio _dio = Dio();

  static Future<dynamic> handleRequest(ApiRequest apiRequest) async {
    _dio.options.followRedirects = false;
    _dio.options.connectTimeout = const Duration(seconds: 50);
    _dio.options.receiveTimeout = const Duration(seconds: 50);
    _dio.interceptors.clear();
    _dio.interceptors.add(AppExceptions());

    bool isOnline = await hasNetwork();
    if (!isOnline) {
      DialogHelper.showToast(message: StringHelper.noInternet);
      Navigator.push(
          context!,
          MaterialPageRoute(
              builder: (context) => NoInternetPage(
                callBack: (apiRequest) {
                  handleRequest(apiRequest);
                },
                apiRequest: apiRequest,
              )));
      return;
    }

    Map<String, dynamic> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'language_type': DbHelper.getLanguage(),
    };
    if (apiRequest.headers != null) {
      headers.addAll(apiRequest.headers??{});
    }
    if (DbHelper.getToken() != null) {
      headers.putIfAbsent(
          'Authorization', () => 'Bearer ${DbHelper.getToken()}');
    }

    try {
      switch (apiRequest.requestType) {
        case RequestType.post:
          return await _handlePostRequest(apiRequest, headers);
        case RequestType.get:
          var response = await _dio.get(apiRequest.url,
              options: Options(
                headers: headers,
              ));
          return response.data;
        case RequestType.delete:
          var response = await _dio.delete(apiRequest.url,
              data: apiRequest.body,
              options: Options(
                headers: headers,
              ));
          return response.data;
        case RequestType.put:
          return await _handlePutRequest(apiRequest, headers);
      }
    } catch (e) {
      return handleError(e);
    }
  }

  static Future<dynamic> _handlePutRequest(
      ApiRequest apiRequest, Map<String, dynamic> headers) async {
    dynamic data;
    switch (apiRequest.bodyType) {
      case BodyType.raw:
        data = apiRequest.body;
        headers['Content-Type'] = 'text/plain';
        break;
      case BodyType.json:
        data = apiRequest.body;
        headers['Content-Type'] = 'application/json';
        break;
      case BodyType.multipart:
        headers['Content-Type'] = 'multipart/form-data';
        data = apiRequest.body;
        break;
      case BodyType.formData:
      default:
        data = FormData.fromMap(apiRequest.body);
        break;
    }

    var response = await _dio.put(apiRequest.url,
        data: data,
        options: Options(
          headers: headers,
        ));
    if (kDebugMode) {
      debugPrint('Put Response: ${response.data}');
    }
    return response.data;
  }

  static Future<dynamic> _handlePostRequest(
      ApiRequest apiRequest, Map<String, dynamic> headers) async {
    dynamic data;
    switch (apiRequest.bodyType) {
      case BodyType.raw:
        data = apiRequest.body;
        headers['Content-Type'] = 'text/plain';
        break;
      case BodyType.json:
        data = apiRequest.body;
        headers['Content-Type'] = 'application/json';
        break;
      case BodyType.multipart:
        headers['Content-Type'] = 'multipart/form-data';
        data = apiRequest.body;
        break;
      case BodyType.formData:
      default:
        data = FormData.fromMap(apiRequest.body);
        break;
    }

    var response = await _dio.post(apiRequest.url,
        data: data,
        options: Options(
          headers: headers,
        ));
    if (kDebugMode) {
      debugPrint('Post Response: ${response.data}');
    }
    return response.data;
  }

  static Response handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        DialogHelper.showToast(
            message: error.response?.data['message'] ?? 'Something went wrong');
        debugPrint('Dio Error Response: ${error.response?.data}');
        return error.response!;
      }
      DialogHelper.showToast(
          message: error.message ?? 'Connection failed or timed out');
      debugPrint('Dio Error Message: ${error.message}');
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: error.message ?? 'Unknown error',
      );
    } else {
      DialogHelper.showToast(message: error.toString());
      debugPrint('Unknown Error: $error');
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: error.toString(),
      );
    }
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      debugPrint('Network check failed: $e');
    }
    return false;
  }

  static Future<MultipartFile> getMultipartImage({required String path}) async {
    final mimeType = lookupMimeType(path);
    return await MultipartFile.fromFile(path,
        filename: path.split('/').last,
        contentType: MediaType(
            mimeType?.split('/').first ?? '', mimeType?.split('/').last ?? ''));
  }

  static Future<String> uploadImage({required String imagePath}) async {
    Map<String, dynamic> body = {
      'media': await getMultipartImage(path: imagePath),
    };
    ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.uploadMediaUrl(),
        requestType: RequestType.post,
        bodyType: BodyType.formData,
        body: body);

    var response = await handleRequest(apiRequest);

    MapResponse<MediaModel> model =
    MapResponse.fromJson(response, (json) => MediaModel.fromJson(json));

    return model.body?.media ?? '';
  }
}
