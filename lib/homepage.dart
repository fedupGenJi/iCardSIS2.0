import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icardsis/activity.dart';
import 'package:icardsis/librarylog.dart';
import 'package:icardsis/newSubscription.dart';
import 'package:icardsis/payfine.dart';
import 'package:icardsis/sendmoney.dart';
import 'dart:typed_data';
import 'config.dart';
import 'loginpage.dart';
import 'khalti.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'statement.dart';
import 'transportcard.dart';

class Homepage extends StatefulWidget {
  final String stdId;
  const Homepage({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class QRCodeOverlay extends StatelessWidget {
  final String base64Image;

  QRCodeOverlay({required this.base64Image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black54,
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.memory(
                  base64Decode(base64Image),
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> _data = {};
  bool _obscureText = true;
  bool showLogoutButton = false;
  final Color primaryColor = Color(0xFF4B2138);
  final Color secondaryColor = Color(0xFF6D3C52);
  final Color backgroundColor = Color(0xFFFADCD5);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('stdId');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginpage()),
    );
  }

  Future<void> _fetchData() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse("$baseUrl/homepage"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": widget.stdId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
        });
      } else {
        _handleFetchFailure();
      }
    } catch (e) {
      _handleFetchFailure();
    }
  }

  void _handleFetchFailure() {
    _showErrorDialog("Unable to fetch data. Logging out...");
    _logout();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AnimatedContainer(
                //   duration: Duration(seconds: 1),
                //   curve: Curves.easeInOut,
                //   height: 200,
                //   width: 200,
                //   child: Image.asset("assets/loading-wtf.gif"),
                // ),
                SizedBox(height: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Database is SLOW:(',
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'BE THERE IN A MOMENT!',
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                    TypewriterAnimatedText(
                      'Here we go again:(',
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true,
                ),
                SizedBox(height: 30),
                CircularProgressIndicator(color: primaryColor),
              ],
            ),
          ),
        ),
      );
    }
    Uint8List imageBytes = base64Decode("${_data["photo"]}");
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showPopup();
              },
              child: CircleAvatar(
                backgroundImage: MemoryImage(imageBytes),
                radius: 22,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "${_data["name"]}",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  showLogoutButton = !showLogoutButton;
                });
              },
              child: Text(
                "ID: ${widget.stdId}",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBalanceCard(),
            SizedBox(height: 20),
            _buildGridOptions(),
            SizedBox(height: 20),
            _buildAssociationSection(), // App Associated Section
            if (showLogoutButton)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: _logout,
                  child: Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      color: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Card Balance",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Rs:",
                      style: TextStyle(color: Colors.white, fontSize: 35)),
                  SizedBox(width: 10),
                  Text(_obscureText ? "****" : "${_data["balance"]}",
                      style: TextStyle(color: Colors.white, fontSize: 35)),
                  IconButton(
                    icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                        color: Colors.white,
                        size: 30),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildActionButton(Icons.attach_money, "Add Money", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ICardSISKhaltiPage(
                      phoneNumber: _data["phoneNo"],
                      stdId: "${widget.stdId}",
                    ),
                  ),
                );
              }),
              SizedBox(width: 10),
              _buildActionButton(Icons.send, "Send Money", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Sendmoney(
                      stdId: "${widget.stdId}",
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 35),
          ),
        ),
        SizedBox(height: 5),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildGridOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          _buildGridButton("assets/file.png", "Statement", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Statement(
                  stdId: "${widget.stdId}",
                ),
              ),
            );
          }),
          _buildGridButton("assets/fine.png", "Pay Fine", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payfine(
                  stdId: "${widget.stdId}",
                ),
              ),
            );
          }),
          _buildGridButton("assets/subscription.png", "Bus Subscription", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewSubscription(
                  stdId: "${widget.stdId}",
                ),
              ),
            );
          }),
          _buildGridButton("assets/book.png", "Library Log", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibraryLogPage(
                  stdId: "${widget.stdId}",
                ),
              ),
            );
          }),
          _buildGridButton("assets/card.png", "Transport Card", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Transportcard(
                  stdId: "${widget.stdId}",
                  isActive: false,
                ),
              ),
            );
          }),
          _buildGridButton("assets/restore.png", "Activity", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Activity(
                  stdId: "${widget.stdId}",
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGridButton(String asset, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, height: 50, width: 50),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociationSection() {
    return Column(
      children: [
        Text("App Associated With",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon.png", height: 100),
          ],
        ),
        SizedBox(height: 15),
        Text("Powered By",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/khalti.png", height: 40),
            SizedBox(width: 20),
            Image.asset("assets/sparrowSMS.png", height: 40),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: primaryColor,
      child: IconButton(
        icon: Icon(Icons.qr_code, color: Colors.white, size: 50),
        onPressed: _fetchQRCode,
      ),
    );
  }

  Future<void> _fetchQRCode() async {
    String baseUrl = await Config.baseUrl;
    final url = Uri.parse("$baseUrl/generateQR");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"stdId": widget.stdId}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final base64Qr = responseData["qr_code"];

      showDialog(
        context: context,
        builder: (context) => QRCodeOverlay(base64Image: base64Qr),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch QR code")),
      );
    }
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Uint8List imageBytes = base64Decode("${_data["photo"]}");
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 550,
            width: 390,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "KATHMANDU",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "UNIVERSITY",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Dhulikhel, Kavre",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Image.asset("assets/icon.png", height: 50, width: 50),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Student
                Text(
                  "STUDENT",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    color: Colors.red,
                  ),
                ),

                SizedBox(height: 10),

                //photo
                Container(
                  height: 150,
                  width: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(imageBytes, fit: BoxFit.cover),
                  ),
                ),

                SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Name:", "${_data["name"]}"),
                    _buildInfoRow("Course:", "${_data["course"]}"),
                    _buildInfoRow("Blood Group:", "${_data["bg"]}"),
                    _buildInfoRow("Year of Enrollment:", "${_data["YOE"]}"),
                    _buildInfoRow("Phone No:", "${_data["phoneNo"]}"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
              fontSize: 18,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error", style: TextStyle(color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
