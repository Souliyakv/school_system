import 'dart:convert';

import 'package:collageapp/page/auth/login.dart';
import 'package:collageapp/page/function/billing.dart';
import 'package:collageapp/widget/config.dart';
import 'package:collageapp/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistraTion extends StatefulWidget {
  const RegistraTion({super.key});

  @override
  State<RegistraTion> createState() => _RegistraTionState();
}

class _RegistraTionState extends State<RegistraTion> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDepartment();
  }

  var selectname;
  var seleteYear;
  List productItemList = [];
  List listDetail = [];
  String? desc;
  var price;

  Future<Null> getAllDepartment() async {
    try {
      var url = Uri.parse("${config}Department/SelectDepartment");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          productItemList = jsonData;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> getDetailData() async {
    try {
      var url = Uri.parse("${config}Department/SelectYear");
      var response =
          await http.post(url, body: {"DP_ID": selectname.toString()});
      // print(response.body);
      if (response.statusCode == 200) {
        var jsonDataYear = json.decode(response.body);
        setState(() {
          listDetail = jsonDataYear;
          desc = json.decode(response.body)[0]['Dp_desc'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> getPrice() async {
    try {
      var url = Uri.parse("${config}Department/SelectPrice");
      var response =
          await http.post(url, body: {"DPY_ID": seleteYear.toString()});
      // print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          price = json.decode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> addRegistration() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse("${config}registration/Addregistration");
      var response = await http.post(url, body: {
        'DP_ID': selectname.toString(),
        "DPY_ID": seleteYear.toString(),
        "RS_Price": price.toString()
      }, headers: {
        'token': token.toString()
      });

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
        showToast.showtoastError('ການລົງທະບຽນບໍ່ສຳເຫຼັດ');
      } else if (response.statusCode == 200) {
        showToast.showtoastSuccess('ການລົງທະບຽນສຳເຫຼັດ');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return BillingPage(
            qrCondeID: response.body,
          );
        }), (route) => false);
      } else {
        showToast.showtoastError('ມີບາງຢ່າງຜິດປົກກະຕິ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ຈ່າຍຄ່າຮຽນ')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [_dropDownDepartment(), _showDetail()],
        ),
      )),
    );
  }

  Widget _dropDownDepartment() {
    return Container(
      width: 370,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1)),
      child: DropdownButton(
          isExpanded: true,
          hint: Text('ເລືອກສາຂາທີ່ຈະຮຽນ'),
          value: selectname,
          items: productItemList.map((category) {
            return DropdownMenuItem(
                value: category['DP_ID'], child: Text(category['DP_Name']));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectname = value;
              getDetailData();
              seleteYear = null;
            });
          }),
    );
  }

  Widget _showDetail() {
    if (selectname == null) {
      return Text('ກະລຸນາເລືອກສາຂາຮຽນຂ້າງເທິງ');
    } else {
      return Column(
        children: [
          ListTile(
            title: Text(
              "ລາຍລະອຽດ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text("${desc}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 370,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1)),
            child: DropdownButton(
                isExpanded: true,
                hint: Text('ເລືອກປີທີ່ຈະຮຽນ'),
                value: seleteYear,
                items: listDetail.map((category) {
                  return DropdownMenuItem(
                      value: category['DPY_ID'],
                      child: Text(category['DPY_Year'].toString()));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    seleteYear = value;
                    // getDetailData();

                    // getPostByProduct();
                    getPrice();
                  });
                }),
          ),
          _showPrice(),
          _button()
        ],
      );
    }
  }

  Widget _showPrice() {
    if (seleteYear == null) {
      return Text('ກະລຸນາເລືອກປີຮຽນຂ້າງເທິງ');
    } else {
      return ListTile(
        title: Text(
          'ຄ່າຮຽນ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text("${price}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      );
    }
  }

  Widget _button() {
    return ElevatedButton(
        onPressed: () {
          try {
            if (seleteYear == null) {
              return showToast.showtoastError('ກະລຸນາເລືອກປີຮຽນຂອງເຈົ້າ');
            } else {
              showToast.load(context);
              addRegistration();
              Navigator.pop(context);
            }
          } catch (e) {
            print(e);
          }
        },
        child: Text("ຈ່າຍຄ່າຮຽນ"));
  }
}
