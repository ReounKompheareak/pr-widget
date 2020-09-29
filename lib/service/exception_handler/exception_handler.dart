import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class ExceptionHandler {
  dynamic handleError(DioError error) {
    if (error.error.runtimeType == SocketException) {
      return throw "No internet connection";
    } else if (error.error.runtimeType == TimeoutException) {
      return throw "Request timeout";
    } else {
      switch (error.response.statusCode) {
        case 400:
          throw BadRequestException(error.response.data);
        case 401:

        case 404:

        case 403:
          throw BadRequestException(error.response.data);
        case 500:

        default:
          return throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${error.response.statusCode}');
      }
    }
  }
}

final exHandler = ExceptionHandler();
