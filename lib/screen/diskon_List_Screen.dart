import 'package:flutter/material.dart';

import '../widget/diskon_Grid.dart';
import '../widget/appMainDrawer.dart';

class DiskonListScreen extends StatefulWidget {
  static const routeName = '\DiskonListScreen';
  @override
  _DiskonListScreenState createState() => _DiskonListScreenState();
}

class _DiskonListScreenState extends State<DiskonListScreen> {
  bool _isInit = true;
// ignore: unused_field
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    _isInit = false;

    super.didChangeDependencies();
  }

  AppBar appheight = AppBar(
    title: Text("tex"),
  );

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
              "Diskon List",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
        backgroundColor: Colors.blue.shade200,
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
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : DiskonGrid(),
        ),
      ),
    );
  }
}
