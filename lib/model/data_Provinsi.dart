import 'package:flutter/foundation.dart';

class DataProvinsi with ChangeNotifier {
  final String kodeProvinsi;
  final String namaProvinsi;

  DataProvinsi({
    @required this.kodeProvinsi,
    @required this.namaProvinsi,
  });

  factory DataProvinsi.fromJson(Map<String, dynamic> json) {
    return DataProvinsi(
      kodeProvinsi: json['KodeProvinsi'] as String,
      namaProvinsi: json['NamaProvinsi'] as String,
    );
  }

  void toggleFavoriteStatus() {
    notifyListeners();
  }
}
