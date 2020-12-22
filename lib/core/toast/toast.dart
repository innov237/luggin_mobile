import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  show(String message, Color color) {
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      msg: message,
      backgroundColor: color,
    );
  }
}
