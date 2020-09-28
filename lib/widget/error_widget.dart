import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorHandlerWidget extends StatelessWidget {

  String message;
  Color buttonColor;
  VoidCallback voidCallback;

  ErrorHandlerWidget({@required this.message ,this.buttonColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/error.png",width: 120,height: 120,fit: BoxFit.cover),
          Text(message),
          SizedBox(height: 16),
          CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              color: buttonColor,
              child: Text("Try again"),
              onPressed: ()=> voidCallback)
        ],
      ),
    );
  }
}
