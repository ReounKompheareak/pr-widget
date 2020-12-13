import 'package:flutter/material.dart';

/// PaginationWidget
///
/// [child] is Widget is show when request data successfully
///
/// [datas] is data we get from api requesr
///
/// [onApiRequest] is handle api request for next page
///

class PaginationWidget<T> extends StatefulWidget {

  /// [shrinkWrap] the same as ListView ShrinkWraps
  final bool shrinkWrap;

  /// data from api request
  final T datas;

  /// Function to return widget when data fetching from network successfully
  final Widget Function(dynamic data) child;

  /// List controller use to detect list scroll maxing
  final ScrollController controller;

  /// called to request when user scroll at maxScrollExtend position
  final Future<T> Function(int) onApiRequest;

  PaginationWidget(
      {@required this.controller,
      @required this.child,
      @required this.datas,
      @required this.onApiRequest,
      this.shrinkWrap = false});

  @override
  _PaginationWidgetState createState() => _PaginationWidgetState();
}

class _PaginationWidgetState<T> extends State<PaginationWidget> {
  int page = 1;

  /// [isLoading] is using to check for display loading widget when user scroll to max position
  bool isLoading = false;

  /// [data] use to display data into  list
  var data = [];

  @override
  void initState() {
    data = widget.datas;
    widget.controller.addListener(() {
      if (widget.controller.position.maxScrollExtent ==
          widget.controller.position.pixels) {
        page++;
        setState(() {
          isLoading = true;
        });
        widget.onApiRequest.call(page).then((value) {
          setState(() {
            isLoading = false;
          });
          // data+=value;

          data = data + value;
        }).catchError((e) {
          setState(() {
            isLoading = false;
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
            shrinkWrap: widget.shrinkWrap,
            controller: widget.controller,
            children: data.map((e) => widget.child(e)).toList()),
        isLoading
            ? Positioned(
                bottom: 15,
                left: 1,
                right: 1,
                child: Center(
                    child: Container(
                        width: 35,
                        height: 35,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(64))),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )))),
              )
            : Container()
      ],
    );
  }
}
