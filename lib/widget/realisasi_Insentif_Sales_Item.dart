import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/insentif_sales.dart';

class RealisasiInsentifSalesItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataInsentifSales = Provider.of<DataInsentifSales>(context, listen: false);
    final formatter = NumberFormat("#,###");
    print(dataInsentifSales.satuan);
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
                    text: '${dataInsentifSales.tipeTarget} ${dataInsentifSales.merk} = ',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextSpan(
                    text:
                        '${formatter.format(dataInsentifSales.totalJual)} ${dataInsentifSales.satuan}',
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
