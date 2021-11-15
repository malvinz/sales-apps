import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import 'package:sales_apps/model/data_PO_header.dart';

import '../provider/purchase_Order_Header.dart';
import '../provider/user_login.dart';

import '../provider/purchase_Order_Detail.dart';
import '../widget/detailItemPOGrid.dart';
import '../model/data_user.dart';
import '../screen/menu_Utama.dart';
import '../provider/data_Customer.dart';

import '../screen/purchase_Order_Detail.dart';

class PurchaseOrderScreen extends StatefulWidget {
  static const routeName = '\PurchaseOrder';
  @override
  _PurchaseOrderScreenState createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  DateTime _tanggalPilih = DateTime.now();
  Map args;
  final _noPOController = TextEditingController();
  var _isInit = true;
  var _isLoading = true;
  List _item = [];
  var itemdata;
  String custID = '';
  var getdiskon;
  double totalPO = 0;
  double diskon = 0;
  double ppn = 0;
  var dataheader;
  String noPO;
  var itemDetailBarang;
  String namaCustomer = '';

  @override
  void initState() {
    super.initState();
  }

  void didChangeDependencies() async {
    noPO = ModalRoute.of(context).settings.arguments == null
        ? "< < A U T O > >"
        : ModalRoute.of(context).settings.arguments;
    _noPOController.text = noPO;
    final kodeSales = Provider.of<UserLogin>(context, listen: false).items;
    itemDetailBarang = Provider.of<PurchaseOrderDetailProvider>(context, listen: false).items;
    _isLoading = true;

    if (_isInit) {
      if (_noPOController.text != "< < A U T O > >" && _noPOController.text != "") {
        dataheader = Provider.of<PurchaseOrderHeaderProvider>(context, listen: false)
            .findbynoPO(_noPOController.text);

        _tanggalPilih = dataheader == null ? DateTime.now() : dataheader.tanggal;
        namaCustomer = dataheader == null ? "" : dataheader.namaCustomer;

        totalPO = dataheader == null ? 0 : dataheader.total;
        diskon = dataheader == null ? 0 : dataheader.diskon;
      }
      itemdata = Provider.of<DataCustomer>(context, listen: false);
      _item = itemdata.items;
      custID = _item[0].custID;
    }

    totalPO = Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
        .totalPOPerNoPO(_noPOController.text);
    // ignore: unnecessary_statements
    (totalPO == null) ? totalPO = 0 : totalPO;

    setState(() {
      _isLoading = false;
    });
    _isInit = false;

    super.didChangeDependencies();
  }

  // ignore: unused_element
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
    final DataUser userdata = Provider.of<UserLogin>(context, listen: false).items;

    final formatter = NumberFormat("#,###");

    void _validateInputDetail() {
      if (namaCustomer == "" || namaCustomer == null) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Harap Pilih Nama Customer Lebih dulu"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.navigate_next))
                ],
                title: Text("Something wrong !"),
              );
            });
      } else {
        args = {
          'nopo': _noPOController.text,
          'productId': '',
          'customerID': custID,
          'tanggalPO': _tanggalPilih
        };

        Navigator.of(context).pushNamed(PurchaseOrderDetailScreen.routeName, arguments: args);
      }
    }

    Future<void> _saveForm() async {
      if (_item.isEmpty) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                    Text("Tidak ada Data, harap masukkan data Barang sales atau customer sales"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, MenuUtamaScreen.routeName);
                      },
                      icon: Icon(Icons.navigate_next))
                ],
                title: Text("Something wrong !"),
              );
            });
      }
      //_----------------------------------------------------------------------------------
      if (_noPOController.text != "< < A U T O > >" && _noPOController.text != "") {
        _noPOController.text = Provider.of<PurchaseOrderHeaderProvider>(context, listen: false)
            .generateNoPO(DateTime.now());
        Provider.of<PurchaseOrderHeaderProvider>(context, listen: false).tambahHeaderPO(
          _noPOController.text,
          DataPOHeader(
              noPO: noPO,
              tanggal: _tanggalPilih,
              kodecustomer: custID,
              namaCustomer: namaCustomer,
              total: totalPO,
              diskon: diskon,
              grandtotal: (((totalPO / 1.1) - diskon) + (((totalPO / 1.1) - diskon) * 0.1)),
              status: 'Proses'),
        );
        Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
            .updateDetailPOPerNoPO(noPO, _noPOController.text);
      } else {
        print('tambah');
        Provider.of<PurchaseOrderHeaderProvider>(context, listen: false).tambahHeaderPO(
          _noPOController.text,
          DataPOHeader(
              noPO: noPO,
              tanggal: _tanggalPilih,
              kodecustomer: custID,
              namaCustomer: namaCustomer,
              total: totalPO,
              diskon: diskon,
              grandtotal: (((totalPO / 1.1) - diskon) + (((totalPO / 1.1) - diskon) * 0.1)),
              status: 'Proses'),
        );
        Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
            .updateDetailPOPerNoPO(_noPOController.text, "< < A U T O > >");
      }
      Navigator.of(context).pop();
    }

    AppBar appheight = AppBar(
      title: Text("tex"),
    );
    return Scaffold(
      appBar: AppBar(
        title: Stack(children: [
          Container(
            height: appheight.preferredSize.height,
            width: appheight.preferredSize.width,
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.30,
              child: SizedBox.expand(
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/gambar/dashboard.png',
                    fit: BoxFit.contain,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: appheight.preferredSize.height,
            width: appheight.preferredSize.width,
            child: Text(
              "Purchase Order",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/gambar/dashboard.png"),
                  fit: BoxFit.contain,
                  colorFilter: new ColorFilter.mode(
                      const Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height * 0.515,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 10),
                                  child: Text(
                                    "No PO",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  // padding: EdgeInsets.only(left: 30),

                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                  ),
                                  width: 130,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    controller: _noPOController,
                                    decoration: InputDecoration(hintText: "< < A U T O > >"),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10, right: 5),
                                  child: Text(
                                    "Tanggal",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blueAccent, width: 1)),
                                    child: Text(
                                      _tanggalPilih == null
                                          ? DateFormat.yMd().format(DateTime.now())
                                          : DateFormat.yMd().format(_tanggalPilih),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    "Nama Customer",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    height: 40,
                                    child: DropdownSearch<String>(
                                      mode: Mode.MENU,
                                      selectedItem: namaCustomer,
                                      showSelectedItem: true,
                                      items: _item.map((item) {
                                        return item.custName.toString();
                                      }).toList(),
                                      label: "Customer",
                                      showSearchBox: true,
                                      hint: "Nama Customer",
                                      popupItemDisabled: (String s) => s.startsWith('I'),
                                      onChanged: (value) {
                                        namaCustomer = value;
                                        custID = Provider.of<DataCustomer>(context, listen: false)
                                            .findByNama(value)
                                            .custID;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20, right: 50, top: 10),
                                  child: Text(
                                    "Total",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                                  child: Text(
                                    "Rp. ${formatter.format(totalPO)}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20, right: 40, top: 10),
                                  child: Text(
                                    "Diskon",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                                  child: Text(
                                    "Rp. ${formatter.format(diskon)}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20, right: 40, top: 10),
                                  child: Text(
                                    "PPN",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 22, right: 10, top: 10),
                                  child: Text(
                                    "Rp. ${formatter.format(ppn)}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                                  child: Text(
                                    "Grand Total",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                                  child: Text(
                                    //"Rp. ${formatter.format((totalPO - diskon) - ((totalPO - diskon) * 0.1))}",
                                    "Rp. ${formatter.format(((totalPO / 1.1) - diskon) + (((totalPO / 1.1) - diskon) * 0.1))}",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: _validateInputDetail,
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Text("Tambah Detail"),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DetailPODetailGrid(
                                noPO: _noPOController.text,
                                custID: custID,
                                tanggal: _tanggalPilih,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
