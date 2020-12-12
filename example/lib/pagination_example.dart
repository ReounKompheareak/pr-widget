import 'package:flutter/material.dart';
import 'package:pr_widget/widget/pagination_widget.dart';
import 'package:pr_widget/widget/stream_widget.dart';
import 'package:pr_widget/service/stream/base_stream_provider.dart';
import 'package:dio/dio.dart';
import 'package:pr_widget/service/exception_handler/exception_handler.dart';

class PaginationExample extends StatefulWidget {
  @override
  _PaginationExampleState createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  ScrollController _scrollController = ScrollController();

  BaseStreamProvider<List<User>> _userStreamProvider = BaseStreamProvider();

  Future<List<User>> fetchDatafromInternetByStreamProvider() {
    return _userStreamProvider.addData(() async {
      return calledApiRequest(1).catchError((e){
         _userStreamProvider.addError(e);
         });
    });
  }

  // ignore: missing_return
  Future<List<User>> calledApiRequest(int page) async {
    try {
      Response response = await Dio().get(
          "https://chunlee-node-api-boilerplate.herokuapps.com/api/user/all_users?count=15&page=$page");
      print("ResponseApi= ${response.data}");
      if (response.statusCode == 200) {
        var list = response.data['data'] as List;
        return list.map((e) => User.fromJson(e)).toList();
      }
      return throw "Error";
    } on DioError catch (e) {
      onHandleDioError(e);
    }on TypeError catch(e){
      onHandleTypeError(e);
    }catch (e){
      return throw e.toString();
    }
  }

  @override
  void initState() {
    fetchDatafromInternetByStreamProvider();
    super.initState();
  }

  @override
  void dispose() {
    _userStreamProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamWidget<List<User>>(
        stream: _userStreamProvider.stream,
        child: (List<User> data) {
          return PaginationWidget<List<User>>(
              controller: _scrollController,
              datas: data,
              onApiRequest: (page) async {
                return await calledApiRequest(page);
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
