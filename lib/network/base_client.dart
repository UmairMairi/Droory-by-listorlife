import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
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
        var res = await _dio.post(apiRequest.url,
            data: apiRequest.body,
            options: Options(
              headers: headers,
            ));
        return res.data;
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
        var response = await _dio.put(apiRequest.url,
            data: apiRequest.body,
            options: Options(
              headers: headers,
            ));
        if (kDebugMode) {
          print(response.data);
        }
        return response.data;
    }
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
}
