import 'package:flutter/material.dart';
import '../widget/appMainDrawer.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = '\DashBoard';
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
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
              "Dash Board",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 30),
            ),
          ),
        ]),
        backgroundColor: Colors.yellow.shade400,
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
        ),
      ),
    );
  }
}
