import 'dart:async';

import 'package:dio/dio.dart';

class BaseStreamProvider<T> {
  StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get service.stream => _controller.stream;

  Future fetchListData(VoidCallback voidCallback) async {
    var result = await voidCallback.call();
    _controller.sink.add(result);
  }

  Future fetchListPaginationData(VoidCallback voidCallback,int page) async {
    var tempResult ;
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
