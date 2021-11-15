import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/purchase_Order_Detail.dart';
import '../provider/purchase_Order_Header.dart';
import '../widget/generatePIOrder.dart';
import '../model/data_PO_header.dart';
import '../screen/purchase_Order.dart';

class PurchaseOrderListGridItem extends StatefulWidget {
  @override
  _PurchaseOrderListGridItemState createState() => _PurchaseOrderListGridItemState();
}

class _PurchaseOrderListGridItemState extends State<PurchaseOrderListGridItem> {
  DataPOHeader _dataPO;
  final formatter = NumberFormat("#,###");
  Future<void> _editData() async {
    var dataheader =
        Provider.of<PurchaseOrderHeaderProvider>(context, listen: false).findbynoPO(_dataPO.noPO);

    if (dataheader.status != "Menunggu Approval PO") {
      Fluttertoast.showToast(
          msg: "Transaksi ini sudah tidak dapat di edit.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 60,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    // ignore: unused_local_variable
    final dataform = await Navigator.of(context)
        .pushNamed(PurchaseOrderScreen.routeName, arguments: _dataPO.noPO);

    setState(
      () {
        Provider.of<PurchaseOrderHeaderProvider>(context, listen: false)
            .getTransasiPOPerSales(context);
      },
    );
  }

  showSuccessToast() {
    Fluttertoast.showToast(
        msg: "Your file has been exported successfully.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 60,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showErrorToast() {
    Fluttertoast.showToast(
        msg: "Exporting your file failed. Nothing was downloaded.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 60,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> exportPI(String noPO, BuildContext context) async {
    int no = 1;
    print(noPO);
    var dataheader =
        Provider.of<PurchaseOrderHeaderProvider>(context, listen: false).findbynoPO(noPO);

    var dataDetail =
        Provider.of<PurchaseOrderDetailProvider>(context, listen: false).findByNoPO(noPO);
    List<List<dynamic>> datatable = [
      ['No', 'Keterangan', 'Jumlah', 'Satuan', 'Harga', 'Sub Total']
    ];

    dataDetail.map((value) {
      datatable.add(
          [no, value.namaBarang, value.qty, value.satuan, value.harga, (value.harga * value.qty)]);
      no = no + 1;
    }).toList();

    generatePDFPI(datatable, noPO.replaceAll('/', '-'), dataheader, context).then(
      (value) {
        if (value)
          showSuccessToast();
        else
          showErrorToast();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _dataPO = Provider.of<DataPOHeader>(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                height: 15,
                child: FittedBox(
                  child: Text(
                    _dataPO.noPO.toString(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 15,
                child: FittedBox(
                  child: Text(
                    _dataPO.namaCustomer.toString(),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 15,
                child: FittedBox(
                  child: Text(
                    formatter.format((_dataPO.total - _dataPO.diskon)).toString(),
                  ),
                ),
              ),
            ],
          ),
          title: Container(
            margin: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width * 0.15,
            height: 15,
            child: FittedBox(
              child: Text(
                DateFormat('dd-MMM-yyyy').format(_dataPO.tanggal).toString(),
              ),
            ),
          ),
          subtitle: FittedBox(
            child: Text(
              _dataPO.status.toString(),
              style: TextStyle(fontSize: 9),
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width * 0.25,
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.document_scanner,
                    color: Colors.green,
                  ),
                  onPressed: _editData,
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.print_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    exportPI(_dataPO.noPO, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
