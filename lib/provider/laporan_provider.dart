import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_apps/model/laporan.dart';
import 'package:http/http.dart' as http;

class LaporanProvider with ChangeNotifier {
  List<Laporan> _item = [Laporan(namaLaporan: "Daftar Customer", kategori: "Daftar")];

  List<Laporan> get items {
    return _item;
  }

  Future<void> getLaporan(BuildContext context, String kategori) async {
    try {
      var aksi = 'getLaporan';

      final url = Uri.parse("http://domain.com/fileapi.php?aksi=" + Uri.encodeComponent(aksi));

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Laporan> loadproduk =
          (json.decode(response.body) as List).map((data) => Laporan.fromJson(data)).toList();

      _item = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
