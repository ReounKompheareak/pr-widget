import 'dart:io';
import 'package:dio/dio.dart';

/// this exception handler script is depend on Dio package

/// to handle type error
dynamic onHandleTypeError(exc) {
  throw exc;
}

/// to handle error base on dio error
dynamic onHandleDioError(exc) {
  if (exc.error is SocketException) {
    return throw "No internet connection";
  } else if (exc.error == DioErrorType.CONNECT_TIMEOUT) {
    return throw "Request timeout";
  } else if (exc.error == DioErrorType.RESPONSE) {
    switch (exc.response.statusCode) {
      case 400:
        // throw BadRequestException(error.response.data);
        throw "Invalid Request: ${exc.response.data}";
      case 401:

      case 404:

      case 403:
        throw "Invalid Request: ${exc.response.data}";
      case 500:

      default:
        return throw 'Error occured while Communication with Server with StatusCode : ${exc.response.statusCode}';
    }
  } else {
    throw "An unexpected error occur!";
  }
}
