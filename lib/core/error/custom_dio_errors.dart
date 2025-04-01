import 'package:clean_arc_bloc/core/model/basic_response.dart';
import 'package:dio/dio.dart';

abstract class CustomDioError extends DioError {
  BasicResponse err;

  CustomDioError({
    required this.err,
    required RequestOptions options,
    super.response,
    DioExceptionType? type
  }) : super (
      requestOptions: options,
      type: type ?? DioExceptionType.unknown,
      error: err
  );
}

class NoInternetError extends CustomDioError {
  NoInternetError({BasicResponse? err, required super.options}) : super(
     err: err ?? BasicResponse(code: "", message: "No Internet")
  );
}


class InvalidTokenError extends CustomDioError {
  InvalidTokenError({BasicResponse? err, required super.options}) : super(
      err: err ?? BasicResponse(code: "", message: "Invalid token")
  );
}

class DataParseError extends CustomDioError {
  DataParseError({BasicResponse? err, required super.options}) : super(
      err: err ?? BasicResponse(code: "", message: "Model parse failed")
  );
}

class UnknownError extends CustomDioError {
  UnknownError({BasicResponse? err, required super.options}) : super(
      err: err ?? BasicResponse(code: "", message: "Unknown Error")
  );
}
