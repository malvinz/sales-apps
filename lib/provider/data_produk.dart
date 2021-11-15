import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dart:convert';
//import '../model/produk.dart';
import './produkA.dart';

class Products with ChangeNotifier {
  List<Produk> _items = [
    Produk(
      kodeBarang: "BAR-0001",
      namaBarang: "Roast Beef Biscuit",
      satuan: "Pack",
      merk: "Toast",
      jenis: "Biscuit",
      rasa: "Beef",
      kemasan: "450 gr",
      harga: "7000",
    ),
    Produk(
      kodeBarang: "BAR-0002",
      namaBarang: "Pandan Biscuit",
      satuan: "Pack",
      merk: "Toast",
      jenis: "Biscuit",
      rasa: "PANDAN",
      kemasan: "450 gr",
      harga: "6500",
    ),
  ];
  List<SatuanProduk> _satuanProduk = [
    SatuanProduk(
      kodeBarang: "BAR-0001",
      namaBarang: "Roast Beef Biscuit",
      satuan: "PACK",
      jumlahUnit: 12,
    ),
    SatuanProduk(
      kodeBarang: "BAR-0002",
      namaBarang: "Pandan Biscuit",
      satuan: "PACK",
      jumlahUnit: 12,
    ),
  ];

  List<Produk> get items {
    // ignore: sdk_version_ui_as_code
    return [..._items];
  }

  Produk findById(String kodeBarang) {
    return _items.firstWhere((prod) => prod.kodeBarang == kodeBarang, orElse: () => null);
  }

  Produk findByName(String namaBarang) {
    return _items.firstWhere((prod) => prod.namaBarang == namaBarang, orElse: () => null);
  }

  List<SatuanProduk> get satuanProduks {
    // ignore: sdk_version_ui_as_code
    return [..._satuanProduk];
  }

  SatuanProduk findSatuanProdukBySatuan(String satuan) {
    return _satuanProduk.firstWhere((prod) => prod.satuan == satuan, orElse: () => null);
  }

  static List<Produk> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Produk>((json) => Produk.fromJson(json)).toList();
  }

  Future<void> getproduk(BuildContext context, String kodesales, String customerID) async {
    try {
      var aksi = 'getBarangPerSales';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            '&KodeSales=' +
            Uri.encodeComponent(kodesales) +
            '&Tipe=PO' +
            '&CustomerID=' +
            Uri.encodeComponent(customerID),
      );

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // final extractedData = json.decode(response.body);

      final List<Produk> loadproduk =
          (json.decode(response.body) as List).map((data) => Produk.fromJson(data)).toList();

      _items = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<double> getStokProdukPerDepo(String kodesales, String kodeBarang, String satuan) async {
    try {
      var aksi = 'getStokBarangPerDepo';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            '&KodeSales=' +
            Uri.encodeComponent(kodesales) +
            '&KodeBarang=' +
            Uri.encodeComponent(kodeBarang) +
            '&Satuan=' +
            Uri.encodeComponent(satuan),
      );

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      final extractedData = json.decode(response.body);

      if (extractedData.isEmpty) {
        return 0;
      } else {
        print(double.parse(extractedData[0]["sisastok"]));
        return double.parse(extractedData[0]["sisastok"]);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getprodukperSales(String kodesales) async {
    try {
      var aksi = 'getBarang';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            '&Sales=' +
            Uri.encodeComponent(kodesales),
      );

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // final extractedData = json.decode(response.body);

      final List<Produk> loadproduk =
          (json.decode(response.body) as List).map((data) => Produk.fromJson(data)).toList();

      _items = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getSatuanBarang(BuildContext context, String kodebarang) async {
    try {
      var aksi = 'getSatuanBarang';

      final url = Uri.parse("http://domain.com/fileapi.php?aksi=" +
          Uri.encodeComponent(aksi) +
          '&KodeBarang=' +
          Uri.encodeComponent(kodebarang));
      print(url);
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(response.body);
      final List<SatuanProduk> loadproduk =
          (json.decode(response.body) as List).map((data) => SatuanProduk.fromJson(data)).toList();

      _satuanProduk = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // ignore: missing_return
  Future<double> getHargaBarangPerKategori(
    BuildContext context,
    String kodebarang,
    String customerID,
    DateTime tanggal,
    String tipe,
  ) async {
    try {
      var aksi = 'getHargaPerBarangPerKategori';

      final url = Uri.parse(
        "http://domain.com/fileapi.php?aksi=" +
            Uri.encodeComponent(aksi) +
            '&KodeBarang=' +
            Uri.encodeComponent(kodebarang) +
            '&CustomerID=' +
            Uri.encodeComponent(customerID) +
            '&Tanggal=' +
            Uri.encodeComponent(DateFormat('yyyy-MM-dd').format(tanggal)) +
            '&Tipe=' +
            Uri.encodeComponent(tipe),
      );

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      final extractedData = json.decode(response.body);

      if (extractedData.isEmpty) {
        return 0;
      } else {
        return double.parse(extractedData[0]["Harga"]);
      }
    } catch (error) {
      throw error;
    }
  }
}
