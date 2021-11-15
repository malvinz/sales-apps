import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_apps/model/insentif_sales.dart';
import 'package:sales_apps/model/target_sales.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TargetSalesProvider with ChangeNotifier {
  List<TargetSales> _item = [
    TargetSales(
      tipeTarget: 'PENJUALAN',
      merk: 'TOAST',
      tanggalawal: DateTime.parse('2021-11-01'),
      tanggalakhir: DateTime.parse('2021-11-30'),
      harikerja: 24,
      totaltarget: 35000000,
      satuan: 'Pack',
      totalJual: 35000000,
      jumlahHariTercapai: 3,
    )
  ];
  List<DataInsentifSales> _itemInsentif = [
    DataInsentifSales(
      tipeTarget: 'PENJUALAN',
      merk: 'TOAST',
      tanggalawal: DateTime.parse('2021-11-01'),
      tanggalakhir: DateTime.parse('2021-11-30'),
      harikerja: 24,
      totaltarget: 50000000,
      satuan: 'Pack',
      totalJual: 50000000,
      jumlahHariTercapai: 3,
    )
  ];

  List<TargetSales> get items {
    return _item;
  }

  List<DataInsentifSales> get itemsInsentif {
    return _itemInsentif;
  }

  Future<void> getTargetSales(BuildContext context, String kodeSales, DateTime tanggal) async {
    try {
      var aksi = 'getTargetSales';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            "&KodeSales=" +
            Uri.encodeComponent(kodeSales) +
            "&Tanggal=" +
            Uri.encodeComponent(
              DateFormat('yyyy-MM-dd').format(tanggal),
            ),
      );
      print(url);
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<TargetSales> loadproduk =
          (json.decode(response.body) as List).map((data) => TargetSales.fromJson(data)).toList();

      _item = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getInsentifSales(BuildContext context, String kodeSales, DateTime tanggal) async {
    try {
      var aksi = 'getInsentifSales';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            "&KodeSales=" +
            Uri.encodeComponent(kodeSales) +
            "&Tanggal=" +
            Uri.encodeComponent(
              DateFormat('yyyy-MM-dd').format(tanggal),
            ),
      );
      print(url);
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<DataInsentifSales> loadproduk = (json.decode(response.body) as List)
          .map((data) => DataInsentifSales.fromJson(data))
          .toList();

      _itemInsentif = loadproduk;
      print(_itemInsentif.length);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
