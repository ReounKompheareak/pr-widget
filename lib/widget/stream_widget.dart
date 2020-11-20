import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class StreamWidget<T> extends StatelessWidget {
  Widget loadingWidget;
  Widget Function(T data) child;
  Widget Function(String message) errorWidget;
  Stream<T> stream;
  Color errorButtonColor;
  VoidCallback onRefreshCallback;

  StreamWidget(
      {@required this.stream,
      @required this.child,
      this.loadingWidget,
      this.errorWidget,
      this.errorButtonColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<T> snapShot) {
          if (snapShot.hasData) {
            return child(snapShot.data);
          } else if (snapShot.hasError) {
            return errorWidget != null
                ? errorWidget(snapShot.error.toString())
                : _ErrorWidget(snapShot.error.toString());
          }
          return loadingWidget != null
              ? loadingWidget
              : Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()));
        });
  }

  // ignore: non_constant_identifier_names
  Widget _ErrorWidget(String message) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/error.png",
              width: 120, height: 120, fit: BoxFit.cover),
          Text(message),
          SizedBox(height: 16),
          CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              color: errorButtonColor,
              child: Text("Try again"),
              onPressed: () => onRefreshCallback)
        ],
      ),
    );
  }
}
