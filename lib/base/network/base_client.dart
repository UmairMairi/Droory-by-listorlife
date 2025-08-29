import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/models/common/map_response.dart';
import 'package:list_and_life/models/media_model.dart';
import 'package:list_and_life/base/network/api_constants.dart';
import 'package:list_and_life/routes/app_routes.dart';
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
      headers.addAll(apiRequest.headers ?? {});
    }
    if (DbHelper.getToken() != null) {
      headers.putIfAbsent(
          'Authorization', () => 'Bearer ${DbHelper.getToken()}');
    }

    try {
      Response response;
      switch (apiRequest.requestType) {
        case RequestType.post:
          response = await _handlePostRequest(apiRequest, headers);
          break;
        case RequestType.get:
          response = await _dio.get(apiRequest.url,
              options: Options(
                headers: headers,
              ));
          break;
        case RequestType.delete:
          response = await _dio.delete(apiRequest.url,
              data: apiRequest.body,
              options: Options(
                headers: headers,
              ));
          break;
        case RequestType.put:
          response = await _handlePutRequest(apiRequest, headers);
          break;
      }

      // Check if user is deleted/banned after each successful API call
      await _checkUserStatus(response);

      return response.data;
    } catch (e) {
      return handleError(e);
    }
  }

  // NEW METHOD: Check if user is deleted or banned
  static Future<void> _checkUserStatus(Response response) async {
    try {
      // Check if response indicates user is deleted/banned
      if (response.data is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response.data;

        // Check for specific error codes that indicate user is deleted/banned
        if (responseData['success'] == false) {
          String? message = responseData['message']?.toString().toLowerCase();

          if (message != null &&
              (message.contains('user not found') ||
                  message.contains('account deleted') ||
                  message.contains('account banned') ||
                  message.contains('user banned') ||
                  message.contains('unauthorized'))) {
            await _forceLogout('Your account has been deleted or banned.');
            return;
          }
        }
      }

      // Additional check: If response status indicates unauthorized (401)
      if (response.statusCode == 401) {
        // Check the response data for our specific messages
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> responseData = response.data;
          String? message = responseData['message']?.toString().toLowerCase();

          if (message != null &&
              (message.contains('user not found') ||
                  message.contains('account deleted') ||
                  message.contains('account banned'))) {
            await _forceLogout('Your account has been deleted or banned.');
            return;
          }
        }

        await _forceLogout('Session expired. Please login again.');
      }
    } catch (e) {
      print('Error checking user status: $e');
    }
  }

  // NEW METHOD: Force logout user
  static Future<void> _forceLogout(String message) async {
    try {
      // Clear all user data using your existing DbHelper methods
      DbHelper.saveUserModel(null);
      DbHelper.saveToken(null);
      DbHelper.saveIsLoggedIn(false);
      DbHelper.saveIsVerified(false);
      DbHelper.saveIsGuest(true);

      // Show message to user
      DialogHelper.showToast(message: message);

      // Navigate to login screen using GoRouter
      if (context != null) {
        GoRouter.of(context!).go(Routes.login);
      } else if (AppPages.rootNavigatorKey.currentContext != null) {
        GoRouter.of(AppPages.rootNavigatorKey.currentContext!).go(Routes.login);
      }
    } catch (e) {
      print('Error during force logout: $e');
    }
  }

  static Future<Response> _handlePutRequest(
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
    return response;
  }

  static Future<Response> _handlePostRequest(
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
    return response;
  }

  static Response handleError(dynamic error) {
    print('[BaseClient.handleError] Entered with error: $error');
    print('[BaseClient.handleError] Error runtimeType: ${error.runtimeType}');

    if (error is DioException) {
      print('[BaseClient.handleError] Error is DioException.');
      if (error.response != null) {
        print('[BaseClient.handleError] DioException has a response.');
        print(
            '[BaseClient.handleError] Response status code: ${error.response?.statusCode}');
        print(
            '[BaseClient.handleError] Response data type: ${error.response?.data.runtimeType}');
        String responseDataPreview = error.response?.data.toString() ?? "null";
        if (responseDataPreview.length > 150)
          responseDataPreview = "${responseDataPreview.substring(0, 150)}...";
        print(
            '[BaseClient.handleError] Response data preview: $responseDataPreview');

        String extractedMessage = 'Something went wrong. Please try again.';

        if (error.response?.data is Map<String, dynamic>) {
          extractedMessage =
              (error.response!.data as Map<String, dynamic>)['message']
                      ?.toString() ??
                  'Error: No message field in response data.';
          print(
              '[BaseClient.handleError] Extracted message from Map data: "$extractedMessage"');

          // CHECK FOR USER DELETION/BAN HERE IN ERROR HANDLER
          String? message = extractedMessage.toLowerCase();
          if (message.contains('user not found') ||
              message.contains('account deleted') ||
              message.contains('account banned') ||
              message.contains('user banned')) {
            print(
                '[BaseClient.handleError] 🚨 User deleted/banned detected! Force logout triggered.');

            // Trigger logout immediately
            try {
              _forceLogout('Your account has been deleted or banned.');
            } catch (e) {
              print('[BaseClient.handleError] Error during force logout: $e');
            }
          }
        } else if (error.response?.data is String) {
          extractedMessage =
              'Received an unexpected error format from the server (Status: ${error.response?.statusCode}).';
          print(
              '[BaseClient.handleError] Response data is a String. Using generic message or the string itself.');
        } else if (error.response?.statusCode == 404) {
          extractedMessage =
              'The requested resource was not found (Error 404).';
          print(
              '[BaseClient.handleError] Status is 404. Setting specific message.');
        }

        bool shouldNotShowToast = extractedMessage.contains('must wait') ||
            extractedMessage.contains('minute') ||
            extractedMessage.contains('after restoring') ||
            extractedMessage.contains('deletion');

        if (!shouldNotShowToast) {
          DialogHelper.showToast(message: extractedMessage);
        }

        print(
            '[BaseClient.handleError] Final Error Response Data from Dio: ${error.response?.data}');
        return error.response!;
      } else {
        print(
            '[BaseClient.handleError] DioException without a response. Message: ${error.message}');
        DialogHelper.showToast(
            message:
                'Network error or server unreachable. Please check your connection.');
        return Response(
          requestOptions: error.requestOptions,
          statusCode: 503,
          statusMessage:
              'Network error or server unreachable: ${error.message}',
        );
      }
    } else {
      print(
          '[BaseClient.handleError] Error is NOT a DioException. Error: $error');
      DialogHelper.showToast(
          message: 'An unexpected error occurred. Please try again.');
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 500,
        statusMessage: 'Unexpected error: ${error.toString()}',
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

  static Future<String> uploadFile({required String filePath}) async {
    Map<String, dynamic> body = {
      'media': await getMultipartImage(path: filePath),
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
