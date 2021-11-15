import 'package:flutter/foundation.dart';

class DataPOHeader with ChangeNotifier {
  final String noPO;
  final DateTime tanggal;
  final String kodecustomer;
  final String namaCustomer;
  final double total;
  final double diskon;
  final double grandtotal;
  final String status;
  DataPOHeader(
      {@required this.noPO,
      @required this.tanggal,
      @required this.kodecustomer,
      @required this.namaCustomer,
      @required this.total,
      @required this.diskon,
      @required this.grandtotal,
      @required this.status});
  factory DataPOHeader.fromJson(Map<String, dynamic> json) {
    return DataPOHeader(
        noPO: json['NoPO'] as String,
        tanggal: DateTime.parse(json['Tanggal']),
        kodecustomer: json['KodeCustomer'] as String,
        namaCustomer: json['NamaCustomer'] as String,
        total: double.parse(json['Total']),
        diskon: double.parse(json['Diskon']),
        grandtotal: double.parse(json['GrandTotal']),
        status: json['Status'] as String);
  }

  void toggleFavoriteStatus() {
    notifyListeners();
  }
}
