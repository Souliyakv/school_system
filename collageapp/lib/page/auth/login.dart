import 'dart:convert';

import 'package:collageapp/page/auth/register.dart';
import 'package:collageapp/page/home/home.dart';
import 'package:collageapp/widget/config.dart';
import 'package:collageapp/widget/rounded_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = true;
  final phone = TextEditingController();
  final password = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var token;

  Future<Null> login() async {
    var url = Uri.parse('${config}user/login');
    var response = await http
        .post(url, body: {'Phone': phone.text, 'Password': password.text});
    setState(() {
      token = json.decode(response.body);
    });

    if (response.statusCode == 500) {
      showToast.showtoastError('ບໍ່ມີບັນຊີນີ້ໃນລະບົບ');
    } else if (response.statusCode == 501) {
      showToast.showtoastError('ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ');
    } else if (response.statusCode == 200) {
      showToast.showtoastSuccess('ເຂົ້າສູ່ລະບົບສຳເຫຼັດ');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      preferences.setString('token', token);
      preferences.setBool('status', true);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }), (route) => false);
    } else {
      showToast.showtoastError('ມີບາງຢ່າງຜິດປົກກະຕິ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _showTitle(),
              SizedBox(
                height: 10,
              ),
              _formInput(),
              SizedBox(
                height: 10,
              ),
              _button(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ບໍ່ມິບັນຊີຜູ້ໃຊ້?'),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return RegisterPage();
                      }));
                    },
                    child: Text(
                      ' ລົງທະບຽນ',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showTitle() {
    return Text(
      'Sirimoungkhoun',
      style: TextStyle(
          fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }

  Widget _formInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextInputFormFields(
              controller: phone,
              validator: (value) {
                if (value!.isEmpty || value.length != 8) {
                  return "ເບີໂທລະສັບຕ້ອງມີ 8 ໂຕອັກສອນ";
                }
                return null;
              },
              autofocus: false,
              labelText: 'ເບີໂທລະສັບ',
              hintText: 'ໃສ່ເບີໂທລະສັບຂອງເຈົ້າ',
              prefixIcon: Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 15,
            ),
            TextInputFormFieldsPassword(
              onTapsuffixIcon: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              controller: password,
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return "ລະຫັດຜ່ານຕ້ອງຫຼາຍກວ່າ 6 ໂຕ";
                }
                return null;
              },
              labelText: 'ເບີໂທລະສັບ',
              hintText: 'ໃສ່ເບີໂທລະສັບຂອງເຈົ້າ',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(
                  _passwordVisible ? Icons.visibility_off : Icons.visibility),
              obscureText: _passwordVisible,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
            )
          ],
        ),
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            try {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.blue,
                      ),
                    );
                  });

              login();
              Navigator.pop(context);
            } catch (e) {
              print(e);
            }
          }
        },
        child: Text(
          'ເຂົ້າສູ່ລະບົບ',
          style: TextStyle(fontSize: 20),
        ));
  }
}
