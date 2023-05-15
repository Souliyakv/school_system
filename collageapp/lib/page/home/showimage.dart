import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShowImageProfile extends StatefulWidget {
  final String? imagePath;
  const ShowImageProfile({super.key, this.imagePath});

  @override
  State<ShowImageProfile> createState() => _ShowImageProfileState();
}

class _ShowImageProfileState extends State<ShowImageProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('ຮູບໂປຣຟາຍ'),
        backgroundColor: Colors.black,
      ),
      body: Center(child: Image.network('${widget.imagePath}')),
    );
  }
}
