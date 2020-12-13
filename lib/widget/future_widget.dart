import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// FutureWidget is FutureBuilder custom widget
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
class FutureWidget<T> extends StatelessWidget {

  /// [future] use to called api request 
  final Future<T> future;

  /// [child] is return as widget when fetch data from api successfully
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) child;

  /// [errorWidget] return widget when error as your customize widget
  final Widget Function(String message) errorWidget;

  /// [errorButtonColor] Customize color with default error button
  final Color errorButtonColor;

  /// called when click on default error widget button
  final VoidCallback onRefreshCallback;

  /// customize widget when on Connecting state
  final Widget loadingWidget;

  FutureWidget(
      {@required this.future,
      @required this.child,
      this.errorWidget,
      this.errorButtonColor,
      this.onRefreshCallback,
      this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapShot) {
          if (snapShot.hasData) {
            return child.call(context, snapShot);
          } else if (snapShot.hasError) {
            return errorWidget != null
                ? errorWidget.call(snapShot.error.toString())
                : _errorWidget(snapShot.error.toString());
          }
          return loadingWidget != null
              ? loadingWidget
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: CircularProgressIndicator()));
        });
  }


  /// defaul error widget
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
