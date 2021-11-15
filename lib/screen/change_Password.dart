import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_apps/model/data_user.dart';
import 'package:sales_apps/provider/user_login.dart';

import 'package:sales_apps/screen/menu_Utama.dart';
import 'package:sales_apps/widget/konfirmation.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '\ChangePasswordScreen';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _passwordLama = TextEditingController();
  TextEditingController _passwordBaru = TextEditingController();
  TextEditingController _passwordBaruKonfirmasi = TextEditingController();
  final _key = GlobalKey<FormState>();
  DataUser datauser;

  void initState() {
    datauser = Provider.of<UserLogin>(context, listen: false).items;

    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appheight = AppBar(
      title: Text(''),
    );

    _konfirmation() {
      final _isvalid = _key.currentState.validate();
      if (!_isvalid) {
        return;
      }

      String tulisan;

      tulisan = "apa anda yakin ingin mengubah passowrd ?";
      Function noFunction;
      Function yesFunction;

      noFunction = () {
        Navigator.pop(context);
      };
      yesFunction = () async {
        final url = Uri.parse('http://domain.com/fileapi.php');

        // ignore: unused_local_variable
        final http.Response response = await http.post(url, body: {
          "aksi": "updatePassowrd",
          "userid": datauser.userid,
          "password": _passwordBaru.text,
        });

        Navigator.of(context).pushNamed(MenuUtamaScreen.routeName);
      };
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return KonfirmationYesNo(
              tulisan: tulisan,
              noFunction: noFunction,
              yesFunction: yesFunction,
            );
          });
    }

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
                    //color: Color.fromRGBO(255, 255, 255, 0.7),
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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/gambar/dashboard.png"),
              fit: BoxFit.contain,
              colorFilter: new ColorFilter.mode(
                  const Color.fromRGBO(255, 255, 255, 0.85), BlendMode.modulate),
            ),
          ),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Card(
                color: Colors.white.withOpacity(0.2),
                margin: EdgeInsets.all(10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _key,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordLama,
                            decoration: InputDecoration(labelText: 'PasswordLama'),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Harap Masukkan Password Lama';
                              } else if (datauser.password != value) {
                                return 'Password anda salah';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordBaru,
                            decoration: InputDecoration(labelText: 'PasswordBaru'),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Harap Masukkan Password Baru';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordBaruKonfirmasi,
                            decoration: InputDecoration(labelText: 'Konfirmasi Password Baru'),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Harap Masukkan Konfirmasi Password Baru';
                              } else if (value != _passwordBaru.text) {
                                return 'Password yang dimasukkan tidak sesuai';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            child: Text("Konfirm"),
                            onPressed: _konfirmation,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
