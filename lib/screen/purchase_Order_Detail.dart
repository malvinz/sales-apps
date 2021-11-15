import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/purchase_Order_Detail.dart';
import '../provider/data_produk.dart';
import '../model/data_PO_detail.dart';
import '../model/data_user.dart';
import '../provider/user_login.dart';

class PurchaseOrderDetailScreen extends StatefulWidget {
  static const routeName = '\PurchaseOrderDetail';

  @override
  _PurchaseOrderDetailScreen createState() => _PurchaseOrderDetailScreen();
}

class _PurchaseOrderDetailScreen extends State<PurchaseOrderDetailScreen> {
  var quantity = TextEditingController();
  final formatter = NumberFormat("#,###");
  double subtotal = 0;
  var _isLoading = false;
  var _isInit = true;
  List _item = [];
  var itemdata;
  var _harga = TextEditingController();
  double hargaNilai;

  var kodesales;
  double qty = 0;
  final _form = GlobalKey<FormState>();

  var _editedDetail = DataPODetail(
    noPO: '',
    kodeBarang: '',
    namaBarang: '',
    satuan: '',
    harga: 0,
    qty: 0,
  );

  var noPO;
  var dataproduk;
  var datasatuan;
  var _satuan;
  String _namaBarang;
  List satuanBarang;
  bool _enableBarang;
  String productId;
  String custid;
  DateTime tanggalPO;

  @override
  void didChangeDependencies() {
    Map dataArguments = ModalRoute.of(context).settings.arguments;
    final DataUser userdata = Provider.of<UserLogin>(context, listen: false).items;
    dataproduk = Provider.of<Products>(context, listen: false).findByName(_editedDetail.namaBarang);
    custid = dataArguments["customerID"];
    noPO = dataArguments["nopo"];
    productId = dataArguments["productId"];
    tanggalPO = dataArguments["tanggalPO"];

    if (_isInit) {
      if (productId != '') {
        _enableBarang = false;
        satuanBarang = Provider.of<Products>(context, listen: false).satuanProduks;

        _editedDetail = Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
            .findById(noPO, productId);
        dataproduk =
            Provider.of<Products>(context, listen: false).findByName(_editedDetail.namaBarang);

        _namaBarang = _editedDetail.namaBarang;
        _satuan = _editedDetail.satuan;
        _harga.text = formatter.format(_editedDetail.harga);
        quantity.text = _editedDetail.qty.toString();
        subtotal = _editedDetail.harga * _editedDetail.qty;
        dataproduk =
            Provider.of<Products>(context, listen: false).findByName(_editedDetail.namaBarang);
      } else {
        _enableBarang = true;
        _editedDetail = DataPODetail(
          noPO: noPO,
          kodeBarang: '',
          namaBarang: '',
          satuan: '',
          harga: 0,
          qty: 0,
        );

        _isLoading = false;
        itemdata = Provider.of<Products>(context, listen: false);
        _item = itemdata.items;

        _namaBarang = '';
        _satuan = '';
        _harga.text = formatter.format(0);
        hargaNilai = 0;
        quantity.text = '0';
        subtotal = 0;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  AppBar appheight = AppBar(
    title: Text("tex"),
  );
  @override
  Widget build(BuildContext context) {
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
              "PO Detail",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
                fontSize: 20,
              ),
            ),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              final _isvalid = _form.currentState.validate();
              if (!_isvalid) {
                return;
              }

              productId == ''
                  ? Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
                      .tambahDetailPO(dataproduk.kodeBarang, _editedDetail)
                  : Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
                      .updateDetailPO(productId, _editedDetail);

              Navigator.of(context).pop();
            },
            icon: Icon(Icons.save_alt_rounded),
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
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "No PO : $noPO",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 15),
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
                            //items: ["PCS", "DUS", "KATON"],
                            items: _item.map((item) {
                              return item.namaBarang.toString();
                            }).toList(),
                            label: "Nama Barang",
                            enabled: _enableBarang,
                            showSearchBox: true,
                            hint: "Nama Barang",

                            onChanged: (value) {
                              dataproduk =
                                  Provider.of<Products>(context, listen: false).findByName(value);
                              _namaBarang = value;
                              _harga.text = formatter.format(double.parse(dataproduk.harga));
                              hargaNilai = double.parse(dataproduk.harga);
                              _satuan = (dataproduk.satuan == null) ? "Pc" : dataproduk.satuan;

                              setState(() {
                                satuanBarang =
                                    Provider.of<Products>(context, listen: false).satuanProduks;

                                if (quantity.text == null ||
                                    quantity.text == "" ||
                                    _harga.text.isEmpty) {
                                  subtotal = 0;
                                } else {
                                  subtotal =
                                      double.parse(_harga.text.toString().replaceAll(',', '')) *
                                          double.parse(quantity.text);
                                }
                              });
                              _editedDetail = DataPODetail(
                                noPO: _editedDetail.noPO,
                                kodeBarang: dataproduk.kodeBarang,
                                namaBarang: value,
                                satuan: dataproduk.satuan,
                                harga: hargaNilai,
                                qty: _editedDetail.qty,
                              );
                            },
                            selectedItem: _namaBarang,
                            onSaved: (value) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Harap Pilih Barang Lebih Dulu';
                              }
                              return null;
                            },
                          ),
                        ),
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
                            items: (satuanBarang == null)
                                ? ['Pack']
                                : satuanBarang.map((item) {
                                    return item.satuan.toString();
                                  }).toList(),
                            label: "SATUAN",
                            showSearchBox: true,
                            hint: "SATUAN",
                            onChanged: (value) {
                              setState(() {
                                datasatuan = Provider.of<Products>(context, listen: false)
                                    .findSatuanProdukBySatuan(value);

                                dataproduk = Provider.of<Products>(context, listen: false)
                                    .findByName(_namaBarang.toString());

                                _harga.text =
                                    formatter.format((hargaNilai * datasatuan.jumlahUnit));

                                if (quantity.text == null ||
                                    quantity.text == "" ||
                                    _harga.text.isEmpty) {
                                  subtotal = 0;
                                } else {
                                  subtotal =
                                      double.parse(_harga.text.toString().replaceAll(',', '')) *
                                          double.parse(quantity.text);
                                }
                              });
                              _editedDetail = DataPODetail(
                                noPO: _editedDetail.noPO,
                                kodeBarang: _editedDetail.kodeBarang,
                                namaBarang: _editedDetail.namaBarang,
                                satuan: value,
                                harga: hargaNilai * datasatuan.jumlahUnit,
                                qty: _editedDetail.qty,
                              );
                            },
                            selectedItem: _satuan,
                            onSaved: (value) {},
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Harap Pilih Satuan Lebih Dulu';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Divider(),
                      Container(
                        height: 70,
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFormField(
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              controller: _harga,
                              onChanged: (value) {
                                setState(
                                  () {
                                    if (value == null || value == "" || quantity.text.isEmpty) {
                                      subtotal = 0;
                                    } else {
                                      subtotal = double.parse(value) * double.parse(quantity.text);
                                    }
                                  },
                                );
                                _editedDetail = DataPODetail(
                                    noPO: _editedDetail.noPO,
                                    kodeBarang: _editedDetail.kodeBarang,
                                    namaBarang: _editedDetail.namaBarang,
                                    satuan: _editedDetail.satuan,
                                    harga: double.parse(value),
                                    qty: _editedDetail.qty);
                              },
                              decoration: InputDecoration(labelText: "Harga"),
                              textInputAction: TextInputAction.done,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Harga Tidak Valid';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: TextFormField(
                          controller: quantity,
                          onChanged: (value) {
                            _editedDetail = DataPODetail(
                              noPO: _editedDetail.noPO,
                              kodeBarang: _editedDetail.kodeBarang,
                              namaBarang: _editedDetail.namaBarang,
                              satuan: _editedDetail.satuan,
                              harga: _editedDetail.harga,
                              qty: double.parse((value.toString() == "") ? '0' : value),
                            );
                            setState(() {
                              if (value == null || value == "" || _harga.text.isEmpty) {
                                subtotal = 0;
                              } else {
                                subtotal =
                                    double.parse(_harga.text.toString().replaceAll(',', '')) *
                                        double.parse(value);
                              }
                            });
                          },
                          decoration: InputDecoration(labelText: "Quantity"),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onSaved: (value) {},
                          validator: (value) {
                            if (value.isEmpty || value == '0') {
                              return 'Harap Masukkan Quantity';
                            }
                            return null;
                          },
                        ),
                      ),
                      Divider(),
                      Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          children: [
                            Text("subtotal"),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            Text(
                              "RP. ${formatter.format(subtotal)}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
