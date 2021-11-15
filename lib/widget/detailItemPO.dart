import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/purchase_Order_Detail.dart';
import '../model/data_PO_detail.dart';
import '../screen/purchase_Order_Detail.dart';

class ItemDetailItemPOGrid extends StatelessWidget {
  final String noPO;
  final String custID;
  final DateTime tanggal;
  ItemDetailItemPOGrid({
    @required this.noPO,
    @required this.custID,
    @required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    final detailItemPODetail = Provider.of<DataPODetail>(context, listen: false);
    final formatter = NumberFormat("#,###");
    final screensize = MediaQuery.of(context).size;
    Map args;

    return Container(
      width: screensize.width,
      child: Card(
        // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                'assets/gambar/dashboard.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: FittedBox(
            child: Text(
              detailItemPODetail.namaBarang,
            ),
          ),
          subtitle: FittedBox(
            child: Text(
                '${formatter.format(detailItemPODetail.harga)} x ${formatter.format(detailItemPODetail.qty)} ${detailItemPODetail.satuan} = Rp. ${formatter.format(detailItemPODetail.harga * detailItemPODetail.qty)}'),
          ),
          trailing: Container(
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    iconSize: 30,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Provider.of<PurchaseOrderDetailProvider>(context, listen: false)
                          .deleteDetailPO(detailItemPODetail.kodeBarang);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(0.0),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    iconSize: 30,
                    icon: Icon(
                      Icons.document_scanner,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      args = {
                        'nopo': (noPO == null) ? '' : noPO,
                        'productId': detailItemPODetail.kodeBarang,
                        'customerID': custID,
                        'tanggalPO': tanggal,
                      };
                      Navigator.of(context)
                          .pushNamed(PurchaseOrderDetailScreen.routeName, arguments: args);
                    },
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
