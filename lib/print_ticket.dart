import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:http/http.dart' as http;

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

  /*  Future saveSale() async {

    String phone = destinationController.text;
    phone = phone.replaceAll("+", "");

    showAlertDialog(context, "");
    /* var result;
    try { */
    var result = await http.post(
      Uri.parse("http://192.168.1.104/api/transfer.php"),
      body: {
        "source": source,
        "destination": phone,
        "value": valueController.text,
        "balance": balance.toString(),
      },
    );

    Navigator.of(context).pop();

    return result;
  } */

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
                onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
