import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:list_and_life/helpers/dialog_helper.dart';

class AppExceptions extends Interceptor {
  static const divider =
      "------------------------------------------------------------------------------------";

  String logObject(Object object) {
    return const JsonEncoder.withIndent('  ')
        .convert(json.decode(json.encode(object)));
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      "\n  Sending ${options.method.toUpperCase()} request to:\n${options.baseUrl}${options.path}\n",
      name: 'Request',
    );

    log(
      "  Headers:\n${options.headers.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}\n",
    );

    log(
      "  Query Parameters:\n${options.queryParameters.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}\n",
    );

    if (options.data != null) {
      try {
        final formData = options.data as FormData;
        log(
          "  Body:\n${formData.fields.map((e) => '  ${e.key}: ${e.value}').join('\n')}\n",
        );
      } catch (e) {
        log(
          "Body:\n${logObject(options.data)}\n",
        );
      }
    }

    log("  END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("\n❌ ERROR:\n${err.message}\n", name: 'Error');
    log("URL: ${err.response?.requestOptions != null ? err.response!.requestOptions.uri.toString() : 'Unknown'}\n");
    log(
      "Error Response:\n${err.response != null ? logObject(err.response!.data) : 'Unknown Error'}\n",
    );
    log("❌ End error");
    log("$divider\n");
    DialogHelper.hideLoading();
    // ... (error handling logic)

    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "\n✅ Received ${response.statusCode} response from:\n${response.requestOptions.uri.toString()}\n",
      name: 'Response',
    );

    //\\ log(" Headers:\n${response.headers?.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}\n");
    response.headers.forEach((k, v) => log('  $k: $v'));
    log(" Response Data:\n${logObject(response.data)}\n");
    log("$divider\n");

    return super.onResponse(response, handler);
  }
}
