import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utilities {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 18.0);
  }
}
