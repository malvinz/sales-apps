import 'package:flutter/material.dart';
import '../provider/data_Customer.dart';
import '../screen/change_Password.dart';
import '../screen/diskon_List_Screen.dart';
import '../screen/laporan_Sales_Screen.dart';

import '../screen/purchase_List_Screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../screen/menu_Utama.dart';
import '../screen/login.dart';
import '../provider/user_login.dart';
import '../model/data_user.dart';
import 'package:provider/provider.dart';
import '../screen/customer_List_Screen.dart';

// ignore: must_be_immutable
class AppMainDrawer extends StatelessWidget {
  DataUser userdata;

  @override
  Widget build(BuildContext context) {
    userdata = Provider.of<UserLogin>(context, listen: false).items;
    AppBar appheight = AppBar(
      title: Text("tex"),
    );

    print((MediaQuery.of(context).size.height - appheight.preferredSize.height));
    return Drawer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(children: [
          AppBar(
            shape: ContinuousRectangleBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80.0),
                bottomRight: Radius.circular(80.0),
              ),
            ),
            title: Text("Main Menu"),
          ),
          Padding(padding: EdgeInsets.all(20)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              Container(
                width: 150,
                height: (MediaQuery.of(context).size.height - appheight.preferredSize.height) * 0.2,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 8,
                  right: 10,
                ),
                child: SizedBox.expand(
                  child: FittedBox(
                    child: Image.asset(
                      'assets/gambar/dashboard.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        userdata == null
                            ? ""
                            : userdata.namaSales.length > 15
                                ? userdata.namaSales.substring(0, 15).toUpperCase()
                                : userdata.namaSales.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    FittedBox(
                      child: Text(
                        userdata == null ? "" : userdata.area.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    FittedBox(
                      child: Text(
                        userdata == null ? "" : userdata.kota.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
          Container(
            height: 20,
          ),
          Divider(
            color: Colors.black,
          ),
        ]),
        Expanded(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      "HOME",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(MenuUtamaScreen.routeName);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(Icons.disc_full),
                    title: Text(
                      "Diskon List",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      Navigator.of(context).pushReplacementNamed(DiskonListScreen.routeName);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(Icons.add_shopping_cart),
                    title: Text(
                      "Purchase Order",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(PurchaseListScreen.routeName);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      "Customer",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // Provider.of<DataCustomer>(context, listen: false)
                      //     .getCustomer(context, userdata.kodeSales)
                      //     .then((_) {
                      Navigator.of(context).pushReplacementNamed(CustomerListScreen.routeName);
                      // });
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text(
                      "Laporan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      Navigator.of(context).pushReplacementNamed(LaporanScreen.routeName);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(Icons.lock_open_outlined),
                    title: Text(
                      "Change Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
                    },
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      "Sign Out",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();

                      preferences.setString("nama", "");
                      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
