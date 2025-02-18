import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icardsis/homepage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'config.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Sendmoney extends StatefulWidget {
  final String stdId;
  const Sendmoney({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Sendmoney> createState() => _SMoneyState();
}

class _SMoneyState extends State<Sendmoney> {
  bool isLoading = true;
  bool dataIsEmpty = false;
  String balance = "0";
  String userId = "";
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response =
          await http.get(Uri.parse('$baseUrl/userinfo/${widget.stdId}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isEmpty) {
          setState(() {
            dataIsEmpty = true;
            isLoading = false;
          });
        } else {
          setState(() {
            balance = data['balance'].toString();
            userId = data['user_id'].toString();
            phoneNumber = data['phone_number'].toString();
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  void validateAndProceed(BuildContext context) {
    String phoneNumber = phoneController.text.trim();
    String amountText = amountController.text.trim();
    int? amount = int.tryParse(amountText);

    if (!RegExp(r'^9\d{9}$').hasMatch(phoneNumber)) {
      _showWarningDialog("Use valiod phoneNo");
      return;
    }

    if (amount == null || amount > 500 || amount < 0) {
      _showWarningDialog("Amount should be less than 500");
      return;
    }

    _showPinDialog(context, amount, phoneNumber);
  }

  void _showPinDialog(BuildContext context, int amount, String phoneNumber) {
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
              "Confirm payment of Rs ${amount.toString()} to $phoneNumber",
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
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
              _showWarningDialog("Payment has been cancelled");
            },
            child: Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pinController.text.length == 4) {
                Navigator.pop(context);
                await _verifyPin(context, pinController.text, amount, phoneNumber);
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

  Future<void> _verifyPin(
      BuildContext context, String pin, int amount, String phoneNumber) async {
    String baseUrl = await Config.baseUrl;
    final response = await http.post(
      Uri.parse('$baseUrl/verifyPin'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"student_id": "${widget.stdId}", "pin": pin}),
    );

    if (response.statusCode == 200) {
      letsPay(amount, phoneNumber);
    } else {
      _showErrorDialog(jsonDecode(response.body)['message']);
    }
  }

  Future<void> letsPay(int amount, String phoneNumber) async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/sendMoney'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "amount": amount,
          "phone_number": phoneNumber,
          "student_id": "${widget.stdId}",
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        _showSuccessDialog(data['message']);
      } else {
        _showErrorDialog(data['error'] ?? 'Failed to process payment');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: "Transaction Failed",
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }

  void _showWarningDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: "??!??",
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.yellow,
    ).show();
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: "Success",
      desc: message,
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(stdId: widget.stdId),
          ),
        );
      },
      btnOkColor: Colors.green,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? (dataIsEmpty
            ? WillPopScope(
                onWillPop: () async => true,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated loading GIF
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
                    ),
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              ))
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Color(0xFFFADCD5),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            child: Image.asset('assets/ICARDSIS.png'),
                          ),
                          SizedBox(width: 30),
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
                      SizedBox(height: 20),
                      Text("Send Money",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600)),
                      SizedBox(height: 40),
                      InfoRow(label: "Balance:", value: "Rs $balance"),
                      InfoRow(label: "User ID:", value: userId),
                      InfoRow(label: "Phone Number:", value: phoneNumber),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone Number',
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Amount',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            validateAndProceed(context);
                          },
                          child: Text('Pay'),
                        ),
                      ),
                    ],
                  ),
                ),
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
