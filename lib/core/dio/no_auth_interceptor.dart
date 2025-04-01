import 'dart:developer';
import 'package:clean_arc_bloc/core/dio/dio_helper.dart';
import 'package:clean_arc_bloc/core/error/custom_dio_errors.dart';
import 'package:clean_arc_bloc/core/model/basic_response.dart';
import 'package:dio/dio.dart';


class NoAuthInterceptor extends QueuedInterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    log("---> API URL(NoAuthInterceptor): ${options.uri}");
    log("---> REQUEST BODY(NoAuthInterceptor): ${options.data}");
    //log("---> HEADER(NoAuthInterceptor): ${options.headers.toString()}");

    RequestOptions requestOption = await DioHelper().setHeaders(options);
    log("---> REQUEST HEADER(NoAuthInterceptor): ${requestOption.headers}");

    if (await DioHelper().isInternetAvailable()) {
      //has internet, proceed network call
      super.onRequest(options, handler);
    } else {
      //no internet
      handler.reject(NoInternetError(
          options: options,
          err: BasicResponse(message: DioHelper().noInternetMessage("en"))
      ));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("<--- API URL(NoAuthInterceptor): ${response.realUri}");
    log("<--- RESPONSE BODY(NoAuthInterceptor): ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("-^-^-> ERROR(status)(NoAuthInterceptor): ${err.response?.statusCode}");
    log("-^-^-> ERROR(type)(NoAuthInterceptor): ${err.type}");
    log("-^-^-> ERROR(message)(NoAuthInterceptor): ${err.message}");
    log("-^-^-> ERROR(response)(NoAuthInterceptor): ${err.response}");
    super.onError(err, handler);
  }
}
