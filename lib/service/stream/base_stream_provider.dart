import 'dart:async';



/// [BaseStreamProvider] is use for a shortcut to create StreamController
class BaseStreamProvider<T> {

  ///Use as StreamController
  StreamController<T> _controller = StreamController<T>.broadcast();

  /// return as stream from controller
  Stream<T> get stream => _controller.stream;

  /// [addData] is to add data from network to stream controller and display into streamwidget
  addData(Future<T> Function() voidCallback) async {

    /// recieved result from api called
    var result = await voidCallback.call();

    /// add data into controller
    _controller.sink.add(result);
  }

  /// handle error when api called contain error
  addError(exc) {
    _controller.sink.addError(exc);
  }


  void dispose() {
    _controller.close();
  }
}
