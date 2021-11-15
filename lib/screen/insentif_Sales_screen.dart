import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/target_Sales.dart';
import '../provider/user_login.dart';
import '../widget/realisasi_Insentif_Sales_Grid.dart';
import '../widget/appMainDrawer.dart';
import '../widget/insetifSalesGrid.dart';

class InsentifScreen extends StatefulWidget {
  static const routeName = '\InsentifSalesScreen';
  @override
  _InsentifScreenState createState() => _InsentifScreenState();
}

class _InsentifScreenState extends State<InsentifScreen> {
  bool _isDonePrepare = false;
  bool _isInit = true;
  var datauser;
  var dataInsentifSales;
  AppBar appheight = AppBar(
    title: Text("tex"),
  );

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      dataInsentifSales = Provider.of<TargetSalesProvider>(context).items;
      datauser = Provider.of<UserLogin>(context, listen: false).items;
      await Provider.of<TargetSalesProvider>(context, listen: false).getInsentifSales(
        context,
        datauser.kodeSales,
        DateTime.now(),
      );
      _isDonePrepare = true;
      setState(() {});
    }
    _isInit = false;

    super.didChangeDependencies();
  }

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
              "Insentif",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 30),
            ),
          ),
        ]),
        backgroundColor: Colors.yellow.shade400,
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
          child: _isDonePrepare == false
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 1,
                                )
                                // border: Border.all(width: 1),
                                ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Insentif  ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (dataInsentifSales == null || dataInsentifSales.isEmpty)
                                          ? ""
                                          : "${DateFormat('dd MMMM yyyy').format(dataInsentifSales[0].tanggalawal)} - ${DateFormat('dd MMMM yyyy').format(dataInsentifSales[0].tanggalakhir)} ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  InsentifSalesGrid(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "REALISASI  ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  RealisasiInsentifSalesGrid(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
