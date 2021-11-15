import 'package:flutter/foundation.dart';

class DataUser with ChangeNotifier {
  final String kodeSales;
  final String namaSales;
  final String area;
  final String kota;
  final String userid;
  final String password;
  final String kodeDepo;
  final String namaDepo;

  DataUser({
    @required this.kodeSales,
    @required this.namaSales,
    @required this.area,
    @required this.kota,
    @required this.userid,
    @required this.password,
    @required this.kodeDepo,
    @required this.namaDepo,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
      kodeSales: json['Sales'] as String,
      namaSales: json['userprofile'] as String,
      area: json['Customer'] as String,
      kota: json['TotalTransaksi'] as String,
      userid: json['userid'] as String,
      password: json['status'] as String,
      kodeDepo: json['KodeDepo'] as String,
      namaDepo: json['NamaDepo'] as String,
    );
  }

  void toggleFavoriteStatus() {
    notifyListeners();
  }
}
