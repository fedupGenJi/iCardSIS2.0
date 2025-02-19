import 'dart:convert';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'package:icardsis/config.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NewSubscription extends StatefulWidget {
  final String stdId;
  final double balance;
  const NewSubscription({Key? key, required this.stdId, required this.balance})
      : super(key: key);

  @override
  State<NewSubscription> createState() => NewSub();
}

class SubscriptionInfo {
  final String studentId;
  final String route;
  final int amount;

  SubscriptionInfo(
      {required this.studentId, required this.route, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'route': route,
      'amount': amount,
    };
  }
}

class NewSub extends State<NewSubscription> {
  TextEditingController amountController = TextEditingController();
  late double currentBalance;
  String? selectedRoute;
  int? selectedAmount;

  @override
  void initState() {
    super.initState();
    currentBalance = widget.balance;
  }

  void _showPinDialog(BuildContext context) {
    TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              "Enter PIN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Confirm payment of Rs ${selectedAmount.toString()} for $selectedRoute",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  hintText: "PIN",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  counterText: "",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showDialog(
                    "Error", "Payment has been cancelled.", DialogType.error);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (pinController.text.length == 4) {
                  Navigator.pop(context);
                  await _verifyPin(context, pinController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a 4-digit PIN")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Pay"),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }

  Future<void> _verifyPin(BuildContext context, String pin) async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/verifyPin'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"student_id": widget.stdId, "pin": pin}),
      );

      if (response.statusCode == 200) {
        SubscriptionInfo subscriptionInfo = SubscriptionInfo(
          studentId: widget.stdId,
          route: selectedRoute!,
          amount: selectedAmount!,
        );
        await sendSubscriptionRequest(subscriptionInfo);
      } else {
        _showDialog(
            "Error", jsonDecode(response.body)['message'], DialogType.error);
      }
    } catch (e) {
      _showDialog("Error", e.toString(), DialogType.error);
    }
  }

  Future<dynamic> sendSubscriptionRequest(SubscriptionInfo info) async {
    try {
      String baseUrl = await Config.baseUrl;
      Uri url = Uri.parse('$baseUrl/buySubscription/pay');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(info.toJson()),
      );

      if (response.statusCode == 200) {
        _showDialog(
            'Success', 'Payment processed successfully', DialogType.success);
        return jsonDecode(response.body);
      } else {
        _showDialog('Error', 'Failed to process payment', DialogType.error);
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog('Error', e.toString(), DialogType.error);
      return {'error': e.toString()};
    }
  }

  void _showDialog(String title, String desc, DialogType type) {
    bool isSuccess = false;
    if (type == DialogType.success) {
      isSuccess = true;
    }
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(
                stdId: widget.stdId,
              ),
            ),
          );
        }
      },
    ).show();
  }

  void selectSubscription(String route, int price) {
    setState(() {
      selectedRoute = route;
      selectedAmount = price;
    });
    _showPinDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFFFADCD5),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Color(0xFFFADCD5),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(
                      stdId: widget.stdId,
                    ),
                  ),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: screenWidth * 0.4,
                        child: Image.asset('assets/ICARDSIS.png'),
                      ),
                      SizedBox(width: screenWidth * 0.1),
                      Text(
                        "ICardSIS",
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Righteous',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                    child: Row(
                      children: [
                        Text(
                          "Balance: Rs ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "$currentBalance",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Buy Subscription",
                      style: TextStyle(
                        fontSize: screenWidth * 0.075,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        headingRowHeight: 50,
                        headingTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        dataTextStyle: TextStyle(fontSize: 14),
                        columns: [
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Route',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Center(
                              child: Text(
                                'Price',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          _buildDataRow(context, '28-Kilo to Dhulikhel', 1200,
                              screenWidth),
                          _buildDataRow(
                              context, '28-Kilo to Sanga', 1500, screenWidth),
                          _buildDataRow(context, '28-Kilo to Radhe Radhe', 2000,
                              screenWidth),
                          _buildDataRow(context, '28-Kilo to Lokanthali', 2250,
                              screenWidth),
                          _buildDataRow(context, '28-Kilo to Koteshor', 2500,
                              screenWidth),
                          _buildDataRow(context, '28-Kilo to Ratna Park', 2750,
                              screenWidth),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
      BuildContext context, String route, int price, double screenWidth) {
    return DataRow(cells: [
      DataCell(
        Center(child: Text(route)),
      ),
      DataCell(
        Center(child: Text('Rs. $price')),
      ),
      DataCell(
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (price > currentBalance) {
                _showDialog(
                    "Warning", "Insufficient Balance", DialogType.warning);
                return;
              }
              selectSubscription(route, price);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Purchase'),
          ),
        ),
      ),
    ]);
  }
}
