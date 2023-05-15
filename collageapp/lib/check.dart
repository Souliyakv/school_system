import 'package:collageapp/page/auth/login.dart';
import 'package:collageapp/page/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  Future<Null> checkUser() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool? status = preferences.getBool('status');
      if (status != null && status == true) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
        }), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return LoginPage();
        }), (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        color: Colors.blue,
      )),
    );
  }
}
