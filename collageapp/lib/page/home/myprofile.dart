import 'dart:convert';
import 'dart:io';

import 'package:collageapp/model.dart/userprofile.dart';
import 'package:collageapp/page/auth/login.dart';
import 'package:collageapp/page/home/change_password.dart';
import 'package:collageapp/page/home/showimage.dart';
import 'package:collageapp/widget/config.dart';
import 'package:collageapp/widget/rounded_input.dart';
import 'package:collageapp/widget/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyProFile extends StatefulWidget {
  const MyProFile({super.key});

  @override
  State<MyProFile> createState() => _MyProFileState();
}

class _MyProFileState extends State<MyProFile> {
  UserProfile profile = UserProfile();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyProfile();
  }

  String? imgFile;
  File? file;
  late String firstName;
  late String lastName;
  late String phone;
  final _formkeyfirstName = GlobalKey<FormState>();
  final _formkeylastName = GlobalKey<FormState>();

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

  Future<Null> changeFirstName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse("${config}user/ChangeFirstName");
    var response = await http.post(url,
        body: {'newFirstName': firstName},
        headers: {"token": token.toString()});
    if (response.statusCode == 500) {
      showToast.showtoastError('ກະລຸນາລ໊ອກອິນ');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 501) {
      showToast.showtoastError('ບັນຊີຖືກລະງັບຊົ່ວຄາວ');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 502) {
      showToast.showtoastError('ການປ່ຽນບໍສຳເຫຼັດ');
      Navigator.pop(context);
    } else if (response.statusCode == 200) {
      showToast.showtoastSuccess('ການປ່ຽນຊື່ສຳເຫຼັດ');
      Navigator.pop(context);
      getMyProfile();
    } else {
      showToast.showtoastError('ບໍ່ສາມາດແກ້ໄຂໄດ້ໃນຕອນນີ້ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  Future<Null> changeLastName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse("${config}user/ChangeLastName");
    var response = await http.post(url,
        body: {'newLastName': lastName}, headers: {"token": token.toString()});
    if (response.statusCode == 500) {
      showToast.showtoastError('ກະລຸນາລ໊ອກອິນ');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 501) {
      showToast.showtoastError('ບັນຊີຖືກລະງັບຊົ່ວຄາວ');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 502) {
      showToast.showtoastError('ການປ່ຽນບໍສຳເຫຼັດ');
      Navigator.pop(context);
    } else if (response.statusCode == 200) {
      showToast.showtoastSuccess('ການປ່ຽນຊື່ສຳເຫຼັດ');
      Navigator.pop(context);
      getMyProfile();
    } else {
      showToast.showtoastError('ບໍ່ສາມາດແກ້ໄຂໄດ້ໃນຕອນນີ້ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  Future<Null> getMyProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('${config}user/getUserProfile');
    var response = await http.get(url, headers: {'token': token.toString()});

    if (response.statusCode == 501) {
      showToast.showtoastError('ບັນຊີີຖືກປິດການໃຊ້ງານຊົ່ວຄາວ');
      preferences.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 500) {
      showToast.showtoastError('ເວີຊັ່ນໝົດອາຍຸ ກະລຸນາເຂົ້າສູ່ລະບົບ');
      preferences.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else {
      setState(() {
        profile = userProfileFromJson(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ຂໍ້ມູນຂອງຂ້ອຍ'),
        actions: [
          IconButton(
              onPressed: () async {
                showToast.clear();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return LoginPage();
                }), (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            _profileImage(),
            SizedBox(
              height: 15,
            ),
            _showFirstName(),
            _showLastName(),
            _showPhone(),
            _showYear(),
            _showLastLogin(),
            SizedBox(
              height: 10,
            ),
            _changePassword()
          ],
        ),
      )),
    );
  }

  Widget _profileImage() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        _showImage(),
        FloatingActionButton(
          onPressed: () {
            _dailogSelectImage();
          },
          child: Icon(Icons.camera_alt),
        )
      ],
    );
  }

  Widget _showImage() {
    if (profile.userProfile == null) {
      return GestureDetector(
        onTap: () {
          showToast.showtoastError('ບໍ່ມີໂປຣຟາຍ');
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(125)),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ShowImageProfile(
              imagePath: profile.userProfile,
            );
          }));
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('${profile.userProfile}'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(125)),
        ),
      );
    }
  }

  Widget _showFirstName() {
    return Card(
      child: ListTile(
        title: Text(
          'ຊື່',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${profile.userFirstName}',
          style: TextStyle(fontSize: 18),
        ),
        leading: Icon(Icons.person),
        trailing: GestureDetector(
          onTap: () {
            _buttonSheetFirstName();
          },
          child: Icon(
            Icons.edit,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _showLastName() {
    return Card(
      child: ListTile(
        title: Text(
          'ນາມສະກຸນ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${profile.userLastName}',
          style: TextStyle(fontSize: 18),
        ),
        leading: Icon(Icons.person),
        trailing: GestureDetector(
          onTap: () {
            _buttonSheetLastName();
          },
          child: Icon(
            Icons.edit,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _showPhone() {
    return Card(
      child: ListTile(
        title: Text(
          'ເບີໂທລະສັບ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '+85620 ${profile.userPhone}',
          style: TextStyle(fontSize: 18),
        ),
        leading: Icon(Icons.phone),
      ),
    );
  }

  Widget _showYear() {
    return Card(
      child: ListTile(
        title: Text(
          'ປີຮຽນ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${profile.userYear}',
          style: TextStyle(fontSize: 18),
        ),
        leading: Icon(Icons.date_range),
      ),
    );
  }

  Widget _showLastLogin() {
    return ListTile(
      title: Text('ເຂົ້າສູ່ລະບົບຄັ້ງລ່າສຸດ'),
      subtitle: Text("${profile.userLastLogin}"),
      leading: Icon(Icons.watch_later),
    );
  }

  Widget _changePassword() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ChangePassword();
        }));
      },
      child: Text(
        'ປ່ຽນລະຫັດຜ່ານ?',
        style: TextStyle(color: Colors.red, fontSize: 15),
      ),
    );
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

  void _buttonSheetFirstName() {
    showToast.showButtonSheet(
        context,
        Column(children: [
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formkeyfirstName,
            child: TextInputFormFieldsDefault(
                initialValue: profile.userFirstName,
                labelText: 'ຊື່ໃໝ່',
                hintText: 'ໃສ່ຊື່ໃໝ່ຂອງເຈົ້າ',
                validator: (value) {
                  if (value!.isEmpty || value.length <= 0) {
                    return "ກະລຸນາໃສ່ຊື່ໃໝ່";
                  }
                  return null;
                },
                autofocus: true,
                onSaved: (value) {
                  setState(() {
                    firstName = value!;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: Text('ຍົກເລີກ')),
              SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    if (_formkeyfirstName.currentState!.validate()) {
                      _formkeyfirstName.currentState!.save();
                      // changeFirstName();
                      showToast.load(context);
                      changeFirstName();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'ປ່ຽນຊຶ້',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          )
        ]));
  }

  void _buttonSheetLastName() {
    showToast.showButtonSheet(
        context,
        Column(children: [
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formkeylastName,
            child: TextInputFormFieldsDefault(
                initialValue: profile.userLastName,
                labelText: 'ນາມສະກຸນໃໝ່',
                hintText: 'ໃສ່ນາມສະກຸນໃໝ່ຂອງເຈົ້າ',
                validator: (value) {
                  if (value!.isEmpty || value.length <= 0) {
                    return "ກະລຸນາໃສ່ນາມສະກຸນໃໝ່";
                  }
                  return null;
                },
                autofocus: true,
                onSaved: (value) {
                  setState(() {
                    lastName = value!;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: Text('ຍົກເລີກ')),
              SizedBox(
                width: 10,
              ),
              TextButton(
                  onPressed: () {
                    if (_formkeylastName.currentState!.validate()) {
                      _formkeylastName.currentState!.save();
                      showToast.load(context);
                      changeLastName();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'ປ່ຽນຊຶ້',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          )
        ]));
  }
}
