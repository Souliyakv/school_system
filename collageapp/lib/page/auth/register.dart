import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:collageapp/widget/rounded_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _passwordVisible = true;
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String? imgFile;
  File? file;

  Future chooseImage(ImageSource imageSource, BuildContext context) async {
    try {
      var object = await ImagePicker().getImage(source: imageSource);
      setState(() {
        file = File(object!.path);
        selectFile(context);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> selectFile(BuildContext context) async {
    if (file == null) return;

    File fileName = File(file!.path);
    Uint8List imagebytes = await fileName.readAsBytes();
    String base64string = base64.encode(imagebytes);
    imgFile = "data:image/jpg;base64,${base64string}";
    setState(() {
      imgFile;
    });
  }

  clearData() {
    setState(() {
      firstname.clear();
      lastname.clear();
      phone.clear();
      password.clear();
      imgFile = "";
      file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              _profile(),
              SizedBox(
                height: 20,
                child: Text(
                  'ເລືອກຮູບ',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              _formInput(),
              SizedBox(
                height: 10,
              ),
              _button()
            ],
          ),
        ),
      ),
    );
  }

  Widget _profile() {
    if (file != null) {
      return GestureDetector(
        onTap: () {
          _dailogSelectImage();
        },
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(
                    file!,
                  ))),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          _dailogSelectImage();
        },
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://media.istockphoto.com/illustrations/user-profile-icon-glassy-vibrant-sky-blue-round-button-illustration-illustration-id1164425002'))),
        ),
      );
    }
  }

  Widget _formInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextInputFormFields(
                controller: firstname,
                validator: (value) {
                  if (value!.isEmpty || value.length <= 0) {
                    return "ກະລຸນາໃສ່ຊື່ຂອງເຈົ້າ";
                  }
                  return null;
                },
                autofocus: false,
                hintText: 'ໃສ່ຊື່ແທ້ຂອງເຈົ້າ',
                labelText: 'ຊື່ແທ້',
                prefixIcon: Icon(Icons.person),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              TextInputFormFields(
                controller: lastname,
                validator: (value) {
                  if (value!.isEmpty || value.length <= 0) {
                    return "ກະລຸນາໃສ່ນາມສະກຸນຂອງເຈົ້າ";
                  }
                  return null;
                },
                autofocus: false,
                labelText: 'ນາມສະກຸນ',
                hintText: 'ໃສ່ນາມສະກຸນຂອງເຈົ້າ',
                prefixIcon: Icon(Icons.person),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              TextInputFormFields(
                controller: phone,
                validator: (value) {
                  if (value!.isEmpty || value.length != 8) {
                    return "ເບີໂທລະສັບຕ້ອງມີ 8 ໂຕ";
                  }
                  return null;
                },
                autofocus: false,
                prefixIcon: Icon(Icons.phone),
                labelText: 'ເບີໂທລະສັບ',
                hintText: 'XXXX XXXX',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              TextInputFormFieldsPassword(
                controller: password,
                validator: (value) {
                  if (value!.isEmpty || value.length <= 6) {
                    return 'ລະຫັດຜ່ານຕ້ອງຫຼາຍກວ່າ 6 ໂຕ';
                  }
                  return null;
                },
                obscureText: _passwordVisible,
                onTapsuffixIcon: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                suffixIcon: Icon(
                    _passwordVisible ? Icons.visibility_off : Icons.visibility),
                prefixIcon: Icon(Icons.lock),
                labelText: 'ລະຫັດຜ່ານ',
                hintText: 'ໃສ່ລະຫັດຜ່ານຂອງເຈົ້າ',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              )
            ],
          )),
    );
  }

  Widget _button() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {}
        },
        child: Text('ສະໝັກສະມາຊິິກ'));
  }

  void _dailogSelectImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ເລືອກຮູບພາບ'),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      chooseImage(ImageSource.gallery, context);
                      Navigator.pop(context);
                    },
                    title: Text('ເລືອກຈາກຮູບພາບ'),
                    leading: Icon(Icons.image),
                  ),
                  ListTile(
                    onTap: () {
                      chooseImage(ImageSource.camera, context);
                      Navigator.pop(context);
                    },
                    title: Text('ເລືອກຈາກກ້ອງ'),
                    leading: Icon(Icons.camera),
                  )
                ],
              ),
            ),
          );
        });
  }
}
