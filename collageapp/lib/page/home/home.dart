import 'package:collageapp/page/function/history_registration.dart';
import 'package:collageapp/page/function/registration.dart';
import 'package:collageapp/page/home/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MyProFile();
                  }));
                },
                icon: Icon(Icons.person))
          ],
          title: Text('Sirimoungkhoun'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return RegistraTion();
                  }));
                },
                child: Container(
                  // height: 50,
                  // width: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.app_registration_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        'ຈ່າຍຄ່າຮຽນ',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return HistoryRegistrationPage();
                  }));
                },
                child: Container(
                  // height: 50,
                  // width: 50,
                  // color: Colors.orange,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_edu,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        'ປະຫວັດການຈ່າຍ',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
