import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/location.dart';
import '../screen/map_screen.dart';
import '../provider/data_Customer.dart';

// ignore: must_be_immutable
class CustomerViewPengiriman extends StatelessWidget {
  final kodeCustomer;
  CustomerViewPengiriman({this.kodeCustomer});
  var datacustomer;

  Future<void> _selectOnMap(BuildContext context) async {
    var latlang = datacustomer.titikPengiriman.split(',');

    final initialLocation = const PlaceLocation(latitude: -6.235918, longitude: 106.782708);
    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (ctx) => MapScreen(
          isSelecting: true,
          isEnable: false,
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
  }

  @override
  Widget build(BuildContext context) {
    final _ukuranLebarLayar = MediaQuery.of(context).size.width;

    datacustomer = Provider.of<DataCustomer>(context, listen: false).findById(kodeCustomer);
    final fotolokasiCust = Provider.of<DataCustomer>(context, listen: false).fotolokasiCustomer;

    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 1,
        alignment: WrapAlignment.start,
        children: [
          Container(),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'No Telp',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.noTelp}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Alamat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.alamat}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Alamat Pengiriman',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(3),
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${datacustomer.alamatPengiriman}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Titik Pengiriman',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(3),
                  child: Text(
                    '${datacustomer.titikPengiriman}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 50,
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Foto Lokasi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  height: 100,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: 8,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: SizedBox.expand(
                    child: fotolokasiCust == null
                        ? Container()
                        : FittedBox(
                            child: fotolokasiCust.fotoLokasi1 == null
                                ? Container()
                                : Image.memory(
                                    base64Decode(fotolokasiCust.fotoLokasi1.replaceAll("\n", "")),
                                    fit: BoxFit.fill,
                                    // "https://w7.pngwing.com/pngs/689/184/png-transparent-logo-brand-asus-republic-of-gamers-product-design-taehyung-best-of-me-logo-asus-electronic-sports.png",
                                  ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1),
                color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lokasi Kordinat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.all(3),
                  width: _ukuranLebarLayar * 0.4,
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      _selectOnMap(context);
                    },
                    child: Text("Lokasi Map"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
