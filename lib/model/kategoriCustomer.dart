import 'package:flutter/foundation.dart';

class KategoriCustomer with ChangeNotifier {
  final String kategoriCustomer;
  final String subKategori;
  final String minimumPembelian;

  KategoriCustomer({
    @required this.kategoriCustomer,
    @required this.subKategori,
    @required this.minimumPembelian,
  });

  factory KategoriCustomer.fromJson(Map<String, dynamic> json) {
    return KategoriCustomer(
      kategoriCustomer: json['KategoriCustomer'] as String,
      subKategori: json['SubKategori'] as String,
      minimumPembelian: json['MinimumPembelian'] as String,
    );
  }

  void toggleFavoriteStatus() {
    notifyListeners();
  }
}
