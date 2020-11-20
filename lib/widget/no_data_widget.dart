import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  String message;
  Color color;
  VoidCallback voidCallback;

  EmptyWidget(this.message, {this.color = Colors.blue, this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no_data.png",
              width: 120, height: 120, fit: BoxFit.cover),
          Text(message),
          SizedBox(height: 16),
          CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              color: color,
              child: Text("Try again"),
              onPressed: voidCallback != null ? voidCallback : () {})
        ],
      ),
    );
  }
}
