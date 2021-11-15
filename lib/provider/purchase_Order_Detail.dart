import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sales_apps/model/data_PO_detail.dart';
import 'dart:convert';

class PurchaseOrderDetailProvider with ChangeNotifier {
  List<DataPODetail> _items = [
    DataPODetail(
        noPO: 'PO/2021/11/0001',
        kodeBarang: 'PBS-0002',
        namaBarang: 'Pandan Biscuit',
        satuan: 'Pack',
        harga: 6500,
        qty: 10),
    DataPODetail(
        noPO: 'PO/2021/11/0001',
        kodeBarang: 'PBS-0001',
        namaBarang: 'Roast Beef Biscuit',
        satuan: 'Pack',
        harga: 7000,
        qty: 13),
    DataPODetail(
        noPO: 'PO/2021/11/0002',
        kodeBarang: 'PBS-0002',
        namaBarang: 'Pandan Biscuit',
        satuan: 'Pack',
        harga: 6500,
        qty: 10),
    DataPODetail(
        noPO: 'PO/2021/11/0002',
        kodeBarang: 'PBS-0001',
        namaBarang: 'Roast Beef Biscuit',
        satuan: 'Pack',
        harga: 7000,
        qty: 9),
  ];

  List<DataPODetail> get items {
    // ignore: sdk_version_ui_as_code
    return [..._items];
  }

  Future<void> getItemByNoPo(BuildContext context, String noPO) async {
    try {
      var aksi = 'getHistoryTransaksiPerNoPO';

      final url = Uri.parse("http://domain.com/fileapi.php?aksi=" +
          Uri.encodeComponent(aksi) +
          '&NoPO=' +
          Uri.encodeComponent(noPO));

      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      final List<DataPODetail> loadproduk =
          (json.decode(response.body) as List).map((data) => DataPODetail.fromJson(data)).toList();

      _items = loadproduk;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void cleardetail() {
    _items.clear();
  }

  DataPODetail findById(String noPO, String kodeBarang) {
    return _items.firstWhere((prod) => (prod.kodeBarang == kodeBarang || prod.noPO == noPO),
        orElse: () => DataPODetail(
            noPO: noPO, kodeBarang: kodeBarang, namaBarang: '', satuan: '', harga: 0, qty: 0));
  }

  List<DataPODetail> findByNoPO(String noPO) {
    return _items
        .where((element) => element.noPO.toLowerCase().contains(noPO.toLowerCase()))
        .toList();
  }

  double get totalPO {
    double grandtotalPO = 0;
    _items.forEach((element) {
      grandtotalPO = grandtotalPO + (element.harga * element.qty);
    });
    return grandtotalPO;
  }

  double totalPOPerNoPO(String noPO) {
    double grandtotalPO = 0;
    List<DataPODetail> itemsfilter =
        _items.where((element) => element.noPO.contains(noPO)).toList();
    itemsfilter.forEach((element) {
      grandtotalPO = grandtotalPO + (element.harga * element.qty);
    });
    return grandtotalPO;
  }

  void tambahDetailPO(String kodeBarang, DataPODetail dataPODetail) {
    final indexKodeBarang = _items.indexWhere((value) => value.kodeBarang == kodeBarang);

    if (indexKodeBarang >= 0) {
      _items[indexKodeBarang] = dataPODetail;
    } else {
      _items.add(dataPODetail);
    }
    notifyListeners();
  }

  void updateDetailPOPerNoPO(String noPOBaru, String noPOLama) {
    List<DataPODetail> listdetailfilter =
        _items.where((element) => element.noPO.contains(noPOLama)).toList();
    var index;
    listdetailfilter.map((value) {
      index = _items.indexWhere(
        (element) => (value.noPO == element.noPO && value.kodeBarang == element.kodeBarang),
      );
      _items[index] = DataPODetail(
        noPO: noPOBaru,
        kodeBarang: value.kodeBarang,
        namaBarang: value.namaBarang,
        satuan: value.satuan,
        harga: value.harga,
        qty: value.qty,
      );
    });
  }

  void deleteDetailPO(String kodeBarang) {
    final indexKodeBarang = _items.indexWhere((value) => value.kodeBarang == kodeBarang);
    if (indexKodeBarang >= 0) {
      _items.removeAt(indexKodeBarang);
    } else {
      print('kode barang tidak ditemukan');
    }
    notifyListeners();
  }

  void updateDetailPO(String kodeBarang, DataPODetail dataPODetail) {
    final indexKodeBarang = _items.indexWhere((value) => value.kodeBarang == kodeBarang);
    if (indexKodeBarang >= 0) {
      _items[indexKodeBarang] = dataPODetail;
    } else {
      print('kode barang tidak ditemukan');
    }
    notifyListeners();
  }
}
