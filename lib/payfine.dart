import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:icardsis/homepage.dart';
import 'package:icardsis/report.dart';
import 'package:icardsis/config.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Payfine extends StatefulWidget {
  final String stdId;
  const Payfine({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Payfine> createState() => _PayfineState();
}

class _PayfineState extends State<Payfine> {
  bool isLoading = true;
  bool dataIsEmpty = false;
  int fineAmount = 0;
  int balance = 0;
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFineData();
  }

  Future<void> fetchFineData() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http
          .get(Uri.parse('$baseUrl/library/fines?stdId=${widget.stdId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          fineAmount = int.tryParse(data['fine'].toString()) ?? 0;
          balance = int.tryParse(data['balance'].toString()) ?? 0;
          isLoading = false;
          dataIsEmpty = false;
        });
      } else {
        setState(() {
          dataIsEmpty = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        dataIsEmpty = true;
        isLoading = false;
      });
    }
  }

  Future<void> _validateAndPayFine() async {
    int enteredAmount = int.tryParse(amountController.text) ?? 0;

    if (enteredAmount <= 0) {
      _showDialog("??!", "Please enter an amount greater than zero.",
          DialogType.warning);
    } else if (enteredAmount > fineAmount) {
      _showDialog(
          "??!", "Entered amount exceeds the fine amount.", DialogType.warning);
    } else if (enteredAmount > balance) {
      _showDialog("??!", "Insufficient balance.", DialogType.warning);
    } else {
      _showPinDialog(context, enteredAmount);
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

  void _showPinDialog(BuildContext context, int amount) {
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
                "Confirm payment of Rs ${amount.toString()} for Fine",
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
                  await _verifyPin(context, pinController.text, amount);
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

  Future<void> _verifyPin(BuildContext context, String pin, int amount) async {
    String baseUrl = await Config.baseUrl;
    final response = await http.post(
      Uri.parse('$baseUrl/verifyPin'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"student_id": "${widget.stdId}", "pin": pin}),
    );

    if (response.statusCode == 200) {
      letsPayFine(amount);
      //_showDialog("Success", "Payment of Rs $amount was successful!", DialogType.success);
    } else {
      _showDialog(
          "Error", jsonDecode(response.body)['message'], DialogType.error);
    }
  }

  Future<void> letsPayFine(int amount) async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/library/payFine'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "amount": amount,
          "student_id": "${widget.stdId}",
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        _showDialog("Success", data['message'], DialogType.success);
      } else {
        _showDialog("Error", data['error'], DialogType.error);
      }
    } catch (e) {
      _showDialog("Error", "Error: $e", DialogType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: dataIsEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Database is SLOW:(',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'BE THERE IN A MOMENT!',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Here we go again:(',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                      ],
                      repeatForever: true,
                    ),
                    SizedBox(height: 30),
                    CircularProgressIndicator(color: Colors.red),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFADCD5),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFADCD5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(stdId: widget.stdId),
              ),
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
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Text("Fine Amount: Rs ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  Text("$fineAmount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Text("Balance: Rs ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  Text("$balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: _validateAndPayFine,
                child: Text('Pay'),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Report(stdId: widget.stdId)),
                  );
                },
                child: Text('Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$label ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
