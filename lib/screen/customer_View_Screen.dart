import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/customer.dart';
import '../provider/data_Customer.dart';
import '../widget/customer_View_General.dart';
import '../widget/customer_View_Pengiriman.dart';
import '../screen/customer_add_Edit_Screen.dart';

class CustomerViewScreen extends StatefulWidget {
  static const routeName = '\CustomerViewScreen';
  @override
  _CustomerViewScreenState createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  String kodecustomer;

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 2);

    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
  }

  Future<void> editData() async {
    final selectedLocation = await Navigator.of(context).pushNamed(
      CustomerAddEditScreen.routeName,
      arguments: kodecustomer,
    );
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    kodecustomer = ModalRoute.of(context).settings.arguments;

    Customer datacustomer =
        Provider.of<DataCustomer>(context, listen: false).findById(kodecustomer);
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
                "${datacustomer.custName}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
              ),
            ),
          ]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: editData,
              // () {
              // Navigator.of(context)
              //     .pushNamed(CustomerAddEditScreen.routeName, arguments: kodecustomer);

              // },
            )
          ],
          bottom: new TabBar(
            controller: controller,
            tabs: [
              Tab(
                icon: new Icon(Icons.document_scanner_rounded),
                text: "General",
              ),
              Tab(
                icon: new Icon(Icons.queue_rounded),
                text: "Pengiriman",
              ),
            ],
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gambar/dashboard.png"),
            fit: BoxFit.contain,
            colorFilter:
                new ColorFilter.mode(const Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate),
          ),
        ),
        child: TabBarView(
          controller: controller,
          children: [
            CustomerViewGeneral(kodeCustomer: kodecustomer),
            CustomerViewPengiriman(
              kodeCustomer: kodecustomer,
            ),
          ],
        ),
      ),
    );
  }
}
