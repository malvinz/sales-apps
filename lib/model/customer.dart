import 'package:flutter/foundation.dart';

class Customer with ChangeNotifier {
  final String custID;
  final String custName;
  final String kategoriCust;
  final String subKategori;
  final String jenis;
  final String namaOutlet;
  final int aktif;
  final String alamat;
  final String noTelp;
  final String sales;
  final DateTime tglLahirPemilik;
  final String alamatPengiriman;
  final String titikPengiriman;
  final String kodeProvinsi;
  final String namaProvinsi;
  final String kodeKota;
  final String namaKota;

  //final String kordinatLokasi;

  // var fotolokasi1;
  // var fotolokasi2;
  // final String fotolokasi2;

  Customer({
    this.custID,
    this.custName,
    this.kategoriCust,
    this.subKategori,
    this.jenis,
    this.namaOutlet,
    this.aktif,
    this.alamat,
    this.noTelp,
    this.sales,
    this.tglLahirPemilik,
    this.alamatPengiriman,
    this.titikPengiriman,
    this.kodeProvinsi,
    this.namaProvinsi,
    this.kodeKota,
    this.namaKota,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      custID: json['CustomerID'] as String,
      custName: json['CustomerName'] as String,
      kategoriCust: json['KategoriCustomer'] as String,
      subKategori: json['SubKategori'] as String,
      jenis: json['Jenis'] as String,
      namaOutlet: json['NamaOutlet'] as String,
      aktif: int.parse(json['Aktif']),
      alamat: json['Alamat'] as String,
      noTelp: json['NoTelp'] as String,
      sales: json['Sales'] as String,
      tglLahirPemilik:
          json['TglLahirPemilik'] == null ? null : DateTime.parse(json['TglLahirPemilik']),
      titikPengiriman: json['LokasiPengiriman'] as String,
      alamatPengiriman: json['AlamatPengiriman'] as String,
      kodeProvinsi: json['KodeProvinsi'] as String,
      namaProvinsi: json['NamaProvinsi'] as String,
      kodeKota: json['KodeKota'] as String,
      namaKota: json['NamaKota'] as String,
    );
  }
}
