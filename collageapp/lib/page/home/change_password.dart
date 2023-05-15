import 'package:collageapp/page/auth/login.dart';
import 'package:collageapp/widget/config.dart';
import 'package:collageapp/widget/rounded_input.dart';
import 'package:collageapp/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Future<Null> changePassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse("${config}user/changePassword");
    var response = await http.post(url, body: {
      "oldPassword": oldPassword.text,
      "newPassword": newPassword.text
    }, headers: {
      "token": token.toString()
    });
    print(response.statusCode);
    print(response.body);
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
    } else if (response.statusCode == 502) {
      showToast.showtoastError('ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ');
    } else if (response.statusCode == 503) {
      showToast.showtoastError('ປ່ຽນລະຫັດຜ່ານບໍ່ສຳເຫຼັດ');
    } else if (response.statusCode == 200) {
      showToast.showtoastSuccess('ປ່ຽນລະຫັດຜ່ານສຳເຫຼັດ');
      Navigator.pop(context);
    } else {
      showToast.showtoastError('ບໍ່ສາມາດປ່ຽນໄດ້ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ປ່ຽນລະຫັດຜ່ານ')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _formPassword(),
            SizedBox(
              height: 15,
            ),
            _changePasswordButton()
          ],
        ),
      ),
    );
  }

  Widget _formPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextInputFormFields(
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'ລະຫັດຜ່ານເກົ່າ',
                  hintText: 'ໃສ່ລະຫັດຜ່ານເກົ່າຂອງເຈົ້າ',
                  controller: oldPassword,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "ລະຫັດຜ່ານຕ້ອງຫຼາຍກວ່າ 6 ໂຕ";
                    }
                    return null;
                  },
                  autofocus: false),
              SizedBox(
                height: 15,
              ),
              TextInputFormFields(
                  textInputAction: TextInputAction.next,
                  labelText: 'ລະຫັດຜ່ານໃໝ່',
                  hintText: 'ໃສ່ລະຫັດຜ່ານໃໝ່',
                  prefixIcon: Icon(Icons.lock),
                  controller: newPassword,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "ລະຫັດຜ່ານຕ້ອງຫຼາຍກວ່າ 6 ໂຕ";
                    }
                    return null;
                  },
                  autofocus: false),
              SizedBox(
                height: 15,
              ),
              TextInputFormFields(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'ຢືນຢັນລະຫັດຜ່ານ',
                  hintText: 'ຢືນຢັນລະຫັດຜ່ານຂອງເຈົ້',
                  controller: confirmPassword,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "ກະລຸນາຢືນຢັນລະຫັດຜ່ານຂອງເຈົ້າ";
                    }
                    return null;
                  },
                  autofocus: false)
            ],
          )),
    );
  }

  Widget _changePasswordButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            try {
              if (newPassword.text != confirmPassword.text) {
                showToast.showtoastError('ລະຫັດຜ່ານຢືນຢັນບໍ່ຖືກຕ້ອງ');
              } else {
                if (oldPassword.text == newPassword.text) {
                  showToast.showtoastError('ກະລຸນາໃສ່ລະຫັດຜ່ານໃໝ່');
                } else {
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

                  changePassword();
                  Navigator.pop(context);
                }
              }
            } catch (e) {
              print(e);
            }
          }
        },
        child: Text('ປ່ຽນລະຫັດຜ່ານ'));
  }
}
