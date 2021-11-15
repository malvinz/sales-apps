import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/customer_Tidak_Order.dart';
import '../screen/customer_View_Screen.dart';

class LaporanCustomerTidakOrderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataCustomerTidakOrder = Provider.of<CustomerTidakOrder>(context, listen: false);

    final screensize = MediaQuery.of(context).size;

    return Container(
      width: screensize.width * 0.9,
      child: Card(
        color: Colors.grey.shade100,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          tileColor: Colors.grey.shade100,
          leading: Text(
            dataCustomerTidakOrder.custName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          title: Text(
            DateFormat('dd-MMMM-yyyy').format(dataCustomerTidakOrder.tglPOTerakhir),
          ),
          subtitle: Text(
            '${dataCustomerTidakOrder.periode.toString()} Hari',
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.document_scanner,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CustomerViewScreen.routeName,
                  arguments: dataCustomerTidakOrder.custID.toString());
            },
          ),
        ),
      ),
    );
  }
}
