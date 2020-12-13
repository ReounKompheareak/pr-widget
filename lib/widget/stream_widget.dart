import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// StreamWidget is StreamBuilder custom widget come along with BaseStream Provider
///
/// We provide on ErrorWidget and LoadingWidget as default already but you can customize with your own widget also
///
/// [future] for handle api request
///
/// [child] return as Function(BuildContext ,AsyncSnapshot<T>) to render UI when api request successfully
///
/// [errorButtonColor] use for change color on default ErrorWidget base on your app color
///
/// [onRefreshCallback] will handle onPressed event in default ErrorButtonWidget
///
/// [errorWidget] use for your own customize widget when api response error
///
///
// ignore: must_be_immutable
class StreamWidget<T> extends StatelessWidget {
  /// Widget to render Stream on connection State
  Widget loadingWidget;

  /// Function to return widget when data fetching from network successfully
  Widget Function(T data) child;

  /// Function to return widget when data fetching from network contain error
  Widget Function(String message) errorWidget;

  /// Stream call on StreamWidget as StreamBuilder
  Stream<T> stream;

  /// Customize color with default error button
  Color errorButtonColor;

  /// called when user click on error button to recall api again
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
                : _errorWidget(snapShot.error.toString());
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

  /// Error Default Widget
  Widget _errorWidget(String message) {
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
