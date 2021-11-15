import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get_mac/get_mac.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './menu_Utama.dart';
import 'package:flutter/services.dart';

import '../provider/user_login.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '\Login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum LoginStatus { notSignIn, signIn }

//=============================== AUTHENTICATION ==========================

class _LoginScreenState extends State<LoginScreen> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  String _deviceid;

  Future<void> _deviceInfo(String userid, String passwordmobile) async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    final macAddress = await GetMac.macAddress;

    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      _deviceid = build.androidId;

      //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      _deviceid = data.identifierForVendor;
    }
    final datalogin = Provider.of<UserLogin>(context, listen: false).logIn;
  }

  savePref(String userName, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("nama", userName);
    preferences.setString("passowrd", password);
  }

  var value = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    value = preferences.getString("nama");

    _loginStatus = value != "" ? LoginStatus.signIn : LoginStatus.notSignIn;
    setState(() {});
  }

  //=============================== END OF AUTHENTICATION

  final _userid = TextEditingController();
  final _password = TextEditingController();

  Future<void> _saveForm() async {
    var aksi = 'getuser';
    var datalogin = Provider.of<UserLogin>(context, listen: false).items;

    if (_userid.text == "" || _password.text == "") {
      return;
    }
    getPref();

    if (value == "") {
      if (datalogin.userid == _userid.text && datalogin.password == _password.text) {
        _loginStatus = LoginStatus.signIn;
        savePref(_userid.text, _password.text);
        await _deviceInfo(_userid.text, _password.text);
        Navigator.of(context).pushReplacementNamed(MenuUtamaScreen.routeName);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(" ID atau Password anda salah, silahkan coba lagi"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.navigate_next))
                ],
                title: Text("Terjadi masalah, harap coba lagi !"),
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(" ID atau Password anda salah, silahkan coba lagi"),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.navigate_next))
              ],
              title: Text("Terjadi masalah, harap coba lagi !"),
            );
          });
    }
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: (AppBar(
            title: Text('Login'),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.next_plan), onPressed: _saveForm),
            ],
          )),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/gambar/dashboard.png"),
                fit: BoxFit.contain,
                colorFilter: new ColorFilter.mode(
                    const Color.fromRGBO(255, 255, 255, 0.7), BlendMode.modulate),
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(color: Colors.white10),
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'UserID'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {},
                        controller: _userid,
                      ),
                      Divider(),
                      TextFormField(
                        obscureText: true,
                        controller: _password,
                        decoration: InputDecoration(labelText: 'Password'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {},
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: _saveForm,
                            child: Text("Login"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        Navigator.pushReplacementNamed(context, MenuUtamaScreen.routeName);
    }
  }
}
