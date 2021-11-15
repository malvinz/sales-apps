import 'package:flutter/foundation.dart';

class Diskon with ChangeNotifier {
  final String kategori;
  final String subKategori;
  final double nilaiAwal;
  final double nilaiAkhir;
  final double diskon;

  Diskon({
    @required this.kategori,
    @required this.subKategori,
    @required this.nilaiAwal,
    @required this.nilaiAkhir,
    @required this.diskon,
  });

  factory Diskon.fromJson(Map<String, dynamic> json) {
    return Diskon(
      kategori: json['KategoriCustomer'] as String,
      subKategori: json['SubKategori'] as String,
      nilaiAwal: double.parse(json['NilaiAwal']),
      nilaiAkhir: double.parse(json['NilaiAkhir']),
      diskon: double.parse(json['Diskon']),
    );
  }
}
