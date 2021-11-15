import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/customer_Tidak_Order_Provider.dart';
import '../provider/user_login.dart';
import '../widget/laporan_Customer_tidak_order_Grid.dart';

class LaporanCustomerTidakOrderPage extends StatefulWidget {
  @override
  _LaporanCustomerTidakOrderPageState createState() => _LaporanCustomerTidakOrderPageState();
}

class _LaporanCustomerTidakOrderPageState extends State<LaporanCustomerTidakOrderPage> {
  DateTime _tanggalPilih = DateTime.now();
  TextEditingController _periode = TextEditingController();
  bool _isloading = false;
  final _form = GlobalKey<FormState>();
  void _showdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      // ignore: unrelated_type_equality_checks
      if (value == Null) {
        return;
      }
      setState(() {
        _tanggalPilih = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userdata = Provider.of<UserLogin>(context, listen: false).items;
    final datacustomertidakorder =
        Provider.of<CustomerTidakOrderProvider>(context, listen: false).items;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black12,
              border: Border.all(
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(8),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Tanggal Laporan :"),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 150,
                          height: 35,
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 1)),
                          child: Text(
                            _tanggalPilih == null
                                ? DateFormat.yMd().format(DateTime.now())
                                : DateFormat.yMd().format(_tanggalPilih),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _showdatepicker,
                        icon: Icon(Icons.date_range),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Lama Tidak Order:"),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          controller: _periode,
                          // onChanged: (value) {
                          //   _periode.text = value == "" ? 0 : value;
                          // },
                          decoration: InputDecoration(labelText: "Periode"),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Periode Tidak Valid';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Periode harus berisi angka';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent.shade100,
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if (_form.currentState.validate()) {
                              _isloading = true;
                              setState(() {});
                              await Provider.of<CustomerTidakOrderProvider>(context, listen: false)
                                  .getCustomerTidakOrder(
                                userdata.kodeSales,
                                double.parse(_periode.text),
                                DateFormat('yyyy-MM-dd').format(_tanggalPilih),
                              );
                              _isloading = false;
                              setState(() {});
                            } else {
                              print('salah');
                            }
                          },
                          icon: Icon(Icons.search),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          datacustomertidakorder == null
              ? Container()
              : _isloading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: LaporanCustomerTidakOrderGrid(),
                    ),
        ],
      ),
    );
  }
}
