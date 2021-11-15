import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../helper/location_helper.dart';
import '../model/data_Kota.dart';
import '../model/data_Provinsi.dart';
import '../model/foto_Lokasi_customer.dart';
import '../model/location.dart';
import '../provider/general_Provider.dart';
import '../screen/map_screen.dart';
import '../model/customer.dart';
import '../provider/data_Customer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../provider/user_login.dart';
import 'dart:io';
import 'package:camera/camera.dart';

class CustomerAddEditScreen extends StatefulWidget {
  static const routeName = '\CustomerAddEditScreen';

  @override
  _CustomerAddEditScreen createState() => _CustomerAddEditScreen();
}

File _image;
File _image2;

class _CustomerAddEditScreen extends State<CustomerAddEditScreen> {
  //========================= MAP===========================
  // String _previewImageUrl;

  var _isloading = false;
  Customer dataCustomer = Customer();
  var _namaCustomer = TextEditingController();
  var _jenis = TextEditingController();
  var _namaOutlet = TextEditingController();
  var _alamat = TextEditingController();
  var _notelp = TextEditingController();
  var _kordinat = TextEditingController();

  String _editImage;
  String _editImage2;
  var _alamatPengiriman = TextEditingController();
  var _titikPengiriman = TextEditingController();
  bool _isInit = true;

  List kategori = [];
  List subKategori = [];
  List provinsi = [];
  List kota = [];

  FotoLokasiCustomer fotolokasi;
  String _selectedKategori;
  String _selectedSubKategori;
  String _selectedProvinsi;
  String _selectedKota;
  DataProvinsi _dataProvinsi;
  DataKota _dataKota;
  DateTime _tanggalPilih = DateTime.now();
  String custID;
  final _form = GlobalKey<FormState>();
  var _editedCustomer = Customer(
    custID: '',
    custName: '',
    kategoriCust: '',
    subKategori: '',
    jenis: '',
    namaOutlet: '',
    aktif: 0,
    alamat: '',
    noTelp: '',
    sales: '',
    tglLahirPemilik: DateTime.now(),
    alamatPengiriman: '',
    titikPengiriman: '',
    kodeProvinsi: '',
    namaProvinsi: '',
    kodeKota: '',
    namaKota: '',
  );

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {});
  }

  Future<void> _selectOnMap() async {
    var latlang = _kordinat.text.split(',');
    final initialLocation = const PlaceLocation(latitude: -6.235918, longitude: 106.782708);
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: latlang[0] == "" ? false : true,
          isEnable: true,
          initialLocation: latlang[0] == ""
              ? initialLocation
              : PlaceLocation(
                  latitude: double.parse(latlang[0]), longitude: double.parse(latlang[1])),
        ),
      ),
    );

    if (selectedLocation == null) {
      return;
    }
    setState(
      () {
        _titikPengiriman.text = selectedLocation[1].toString();
        _kordinat.text =
            "${selectedLocation[0].latitude.toString()},${selectedLocation[0].longitude.toString()}";

        _editedCustomer = Customer(
          custID: _editedCustomer.custID,
          custName: _editedCustomer.custName,
          kategoriCust: _editedCustomer.kategoriCust,
          subKategori: _editedCustomer.subKategori,
          jenis: _editedCustomer.jenis,
          namaOutlet: _editedCustomer.namaOutlet,
          aktif: 1,
          alamat: _editedCustomer.alamat,
          noTelp: _editedCustomer.noTelp,
          sales: _editedCustomer.sales,
          tglLahirPemilik: _editedCustomer.tglLahirPemilik,
          alamatPengiriman: _editedCustomer.alamatPengiriman,
          titikPengiriman: _titikPengiriman.text,
          kodeProvinsi: _editedCustomer.kodeProvinsi,
          namaProvinsi: _editedCustomer.namaProvinsi,
          kodeKota: _editedCustomer.kodeKota,
          namaKota: _editedCustomer.namaKota,
        );
      },
    );

    _showPreview(selectedLocation[0].latitude, selectedLocation[0].longitude);
  }

//============================== END OF MAP ==========================
  @override
  void didChangeDependencies() async {
    _isloading = true;
    var datauser = Provider.of<UserLogin>(context, listen: false).items;
    final kodeCustomer = ModalRoute.of(context).settings.arguments;
    custID = kodeCustomer == null ? '' : kodeCustomer;

    if (_isInit == true) {
      if (kodeCustomer != '') {
        _editedCustomer = Provider.of<DataCustomer>(context).findById(kodeCustomer);
        fotolokasi = Provider.of<DataCustomer>(context, listen: false).fotolokasiCustomer;

        _namaCustomer.text = _editedCustomer.custName;
        _selectedKategori = _editedCustomer.kategoriCust;
        _selectedSubKategori = _editedCustomer.subKategori;
        _jenis.text = _editedCustomer.jenis;
        _namaOutlet.text = _editedCustomer.namaOutlet;
        _alamat.text = _editedCustomer.alamat;
        _notelp.text = _editedCustomer.noTelp;
        _tanggalPilih = _editedCustomer.tglLahirPemilik;
        _alamatPengiriman.text = _editedCustomer.alamatPengiriman;
        _titikPengiriman.text = _editedCustomer.titikPengiriman;

        _editImage = fotolokasi == null ? "" : fotolokasi.fotoLokasi1;
        _editImage2 = fotolokasi == null ? "" : fotolokasi.fotoLokasi2;
        _selectedProvinsi = _editedCustomer.namaProvinsi;
        _selectedKota = _editedCustomer.namaKota;

        _dataProvinsi = Provider.of<GeneralProvider>(context, listen: false)
            .findProvinsiByNamaProvinsi(_editedCustomer.namaProvinsi);
        kota = Provider.of<GeneralProvider>(context, listen: false)
            .itemsKota(_dataProvinsi.kodeProvinsi);
      }
      provinsi = Provider.of<GeneralProvider>(context, listen: false).itemsProvinsi;
    }
    kategori = Provider.of<DataCustomer>(context, listen: false).kategoricustomers;

    _isInit = false;
    _isloading = false;

    super.didChangeDependencies();
  }

  void _showdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2000),
    ).then((value) {
      // ignore: unrelated_type_equality_checks
      if (value == Null) {
        return;
      }
      setState(() {
        _tanggalPilih = value;
        _editedCustomer = Customer(
          custID: _editedCustomer.custID,
          custName: _editedCustomer.custName,
          kategoriCust: _editedCustomer.kategoriCust,
          subKategori: _editedCustomer.subKategori,
          jenis: _editedCustomer.jenis,
          namaOutlet: _editedCustomer.namaOutlet,
          aktif: 1,
          alamat: _editedCustomer.alamat,
          noTelp: _editedCustomer.noTelp,
          sales: _editedCustomer.sales,
          tglLahirPemilik: value,
          alamatPengiriman: _editedCustomer.alamatPengiriman,
          titikPengiriman: _editedCustomer.titikPengiriman,
          kodeProvinsi: _editedCustomer.kodeProvinsi,
          namaProvinsi: _editedCustomer.namaProvinsi,
          kodeKota: _editedCustomer.kodeKota,
          namaKota: _editedCustomer.namaKota,
        );
      });
    });
  }

  void _saveCustomer() async {
    final _isvalid = _form.currentState.validate();

    if (!_isvalid) {
      return;
    }
    _form.currentState.save();

    _isloading = true;
    setState(() {});
    if ((_image == null && _editImage == null) || (_image2 == null && _editImage2 == null)) {
      //VinShowDialog(judul: 'Data Tidak Valid', pesan: 'Harap Pilih Foto Lebih Dulu');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Harap Pilih Pilih Foto Lokasi Lebih Dulu",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    final datauser = Provider.of<UserLogin>(context, listen: false).items;
    if (_namaCustomer.text.length > 2) {
      if (custID == "") {
        String _kodeCust = Provider.of<DataCustomer>(context, listen: false)
            .generateKodeCust(_namaCustomer.text.substring(0, 3) + '-');

        _editedCustomer = Customer(
          custID: _kodeCust,
          custName: _editedCustomer.custName,
          kategoriCust: _editedCustomer.kategoriCust,
          subKategori: _editedCustomer.subKategori,
          jenis: _editedCustomer.jenis,
          namaOutlet: _editedCustomer.namaOutlet,
          aktif: 1,
          alamat: _editedCustomer.alamat,
          noTelp: _editedCustomer.noTelp,
          sales: datauser.kodeSales,
          tglLahirPemilik: _editedCustomer.tglLahirPemilik,
          alamatPengiriman: _editedCustomer.alamatPengiriman,
          titikPengiriman: _editedCustomer.titikPengiriman,
          kodeProvinsi: _editedCustomer.kodeProvinsi,
          namaProvinsi: _editedCustomer.namaProvinsi,
          kodeKota: _editedCustomer.kodeKota,
          namaKota: _editedCustomer.namaKota,
        );

        Provider.of<DataCustomer>(context, listen: false)
            .tambahCustomer(_kodeCust, _editedCustomer);
        Navigator.pop(context);
      } else {
        Provider.of<DataCustomer>(context, listen: false).tambahCustomer(custID, _editedCustomer);

        Navigator.pop(context);
      }
    } else {}

    _isloading = false;
    setState(() {});
  }

//===============================Photo Picker ===================================================
  _imgFromCamera(String img) async {
    XFile image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      print(img);
      if (img == '1') {
        _image = File(image.path);
      } else {
        _image2 = File(image.path);
      }
    });
  }

  _imgFromGallery(String img) async {
    XFile image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (img == '1') {
        _image = File(image.path);
      } else {
        _image2 = File(image.path);
      }
    });
  }

  void _showPicker(context, String img) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(img);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(img);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

//===============================END OF PHOTO PICKER
  @override
  Widget build(BuildContext context) {
    final _sizeWidthScreen = MediaQuery.of(context).size.width;
    AppBar appheight = AppBar(
      title: Text("tex"),
    );
    return Scaffold(
      appBar: AppBar(
        title: Stack(children: [
          Container(
            height: appheight.preferredSize.height,
            width: appheight.preferredSize.width,
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.30,
              child: SizedBox.expand(
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/gambar/dashboard.png',
                    fit: BoxFit.contain,
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: appheight.preferredSize.height,
            width: appheight.preferredSize.width,
            child: Text(
              "Add / Edit Customer",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              _saveCustomer();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gambar/dashboard.png"),
            fit: BoxFit.contain,
            colorFilter:
                new ColorFilter.mode(const Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate),
          ),
        ),
        child: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Wrap(runSpacing: 5, children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                "Nama Customer / Pemilik",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: _sizeWidthScreen * 0.3,
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                controller: _namaCustomer,
                                enabled: custID == "" ? true : false,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: value,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                decoration: InputDecoration(labelText: "Nama Customer"),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value.isEmpty || value.length < 3) {
                                    return 'harap masukkan Nama Customer Minimal 3 huruf';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              items: (kategori == null)
                                  ? ['Toko']
                                  : kategori
                                      .map((item) {
                                        return item.kategoriCustomer.toString();
                                      })
                                      .toSet()
                                      .toList(),
                              label: "Kategori",
                              showSearchBox: true,
                              hint: "Kategori",
                              selectedItem: _selectedKategori,
                              onChanged: (value) async {
                                subKategori = Provider.of<DataCustomer>(context, listen: false)
                                    .subKategoriCustomer(value);

                                _selectedSubKategori = "";
                                _editedCustomer = Customer(
                                  custID: _editedCustomer.custID,
                                  custName: _editedCustomer.custName,
                                  kategoriCust: value,
                                  subKategori: _editedCustomer.subKategori,
                                  jenis: _editedCustomer.jenis,
                                  namaOutlet: _editedCustomer.namaOutlet,
                                  aktif: 1,
                                  alamat: _editedCustomer.alamat,
                                  noTelp: _editedCustomer.noTelp,
                                  sales: _editedCustomer.sales,
                                  tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                  alamatPengiriman: _editedCustomer.alamatPengiriman,
                                  titikPengiriman: _editedCustomer.titikPengiriman,
                                  kodeProvinsi: _editedCustomer.kodeProvinsi,
                                  namaProvinsi: _editedCustomer.namaProvinsi,
                                  kodeKota: _editedCustomer.kodeKota,
                                  namaKota: _editedCustomer.namaKota,
                                );
                                setState(() {});
                              },
                              onSaved: (_) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'harap Pilih Kategori lebih dulu';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              // items: ["PCS", "DUS", "KATON"],
                              items: (subKategori == null)
                                  ? ['Grosir']
                                  : subKategori.map((item) {
                                      return item.subKategori.toString();
                                    }).toList(),
                              label: "SubKategori",
                              showSearchBox: true,
                              hint: "SubKategori",
                              selectedItem: _selectedSubKategori,
                              onChanged: (value) {
                                _editedCustomer = Customer(
                                  custID: _editedCustomer.custID,
                                  custName: _editedCustomer.custName,
                                  kategoriCust: _editedCustomer.kategoriCust,
                                  subKategori: value,
                                  jenis: _editedCustomer.jenis,
                                  namaOutlet: _editedCustomer.namaOutlet,
                                  aktif: 1,
                                  alamat: _editedCustomer.alamat,
                                  noTelp: _editedCustomer.noTelp,
                                  sales: _editedCustomer.sales,
                                  tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                  alamatPengiriman: _editedCustomer.alamatPengiriman,
                                  titikPengiriman: _editedCustomer.titikPengiriman,
                                  kodeProvinsi: _editedCustomer.kodeProvinsi,
                                  namaProvinsi: _editedCustomer.namaProvinsi,
                                  kodeKota: _editedCustomer.kodeKota,
                                  namaKota: _editedCustomer.namaKota,
                                );
                              },
                              onSaved: (_) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'harap Pilih Sub Kategori Lebih Dulu';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              items: provinsi.map((item) {
                                return item.namaProvinsi.toString();
                              }).toList(),
                              label: "Provinsi",
                              showSearchBox: true,
                              hint: "Provinsi",
                              selectedItem: _selectedProvinsi,
                              onChanged: (value) {
                                _dataProvinsi = Provider.of<GeneralProvider>(context, listen: false)
                                    .findProvinsiByNamaProvinsi(value);
                                print(_dataProvinsi.kodeProvinsi);

                                kota = Provider.of<GeneralProvider>(context, listen: false)
                                    .itemsKota(_dataProvinsi.kodeProvinsi);

                                _editedCustomer = Customer(
                                  custID: _editedCustomer.custID,
                                  custName: _editedCustomer.custName,
                                  kategoriCust: _editedCustomer.kategoriCust,
                                  subKategori: value,
                                  jenis: _editedCustomer.jenis,
                                  namaOutlet: _editedCustomer.namaOutlet,
                                  aktif: 1,
                                  alamat: _editedCustomer.alamat,
                                  noTelp: _editedCustomer.noTelp,
                                  sales: _editedCustomer.sales,
                                  tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                  alamatPengiriman: _editedCustomer.alamatPengiriman,
                                  titikPengiriman: _editedCustomer.titikPengiriman,
                                  kodeProvinsi: _dataProvinsi.kodeProvinsi,
                                  namaProvinsi: value,
                                  kodeKota: _editedCustomer.kodeKota,
                                  namaKota: _editedCustomer.namaKota,
                                );
                                setState(() {});
                              },
                              onSaved: (_) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'harap Pilih Provinsi Lebih Dulu';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItem: true,
                              // items: ["PCS", "DUS", "KATON"],
                              items: kota.map((item) {
                                return item.namaKota.toString();
                              }).toList(),
                              label: "Nama Kota",
                              showSearchBox: true,
                              hint: "Nama Kota",
                              selectedItem: _selectedKota,
                              onChanged: (value) {
                                _dataKota = Provider.of<GeneralProvider>(context, listen: false)
                                    .findKotaByNamaKota(value);

                                _editedCustomer = Customer(
                                  custID: _editedCustomer.custID,
                                  custName: _editedCustomer.custName,
                                  kategoriCust: _editedCustomer.kategoriCust,
                                  subKategori: value,
                                  jenis: _editedCustomer.jenis,
                                  namaOutlet: _editedCustomer.namaOutlet,
                                  aktif: 1,
                                  alamat: _editedCustomer.alamat,
                                  noTelp: _editedCustomer.noTelp,
                                  sales: _editedCustomer.sales,
                                  tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                  alamatPengiriman: _editedCustomer.alamatPengiriman,
                                  titikPengiriman: _editedCustomer.titikPengiriman,
                                  kodeProvinsi: _editedCustomer.kodeProvinsi,
                                  namaProvinsi: _editedCustomer.namaProvinsi,
                                  kodeKota: _dataKota.kodeKota,
                                  namaKota: value,
                                );
                              },
                              onSaved: (_) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'harap Pilih kota Lebih Dulu';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Jenis",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                controller: _jenis,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap Masukkan Jenis Customer';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: "Jenis Customer"),
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: value,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Nama Outlet",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                controller: _namaOutlet,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: value,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                decoration: InputDecoration(labelText: "Nama Outlet"),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap Masukkan Nama Outlet lebih dulu';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Alamat",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                maxLines: 4,
                                controller: _alamat,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: value,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                decoration: InputDecoration(labelText: "Alamat Customer"),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap masukkan Alamat Customer ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "No Telp",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                controller: _notelp,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: value,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                decoration: InputDecoration(labelText: "No Telp Customer"),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap masukkan Alamat Customer ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Tanggal Lahir",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 15)),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 25),
                                width: _sizeWidthScreen * 0.4,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent, width: 1)),
                                child: Text(
                                  _tanggalPilih == null
                                      ? DateFormat('dd-MMMM-yyyy').format(DateTime.now())
                                      : DateFormat('dd-MMMM-yyyy').format(_tanggalPilih),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                              child: IconButton(
                                onPressed: _showdatepicker,
                                icon: Icon(Icons.date_range),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Alamat Pengirim",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                maxLines: 4,
                                controller: _alamatPengiriman,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: value,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                decoration: InputDecoration(labelText: "Alamat Pengirim"),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap masukkan Alamat Customer ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Titik Pengiriman",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                maxLines: 4,
                                controller: _titikPengiriman,
                                onChanged: (value) {
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: value,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                decoration: InputDecoration(labelText: "Titik Pengirim"),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap masukkan Alamat Customer ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            Container(
                              width: _sizeWidthScreen * 0.3,
                              child: Text(
                                "Titik Kordinat",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                controller: _kordinat,
                                decoration: InputDecoration(labelText: "Kordinat"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'harap masukkan Kordinat lebih dulu ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _selectOnMap,
                          child: Text("Pilih Lokasi"),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          'Foto Lokasi 1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 200,
                              width: _sizeWidthScreen * 0.4,
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: (_image != null || _editImage != null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (custID == "" || _image != null)
                                          ? Image.file(
                                              _image,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            )
                                          : SizedBox.expand(
                                              child: FittedBox(
                                                child: Image.memory(
                                                  base64Decode(_editImage.replaceAll("\n", "")),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(50)),
                                      width: 100,
                                      height: 100,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                            ),
                            Container(
                              height: 120,
                              width: _sizeWidthScreen * 0.4,
                              margin: EdgeInsets.only(left: 5, top: 10),
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  _showPicker(context, '1');
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                child: Text("Pick Photo"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(color: Colors.red))),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Text(
                          'Foto Lokasi 2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 200,
                              width: _sizeWidthScreen * 0.4,
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: (_image2 != null || _editImage2 != null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: (custID == "" || _image2 != null)
                                          ? Image.file(
                                              _image2,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            )
                                          : SizedBox.expand(
                                              child: FittedBox(
                                                child: Image.memory(
                                                  base64Decode(_editImage2.replaceAll("\n", "")),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(50)),
                                      width: 100,
                                      height: 100,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                            ),
                            Container(
                              height: 120,
                              width: _sizeWidthScreen * 0.4,
                              margin: EdgeInsets.only(left: 5, top: 10),
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  _showPicker(context, '2');
                                  _editedCustomer = Customer(
                                    custID: _editedCustomer.custID,
                                    custName: _editedCustomer.custName,
                                    kategoriCust: _editedCustomer.kategoriCust,
                                    subKategori: _editedCustomer.subKategori,
                                    jenis: _editedCustomer.jenis,
                                    namaOutlet: _editedCustomer.namaOutlet,
                                    aktif: 1,
                                    alamat: _editedCustomer.alamat,
                                    noTelp: _editedCustomer.noTelp,
                                    sales: _editedCustomer.sales,
                                    tglLahirPemilik: _editedCustomer.tglLahirPemilik,
                                    alamatPengiriman: _editedCustomer.alamatPengiriman,
                                    titikPengiriman: _editedCustomer.titikPengiriman,
                                    kodeProvinsi: _editedCustomer.kodeProvinsi,
                                    namaProvinsi: _editedCustomer.namaProvinsi,
                                    kodeKota: _editedCustomer.kodeKota,
                                    namaKota: _editedCustomer.namaKota,
                                  );
                                },
                                child: Text("Pick Photo"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(color: Colors.red))),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
