import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/target_sales.dart';

class RealisasiTargetSalesItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataTargetSales = Provider.of<TargetSales>(context, listen: false);
    final formatter = NumberFormat("#,###");
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '${dataTargetSales.tipeTarget} ${dataTargetSales.merk} = ',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextSpan(
                    text:
                        '${formatter.format(dataTargetSales.totalJual)} ${dataTargetSales.satuan}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
