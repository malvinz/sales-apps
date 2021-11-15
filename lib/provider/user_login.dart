import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_apps/model/log_Mobil.dart';

import '../model/data_user.dart';
import 'dart:convert';

class UserLogin with ChangeNotifier {
  DataUser _datauser = DataUser(
      kodeSales: "MAL-0001",
      namaSales: "MALVIN",
      area: "JAKARTA",
      kota: "JAKARTA BARAT",
      userid: "Malvin",
      password: "malvin",
      kodeDepo: "DEP-0001",
      namaDepo: "MAIN DEPO");
  LogMobile _dataLogIn = LogMobile(
    userid: "MALVIN",
    passwordmobile: "malvin",
    macaddress: "15.15487.6545",
    mobileid: "",
    program: "Sales",
  );

  DataUser get items {
    return _datauser;
  }

  LogMobile get logIn {
    return _dataLogIn;
  }

  Future<void> getUserLogin(BuildContext context, String userid) async {
    try {
      var aksi = 'getDataSales';

      final url = Uri.parse('http://domain.com/fileapi.php?aksi=' +
          Uri.encodeComponent(aksi) +
          "&userid=" +
          Uri.encodeComponent(userid));

      final http.Response response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final extractedData = json.decode(response.body);
      final Map<String, dynamic> data = extractedData[0];

      // final List<DataUser> datasales = (json.decode(response.body) as List)
      //     .map((data) => DataUser.fromJson(data))
      //     .toList();

      if (data.isNotEmpty) {
        _datauser = new DataUser(
          kodeSales: data["KodeSales"],
          namaSales: data["NamaSales"],
          area: data["NamaProvinsi"],
          kota: data["NamaKota"],
          userid: data["UserID"],
          password: data["PasswordMobile"],
          kodeDepo: data["KodeDepo"],
          namaDepo: data["NamaDepo"],
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                    Text("Terjadi masalah untuk data sales, harap coba lagi atau hubungi team IT."),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.navigate_next))
                ],
                title: Text("Something wrong !"),
              );
            });
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUserLogInfo(BuildContext context, String userid, String passwordMobile) async {
    try {
      var aksi = 'getLogIn';

      final url = Uri.parse(
        'http://domain.com/fileapi.php?aksi=' +
            Uri.encodeComponent(aksi) +
            "&UserID=" +
            Uri.encodeComponent(userid) +
            '&PasswordMobile=' +
            Uri.encodeComponent(passwordMobile) +
            '&Program=' +
            Uri.encodeComponent('Sales_App'),
      );

      final http.Response response =
          await http.get(url, headers: {"Content-Type": "application/json"});
      final extractedData = json.decode(response.body);
      if (extractedData.isNotEmpty) {
        final Map<String, dynamic> data = extractedData[0];

        _dataLogIn = new LogMobile(
          userid: data["userid"],
          passwordmobile: data["passwordMobile"],
          macaddress: data["MacAddress"],
          mobileid: data["id"],
          program: data["Program"],
        );
      } else {
        _dataLogIn = new LogMobile(
          userid: '',
          passwordmobile: '',
          macaddress: '',
          mobileid: '',
          program: '',
        );
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> insertLogInInfo(
    String userid,
    String passwordMobile,
    String macAddress,
    String id,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(
      url,
      body: {
        "aksi": "insertLogInInfo",
        'UserId': userid,
        'PasswordMobile': passwordMobile,
        'MacAddress': macAddress,
        'Id': id,
        'Program': 'Sales_App'
      },
    );
  }

  Future<void> deleteLogInInfo(
    String userid,
    String passwordMobile,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(
      url,
      body: {
        "aksi": "deleteLogInInfo",
        'UserId': userid,
        'PasswordMobile': passwordMobile,
        'Program': 'Sales_App'
      },
    );
  }

  Future<void> insertLogHistory(
    String userid,
    String macAddress,
    String lokasi,
    String deviceID,
  ) async {
    final url = Uri.parse('http://domain.com/fileapi.php');

    // ignore: unused_local_variable
    final http.Response response = await http.post(
      url,
      body: {
        "aksi": "insertLogHistory",
        'UserID': userid,
        'MacAddress': macAddress,
        'Lokasi': lokasi,
        'DeviceID': deviceID,
        'Program': "Sales_App"
      },
    );
  }
}
