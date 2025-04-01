import 'dart:convert';
import 'dart:developer';
import 'package:clean_arc_bloc/config/app_constant.dart';
import 'package:clean_arc_bloc/config/end_point.dart';
import 'package:clean_arc_bloc/core/dio/app_interceptor.dart';
import 'package:clean_arc_bloc/core/dio/no_auth_interceptor.dart';
import 'package:clean_arc_bloc/core/dio/refresh_token_interceptor.dart';
import 'package:clean_arc_bloc/core/dio/retry_interceptor.dart';
import 'package:clean_arc_bloc/core/utils/shared_pref_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_utils/src/platform/platform.dart';

final dio = Dio(
    BaseOptions(
        connectTimeout: Duration(milliseconds: TIMEOUT_TIME),
        receiveTimeout: Duration(milliseconds: TIMEOUT_TIME),
        baseUrl: BASE_URL_PRODUCTION,
        responseType: ResponseType.plain
    )
);

class DioHelper {

  Dio getDioInstance({bool withAuthInterceptor = true}) {
    dio.interceptors.add(withAuthInterceptor ? AppInterceptor() : NoAuthInterceptor());
    return dio;
  }

  Dio createRetryDioInstance() {
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: Duration(milliseconds: TIMEOUT_TIME),
      receiveTimeout: Duration(milliseconds: TIMEOUT_TIME),
      baseUrl: BASE_URL_PRODUCTION,
      responseType: ResponseType.plain,
    );

    var dio = Dio(baseOptions);
    dio.interceptors.add(RetryInterceptor());
    return dio;
  }

  cancelApiCall({required CancelToken cancelToken}) {
    cancelToken.cancel();
  }

  Future<bool> isInternetAvailable() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile));
  }

  Future<bool> isConnectedToVPN() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.vpn);
  }

  Future<RequestOptions> setHeaders(RequestOptions options) async {
    //String? accessToken = await SharedPreferenceHelper().getEncryptedString(AUTHORIZATION_TOKEN);

    //add header to request option
    options.headers["Content-Type"] = "application/json";
    options.headers["Accept-Language"] = getx.Get.locale?.languageCode ?? "en";

    return options;
  }

  String connectedToVpnMessage(String language) {
    return language == "en"
        ? "Sorry, Bhorosha app is accessible only from Bangladesh!"
        : "দুঃখিত, Bhorosha অ্যাপ শুধুমাত্র বাংলাদেশ থেকে ব্যবহার করা যাবে।";
  }

  String noInternetMessage(String language) {
    return language == "en"
        ? "Not connected with internet"
        : "ইন্টারনেট সংযোগ নেই";
  }

  Future<Response?> refreshToken() async {
    dio.interceptors.add(RefreshTokenInterceptor());
    String? rToken = await SharedPreferenceHelper().getEncryptedString(REFRESH_TOKEN);
    if (rToken != null && rToken.isNotEmpty) {
      try {
        final response = await dio.post(refreshTokenEndPoint, data: {'refresh_token': rToken});
        return response;
      } catch (e) {
        if (e is DioException && e.response != null) {
          return e.response;
        } else {
          return null;
        }
      }
    } else {
      return Response(
        requestOptions: RequestOptions(path: refreshTokenEndPoint),
        data: jsonEncode({"message": "Invalid refresh token"}),
        statusCode: 400,
      );
    }
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions, Dio dio) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
