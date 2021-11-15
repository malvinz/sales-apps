import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/purchase_Order_Header.dart';
import '../screen/purchase_Order.dart';
import '../widget/purchase_Order_List_Grid_Item.dart';

import '../widget/appMainDrawer.dart';

class PurchaseListScreen extends StatefulWidget {
  static const routeName = '\PurchaseListScreen';

  @override
  _PurchaseListScreenState createState() => _PurchaseListScreenState();
}

bool _isInit = true;

bool _isLoading = false;

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  var _filterText = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int _maxitem;

  var dataPO;
  int itemDataPO;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      setState(() {});

      // Provider.of<PurchaseOrderHeaderProvider>(context)
      //     .getTransasiPOPerSales(context)
      //     .then((value) {
      setState(() {
        _isLoading = false;
        setRecord();
      });
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void setRecord() {
    final dataPO = Provider.of<PurchaseOrderHeaderProvider>(context, listen: false);
    itemDataPO = (_filterText.text == "" || _filterText.text == null)
        ? dataPO.items.length
        : dataPO.itemsfilter(_filterText.text).length;

    if (itemDataPO < 10) {
      _maxitem = itemDataPO;
    } else {
      _maxitem = 10;
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  _loadMoreData() {
    if (_maxitem < itemDataPO) {
      if ((itemDataPO - _maxitem - 10) < 0) {
        _maxitem = itemDataPO;
      } else {
        _maxitem = _maxitem + 10;
      }
    }
    setState(() {});
    //  }
  }

  Future<void> _refresh() async {
    // await Provider.of<PurchaseOrderHeaderProvider>(context, listen: false)
    //     .getTransasiPOPerSales(context)
    //     .then((value) {
    //   setState(() {});
    // });
    Provider.of<PurchaseOrderHeaderProvider>(context, listen: false).items;
    setState(() {});
  }

  AppBar appheight = AppBar(
    title: Text("tex"),
  );

  @override
  Widget build(BuildContext context) {
    setRecord();
    final dataPO = Provider.of<PurchaseOrderHeaderProvider>(context);
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
              "Purchase List",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
            ),
          ),
        ]),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PurchaseOrderScreen.routeName);
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
            : RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextFormField(
                                controller: _filterText,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  labelText: "Filter No PO",
                                ),
                                onChanged: (_) {
                                  setRecord();
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: () {
                                  setRecord();
                                  setState(() {});
                                },
                                icon: Icon(Icons.search),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 9.5 / 2,
                            crossAxisSpacing: 20,
                          ),
                          itemCount: _maxitem == itemDataPO ? _maxitem : _maxitem + 1,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: (_filterText.text == "" || _filterText.text == null)
                                ? dataPO.items[i]
                                : dataPO.itemsfilter(_filterText.text)[i],
                            child: (i == _maxitem)
                                ? CupertinoActivityIndicator()
                                : PurchaseOrderListGridItem(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
