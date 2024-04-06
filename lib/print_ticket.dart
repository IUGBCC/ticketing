import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class PrintTicketPage extends StatelessWidget {
  final int id;
  final int unitprice;
  final String totalSale;
  final String totalTicket;
  final String departure;
  final String arrival;

  PrintTicketPage(this.id, this.unitprice, this.totalSale, this.totalTicket,
      this.departure, this.arrival);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BodySection(
                id, unitprice, totalSale, totalTicket, departure, arrival),
          ],
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        'Imprimer le ticket',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),

      centerTitle: true,
      backgroundColor: Colors.blueGrey,
      //backgroundColor: Colors.grey[300],

      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 25,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class BodySection extends StatefulWidget {
  final int id;
  final int unitprice;
  final String totalSale;
  final String totalTicket;
  final String departure;
  final String arrival;

  BodySection(this.id, this.unitprice, this.totalSale, this.totalTicket,
      this.departure, this.arrival,
      {Key? key})
      : super(key: key);

  @override
  _BodySectionState createState() => _BodySectionState(
      id, unitprice, totalSale, totalTicket, departure, arrival);
}

class _BodySectionState extends State<BodySection> {
  final int id;
  final int unitprice;
  final String totalSale;
  final String totalTicket;
  final String departure;
  final String arrival;

  _BodySectionState(this.id, this.unitprice, this.totalSale, this.totalTicket,
      this.departure, this.arrival);

  final paymentListKey = GlobalKey<_BodySectionState>();

  String? montant_total;
  String? nombreDeTickets;

  var f = NumberFormat.currency(locale: 'eu', symbol: 'FCFA', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    montant_total = totalSale.toString();
    nombreDeTickets = totalTicket.toString();
  }

  String myNumberFormat(dynamic number) {
    number = number.replaceAll('.', ' ');

    return number;
  }

  Future saveSale() async {
    showAlertDialog(context, "Printing ticket, please wait...");

    var result = await http.post(
      Uri.parse("http://10.0.2.2/ticketing_api/save_sale.php"),
      body: {
        "numberofticket": nombreDeTickets,
        "totalprice": montant_total,
        "id": id.toString(),
      },
    );

    Navigator.of(context).pop();

    print(result.body);

    return result;
  }

  showAlertDialog(BuildContext context, String msg) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 5), child: Text(msg)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50, top: 15),
                child: PrettyQr(
                  image: AssetImage('images/payment4.png'),
                  typeNumber: 3,
                  size: 150,
                  data: montant_total.toString(),
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                  elementColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Text(
              '$departure <---> $arrival',
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Text(
              'Nombre de tickets :',
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              nombreDeTickets.toString(),
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Text(
              'Prix Unitaire :',
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              unitprice.toString(),
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Text(
              'Total :',
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${montant_total}F',
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Text(
              'Date :',
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              DateFormat('dd-MM-yyyy à kk:mm')
                  .format(DateTime.now())
                  .toString(),
              textAlign: TextAlign.left,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
          SizedBox(
            height: 70,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //primary: d_blue,
                  primary: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(13),
                ),
                child: Text(
                  'Imprimer',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () async {
                  // showAlertDialog(context, "Printing ticket, please wait...");

                  saveSale();

                  final output = await getTemporaryDirectory();
                  print(output);
                  final file = File("${output.path}/ticket.pdf");
                  // final file = File("/storage/emulated/0/Download/example.pdf");

                  final pdf = pw.Document();

                  pdf.addPage(pw.Page(
                      pageFormat: const PdfPageFormat(150, 210),
                      build: (pw.Context context) {
                        return pw.Center(
                          child: pw.Column(children: [
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Container(
                                  // margin:
                                  //     pw.EdgeInsets.only(bottom: 50, top: 15),
                                  child:

                                      /*  PrettyQr(
                  image: AssetImage('images/payment4.png'),
                  typeNumber: 3,
                  size: 150,
                  data: montant_total.toString(),
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                  elementColor: Colors.blueGrey,
                ), */

                                      pw.BarcodeWidget(
                                          data: montant_total.toString(),
                                          barcode: pw.Barcode.qrCode(),
                                          width: 70,
                                          height: 70,
                                          color: PdfColor.fromInt(
                                              Colors.red.value)),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 10),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: <pw.Widget>[
                                  pw.Text(
                                    '$departure <---> $arrival',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: <pw.Widget>[
                                  pw.Text(
                                    'Nombre de tickets :',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(width: 10),
                                  pw.Text(
                                    nombreDeTickets.toString(),
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: <pw.Widget>[
                                  pw.Text(
                                    'Prix Unitaire :',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(width: 10),
                                  pw.Text(
                                    unitprice.toString(),
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: <pw.Widget>[
                                  pw.Text(
                                    'Total :',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(width: 10),
                                  pw.Text(
                                    '${montant_total}F',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 10,
                            ),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: <pw.Widget>[
                                  pw.Text(
                                    'Date :',
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(width: 10),
                                  pw.Text(
                                    DateFormat('dd-MM-yyyy à kk:mm')
                                        .format(DateTime.now())
                                        .toString(),
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      color:
                                          PdfColor.fromInt(Colors.black.value),
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            pw.SizedBox(
                              height: 10,
                            ),
                          ]),
                        ); // Center
                      })); // Page

                  await file.writeAsBytes(await pdf.save());
                  print(file);

                  await OpenFilex.open(file.path);

                  // Navigator.of(context).pop();
                }),
          ),
        ],
      ),
    );
  }
}
