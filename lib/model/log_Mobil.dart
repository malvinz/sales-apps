import 'package:flutter/foundation.dart';

class LogMobile {
  final String userid;
  final String passwordmobile;
  final String macaddress;
  final String mobileid;
  final String program;

  const LogMobile({
    @required this.userid,
    @required this.passwordmobile,
    @required this.macaddress,
    @required this.mobileid,
    @required this.program,
  });
  factory LogMobile.fromJson(Map<String, dynamic> json) {
    return LogMobile(
      userid: json['userid'] as String,
      passwordmobile: json['passwordMobil'] as String,
      macaddress: json['MacAddress'] as String,
      mobileid: json['id'] as String,
      program: json['Program'] as String,
    );
  }
}
