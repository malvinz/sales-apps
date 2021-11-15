import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/customer_Tidak_Order_Provider.dart';
import '../widget/laporan_Customer_tidak_order_Item.dart';

class LaporanCustomerTidakOrderGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataCustomerTidakOrder = Provider.of<CustomerTidakOrderProvider>(context, listen: false);
    var screenSize = MediaQuery.of(context).size;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenSize.width < 0 ? 0 : 1,

          childAspectRatio: 9.5 / 2,
          crossAxisSpacing: 20,
          //mainAxisSpacing: 20,
        ),
        itemCount: dataCustomerTidakOrder.items.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: dataCustomerTidakOrder.items[i],
              child: LaporanCustomerTidakOrderItem(),
            ));
  }
}
