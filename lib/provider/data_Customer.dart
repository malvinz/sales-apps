import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_apps/model/foto_Lokasi_customer.dart';
import '../model/kategoriCustomer.dart';

import 'dart:convert';
//import '../model/produk.dart';
import '../model/customer.dart';

class DataCustomer with ChangeNotifier {
  List<Customer> _items = [
    Customer(
      custID: "cust-0001",
      custName: "Customer",
      kategoriCust: "Retail",
      subKategori: "Toko",
      jenis: "Warung",
      namaOutlet: "Toko Nanda",
      aktif: 1,
      alamat: "Jl. Jelambar , Grogol.",
      noTelp: "0811-1111-1111",
      sales: "MAL-0001",
      tglLahirPemilik: DateTime.parse("1990-01-01"),
      alamatPengiriman: "Jl. Jelambar, grogol",
      titikPengiriman: "-6.1709194,106.7978927",
      kodeProvinsi: "8",
      namaProvinsi: "Jakarta",
      kodeKota: "1",
      namaKota: "Jakarta Barat",
    ),
    Customer(
      custID: "cust-0002",
      custName: "Andy",
      kategoriCust: "Grossir",
      subKategori: "Distributor",
      jenis: "Warung",
      namaOutlet: "PT. XYZ Sarana Indo",
      aktif: 1,
      alamat: "Jl. Kebon Jeruk , Petamburan.",
      noTelp: "0812-1234-4567",
      sales: "MAL-0001",
      tglLahirPemilik: DateTime.parse("1990-10-01"),
      alamatPengiriman: "Jl. Bandengan Utara, ",
      titikPengiriman: "-6.18005,106.7898675",
      kodeProvinsi: "8",
      namaProvinsi: "Jakarta",
      kodeKota: "1",
      namaKota: "Jakarta Utara",
    ),
  ];

  List<KategoriCustomer> _kategoriCustomer = [
    KategoriCustomer(
      kategoriCustomer: 'Distributor',
      subKategori: 'Sub-Distributor',
      minimumPembelian: '0',
    ),
    KategoriCustomer(
      kategoriCustomer: 'Stokis',
      subKategori: 'Stokis',
      minimumPembelian: '0',
    ),
    KategoriCustomer(
      kategoriCustomer: 'Toko',
      subKategori: 'Grosir',
      minimumPembelian: '0',
    ),
    KategoriCustomer(
      kategoriCustomer: 'Toko',
      subKategori: 'Retail',
      minimumPembelian: '75000',
    ),
    KategoriCustomer(
      kategoriCustomer: 'User',
      subKategori: 'Industri',
      minimumPembelian: '0',
    ),
    KategoriCustomer(
      kategoriCustomer: 'User',
      subKategori: 'UMKM',
      minimumPembelian: '0',
    ),
    KategoriCustomer(
      kategoriCustomer: 'User',
      subKategori: 'Konsumen',
      minimumPembelian: '0',
    ),
  ];
  FotoLokasiCustomer fotolokasiCustomer;

  List<Customer> get items {
    // ignore: sdk_version_ui_as_code
    return [..._items];
  }

  FotoLokasiCustomer get custLocation {
    return fotolokasiCustomer;
  }

  List<Customer> itemsfilter(String filterText) {
    // ignore: sdk_version_ui_as_code
    return _items
        .where((element) => element.custName.toLowerCase().contains(filterText.toLowerCase()))
        .toList();
  }

  void tambahCustomer(String custID, Customer dataCustomer) {
    final indexCustID = _items.indexWhere((value) => value.custID == custID);

    if (indexCustID >= 0) {
      _items[indexCustID] = dataCustomer;
    } else {
      _items.add(dataCustomer);
    }

    notifyListeners();
  }

  Customer findById(String custID) {
    return _items.firstWhere((prod) => prod.custID == custID);
  }

  Customer findByNama(String custname) {
    return _items.firstWhere((prod) => prod.custName == custname);
  }

  static List<Customer> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
  }

  String generateKodeCust(String prefixName) {
    String _kodeCustBaru;
    int nobaru;
    Customer _listFilter =
        _items.firstWhere((prod) => (prod.custID.substring(0, 4) == prefixName), orElse: () {
      null;
    });

    if (_listFilter == null) {
      _kodeCustBaru = prefixName + '0001';
    } else {
      _items.sort((nilai, value) {
        return value.custID.compareTo(nilai.custID);
      });
      nobaru = int.parse(_items[0].custID.substring(5, 8)) + 1;
      _kodeCustBaru = _items[0].custID.substring(0, 11) + nobaru.toString().padLeft(4, '0');
    }
    return _kodeCustBaru;
  }

  Future<void> getFotoLokasiPerCustomer(
      BuildContext context, String kodeSales, String customerID) async {
    try {
      var aksi = 'getFotoLokasiPerCustomer';

      final url = Uri.parse(
        'http://domain.com/fileapi.php?aksi=' +
            Uri.encodeComponent(aksi) +
            "&KodeSales=" +
            Uri.encodeComponent(kodeSales) +
            '&CustomerID=' +
            Uri.encodeComponent(customerID),
      );

      final http.Response response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final extractedData = json.decode(response.body);
      final Map<String, dynamic> data = extractedData[0];

      // final List<DataUser> datasales = (json.decode(response.body) as List)
      //     .map((data) => DataUser.fromJson(data))
      //     .toList();

      if (data.isNotEmpty) {
        fotolokasiCustomer = FotoLokasiCustomer(
          customerID: data['CustomerID'],
          fotoLokasi1: data['FotoLokasi1'],
          fotoLokasi2: data['FotoLokasi2'],
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Gagal mengunduh Foto Lokasi Customer !"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.navigate_next))
                ],
                title: Text("Something wrong !"),
              );
            });
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<String> getNewCustID(BuildContext context, String prefik) async {
    var aksi = 'getNewCustomerID';

    final url = Uri.parse(
      "http://domain.com/fileapi.php?aksi=" +
          Uri.encodeComponent(aksi) +
          '&prefik=' +
          Uri.encodeComponent(
            prefik.toUpperCase(),
          ),
    );

    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    final extractedData = json.decode(response.body);
    //_NoPOBaru = extractedData[0]["NoPOBaru"];
    return extractedData[0]["noCustBaru"];
  }

  Future<void> getCustomer(BuildContext context, String kodesales) async {
    var aksi = 'getCustomerPerSales';

    final url = Uri.parse("http://domain.com/fileapi.php?aksi=" +
        Uri.encodeComponent(aksi) +
        '&KodeSales=' +
        Uri.encodeComponent(kodesales));

    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    final extractedData = json.decode(response.body);

    if (!extractedData.isEmpty) {
      final List<Customer> loadproduk =
          (json.decode(response.body) as List).map((data) => Customer.fromJson(data)).toList();

      _items = loadproduk;
    } else {}
    notifyListeners();
  }

  Future<void> getKateogirCustomer(BuildContext context) async {
    var aksi = 'getALLKategoriCustomer';

    final url = Uri.parse("http://domain.com/fileapi.php?aksi=" + Uri.encodeComponent(aksi));

    final response = await http.get(url, headers: {"Content-Type": "application/json"});

    final extractedData = json.decode(response.body);

    if (!extractedData.isEmpty) {
      final List<KategoriCustomer> loadKategoriCustomer = (json.decode(response.body) as List)
          .map((data) => KategoriCustomer.fromJson(data))
          .toList();

      _kategoriCustomer = loadKategoriCustomer;
    }

    notifyListeners();
  }

  List<KategoriCustomer> get kategoricustomers {
    // ignore: sdk_version_ui_as_code
    return [..._kategoriCustomer];
  }

  List<KategoriCustomer> subKategoriCustomer(String kategori) {
    return _kategoriCustomer.where((value) => value.kategoriCustomer == kategori).toList();
  }

  KategoriCustomer findByKategori(String kategori) {
    return _kategoriCustomer.firstWhere((prod) => prod.kategoriCustomer == kategori);
  }
}
