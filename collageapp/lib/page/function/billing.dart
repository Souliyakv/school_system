import 'package:barcode_widget/barcode_widget.dart';
import 'package:collageapp/model.dart/getdetailsbilling.dart';
import 'package:collageapp/page/auth/login.dart';
import 'package:collageapp/page/home/home.dart';
import 'package:collageapp/widget/config.dart';
import 'package:collageapp/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BillingPage extends StatefulWidget {
  final String? qrCondeID;
  const BillingPage({super.key, this.qrCondeID});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  GetDetailBilling getDetailBilling = GetDetailBilling();

  Future<Null> getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse("${config}registration/SelectDetailRegistration");
    var response = await http.post(url,
        body: {'RS_ID': widget.qrCondeID},
        headers: {'token': token.toString()});

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
      showToast.showtoastError('ບໍ່ມີຂໍ້ມູນ');
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }), (route) => false);
    } else if (response.statusCode == 200) {
      setState(() {
        getDetailBilling = getDetailBillingFromJson(response.body);
      });
    } else {
      showToast.showtoastError('ມີບາງຢ່າງຜິດປົກກະຕິ ກະລຸນາລອງໃໝ່ພາຍຫຼັງ');
    }
  }

  late double _deviceHeight;
  late double _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("ການລົງທະບຽນສຳເຫຼັດ"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Column(
                children: [_titlebilling(), _detailsBilling(), _qrCode()],
              ),
            ),
            _button()
          ],
        ),
      )),
    );
  }

  Widget _titlebilling() {
    return Center(
      child: Column(
        children: [
          Text(
            'SIRIMOUNGKHOUN COLLEGE(SC.D)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text('(ໂທ: 020 5574 1288)'),
          // SizedBox(
          //   height: _deviceHeight * 0.01,
          // ),
          Text(
            'ໃບຈ່າຍຄ່າຮຽນ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text('----------------------------')
        ],
      ),
    );
  }

  Widget _detailsBilling() {
    return Column(
      children: [
        ListTile(
          title: Text("ລະຫັດ:${getDetailBilling.rsId}"),
          trailing: Text("ລົງວັນທີ:${getDetailBilling.rsAt}"),
        ),
        ListTile(
            title: Text(
          "ຊື່: ${getDetailBilling.userFirstName}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
        ListTile(
          title: Text(
            "ນາມສະກຸນ: ${getDetailBilling.userLastName}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ListTile(
          title: Text(
            "ເບີໂທລະສັບ: +85620 ${getDetailBilling.userPhone}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ListTile(
          title: Text(
            "ສາຂາ: ${getDetailBilling.dpName}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ListTile(
          title: Text(
            "ປີຮຽນ: ${getDetailBilling.dpyYear}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        ListTile(
          title: Text(
            "ຄ່າຮຽນ: ${getDetailBilling.rsPrice} ກີບ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        )
      ],
    );
  }

  Widget _button() {
    return Container(
        padding: EdgeInsets.only(left: 50, right: 50),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return HomePage();
              }), (route) => false);
            },
            child: Text("ປິດ")));
  }

  Widget _qrCode() {
    return Container(
        height: _deviceHeight * 0.14,
        width: _deviceWidth * 0.3,
        child: BarcodeWidget(
            data: widget.qrCondeID.toString(),
            barcode: Barcode.qrCode(
                errorCorrectLevel: BarcodeQRCorrectionLevel.high)));
  }
}
