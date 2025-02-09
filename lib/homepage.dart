import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'config.dart';
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';

class Homepage extends StatefulWidget {
  final String stdId;
  const Homepage({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic> _data = {};
  bool _obscureText = true;
  final Color primaryColor = Color(0xFF4B2138);
  final Color secondaryColor = Color(0xFF6D3C52);
  final Color backgroundColor = Color(0xFFFADCD5);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse("$baseUrl/homepage"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": "${widget.stdId}"}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
        });
      } else {
        _showErrorDialog("Error: Failed to load data");
      }
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                height: 200,
                width: 200,
                child: Image.asset("assets/loading-wtf.gif"),
              ),
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
            Text(
              "ID: ${widget.stdId}",
              style: TextStyle(color: Colors.white, fontSize: 18),
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
              _buildActionButton(Icons.attach_money, "Add Money"),
              SizedBox(width: 10),
              _buildActionButton(Icons.send, "Send Money"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _showDialog(text);
          },
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
          _buildGridButton("assets/file.png", "Statement"),
          _buildGridButton("assets/fine.png", "Pay Fine"),
          _buildGridButton("assets/subscription.png", "New Subscription"),
          _buildGridButton("assets/book.png", "Library Log"),
          _buildGridButton("assets/card.png", "Transport Card"),
          _buildGridButton("assets/restore.png", "Activity"),
        ],
      ),
    );
  }

  Widget _buildGridButton(String asset, String label) {
    return GestureDetector(
      onTap: () {
        _showDialog(label);
      },
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
        Text("In Help By",
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
        onPressed: () {},
      ),
    );
  }

  void _showDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text("You clicked $title!"),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 550,
              width: 390,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.95, -0.93),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.amber),
                      child: Image.asset("assets/icon.png"),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, -0.93),
                    child: Text(
                      "KATHMANDU",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'title',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, -0.83),
                    child: Text(
                      "UNIVERSITY",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'title',
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.0, -0.72),
                    child: Text(
                      "Dhulikhel,Kavre,Nepal",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.65),
                    child: Text(
                      "STUDENT",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.2),
                    child: SizedBox(
                      height: 250,
                      width: 200,
                      child: Image.asset("assets/pp.png"),
                    ),
                  ),
                  // name of student
                  Align(
                    alignment: Alignment(0, 0.35),
                    child: Text(
                      "${_data["name"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  // coarse of student
                  Align(
                    alignment: Alignment(0, 0.45),
                    child: Text(
                      "${_data["coarse"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // department of student
                  Align(
                    alignment: Alignment(0, 0.55),
                    child: Text(
                      "${_data["department"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  //blood group
                  Align(
                    alignment: Alignment(0, 0.65),
                    child: Text(
                      "${_data["blood"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // year of enrollment
                  Align(
                    alignment: Alignment(0, 0.75),
                    child: Text(
                      "${_data["yoe"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // phone number
                  Align(
                    alignment: Alignment(0, 0.85),
                    child: Text(
                      "${_data["phone number"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  //enter
                ],
              ),
            ),
          );
        });
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
