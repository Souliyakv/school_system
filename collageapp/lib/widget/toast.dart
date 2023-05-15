import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class showToast {
  static void showtoastSuccess(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);
  }

  static void showtoastError(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.white,
        textColor: Colors.red);
  }

  static void showButtonSheet(BuildContext context, Widget? child) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: child,
          );
        });
  }

  static void load(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ກຳລັງໂຫຼດ...'),
            content: CircularProgressIndicator(),
          );
        });
  }

  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    return token;
  }

  static void clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
