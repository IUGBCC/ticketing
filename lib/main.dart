import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticketing/ticket.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticketing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Ticketing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getAllLines();
  }

  static Future getAllLines() async {
    // for mobile
    var url = "http://10.0.2.2/ticketing_api/get_all_lines.php";
    var response = await http.get(Uri.parse(url));

    // for web browser
    //var uri = Uri.http("localhost", "ticketing_api/get_all_lines.php");
    //var response = await http.get(uri);
    //print(response);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getAllLines(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        //color: Colors.white,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20),
                        child: const CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Container(
                        //color: Colors.white,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text('No deata.'));
                  }

                  if (snapshot.hasError)
                    return Center(child: Text('${snapshot.error}'));

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = snapshot.data[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicketPaymentPage(
                                    data['id'],
                                    data['departure'],
                                    data['arrival'],
                                    data['unitprice']),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            color: Colors.white,
                            elevation: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.car_repair,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  title: Text(
                                    '${data['departure']} <--> ${data['arrival']}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'Price :  ${data['unitprice']}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                })
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
