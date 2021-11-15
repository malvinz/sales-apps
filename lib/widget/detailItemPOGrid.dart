import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/detailItemPO.dart';

import '../provider/purchase_Order_Detail.dart';

class DetailPODetailGrid extends StatelessWidget {
  final String noPO;
  final String custID;
  final DateTime tanggal;

  DetailPODetailGrid({@required this.noPO, @required this.custID, @required this.tanggal});

  @override
  Widget build(BuildContext context) {
    final dataHistoryTransaksi = Provider.of<PurchaseOrderDetailProvider>(context).findByNoPO(noPO);

    if (dataHistoryTransaksi.length == 0) {
      return Text("Tidak ada data");
    } else {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 8 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: dataHistoryTransaksi.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: dataHistoryTransaksi[i],
            child: ItemDetailItemPOGrid(
              noPO: noPO,
              custID: custID,
              tanggal: tanggal,
            ),
          ),
        ),
      );
    }
  }
}
