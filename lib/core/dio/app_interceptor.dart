import 'dart:developer';
import 'package:clean_arc_bloc/core/dio/dio_helper.dart';
import 'package:clean_arc_bloc/core/error/custom_dio_errors.dart';
import 'package:clean_arc_bloc/core/model/basic_response.dart';
import 'package:dio/dio.dart';


class AppInterceptor extends QueuedInterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    log("---> API URL (AppInterceptor): ${options.uri}");
    log("---> REQUEST BODY (AppInterceptor): ${options.data}");
    log("---> HEADER(AppInterceptor): ${options.headers.toString()}");

    RequestOptions requestOption = await DioHelper().setHeaders(options);
    log("---> REQUEST HEADER(AppInterceptor): ${requestOption.headers}");

    if (await DioHelper().isInternetAvailable()) {
      //has internet
      super.onRequest(requestOption, handler);
    } else {
      //no internet
      handler.reject(NoInternetError(
          options: options,
          err: BasicResponse(
              message: DioHelper().noInternetMessage("en"))));
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    log("<--- API URL(AppInterceptor): ${response.realUri}");
    log("<--- RESPONSE BODY(AppInterceptor): ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("-^-^-> ERROR(status)(AppInterceptor): ${err.response?.statusCode}");
    log("-^-^-> ERROR(type)(AppInterceptor): ${err.type}");
    log("-^-^-> ERROR(message)(AppInterceptor): ${err.message}");
    log("-^-^-> ERROR(response)(AppInterceptor): ${err.response}");
    super.onError(err, handler);

    /*if (err.response?.statusCode == 403) {
      //invalid token, try to refresh token
      final response = await DioHelper().refreshToken();
      if (response != null && response.statusCode! < 400) {
        BaseResponse parsedResponse = BaseResponse<RefreshTokenData>.parseAsObject(jsonDecode(response.data), RefreshTokenData.fromJson);
        await SharedPreferenceHelper().setStringAsEncrypt(REFRESH_TOKEN, (parsedResponse.data as RefreshTokenData).refreshToken ?? "");
        await SharedPreferenceHelper().setStringAsEncrypt(AUTHORIZATION_TOKEN, (parsedResponse.data as RefreshTokenData).accessToken ?? "");
        err.response?.requestOptions.headers["Authorization"] = "JWT ${(parsedResponse.data as RefreshTokenData).accessToken}";

        //retry api call
        Future retriedResponse = DioHelper().retry(
            err.response!.requestOptions,
            DioHelper().createRetryDioInstance()
        );
        retriedResponse.then((value) {
          handler.resolve(value);
        }).catchError((error, stack) {
          //retry api call failed
          onError(error, handler);
        });
      } else {
        //token refresh failed
        if (response?.data != null) {
          log("caught(AppInterceptor): InvalidTokenError line:79");
          super.onError(
              InvalidTokenError(
                  options: err.requestOptions,
                  err: BasicResponse.fromJson(jsonDecode(response!.data))),
              handler);
        } else {
          log("caught(AppInterceptor): UnknownError line:84");
          super.onError(UnknownError(options: err.requestOptions), handler);
        }
      }
    } else if (err.response?.data != null &&
        !err.response!.data.toString().contains("<!doctype html>")) {
      //error with response
      BasicResponse? errorResponse = BasicResponse.fromJson(jsonDecode(err.response?.data));
      super.onError(
          DioException(
              requestOptions: err.requestOptions,
              error: errorResponse,
              type: DioExceptionType.badResponse),
          handler);
    } else {
      log("caught(AppInterceptor): error line:100");
      super.onError(err, handler);
    }*/
  }
}
