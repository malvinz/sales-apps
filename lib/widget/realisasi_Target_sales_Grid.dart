import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/target_Sales.dart';
import '../widget/realisasi_Target_sales_Grid_Item.dart';
// import '../widget/target_Sales_Item.dart';

class RealisasiTargetSalesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataTargetSales = Provider.of<TargetSalesProvider>(context);

    if ((dataTargetSales == null ? 0 : dataTargetSales.items.length) == 0) {
      return Text("Tidak ada data");
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 15,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: dataTargetSales == null ? 0 : dataTargetSales.items.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: dataTargetSales.items[i],
            child: RealisasiTargetSalesItem(),
          ),
        ),
      );
    }
  }
}
