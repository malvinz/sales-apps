import 'package:flutter/foundation.dart';

class CustomerTidakOrder with ChangeNotifier {
  final String custID;
  final String custName;
  final DateTime tglPOTerakhir;
  final double periode;

  // final String fotolokasi2;

  CustomerTidakOrder({
    this.custID,
    this.custName,
    this.tglPOTerakhir,
    this.periode,
  });

  factory CustomerTidakOrder.fromJson(Map<String, dynamic> json) {
    return CustomerTidakOrder(
      custID: json['CustomerID'] as String,
      custName: json['CustomerName'] as String,
      tglPOTerakhir: DateTime.parse(json['TglTerakhirPo']),
      periode: double.parse(json['Periode']),
    );
  }
}
