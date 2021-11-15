import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../widget/appMainDrawer.dart';
import '../widget/laporan_customer_tidak_order.dart';

class LaporanScreen extends StatefulWidget {
  static const routeName = '\LaporanSales';
  @override
  _LaporanScreenState createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  String namaLaporan;

  AppBar appheight = AppBar(
    title: Text("tex"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Stack(children: [
          Container(
            height: appheight.preferredSize.height,
            width: appheight.preferredSize.width,
            alignment: Alignment.centerRight,
            child: Container(
              child: Image.asset(
                'assets/gambar/dashboard.png',
                fit: BoxFit.contain,
                color: Color.fromRGBO(255, 255, 255, 0.7),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: appheight.preferredSize.height,
            width: appheight.preferredSize.width,
            child: Text(
              "Laporan Sales",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
        // style: TextStyle(
        //   color: Colors.blue.shade900,
        //   fontWeight: FontWeight.bold,
        // ),

        backgroundColor: Colors.transparent,
      ),
      drawer: AppMainDrawer(),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/gambar/dashboard.png"),
              fit: BoxFit.contain,
              colorFilter: new ColorFilter.mode(
                  const Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black12,
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.15,
                        color: Colors.white,
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItem: true,
                          // items: ["PCS", "DUS", "KATON"],
                          items: ['Laporan Customer Tidak Order', 'Laporan Performa Sales'],
                          label: "Nama Laporan",
                          showSearchBox: true,
                          hint: "Nama Laporan",
                          selectedItem: namaLaporan,
                          onSaved: (_) {},
                          onChanged: (value) {
                            namaLaporan = value;

                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'harap Pilih Laporan lebih dulu';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          color: Colors.black,
                          onPressed: () {},
                          icon: Icon(Icons.search),
                        ),
                      )
                    ],
                  ),
                ),
                namaLaporan == "Laporan Customer Tidak Order"
                    ? LaporanCustomerTidakOrderPage()
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
