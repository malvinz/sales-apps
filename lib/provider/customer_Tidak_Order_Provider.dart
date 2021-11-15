import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sales_apps/model/customer_Tidak_Order.dart';

class CustomerTidakOrderProvider with ChangeNotifier {
  List<CustomerTidakOrder> _item;

  List<CustomerTidakOrder> get items {
    return _item;
  }

  Future<void> getCustomerTidakOrder(String kodeSales, double periode, String tanggal) async {
    try {
      var aksi = 'getCustomerTidakRepeatOrder';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            "&Sales=" +
            Uri.encodeComponent(kodeSales) +
            "&Periode=" +
            Uri.encodeComponent(periode.toString()) +
            "&tanggalmulai=" +
            Uri.encodeComponent(tanggal),
      );

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<CustomerTidakOrder> loadproduk = (json.decode(response.body) as List)
          .map((data) => CustomerTidakOrder.fromJson(data))
          .toList();

      _item = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
