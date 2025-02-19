import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:icardsis/homepage.dart';
import 'package:icardsis/newSubscription.dart';
import 'package:icardsis/config.dart';

class Transportcard extends StatefulWidget {
  final String stdId;
  final double balance;
  const Transportcard({Key? key, required this.stdId, required this.balance})
      : super(key: key);

  @override
  State<Transportcard> createState() => _TransportcardState();
}

class _TransportcardState extends State<Transportcard> {
  bool isLoading = true;
  bool hasActiveSubscription = false;
  Map<String, dynamic>? subscriptionData;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    checkSubscriptionStatus();
  }

  Future<void> checkSubscriptionStatus() async {
    String baseUrl = await Config.baseUrl;
    final response = await http.get(Uri.parse(
        '$baseUrl/busSubscription/verifyStatus?studentId=${widget.stdId}'));

    if (response.statusCode == 200) {
      bool status = jsonDecode(response.body);
      if (status) {
        fetchSubscriptionData();
      } else {
        setState(() {
          isLoading = false;
          hasActiveSubscription = false;
        });
      }
    }
  }

  Future<void> fetchSubscriptionData() async {
    String baseUrl = await Config.baseUrl;
    final response = await http.get(Uri.parse(
        '$baseUrl/busSubscription/getData?studentId=${widget.stdId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        subscriptionData = data;
        hasActiveSubscription = true;
        isLoading = false;
        if (data["photo"] != null) {
          imageBytes = base64Decode(data["photo"]);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/ICARDSIS.png', height: 80),
              Text(
                "iCardSIS",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Database is SLOW:(',
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      speed: Duration(milliseconds: 100)),
                  TypewriterAnimatedText('BE THERE IN A MOMENT!',
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      speed: Duration(milliseconds: 100)),
                  TypewriterAnimatedText('Here we go again:(',
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                      speed: Duration(milliseconds: 100)),
                ],
                repeatForever: true,
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.red),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFADCD5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFADCD5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(stdId: widget.stdId),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/ICARDSIS.png', height: 80),
            SizedBox(height: 10),
            Text(
              "Transport Card",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            hasActiveSubscription && subscriptionData != null
                ? Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Status: ${subscriptionData!['subscription_status']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: imageBytes != null
                                ? MemoryImage(imageBytes!)
                                : AssetImage('assets/3135715.png')
                                    as ImageProvider,
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(height: 20),
                          _buildInfoRow('Name:', subscriptionData!['name']),
                          _buildInfoRow('Route:', subscriptionData!['route']),
                          _buildInfoRow(
                              'Expiry:', subscriptionData!['deadline']),
                          _buildInfoRow(
                            "Days Remaining",
                            subscriptionData!['daysRemaining'],
                            isRed: subscriptionData!['daysRemaining'] < 5,
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No Active ID',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewSubscription(
                                  stdId: widget.stdId, balance: widget.balance),
                            ),
                          );
                        },
                        child: Text('Buy Bus Pass'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String label, dynamic value, {bool isRed = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              color: isRed ? Colors.red : Colors.black,
              fontWeight: isRed ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
