import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/target_Sales.dart';
import '../widget/realisasi_Insentif_Sales_Item.dart';

// import '../widget/target_Sales_Item.dart';

class RealisasiInsentifSalesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataInsentifSales = Provider.of<TargetSalesProvider>(context, listen: false);

    if (((dataInsentifSales == null || dataInsentifSales.itemsInsentif.length == null)
            ? 0
            : dataInsentifSales.itemsInsentif.length) ==
        0) {
      return Text("Tidak ada data");
    } else {
      return Container(
        //height: MediaQuery.of(context).size.height,
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
          itemCount: dataInsentifSales == null ? 0 : dataInsentifSales.itemsInsentif.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: dataInsentifSales.itemsInsentif[i],
            child: RealisasiInsentifSalesItem(),
          ),
        ),
      );
    }
  }
}
