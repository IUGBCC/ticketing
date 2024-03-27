import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:ticketing/print_ticket.dart';

class TicketPaymentPage extends StatelessWidget {
  final int id;
  final int unitprice;
  final String departure;
  final String arrival;

  TicketPaymentPage(this.id, this.departure, this.arrival, this.unitprice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSection(),
            TicketPaymentSection(id, departure, arrival, unitprice),
          ],
        ),
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 15),
            child: Image.asset('images/payment4.png'),
          ),
        ],
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
        'Prendre un ticket',
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

class TicketPaymentSection extends StatefulWidget {
  final int id;
  final int unitprice;
  final String departure;
  final String arrival;

  TicketPaymentSection(this.id, this.departure, this.arrival, this.unitprice,
      {Key? key})
      : super(key: key);

  @override
  _TicketPaymentSectionState createState() =>
      _TicketPaymentSectionState(id, departure, arrival, unitprice);
}

class _TicketPaymentSectionState extends State<TicketPaymentSection> {
  final int id;
  final int unitprice;
  final String departure;
  final String arrival;

  _TicketPaymentSectionState(
      this.id, this.departure, this.arrival, this.unitprice,
      {Key? key});

  final paymentListKey = GlobalKey<_TicketPaymentSectionState>();

  String? montant_total;
  String? nombreDeTickets;

  var f = NumberFormat.currency(locale: 'eu', symbol: 'FCFA', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    montant_total = unitprice.toString();
  }

  getMontantTotal(double nombreDeTickets) {
    double total = unitprice * nombreDeTickets;
    this.nombreDeTickets = nombreDeTickets.toString();

    setState(() {
      montant_total = total.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 50,
          ),
          Text(
            '$departure <--> $arrival',
            textAlign: TextAlign.left,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Nombre de tickets',
            textAlign: TextAlign.left,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(left: 0),
              child: SpinBox(
                min: 1,
                max: 100,
                value: 1,
                onChanged: (value) => getMontantTotal(value),
              )),
          SizedBox(
            height: 30,
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
            const SizedBox(width: 8),
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
            const SizedBox(width: 78),
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
                  'Valider',
                  style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrintTicketPage(
                          id,
                          unitprice,
                          montant_total.toString(),
                          nombreDeTickets.toString(),
                          departure,
                          arrival),
                    ),
                  );
                }),
          ),
        ]));
  }
}
