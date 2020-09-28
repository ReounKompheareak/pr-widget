import 'package:flutter/material.dart';
import 'package:pr_widget/widget/error_widget.dart';

class StreamWidget<T> extends StatelessWidget {

  Widget loadingWidget;
  Widget errorWidget;
  Stream<T> stream;
  StreamWidget({@required this.stream,this.loadingWidget, this.errorWidget});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context,AsyncSnapshot<T> snapShot){
          if(snapShot.hasData){

          }else if (snapShot.hasError){
            return ErrorHandlerWidget(message:snapShot.error.toString());
          }
          return loadingWidget != null
              ? loadingWidget
              : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator()));
    });
  }
}
