import 'package:flutter/foundation.dart';

class FotoLokasiCustomer with ChangeNotifier {
  final String customerID;
  var fotoLokasi1;
  var fotoLokasi2;

  FotoLokasiCustomer({
    @required this.customerID,
    @required this.fotoLokasi1,
    @required this.fotoLokasi2,
  });

  factory FotoLokasiCustomer.fromJson(Map<String, dynamic> json) {
    return FotoLokasiCustomer(
      customerID: json['CustomerID'] as String,
      fotoLokasi1: json['FotoLokasi1'],
      fotoLokasi2: json['FotoLokasi2'],
    );
  }
}
