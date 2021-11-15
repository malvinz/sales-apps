import 'package:flutter/foundation.dart';

class Laporan with ChangeNotifier {
  final String namaLaporan;
  final String kategori;

  Laporan({
    @required this.namaLaporan,
    @required this.kategori,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      namaLaporan: json['NamaLaporan'] as String,
      kategori: json['Kategori'] as String,
    );
  }
}
