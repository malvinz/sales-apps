import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sales_apps/model/data_Kota.dart';
import 'package:sales_apps/model/data_Provinsi.dart';

class GeneralProvider with ChangeNotifier {
  List<DataProvinsi> _itemProvinsi = [
    DataProvinsi(
      kodeProvinsi: '1',
      namaProvinsi: 'DKI Jakarta',
    ),
    DataProvinsi(
      kodeProvinsi: '2',
      namaProvinsi: 'Jawa Barat',
    ),
  ];
  List<DataKota> _itemKota = [
    DataKota(
      kodeKota: '1',
      namaKota: 'Jakarta Barat',
      kodeProvinsi: '1',
    ),
    DataKota(
      kodeKota: '2',
      namaKota: 'Jakarta Timur',
      kodeProvinsi: '1',
    ),
    DataKota(
      kodeKota: '3',
      namaKota: 'Jakarta Tengah',
      kodeProvinsi: '1',
    ),
    DataKota(
      kodeKota: '4',
      namaKota: 'Jakarta Pusat',
      kodeProvinsi: '1',
    ),
    DataKota(
      kodeKota: '5',
      namaKota: 'Jakarta Selatan',
      kodeProvinsi: '1',
    ),
    DataKota(
      kodeKota: '6',
      namaKota: 'Kepulauan Seribu',
      kodeProvinsi: '1',
    ),
    DataKota(
      kodeKota: '7',
      namaKota: 'Kab. Bekasi',
      kodeProvinsi: '2',
    ),
    DataKota(
      kodeKota: '8',
      namaKota: 'Kota Bekasi',
      kodeProvinsi: '2',
    ),
  ];

  List<DataProvinsi> get itemsProvinsi {
    return _itemProvinsi;
  }

  DataProvinsi findProvinsiByNamaProvinsi(String namaProvinsi) {
    return _itemProvinsi.firstWhere(
      (prod) => prod.namaProvinsi == namaProvinsi,
      orElse: () => DataProvinsi(
        kodeProvinsi: '',
        namaProvinsi: '',
      ),
    );
  }

  DataKota findKotaByNamaKota(String namaKota) {
    return _itemKota.firstWhere((prod) => prod.namaKota == namaKota);
  }

  List<DataKota> itemsKota(String kodeProvinsi) {
    return _itemKota.where((element) => element.kodeProvinsi.contains(kodeProvinsi)).toList();
  }

  Future<void> getProvinsi() async {
    try {
      var aksi = 'getProvinsi';

      final url = Uri.parse("http://domain.com/fileapi.php?aksi=" + Uri.encodeComponent(aksi));

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<DataProvinsi> loadproduk =
          (json.decode(response.body) as List).map((data) => DataProvinsi.fromJson(data)).toList();

      _itemProvinsi = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getKota() async {
    try {
      var aksi = 'getKota';

      final url = Uri.parse("http://domain.com/fileapi.php?aksi=" + Uri.encodeComponent(aksi));

      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<DataKota> loadproduk =
          (json.decode(response.body) as List).map((data) => DataKota.fromJson(data)).toList();

      _itemKota = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> insertRakTransaksiPerPermintaanSales(
    String noPermintaan,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(url, body: {
      "aksi": "insertRakStockTransaksi",
      "NoPermintaan": noPermintaan,
    });
    print(response.body);
  }

  Future<void> updateRakTransaksi(
    String kodeRak,
    String kodeBarang,
    DateTime tanggalExpired,
    String satuan,
    String noTrans,
    DateTime tanggal,
    bool statusSelesai,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(url, body: {
      "aksi": "updateRakTransaksi",
      "NoTrans": noTrans,
      "StatusSelesai": statusSelesai.toString(),
    });
  }

  Future<void> updateRakStock(
    String noTrans,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(url, body: {
      "aksi": "updateRakStock",
      "NoTrans": noTrans,
    });
  }

  Future<void> deleteRakStockTransaksi(
    String noTrans,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(url, body: {
      "aksi": "deleteRakStockTransaksi",
      "NoTrans": noTrans,
    });
  }
}
