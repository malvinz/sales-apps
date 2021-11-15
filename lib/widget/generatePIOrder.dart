import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:terbilang/terbilang.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../model/data_PO_header.dart';
import '../provider/data_Customer.dart';

const PdfColor green = PdfColor.fromInt(0xffe06c6c); //darker background color
const PdfColor lightGreen = PdfColor.fromInt(0xffedabab); //light background color
final formatter = NumberFormat("#,###");
const _darkColor = PdfColor.fromInt(0xff242424);
// ignore: unused_element
const _lightColor = PdfColor.fromInt(0xff9D9D9D);
const PdfColor baseColor = PdfColor.fromInt(0xffD32D2D);
// ignore: unused_element
const PdfColor _baseTextColor = PdfColor.fromInt(0xffffffff);
const PdfColor accentColor = PdfColor.fromInt(0xfff1c0c0);
const pw.TextStyle textstylebody = pw.TextStyle(fontSize: 11);

//create pdf file
Future<bool> generatePDFPI(List<List<dynamic>> tableData, String namaFile, DataPOHeader dataheader,
    BuildContext context) async {
  var datacustomer =
      Provider.of<DataCustomer>(context, listen: false).findById(dataheader.kodecustomer);
  final image =
      pw.MemoryImage((await rootBundle.load('assets/gambar/dashboard.png')).buffer.asUint8List());

//====PDF HEADER ======
  pw.Widget pdfHeader() {
    return pw.Container(
      margin: pw.EdgeInsets.all(0),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xffffffff),
        borderRadius: pw.BorderRadius.circular(15),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    height: 60,
                    width: 60,
                    margin: pw.EdgeInsets.only(right: 8),
                    alignment: pw.Alignment.center,
                    child: pw.SizedBox.expand(
                        child: pw.FittedBox(
                      child: pw.Image(image),
                    )),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "PT. Corporation Name",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                            fontSize: 13, color: _darkColor, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text("Address 1",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontSize: 9, color: _darkColor)),
                      pw.Text("Address 2 ",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontSize: 9, color: _darkColor)),
                      pw.Text("Address 3",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(fontSize: 9, color: _darkColor)),
                    ],
                  ),
                ],
              ),
              // pw.SizedBox(width: 50),
              pw.Column(children: [
                pw.Text(
                  "PERFORMA INVOICE",
                  style:
                      pw.TextStyle(fontSize: 12, color: _darkColor, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text("No. :  ${dataheader.noPO}", style: textstylebody),
                pw.Text("Tanggal: ${DateFormat('dd MMMM yyyy').format(dataheader.tanggal)}",
                    style: textstylebody),
              ])
            ],
          ),
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.Container(
              height: 3,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: _darkColor),
                ),
              ),
            ),
            pw.Container(
              height: 3,
              margin: pw.EdgeInsets.only(bottom: 13),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: _darkColor),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
//================= end of PDF HEADER =========================

  pw.Widget headerWidget = pdfHeader();

  final pw.Document pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      //pageTheme: pageTheme,
      pageFormat: PdfPageFormat.a4.copyWith(
        marginTop: 1 * PdfPageFormat.cm,
        marginLeft: 1 * PdfPageFormat.cm,
        marginRight: 1 * PdfPageFormat.cm,
        marginBottom: 1 * PdfPageFormat.cm,
      ),
      build: (pw.Context context) {
        return pw.Column(
          children: [
            headerWidget,
            pdfBody(dataheader.namaCustomer, datacustomer.alamatPengiriman),
            pw.SizedBox(height: 10),
            _generateTableContent(tableData, context),
            footerContent(dataheader),
            pw.SizedBox(height: 25),
            pageFooter(),

            /// Center
          ],
        );
      },
    ),
  );

  try {
    Directory dir = await getExternalStorageDirectory();
    String filePath = dir.path + "/";
    print(filePath);
    // ignore: unrelated_type_equality_checks
    if (Directory(filePath).exists() != true) {
      new Directory(filePath).createSync(recursive: true);
      final File file = File(filePath + "$namaFile.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      return true;
    } else {
      final File file = File(filePath + "$namaFile.pdf");
      file.writeAsBytesSync(List.from(await pdf.save()));
      return true;
    }
  } catch (e) {
    return false;
  }
}

//===========Table Content ======================

// ignore: missing_return
pw.Widget _generateTableContent(List<List<dynamic>> data1, pw.Context context) {
  try {
    // const int maxitem = 12;

    List<pw.TableRow> datarow = [
      pw.TableRow(children: [pw.Text('')])
    ];
    data1.map((value) {
      // print(double.tryParse(value[4]));
      datarow.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              left: pw.BorderSide(width: 1),
              right: pw.BorderSide(width: 1),
              bottom: pw.BorderSide(width: value[1] == "" ? 0 : 1),
              top: pw.BorderSide(width: value[1] == "" ? 0 : 1),
            ),
          ),
          children: [
            double.tryParse(value[2].toString()) == null
                ? pw.Padding(
                    child: pw.Text(
                      value[0].toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                    ),
                    padding: pw.EdgeInsets.all(3),
                  )
                : pw.Padding(
                    child: pw.Text(
                      value[0].toString(),
                      textAlign: pw.TextAlign.center,
                    ),
                    padding: pw.EdgeInsets.all(3),
                  ),
            double.tryParse(value[2].toString()) == null
                ? pw.Padding(
                    child: pw.Text(
                      value[1].toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    padding: pw.EdgeInsets.all(3),
                  )
                : pw.Padding(
                    child: pw.Text(
                      value[1].toString(),
                      textAlign: pw.TextAlign.left,
                      style: textstylebody,
                    ),
                    padding: pw.EdgeInsets.all(3),
                  ),
            double.tryParse(value[2].toString()) == null
                ? pw.Padding(
                    child: pw.Text(
                      value[2].toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    padding: pw.EdgeInsets.all(3),
                  )
                : pw.Padding(
                    child: pw.Text(
                      '${formatter.format(value[2])}',
                      textAlign: pw.TextAlign.right,
                      style: textstylebody,
                    ),
                    padding: pw.EdgeInsets.all(3),
                  ),
            double.tryParse(value[4].toString()) == null
                ? pw.Padding(
                    child: pw.Text(
                      value[3].toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    padding: pw.EdgeInsets.all(3),
                  )
                : pw.Padding(
                    child: pw.Text(
                      value[3].toString(),
                      textAlign: pw.TextAlign.center,
                      style: textstylebody,
                    ),
                    padding: pw.EdgeInsets.all(3),
                  ),
            double.tryParse(value[4].toString()) == null
                ? pw.Padding(
                    child: pw.Text(
                      value[4].toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    padding: pw.EdgeInsets.all(3),
                  )
                : pw.Padding(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Rp. ",
                          style: textstylebody,
                        ),
                        pw.Text(
                          '${formatter.format(value[4] / 1.1)}',
                          textAlign: pw.TextAlign.center,
                          style: textstylebody,
                        ),
                      ],
                    ),
                    padding: pw.EdgeInsets.all(3),
                  ),
            double.tryParse(value[5].toString()) == null
                ? pw.Padding(
                    child: pw.Text(
                      value[5].toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    padding: pw.EdgeInsets.all(3),
                  )
                : pw.Padding(
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Rp. ",
                          style: textstylebody,
                        ),
                        pw.Text(
                          '${formatter.format(value[5] / 1.1)}',
                          textAlign: pw.TextAlign.center,
                          style: textstylebody,
                        ),
                      ],
                    ),
                    padding: pw.EdgeInsets.all(3),
                  ),
          ],
        ),
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder(
        verticalInside: pw.BorderSide(width: 1),
      ),
      columnWidths: {
        0: pw.FlexColumnWidth(0.5),
        1: pw.FlexColumnWidth(4),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(2),
        5: pw.FlexColumnWidth(2),
      },
      children: datarow,
    );
  } catch (error) {}
}

//==========END OF TABLE CONTENT ==================

//============Body Export
pw.Widget pdfBody(String namaCustomer, String alamatCustomer) {
  return pw.Container(
    alignment: pw.Alignment.centerLeft,
    margin: pw.EdgeInsets.all(0),
    decoration: pw.BoxDecoration(
      color: PdfColor.fromInt(0xffffffff),
      borderRadius: pw.BorderRadius.circular(15),
    ),
    child: pw.Column(
      children: [
        pw.Text(
          "Pengiriman untuk : \n$namaCustomer \n$alamatCustomer \n\nDetail Pemesanan :",
          style: textstylebody,
          textAlign: pw.TextAlign.left,
        )
      ],
    ),
  );
}

//============ END OF EXPORT

//============ FOOTER OF CONTENT ================
pw.Widget footerContent(DataPOHeader dataPOHeader) {
  return pw.Container(
    margin: pw.EdgeInsets.all(0),
    decoration: pw.BoxDecoration(
      color: PdfColor.fromInt(0xffffffff),
      borderRadius: pw.BorderRadius.circular(15),
    ),
    child: pw.Row(
      children: [
        pw.Container(
          height: 100,
          width: 333,
          margin: pw.EdgeInsets.all(0),
          padding: pw.EdgeInsets.all(5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: pw.Text(
              'Terbilang   :${Terbilang(number: dataPOHeader.grandtotal.ceil()).result()} rupiah',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              maxLines: 10),
        ),
        pw.Container(
          height: 100,
          width: 103,
          margin: pw.EdgeInsets.all(0),
          padding: pw.EdgeInsets.all(0),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: pw.Column(
            children: [
              pw.Container(
                height: 20,
                width: 120,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Text(
                  "Total",
                  style: textstylebody,
                ),
              ),
              pw.Container(
                width: 120,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Text(
                  "Diskon",
                  style: textstylebody,
                ),
              ),
              pw.Container(
                width: 120,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Text(
                  "DPP",
                  style: textstylebody,
                ),
              ),
              pw.Container(
                width: 120,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Text(
                  "PPN 10%",
                  style: textstylebody,
                ),
              ),
              pw.Container(
                width: 120,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Text(
                  "Grand Total",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        pw.Container(
          height: 100,
          width: 103,
          margin: pw.EdgeInsets.all(0),
          padding: pw.EdgeInsets.all(0),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: pw.Column(
            children: [
              pw.Container(
                width: 119,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Rp. ",
                      style: textstylebody,
                    ),
                    pw.Text(
                      "${formatter.format(dataPOHeader.total)}",
                      style: textstylebody,
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: 119,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Rp. ",
                      style: textstylebody,
                    ),
                    pw.Text(
                      //"${formatter.format(dataPOHeader.diskon)}",
                      "${formatter.format(dataPOHeader.diskon)}",
                      style: textstylebody,
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: 119,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Rp. ",
                      style: textstylebody,
                    ),
                    pw.Text(
                      "${formatter.format((dataPOHeader.total) - dataPOHeader.diskon)}",
                      // "${formatter.format(dataPOHeader.grandtotal)}",
                      style: textstylebody,
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: 119,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Rp. ",
                      style: textstylebody,
                    ),
                    pw.Text(
                      "${formatter.format(((dataPOHeader.total) - dataPOHeader.diskon) * 0.1)}",
                      //"${formatter.format(dataPOHeader.grandtotal)}",
                      style: textstylebody,
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: 119,
                height: 20,
                margin: pw.EdgeInsets.all(0),
                padding: pw.EdgeInsets.all(4),
                alignment: pw.Alignment.centerLeft,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Rp. ",
                      style: textstylebody,
                    ),
                    pw.Text(
                      //"${formatter.format(((dataPOHeader.total / 1.1) - dataPOHeader.diskon) + ((dataPOHeader.total / 1.1) - dataPOHeader.diskon) * 0.1)}",
                      "${formatter.format(((dataPOHeader.total) - dataPOHeader.diskon) + (((dataPOHeader.total) - dataPOHeader.diskon) * 0.1))}",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//============ END OF FOOTER OF CONTENT ============

//============ PAGE FOOTER =========================
pw.Widget pageFooter() {
  return pw.Container(
    margin: pw.EdgeInsets.all(0),
    decoration: pw.BoxDecoration(
      color: PdfColor.fromInt(0xffffffff),
      borderRadius: pw.BorderRadius.circular(15),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Container(
              height: 90,
              width: 100,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    width: 1,
                  ),
                ),
              ),
              padding: pw.EdgeInsets.all(8),
              alignment: pw.Alignment.center,
              child: pw.Column(
                children: [
                  pw.Text('Hormat Kami', style: textstylebody),
                  pw.SizedBox(height: 50),
                  pw.Text('Finance', style: textstylebody),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text('Catatan : ', style: textstylebody, textAlign: pw.TextAlign.left)
      ],
    ),
  );
}

//============ END OF PAGE FOOTER ==================
