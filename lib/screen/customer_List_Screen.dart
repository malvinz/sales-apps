import 'package:flutter/material.dart';

import '../screen/customer_add_Edit_Screen.dart';
import '../widget/customerListGrid.dart';

import '../widget/appMainDrawer.dart';

class CustomerListScreen extends StatefulWidget {
  static const routeName = '\CustomerListScreen';

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  bool _isLoading = false;
  TextEditingController _filterText = TextEditingController();

  Future<void> _refresh() async {}

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
              "List Customer",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CustomerAddEditScreen.routeName, arguments: '');
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppMainDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gambar/dashboard.png"),
            fit: BoxFit.contain,
            colorFilter:
                new ColorFilter.mode(const Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate),
          ),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(15),
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: TextFormField(
                              controller: _filterText,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: "Filter Nama Customer",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: 25,
                            child: IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: Icon(Icons.search),
                            ),
                          )
                        ],
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: _refresh,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: CustomerListGrid(
                          filtertext: _filterText.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
