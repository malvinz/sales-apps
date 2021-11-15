import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/customer.dart';
import '../provider/data_Customer.dart';
import '../provider/user_login.dart';
import '../screen/customer_View_Screen.dart';

class CustomerListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dataCustomeritem = Provider.of<Customer>(context);
    final datauser = Provider.of<UserLogin>(context).items;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 11,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_dataCustomeritem.custName.toString()),
                  Divider(),
                  Text(_dataCustomeritem.kategoriCust.toString()),
                  Divider(),
                  Text(_dataCustomeritem.subKategori.toString()),
                ],
              ),
            ),
            VerticalDivider(),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Column(
                children: [
                  Text(_dataCustomeritem.jenis),
                  Divider(),
                  Text(_dataCustomeritem.namaOutlet),
                ],
              ),
            ),
            VerticalDivider(),
            IconButton(
              icon: Icon(
                Icons.document_scanner,
                color: Colors.green,
              ),
              onPressed: () async {
                Navigator.of(context).pushNamed(CustomerViewScreen.routeName,
                    arguments: _dataCustomeritem.custID.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}
