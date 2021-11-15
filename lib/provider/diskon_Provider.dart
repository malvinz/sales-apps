import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/diskon.dart';
import 'package:http/http.dart' as http;

class DiskonProvider with ChangeNotifier {
  List<Diskon> _item = [
    Diskon(
        kategori: "Grossir",
        subKategori: "Distributor",
        nilaiAwal: 1000000,
        nilaiAkhir: 25000000,
        diskon: 5),
    Diskon(
        kategori: "Retail", subKategori: "Toko", nilaiAwal: 100000, nilaiAkhir: 1000000, diskon: 1),
  ];

  List<Diskon> get items {
    return _item;
  }

  Future<void> getDiskon(BuildContext context) async {
    try {
      var aksi = 'getDiskon';

      final url = Uri.parse("http://domain.com/fileapi.php?aksi=" + Uri.encodeComponent(aksi));

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Diskon> loadproduk =
          (json.decode(response.body) as List).map((data) => Diskon.fromJson(data)).toList();

      _item = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
