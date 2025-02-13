import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const Report());
}

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _PayfineState();
}

class _PayfineState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Padding(
              padding: EdgeInsets.all(16.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Row(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: Image.asset('assets/ICARDSIS.png'),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "ICardSIS",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Righteous',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      "Library Report",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 400, // Set the desired width
                    height: 300, // Set the desired height
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Book ID')),
                        DataColumn(label: Text('Fine')),
                        DataColumn(label: Text('')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('1234')),
                          DataCell(Text('25')),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                print('Button Pressed!');
                              },
                              child: Text('Report'),
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('2345')),
                          DataCell(Text('30')),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                print('Button Pressed!');
                              },
                              child: Text('Report'),
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('3456')),
                          DataCell(Text('27')),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                print('Button Pressed!');
                              },
                              child: Text('Report'),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
