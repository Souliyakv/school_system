import 'package:collageapp/model.dart/getlistofregistration.dart';
import 'package:collageapp/page/auth/login.dart';
import 'package:collageapp/page/function/billing.dart';
import 'package:collageapp/widget/config.dart';
import 'package:collageapp/widget/rounded_input.dart';
import 'package:collageapp/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class HistoryRegistrationPage extends StatefulWidget {
  const HistoryRegistrationPage({super.key});

  @override
  State<HistoryRegistrationPage> createState() =>
      _HistoryRegistrationPageState();
}

class _HistoryRegistrationPageState extends State<HistoryRegistrationPage> {
  List<GetListOfRegistration> listOfRegistration = [];
  final _valueSearch = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfRegistration();
  }

  Future<Null> getListOfRegistration() async {
    var token = await showToast.getToken();
    var url = Uri.parse("${config}registration/ListOfRegistration");
    var response = await http.get(url, headers: {"token": token.toString()});

    if (response.statusCode == 501) {
      showToast.showtoastError('ບັນຊີີຖືກປິດການໃຊ້ງານຊົ່ວຄາວ');
      showToast.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 500) {
      showToast.showtoastError('ເວີຊັ່ນໝົດອາຍຸ ກະລຸນາເຂົ້າສູ່ລະບົບ');
      showToast.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 200) {
      setState(() {
        listOfRegistration = getListOfRegistrationFromJson(response.body);
      });
    } else {
      showToast.showtoastError('ມີບາງຢ່າງຜິດປົກກະຕິ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  Future<Null> searchOfRegistration() async {
    var token = await showToast.getToken();
    var url = Uri.parse("${config}registration/SearchRegistration");
    var response = await http.post(url,
        body: {"RS_ID": _valueSearch.text.toString()},
        headers: {"token": token.toString()});

    if (response.statusCode == 501) {
      showToast.showtoastError('ບັນຊີີຖືກປິດການໃຊ້ງານຊົ່ວຄາວ');
      showToast.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 500) {
      showToast.showtoastError('ເວີຊັ່ນໝົດອາຍຸ ກະລຸນາເຂົ້າສູ່ລະບົບ');
      showToast.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }), (route) => false);
    } else if (response.statusCode == 200) {
      setState(() {
        listOfRegistration = getListOfRegistrationFromJson(response.body);
      });
    } else {
      showToast.showtoastError('ມີບາງຢ່າງຜິດປົກກະຕິ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ປະຫວັດການຈ່າຍຄ່າຮຽນທັງໝົດ"),
          actions: [
            IconButton(
                onPressed: () {
                  getListOfRegistration();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              _search(),
              _listOfData()
            ],
          ),
        ));
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 280,
            height: 60,
            child: Form(
              key: _formkey,
              child: TextInputFormFields(
                  prefixIcon: Icon(Icons.search),
                  labelText: "ລະຫັດ",
                  hintText: "ໃສ່ລະຫັດທີ່ທ່ານຕ້ອງການຄົ້ນຫາ",
                  controller: _valueSearch,
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 0) {
                      return "ໃສ່ ID";
                    }
                    return null;
                  },
                  autofocus: false),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
              height: 45,
              child: IconButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      searchOfRegistration();
                    }
                  },
                  icon: Icon(Icons.search)))
        ],
      ),
    );
  }

  _listOfData() {
    if (listOfRegistration.length == 0) {
      return Text("ບໍ່ມີຂໍ້ມູນ");
    } else {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listOfRegistration.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return BillingPage(
                      qrCondeID: listOfRegistration[index].rsId.toString(),
                    );
                  }));
                },
                title: Text(
                  listOfRegistration[index].dpName.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                subtitle: Text(
                  "ຄ່າຮຽນ: ${listOfRegistration[index].rsPrice} ກີບ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text("${listOfRegistration[index].rsAt}"),
                leading: CircleAvatar(
                  child: Text(listOfRegistration[index].dpyYear.toString()),
                ),
              ),
            );
          });
    }
  }
}
