import 'package:flutter/foundation.dart';

class Produk with ChangeNotifier {
  final String kodeBarang;
  final String namaBarang;
  final String satuan;
  final String merk;
  final String jenis;
  final String rasa;
  final String kemasan;
  final String harga;

  Produk(
      {this.kodeBarang,
      this.namaBarang,
      this.satuan,
      this.merk,
      this.jenis,
      this.rasa,
      this.kemasan,
      this.harga});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      kodeBarang: json['KodeBarang'] as String,
      namaBarang: json['NamaBarang'] as String,
      satuan: json['Satuan'] as String,
      merk: json['Merk'] as String,
      jenis: json['Jenis'] as String,
      rasa: json['Rasa'] as String,
      kemasan: json['Kemasan'] as String,
      harga: json['harga'] as String,
    );
  }
}

class SatuanProduk with ChangeNotifier {
  final String kodeBarang;
  final String namaBarang;

  final String satuan;
  final double jumlahUnit;

  SatuanProduk({
    this.kodeBarang,
    this.namaBarang,
    this.satuan,
    this.jumlahUnit,
  });

  factory SatuanProduk.fromJson(Map<String, dynamic> json) {
    return SatuanProduk(
      kodeBarang: json['KodeBarang'] as String,
      namaBarang: json['NamaBarang'] as String,
      satuan: json['Satuan'] as String,
      jumlahUnit: double.parse(json['jumlahunit']),
    );
  }
}
