import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/customer_Tidak_Order_Provider.dart';
import '../provider/general_Provider.dart';

import '../provider/target_Sales.dart';

import '../screen/change_Password.dart';
import '../screen/insentif_Sales_screen.dart';
import '../screen/laporan_Sales_Screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

import '../screen/customer_List_Screen.dart';
import '../screen/customer_View_Screen.dart';
import '../provider/purchase_Order_Detail.dart';
import '../provider/purchase_Order_Header.dart';
import '../screen/transaksi_detail.dart';
import '../provider/diskon_Provider.dart';

import '../screen/dashBoard.dart';
import '../screen/diskon_List_Screen.dart';
import '../screen/purchase_List_Screen.dart';

import '../provider/user_login.dart';
import './screen/login.dart';
import './screen/menu_Utama.dart';
import './screen/purchase_Order.dart';
import './screen/purchase_Order_Detail.dart';
import './provider/data_produk.dart';

import './provider/data_Customer.dart';
import './screen/customer_add_Edit_Screen.dart';

SharedPreferences preferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  CameraDescription camera;
  String parameter1;

  Future<void> cekAuth() async {
    parameter1 = preferences.getString("nama");
    //  return parameter1;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    cekAuth();
    parameter1 = preferences.getString('nama') == null ? "" : preferences.getString('nama');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: UserLogin(),
        ),
        ChangeNotifierProvider.value(
          value: PurchaseOrderHeaderProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DataCustomer(),
        ),
        ChangeNotifierProvider.value(
          value: PurchaseOrderDetailProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DiskonProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CustomerTidakOrderProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TargetSalesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: GeneralProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sales_apps',
          theme: ThemeData(
            //primarySwatch: Color(Color.fromRGBO(255,255,112,0.57)),
            primaryColor: Colors.blue.shade200,
            accentColor: Colors.blueAccent.shade100,
          ),
          home: parameter1 == "" ? LoginScreen() : MenuUtamaScreen(),
          routes: {
            MenuUtamaScreen.routeName: (ctx) => MenuUtamaScreen(),
            TransaksiDetailScreen.routeName: (ctx) => TransaksiDetailScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            PurchaseOrderScreen.routeName: (ctx) => PurchaseOrderScreen(),
            PurchaseOrderDetailScreen.routeName: (ctx) => PurchaseOrderDetailScreen(),
            CustomerListScreen.routeName: (ctx) => CustomerListScreen(),
            CustomerViewScreen.routeName: (ctx) => CustomerViewScreen(),
            CustomerAddEditScreen.routeName: (ctx) => CustomerAddEditScreen(),
            PurchaseListScreen.routeName: (ctx) => PurchaseListScreen(),
            DashBoardScreen.routeName: (ctx) => DashBoardScreen(),
            DiskonListScreen.routeName: (ctx) => DiskonListScreen(),
            LaporanScreen.routeName: (ctx) => LaporanScreen(),
            ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
            InsentifScreen.routeName: (ctx) => InsentifScreen(),
          }),
    );
  }
}
