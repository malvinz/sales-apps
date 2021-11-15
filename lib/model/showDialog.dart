import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VinShowDialog with Exception {
  final String pesan;
  final String judul;

  VinShowDialog({this.pesan, this.judul});

  // ignore: missing_return
  Widget build(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("$pesan"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.navigate_next))
          ],
          title: Text("$judul"),
        );
      },
    );
  }
}
