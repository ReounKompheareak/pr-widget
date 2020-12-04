import 'dart:async';

import 'package:dio/dio.dart';

class BaseStreamProvider<T> {
  
  StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  Future<T> addData(VoidCallback voidCallback) async {
    var result = await voidCallback.call();
    _controller.sink.add(result);
  }


  addError(exc){
    _controller.sink.addError(exc);
  }

  Future fetchListPaginationData(VoidCallback voidCallback,int page) async {
    dynamic tempResult = [] ;
    var result = await voidCallback.call();
    if(page >1) {
      tempResult += result;
      _controller.sink.add(tempResult);
    }else{
      tempResult = result;
    }
  }







  void dispose() {
    _controller.close();
  }
}
