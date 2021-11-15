import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/target_Sales.dart';
import '../widget/realisasi_Target_sales_Grid.dart';
import '../widget/target_Sales_Grid.dart';

class TargetSalesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataTargetSales = Provider.of<TargetSalesProvider>(context).items;
    final titlesize = AppBar(
      title: Text('test'),
    );
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height - titlesize.preferredSize.height) * 0.4,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    //  color: Colors.lightBlue.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                    )
                    // border: Border.all(width: 1),
                    ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "TARGET  ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          (dataTargetSales == null || dataTargetSales.isEmpty)
                              ? ""
                              : "${DateFormat('dd MMMM yyyy').format(dataTargetSales[0].tanggalawal)} - ${DateFormat('dd MMMM yyyy').format(dataTargetSales[0].tanggalakhir)} ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      TargetSalesGrid(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height - titlesize.preferredSize.height) * 0.4,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  //  color: Colors.lightBlue.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "REALISASI  ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      RealisasiTargetSalesGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
