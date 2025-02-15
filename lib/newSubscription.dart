import 'package:flutter/material.dart';

import 'homepage.dart';

class NewSubscription extends StatefulWidget {
  final String stdId;
  const NewSubscription({Key? key, required this.stdId}) : super(key: key);

  @override
  State<NewSubscription> createState() => NewSub();
}

class NewSub extends State<NewSubscription> {
  final TextEditingController _pinController = TextEditingController();

  void _showPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Transfer Pin'),
          content: TextField(
            controller: _pinController,
            decoration: InputDecoration(hintText: 'Transfer Pin'),
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_pinController.text.length == 4) {
                  // Handle the transfer pin logic here
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Transfer Pin: ${_pinController.text}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pin must be 4 digits long')),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

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
                      Navigator.pushReplacement(
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 110),
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
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        "Bye Subscription",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 400, // Set the desired width
                      height: 300, // Set the desired height
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Route',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Price',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(
                              Center(child: Text('28-Kilo to Sanga')),
                            ),
                            DataCell(
                              Center(child: Text('Rs. 1500')),
                            ),
                            DataCell(
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showPinDialog(context);
                                  },
                                  child: Text('Purchase'),
                                ),
                              ),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Center(child: Text('28-Kilo to Radhe Radhe')),
                            ),
                            DataCell(
                              Center(child: Text('Rs. 2000')),
                            ),
                            DataCell(
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showPinDialog(context);
                                  },
                                  child: Text('Purchase'),
                                ),
                              ),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Center(child: Text('28-Kilo to Lokanthali')),
                            ),
                            DataCell(
                              Center(child: Text('Rs. 2250')),
                            ),
                            DataCell(
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showPinDialog(context);
                                  },
                                  child: Text('Purchase'),
                                ),
                              ),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Center(child: Text('28-Kilo to Koteshor')),
                            ),
                            DataCell(
                              Center(child: Text('Rs. 2500')),
                            ),
                            DataCell(
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showPinDialog(context);
                                  },
                                  child: Text('Purchase'),
                                ),
                              ),
                            ),
                          ]),
                          DataRow(cells: [
                            DataCell(
                              Center(child: Text('28-Kilo to Ratna Park')),
                            ),
                            DataCell(
                              Center(child: Text('Rs. 2750')),
                            ),
                            DataCell(
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showPinDialog(context);
                                  },
                                  child: Text('Purchase'),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
