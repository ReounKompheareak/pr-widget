import 'package:flutter/material.dart';

class PaginationWidget<T> extends StatefulWidget {
  bool shrinkWrap;
  T datas;
  Widget Function(dynamic data) child;
  ScrollController controller;
  Future<T> Function(int) onApiRequest;

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
  bool isLoading = false;
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
  }

  @override
  Widget build(BuildContext context) {
    // for(var i in widget.datas){
    //       print("FetchData: ${i.firstname}");
    //     }
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
