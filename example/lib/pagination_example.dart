import 'package:flutter/material.dart';
import 'package:pr_widget/widget/pagination_widget.dart';
import 'package:pr_widget/widget/stream_widget.dart';
import 'package:pr_widget/service/stream/base_stream_provider.dart';
import 'package:dio/dio.dart';

class PaginationExample extends StatefulWidget {
  @override
  _PaginationExampleState createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  ScrollController _scrollController = ScrollController();

  BaseStreamProvider<List<User>> _userStreamProvider = BaseStreamProvider();

  Future<List<User>> fetchDatafromInternet({int page}) {
    print("Called fetchDataFromInternet");
    return _userStreamProvider.fetchListData(() async{
      Response response = await Dio().get("https://chunlee-node-api-boilerplate.herokuapp.com/api/user/all_users?count=15&page=$page");
      if(response.statusCode ==200){
        var list = response.data['data'] as List;
        return list.map((e) => User.fromJson(e)).toList();
      }
    });
  }

  @override
  void initState() {
    fetchDatafromInternet(page: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamWidget<List<User>>(
      stream: _userStreamProvider.stream,
      child: ( List<User> data) {
        return PaginationWidget<List<User>>(
            controller: _scrollController,
            datas: data,
            fetchData: (page){
              return fetchDatafromInternet(page: page);
            },
            child: (data) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      title: Text("${data.firstname}  ${data.lastname}")),
                      Divider()
                ],
              );
            });
      },
    ),
    );
  }
}

class User {
  String id;
  String firstname;
  String lastname;

  User({this.id, this.firstname, this.lastname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        firstname: json['first_name'],
        lastname: json['last_name']);
  }
}
