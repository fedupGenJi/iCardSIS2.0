import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final String stdId;
  const Homepage({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _obscureText = true;
  final Color primaryColor = Color(0xFF4B2138);
  final Color secondaryColor = Color(0xFF6D3C52);
  final Color backgroundColor = Color(0xFFFADCD5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showDialog("Profile Picture Clicked!");
              },
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/3135715.png"),
                radius: 22,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Aakash Thakur",
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
              Text("Card Balance", style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Rs:", style: TextStyle(color: Colors.white, fontSize: 35)),
                  SizedBox(width: 10),
                  Text(_obscureText ? "****" : "1000",
                      style: TextStyle(color: Colors.white, fontSize: 35)),
                  IconButton(
                    icon: Icon(_obscureText ? Icons.remove_red_eye : Icons.visibility_off,
                        color: Colors.white, size: 30),
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
        Text("App Associated With", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon.png", height: 100),
          ],
        ),
        SizedBox(height: 15),
        Text("In Help By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
}