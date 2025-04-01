import 'dart:developer';
import 'package:clean_arc_bloc/core/error/custom_dio_errors.dart';
import 'package:clean_arc_bloc/core/model/basic_response.dart';
import 'package:dio/dio.dart';


abstract class Failure {
  final String? errorDescription;
  final String? statusCode;

  const Failure({this.errorDescription, this.statusCode});

  static Failure mapExceptionToFailure(Object error) {
    log("error type = ${error.toString()}");
    Failure failure;
    if (error is CustomDioError) {
      if (error is NoInternetError) {
        failure = NoInternetFailure(errorDescription: error.err.message);
      }else if (error is InvalidTokenError) {
        failure = InvalidTokenFailure(errorDescription: error.err.message);
      } else if (error is DataParseError) {
        failure = DataParseFailure(
            errorDescription: error.err.message); //not implemented yet
      } else {
        failure = UnknownFailure(errorDescription: error.message);
      }
    } else if (error is DioError) {
      if (error.toString().contains("SocketException")) {
        failure = DioFailure(
            errorDescription:
                error.requestOptions.headers["Accept-Language"] == "bn"
                    ? "সংযোগ স্থাপন সম্ভব হয় নাই।"
                    : "Could not connect.");
      } else {
        failure = DioFailure(
            statusCode: (error.error is BasicResponse &&
                    (error.error as BasicResponse).code != null)
                ? (error.error as BasicResponse).code
                : error.response?.statusCode?.toString(),
            errorDescription: (error.error is BasicResponse &&
                    (error.error as BasicResponse).message != null)
                ? (error.error as BasicResponse).message
                : error.message);
      }
    } else {
      failure = UnknownFailure(errorDescription: error.toString());
    }

    return failure;
  }
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({super.errorDescription});
}

class VpnConnectionFailure extends Failure {
  const VpnConnectionFailure({super.errorDescription});
}

class InvalidTokenFailure extends Failure {
  const InvalidTokenFailure({String? errorDescription})
      : super(errorDescription: errorDescription ?? "Unauthenticated");
}

class TokenRefreshFailure extends Failure {
  const TokenRefreshFailure() : super(errorDescription: "Token refresh failed");
}

class DataParseFailure extends Failure {
  const DataParseFailure({super.errorDescription});
}

class DioFailure extends Failure {
  const DioFailure({super.errorDescription, super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.errorDescription});
}
