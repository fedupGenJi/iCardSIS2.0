import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:icardsis/homepage.dart';
import 'package:icardsis/newSubscription.dart';

class Transportcard extends StatefulWidget {
  final String stdId;
  final bool isActive; // Add a boolean field to manage the status
  const Transportcard({Key? key, required this.stdId, required this.isActive})
      : super(key: key);

  @override
  State<Transportcard> createState() => transport();
}

class transport extends State<Transportcard> {
  Uint8List? get imageBytes => null;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
          body: SingleChildScrollView(
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
                SizedBox(height: 10),
                Text(
                  "Transport Card",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    Text(
                      widget.isActive ? "Active " : "Inactive ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (!widget.isActive)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewSubscription(
                            stdId: "${widget.stdId}",
                            balance: 0,
                          ),
                        ),
                      );
                    },
                    child: Text('Buy Bus Pass'),
                  ),
                SizedBox(height: 20),
                widget.isActive
                    ? Container(
                        width: screenWidth * 0.9,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: screenWidth * 0.4,
                              child: Image.asset('assets/3135715.png'),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    _buildInfoRow('Name:', 'John Doe'),
                                    _buildInfoRow('Rout:', 'Lokan thali'),
                                    _buildInfoRow('Expirey:', '31-12-2025'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(), // Show empty container when card is inactive
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
