import 'package:flutter/material.dart';

class ICardSISKhaltiPage extends StatelessWidget {
  final String phoneNumber;

  const ICardSISKhaltiPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    Color primaryColor = Colors.white;
    Color secondaryColor = const Color(0xFF5A2D91);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          "Payment Page",
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
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
            const SizedBox(height: 100),
            Text(
              "User Phone No: $phoneNumber",
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: primaryColor,
                    title: Text("Button Clicked", style: TextStyle(color: secondaryColor)),
                    content: Text("Proceed button was clicked.", style: TextStyle(color: secondaryColor)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK", style: TextStyle(color: secondaryColor)),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Proceed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}