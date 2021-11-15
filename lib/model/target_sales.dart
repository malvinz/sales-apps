import 'package:flutter/foundation.dart';

class TargetSales with ChangeNotifier {
  final String tipeTarget;
  final DateTime tanggalawal;
  final DateTime tanggalakhir;
  final double harikerja;
  final double totaltarget;
  final String satuan;
  final double totalJual;
  final double jumlahHariTercapai;
  final String merk;
  TargetSales({
    @required this.tipeTarget,
    @required this.merk,
    @required this.tanggalawal,
    @required this.tanggalakhir,
    @required this.harikerja,
    @required this.totaltarget,
    @required this.satuan,
    @required this.totalJual,
    @required this.jumlahHariTercapai,
  });

  factory TargetSales.fromJson(Map<String, dynamic> json) {
    return TargetSales(
      tipeTarget: json['TipeTarget'] as String,
      merk: json['Merk'] as String,
      tanggalawal: DateTime.parse(json['TanggalMulai']),
      tanggalakhir: DateTime.parse(json['TanggalAkhir']),
      harikerja: double.parse(json['Harikerja']),
      totaltarget: double.parse(json['TotalTarget']),
      satuan: json['satuan'] as String,
      totalJual: double.parse(json['TotalJual'] == null ? '0' : json['TotalJual']),
      jumlahHariTercapai: double.parse(json['JumlahHariMencapaiTarget']),
    );
  }
}
