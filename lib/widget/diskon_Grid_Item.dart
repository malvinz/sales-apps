import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../model/diskon.dart';

class DiskonGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detailDiskon = Provider.of<Diskon>(context, listen: false);
    final formatter = NumberFormat("#,###");
    final screensize = MediaQuery.of(context).size;

    return Container(
      width: screensize.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Container(
                height: screensize.height * 0.10,
                width: screensize.width * 0.20,
                child: SizedBox.expand(
                  child: FittedBox(
                    child: Image.asset(
                      'assets/gambar/dashboard.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              VerticalDivider(),
              Container(
                margin: EdgeInsets.only(left: 5),
                alignment: Alignment.center,
                width: screensize.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Kategori Customer : ${detailDiskon.kategori}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Dengan Sub Kategori : ${detailDiskon.subKategori}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(),
              Container(
                width: screensize.width * 0.30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nilai Awal Diskon : ${formatter.format(detailDiskon.nilaiAwal)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                    ),
                    Divider(),
                    Text(
                      'Nilai Akhir Diskon :  ${formatter.format(detailDiskon.nilaiAkhir)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                    ),
                    Divider(),
                    Text(
                      'Diskon ${detailDiskon.diskon}% ',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
