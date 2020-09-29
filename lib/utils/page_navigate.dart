import 'package:flutter/material.dart';

class Navigate {
  void push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  void pushReplacement(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }
}

final navigate = Navigate();
