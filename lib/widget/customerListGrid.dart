import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/customerListIem.dart';
import '../provider/data_Customer.dart';

// ignore: must_be_immutable
class CustomerListGrid extends StatelessWidget {
  String filtertext;
  CustomerListGrid({this.filtertext});

  @override
  Widget build(BuildContext context) {
    final listDataCustomer = Provider.of<DataCustomer>(context);

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3,
          //crossAxisSpacing: 20,
          // mainAxisSpacing: 20,
        ),
        itemCount: (filtertext == "" || filtertext == null)
            ? listDataCustomer.items.length
            : listDataCustomer.itemsfilter(filtertext).length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: (filtertext == "" || filtertext == null)
                  ? listDataCustomer.items[i]
                  : listDataCustomer.itemsfilter(filtertext)[i],
              child: CustomerListItem(),
            ));
  }
}
