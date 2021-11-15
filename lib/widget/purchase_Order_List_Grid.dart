import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/purchase_Order_List_Grid_Item.dart';
import '../provider/purchase_Order_Header.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class PurchaseOrderListGrid extends StatefulWidget {
  String filtertext;
  PurchaseOrderListGrid({this.filtertext});

  @override
  _PurchaseOrderListGridState createState() => _PurchaseOrderListGridState();
}

class _PurchaseOrderListGridState extends State<PurchaseOrderListGrid> {
  ScrollController _scrollController = ScrollController();
  int _maxitem;

  var dataPO;
  int itemDataPO;

  @override
  void didChangeDependencies() {
    final dataPO = Provider.of<PurchaseOrderHeaderProvider>(context, listen: false);
    itemDataPO = (widget.filtertext == "" || widget.filtertext == null)
        ? dataPO.items.length
        : dataPO.itemsfilter(widget.filtertext).length;
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
    super.didChangeDependencies();
  }

  void changeSet() {
    itemDataPO = (widget.filtertext == "" || widget.filtertext == null)
        ? Provider.of<PurchaseOrderHeaderProvider>(context, listen: false).items.length
        : Provider.of<PurchaseOrderHeaderProvider>(context, listen: false)
            .itemsfilter(widget.filtertext)
            .length;
    if (itemDataPO < 10) {
      _maxitem = itemDataPO;
    } else if (_maxitem < 10) {
      _maxitem = 10;
    }
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

  @override
  Widget build(BuildContext context) {
    final dataPO = Provider.of<PurchaseOrderHeaderProvider>(context, listen: false);
    changeSet();
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 9.5 / 2,
        crossAxisSpacing: 20,
      ),
      itemCount: _maxitem == itemDataPO ? _maxitem : _maxitem + 1,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: (widget.filtertext == "" || widget.filtertext == null)
            ? dataPO.items[i]
            : dataPO.itemsfilter(widget.filtertext)[i],
        child: (i == _maxitem) ? CupertinoActivityIndicator() : PurchaseOrderListGridItem(),
      ),
    );
  }
}
