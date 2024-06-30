import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/media_model.dart';
import 'package:list_and_life/network/api_constants.dart';
import 'package:mime/mime.dart';

import '../helpers/db_helper.dart';
import '../helpers/dialog_helper.dart';
import '../routes/app_pages.dart';
import 'api_request.dart';
import 'app_exceptions.dart';
import 'no_internet_page.dart';

class BaseClient {
  static BuildContext? context = AppPages.rootNavigatorKey.currentContext;
  static final Dio _dio = Dio();

  static Future<dynamic> handleRequest(ApiRequest apiRequest) async {
    _dio.options.followRedirects = false;
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.interceptors.clear();
    _dio.interceptors.add(AppExceptions());

    bool isOnline = await hasNetwork();
    if (!isOnline) {
      DialogHelper.showToast(message: 'No Internet, Please try later!');
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
      'Content-Type': 'application/json'
    };
    if (apiRequest.headers != null) {
      headers.addAll(apiRequest.headers!);
    }

    if (DbHelper.getToken() != null) {
      headers.putIfAbsent(
          'Authorization', () => 'Bearer ${DbHelper.getToken()}');
    }

    switch (apiRequest.requestType) {
      case RequestType.POST:
        return await _handlePostRequest(apiRequest, headers);
      case RequestType.GET:
        var response = await _dio.get(apiRequest.url,
            options: Options(
              headers: headers,
            ));

        return response.data;
      case RequestType.DELETE:
        var response = await _dio.delete(apiRequest.url,
            data: apiRequest.body,
            options: Options(
              headers: headers,
            ));
        return response.data;

      case RequestType.PUT:
        return await _handlePutRequest(apiRequest, headers);
    }
  }

  static Future<dynamic> _handlePutRequest(
      ApiRequest apiRequest, Map<String, dynamic> headers) async {
    var data;
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
      print(response.data);
    }
    return response.data;
  }

  static Future<dynamic> _handlePostRequest(
      ApiRequest apiRequest, Map<String, dynamic> headers) async {
    var data;
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

    var res = await _dio.post(apiRequest.url,
        data: data,
        options: Options(
          headers: headers,
        ));
    return res.data;
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
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
        requestType: RequestType.POST,
        bodyType: BodyType.formData,
        body: body);

    var response = await handleRequest(apiRequest);

    MapResponse<MediaModel> model =
        MapResponse.fromJson(response, (json) => MediaModel.fromJson(json));

    return model.body?.media ?? '';
  }
}
