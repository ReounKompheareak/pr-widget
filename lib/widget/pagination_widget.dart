import 'package:flutter/material.dart';

class PaginationWidget<T> extends StatefulWidget {

  bool shrinkWrap;
  T datas;
  Widget Function(dynamic data) child;
  ScrollController controller;
  int initPage;
  Future<T> Function(int) fetchData;
  

  PaginationWidget({@required this.controller,
                    @required this.child,
                    @required this.datas,
                    @required this.fetchData,
                    this.initPage = 1,
                    this.shrinkWrap=false});

  @override
  _PaginationWidgetState createState() => _PaginationWidgetState();
}

class _PaginationWidgetState<T> extends State<PaginationWidget> {
  int page ;
  bool isLoading = false;
  var data = [];


  @override
  void initState() {
    data = widget.datas;
    page = widget.initPage;
    widget.controller.addListener(() {
      if(widget.controller.position.maxScrollExtent == widget.controller.position.pixels){
        page++;
        setState(() {
          isLoading = true;
        });
        widget.fetchData.call(page).whenComplete((){
          setState(() {
            isLoading = false;
          });
        });
      }
     });
  }



  @override
  Widget build(BuildContext context) {
    data += widget.datas;
    return Stack(
      children: [
        ListView(
          shrinkWrap: widget.shrinkWrap,
          controller: widget.controller,
          children: data.map((e) => widget.child(e)).toList(),
        ),
        isLoading ? Positioned(
          bottom: 1,
          left: MediaQuery.of(context).size.width*0.9,
          right: MediaQuery.of(context).size.width*0.9,
          child: CircularProgressIndicator(),
        ): Container()
      ],
    );
  }
}