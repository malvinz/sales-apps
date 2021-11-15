import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/data_Customer.dart';
import 'package:intl/intl.dart';

class CustomerViewGeneral extends StatelessWidget {
  final kodeCustomer;
  CustomerViewGeneral({this.kodeCustomer});

  @override
  Widget build(BuildContext context) {
    final _ukuranLebarLayar = MediaQuery.of(context).size.width;

    final datacustomer = Provider.of<DataCustomer>(context, listen: false).findById(kodeCustomer);

    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 1,
        alignment: WrapAlignment.start,
        children: [
          Container(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tgl Lahir Pemilik',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                VerticalDivider(),
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  width: _ukuranLebarLayar * 0.4,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${DateFormat('dd-MMMM-yyyy').format(datacustomer.tglLahirPemilik).toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    'Jenis',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.jenis}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kategori',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.kategoriCust}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sub Kategori',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.subKategori}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nama Outlet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.namaOutlet}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
