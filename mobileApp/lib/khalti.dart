import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'config.dart';
import 'homepage.dart';
class ICardSISKhaltiPage extends StatefulWidget {
  final String phoneNumber;
  final String stdId;
  const ICardSISKhaltiPage({Key? key, required this.phoneNumber, required this.stdId})
      : super(key: key);

  @override
  _ICardSISKhaltiPageState createState() => _ICardSISKhaltiPageState();
}

class _ICardSISKhaltiPageState extends State<ICardSISKhaltiPage>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    Color primaryColor = Colors.white;
    Color secondaryColor = const Color(0xFF5A2D91);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Payment Page",
            style:
                TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: secondaryColor),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Center(
              child: Image.asset(
                'assets/khalti.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 50),
            const SizedBox(height: 10),
            Text(
              "Use number 9800000001 for tests!",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor),
            ),
            Text(
              "Use pin 1111 for tests!",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor),
            ),
            Text(
              "Use otp 987654 for tests!",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor),
            ),
                  Text(
              "User Phone No: ${widget.phoneNumber}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondaryColor),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: secondaryColor),
              decoration: InputDecoration(
                labelText: "Enter Amount in NPR",
                labelStyle: TextStyle(color: secondaryColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double? amount = double.tryParse(amountController.text);
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid amount")),
                  );
                  return;
                }

                String? pidx =
                    await fetchPidxFromServer(amount * 100, widget.phoneNumber);
                if (pidx == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Failed to generate transaction ID (pidx)")),
                  );
                  return;
                }
                debugPrint(pidx);

                KhaltiPayConfig payConfig = KhaltiPayConfig(
                  publicKey: 'Key c69ca28a547c4d678860a36d5449e5b6',
                  pidx: pidx,
                  environment: Environment.test,
                );

                Khalti khalti = await Khalti.init(
                  enableDebugging: true,
                  payConfig: payConfig,
                  onPaymentResult: (paymentResult, khalti) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Payment Successful: ${paymentResult.payload?.transactionId}"),
                      ),
                    );
                    khalti.close(context);
                  },
                  onMessage: (khalti,
                      {description,
                      statusCode,
                      event,
                      needsPaymentConfirmation}) async {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Status: $statusCode, Event: $event"),
                      ),
                    );
                    Future.delayed(Duration(seconds: 5), () {
                      khalti.close(context);
                      _sendPaymentStatusToServer(
                          pidx); //it shouldn't be done to be honest
                    });
                  },
                  onReturn: () {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Successfully redirected to return_url."),
                      ),
                    );
                  },
                );

                khalti.open(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Proceed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> fetchPidxFromServer(double amount, String phoneNumber) async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse("$baseUrl/khalti"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
          "phoneNumber": phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["pidx"];
      } else {
        debugPrint("Error fetching pidx from server: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Exception in fetchPidxFromServer: $e");
      return null;
    }
  }

  Future<void> _sendPaymentStatusToServer(String pidx) async {
    String baseUrl = await Config.baseUrl;
    final Uri url = Uri.parse('$baseUrl/khalti/result');
    try {
      final response = await http.post(
        url,
        body: json.encode({"pidx": pidx}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        bool status = data['status'];
        String message = data['message'];

        if (status) {
          _showPaymentDialog('Payment Successful', message, DialogType.success);
        } else {
          _showPaymentDialog('Payment Failed', message, DialogType.error);
        }
      } else {
        _showPaymentDialog('Payment Error', 'Failed to connect to the server.',
            DialogType.error);
      }
    } catch (e) {
      _showPaymentDialog(
          'Payment Error', 'An error occurred: $e', DialogType.error);
    }
  }

  void _showPaymentDialog(String title, String desc, DialogType dialogType) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage(stdId: "${widget.stdId}")),
      );
      },
    ).show();
  }
}
