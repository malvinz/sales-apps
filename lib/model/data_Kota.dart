import 'package:flutter/foundation.dart';

class DataKota with ChangeNotifier {
  final String kodeKota;
  final String namaKota;
  final String kodeProvinsi;

  DataKota({
    @required this.kodeKota,
    @required this.namaKota,
    @required this.kodeProvinsi,
  });

  factory DataKota.fromJson(Map<String, dynamic> json) {
    return DataKota(
      kodeKota: json['KodeKota'] as String,
      namaKota: json['NamaKota'] as String,
      kodeProvinsi: json['KodeProvinsi'] as String,
    );
  }

  void toggleFavoriteStatus() {
    notifyListeners();
  }
}
