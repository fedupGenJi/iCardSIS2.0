import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icardsis/homepage.dart';
import 'package:icardsis/report.dart';

class Payfine extends StatefulWidget {
  final String stdId;
  const Payfine({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Payfine> createState() => _PayfineState();
}

class _PayfineState extends State<Payfine> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFFFADCD5),
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color(0xFFFADCD5),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepage(
                            stdId: "${widget.stdId}",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            body: Padding(
                padding: EdgeInsets.all(16.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Container(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/ICARDSIS.png'),
                    ),
                    Center(
                      child: Text(
                        "Pay Fine",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 70),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Fine Amount:- Rs ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "250",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Balance:- Rs ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "250",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Button Pressed!');
                        },
                        child: Text('Pay'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Report(
                                      stdId: "${widget.stdId}",
                                    )),
                          );
                        },
                        child: Text('Report'),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
