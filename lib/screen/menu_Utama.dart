import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../provider/target_Sales.dart';
import '../provider/user_login.dart';
import '../screen/login.dart';
import '../widget/insentifSales.dart';
import '../widget/target_sales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import '../widget/appMainDrawer.dart';
import 'package:get_mac/get_mac.dart';

class MenuUtamaScreen extends StatefulWidget {
  static const routeName = '\MenuUtama';

  @override
  _MenuUtamaScreenState createState() => _MenuUtamaScreenState();
}

class _MenuUtamaScreenState extends State<MenuUtamaScreen> {
  String _deviceid;
  String _devicename;
  final List screen = [
    TargetSalesScreen(),
    InsentifSales(),
  ];

  bool _isDonePrepare = false;
  bool _isInit = true;
  SwiperController _controller = SwiperController();
  int _currentIndex = 0;

  Future<bool> _deviceInfo(String userid, String passwordMobile) async {
    String _lokasi;
    // await Provider.of<UserLogin>(context, listen: false)
    //     .getUserLogInfo(context, userid, passwordMobile);
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _lokasi = '${position.latitude},${position.longitude}';
    });

    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    final datalogin = Provider.of<UserLogin>(context, listen: false).logIn;

    final macAddress = await GetMac.macAddress;
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        _devicename = build.model;

        _deviceid = build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;

        _devicename = data.name;
        _deviceid = data.identifierForVendor;
      }

      if (datalogin == null || datalogin.macaddress.isEmpty) {
        Fluttertoast.showToast(
          msg: "Login Expired, Please Re-Login.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 60,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.setString("nama", "");
        print('data log info tidak ada atau null');
        return false;
      } else if (datalogin.macaddress == "") {
        // await Provider.of<UserLogin>(context, listen: false)
        //     .deleteLogInInfo(userid, passwordMobile);
        Fluttertoast.showToast(
          msg: "you are Login with defferent device from your last login, Please Re-Login.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 60,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("nama", "");
        print('mac address tidak sama');
        return false;
      }

      // await Provider.of<UserLogin>(context, listen: false)
      //     .insertLogHistory(userid, macAddress, _lokasi, _deviceid);
      return true;
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit == true) {
      _isDonePrepare = false;
      FocusNode focusNode = new FocusNode();
      focusNode.unfocus();
      String _userid;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _userid = preferences.getString("nama");

      final datauser = Provider.of<UserLogin>(context, listen: false).items;

      _deviceInfo(datauser.userid, datauser.password).then((value) async {
        if (value == true) {
          setState(
            () {
              _isDonePrepare = true;
            },
          );
        } else {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appheight = AppBar(
      title: Text("tex"),
    );
    final dataTargetSales = Provider.of<TargetSalesProvider>(context, listen: false).items;

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
                    'assets/gambar/freelogo.png',
                    fit: BoxFit.contain,
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
              "Target",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
      ),
      drawer: _isDonePrepare ? AppMainDrawer() : null,
      body: SizedBox.expand(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gambar/dashboard.png"),
                fit: BoxFit.contain,
                colorFilter: new ColorFilter.mode(
                    const Color.fromRGBO(255, 255, 255, 0.6), BlendMode.modulate),
              ),
            ),
            child: _isDonePrepare == false
                ? Center(child: CircularProgressIndicator())
                : Swiper(
                    index: _currentIndex,
                    onIndexChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    controller: _controller,
                    loop: false,
                    pagination: SwiperPagination(
                      margin: EdgeInsets.only(
                        right: 50.0,
                      ),
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        activeColor: Colors.blue,
                        activeSize: 15.0,
                      ),
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return screen[index];
                    },
                  )),
      ),
    );
  }
}
