import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'dart:convert';

import 'package:sales_apps/model/data_PO_header.dart';
import 'package:sales_apps/provider/user_login.dart';

class PurchaseOrderHeaderProvider with ChangeNotifier {
  String _noPOBaru = "";
  List<DataPOHeader> _items = [
    DataPOHeader(
      noPO: 'PO/2021/11/0001',
      tanggal: DateTime.parse('2021-11-02'),
      kodecustomer: 'cust-0001',
      namaCustomer: 'Customer',
      total: 141818,
      diskon: 1418,
      grandtotal: 154440,
      status: 'Selesai',
    ),
    DataPOHeader(
      noPO: 'PO/2021/11/0002',
      tanggal: DateTime.parse('2021-11-05'),
      kodecustomer: 'cust-0001',
      namaCustomer: 'Customer',
      total: 116364,
      diskon: 1164,
      grandtotal: 126720,
      status: 'Selesai',
    ),
  ];

  List<DataPOHeader> get items {
    // ignore: sdk_version_ui_as_code
    //notifyListeners();
    return [..._items];
  }

  List<DataPOHeader> itemsfilter(String filterText) {
    // ignore: sdk_version_ui_as_code
    return _items
        .where((element) => element.noPO.toLowerCase().contains(filterText.toLowerCase()))
        .toList();
  }

  String get noOrderBaru {
    return _noPOBaru;
  }

  void tambahHeaderPO(String noPO, DataPOHeader dataPOheader) {
    final indexKodeBarang = _items.indexWhere((value) => value.noPO == noPO);

    if (indexKodeBarang >= 0) {
      _items[indexKodeBarang] = dataPOheader;
    } else {
      _items.add(dataPOheader);
    }
    notifyListeners();
  }

  String generateNoPO(DateTime tanggal) {
    String _noPoBaru;
    int nobaru;
    _items.firstWhere((prod) =>
        (prod.noPO.substring(0, 11) == 'PO/' + DateFormat('yyyy/MM/').format(tanggal).toString()));

    if (_items.isEmpty) {
      _noPoBaru = 'PO/' + DateFormat('yyyy/MM/').format(tanggal).toString() + '0001';
    } else {
      _items.sort((nilai, value) {
        return value.noPO.compareTo(nilai.noPO);
      });
      nobaru = int.parse(_items[0].noPO.substring(12, 15)) + 1;
      _noPoBaru = _items[0].noPO.substring(0, 11) + nobaru.toString().padLeft(4, '0');
    }
    return _noPoBaru;
  }

  DataPOHeader findbynoPO(String noPO) {
    return _items.firstWhere((datapoHeader) => datapoHeader.noPO == noPO, orElse: () => null);
  }
  // void tambahHeaderPO(DataPOHeader dataPOHeader) {
  //   final dataHeaderbaru = DataPOHeader(
  //       noPO: dataPOHeader.noPO,
  //       tanggal: dataPOHeader.tanggal,
  //       diskon: dataPOHeader.diskon,
  //       total: dataPOHeader.total,
  //       grandtotal: dataPOHeader.grandtotal,
  //       namaCustomer: dataPOHeader.namaCustomer,
  //       kodecustomer:
  //       );
  //   _items.add(datadetailbaru);
  //   notifyListeners();
  // }

  Future<String> getDiskon(BuildContext context, String kodeCustomer, double totalPO) async {
    var aksi = "getDiskonPO";
    final url = Uri.parse(
      "http://domain.com/fileapi.php?aksi=" +
          Uri.encodeComponent(aksi) +
          "&TotalPO=" +
          Uri.encodeComponent(
            totalPO.toString(),
          ) +
          "&CustomerID=" +
          Uri.encodeComponent(kodeCustomer),
    );

    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (json.decode(response.body).isEmpty) {
      return '0';
    } else {
      final extractedData = json.decode(response.body);
      //_NoPOBaru = extractedData[0]["NoPOBaru"];

      return extractedData[0]["TotalDiskon"];
    }
  }

  Future<String> getNoPO(BuildContext context, DateTime tanggal) async {
    var aksi = 'getNoPO';

    final url = Uri.parse("http://domain.com/fileapi.php?aksi=" +
        Uri.encodeComponent(aksi) +
        "&Tanggal=" +
        Uri.encodeComponent((tanggal == null) ? DateTime.now().toString() : tanggal.toString()));
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    final extractedData = json.decode(response.body);
    //_NoPOBaru = extractedData[0]["NoPOBaru"];
    return extractedData[0]["NoPOBaru"];
  }

  Future<void> getTransasiPOPerSales(BuildContext context) async {
    try {
      var aksi = 'getTransasiPOPerSales';
      final sales = Provider.of<UserLogin>(context, listen: false).items.kodeSales;
      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            "&Sales=" +
            Uri.encodeComponent(sales),
      );

      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // final extractedData = json.decode(response.body);
      // print(response.body.length);

      final List<DataPOHeader> loadproduk =
          (json.decode(response.body) as List).map((data) => DataPOHeader.fromJson(data)).toList();

      _items = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
