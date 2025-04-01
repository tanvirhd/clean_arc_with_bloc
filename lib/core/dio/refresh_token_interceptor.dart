import 'dart:developer';

import 'package:dio/dio.dart';

class RefreshTokenInterceptor extends QueuedInterceptorsWrapper {
  RefreshTokenInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log("---> API URL: ${options.uri}");
    log("---> REQUEST BODY: ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<--- API URL: ${response.realUri}");
    log("<--- RESPONSE BODY: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    log("-^-^-> ERROR(status): ${err.response?.statusCode}");
    log("-^-^-> ERROR(type): ${err.type}");
    log("-^-^-> ERROR(message): ${err.message}");
    log("-^-^-> ERROR(response): ${err.response}");
    super.onError(err, handler);
  }
}
