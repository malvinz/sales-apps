import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/diskon_Provider.dart';
import '../widget/diskon_Grid_Item.dart';

class DiskonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataDiskon = Provider.of<DiskonProvider>(context);

    if ((dataDiskon == null ? 0 : dataDiskon.items.length) == 0) {
      return Text("Tidak ada data");
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
          itemCount: dataDiskon == null ? 0 : dataDiskon.items.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: dataDiskon.items[i],
            child: DiskonGridItem(),
          ),
        ),
      );
    }
  }
}
