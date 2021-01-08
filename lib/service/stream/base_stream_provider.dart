import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

/// [BaseStreamProvider] is use for a shortcut to create StreamController
class BaseStreamProvider<T> {
  ///Use as StreamController
  StreamController<T> _controller = StreamController<T>.broadcast();

  /// return as stream from controller
  Stream<T> get stream => _controller.stream;

  /// [addData] is to add data from network to stream controller and display into streamwidget
  addData(Future<T> Function() voidCallback) async {
    try {
      /// recieved result from api called
      var result = await voidCallback.call();

      /// add data into controller
      _controller.sink.add(result);
    } on SocketException {
      addError('No internet connection');
    } on DioError catch (exc) {
      if (exc.error is SocketException) {
        addError(
            'SocketException: Failed host lookup: nodename nor servname provided, or not known, errno = 8');
      } else if (exc.error == DioErrorType.CONNECT_TIMEOUT) {
        addError("Request timeout");
      } else if (exc.error == DioErrorType.RESPONSE) {
        switch (exc.response.statusCode) {
          case 400:
            return addError("Invalid Request: ${exc.response.data}");
          case 401:
            return addError("Invalid Request: ${exc.response.data}");
          case 404:
            return addError("Invalid Request: ${exc.response.data}");
          case 403:
            return addError("Invalid Request: ${exc.response.data}");
          case 500:

          default:
            return addError(
                'Error occured while Communication with Server with StatusCode : ${exc.response.statusCode}');
        }
      } else {
        addError("An unexpected error occur!");
      }
    } on TypeError catch (e) {
      addError(e);
    } catch (e) {
      addError('Something went wrong');
    }
  }

  /// handle error when api called contain error
  addError(exc) {
    _controller.sink.addError(exc);
  }

  void dispose() {
    _controller.close();
  }
}
