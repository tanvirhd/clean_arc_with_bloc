import 'dart:developer';
import 'package:clean_arc_bloc/core/dio/dio_helper.dart';
import 'package:clean_arc_bloc/core/error/custom_dio_errors.dart';
import 'package:clean_arc_bloc/core/model/basic_response.dart';
import 'package:dio/dio.dart';


class RetryInterceptor extends QueuedInterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log("---> API URL(RetryInterceptor): ${options.uri}");
    log("---> REQUEST BODY(RetryInterceptor): ${options.data}");
    log("---> HEADER(RetryInterceptor): ${options.headers.toString()}");

    if (await DioHelper().isInternetAvailable()) {
      //has internet
      super.onRequest(options, handler);
    } else {
      //no internet
      handler.reject(NoInternetError(
          options: options,
          err: BasicResponse(message: DioHelper().noInternetMessage("en"))));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    log("<--- API URL(RetryInterceptor): ${response.realUri}");
    log("<--- RESPONSE BODY(RetryInterceptor): ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("-^-^-> ERROR(status)(RetryInterceptor): ${err.response?.statusCode}");
    log("-^-^-> ERROR(type)(RetryInterceptor): ${err.type}");
    log("-^-^-> ERROR(message)(RetryInterceptor): ${err.message}");
    log("-^-^-> ERROR(response)(RetryInterceptor): ${err.response}");

    super.onError(err, handler);
  }
}
