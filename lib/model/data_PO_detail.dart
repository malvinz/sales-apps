import 'package:flutter/foundation.dart';

class DataPODetail with ChangeNotifier {
  final String noPO;
  final String kodeBarang;
  final String namaBarang;
  final String satuan;
  final double harga;
  final double qty;

  DataPODetail({
    @required this.noPO,
    @required this.kodeBarang,
    @required this.namaBarang,
    @required this.satuan,
    @required this.harga,
    @required this.qty,
  });

  factory DataPODetail.fromJson(Map<String, dynamic> json) {
    return DataPODetail(
      noPO: json['NoPO'] as String,
      kodeBarang: json['KodeBarang'] as String,
      namaBarang: json['NamaBarang'] as String,
      satuan: json['Satuan'] as String,
      harga: double.parse(json['Harga']),
      qty: double.parse(json['Jumlah']),
    );
  }

  void toggleFavoriteStatus() {
    notifyListeners();
  }
}
