import 'package:flutter/material.dart';

/// Shortcut form of Naviation from page to page
class Navigate {

  /// push to navigate to destiny page
  void push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
  /// shortcut push and replacement
  void pushReplacement(BuildContext context, Widget screen) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }
}


/// use as global 
final navigate = Navigate();
