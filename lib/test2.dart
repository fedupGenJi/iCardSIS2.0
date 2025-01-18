import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatelessWidget {
  final double kuCardBalance =
      1500.00; // Example balance, you can replace this with actual data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'Home':
                // Navigate to Home
                break;
              case 'Settings':
                // Navigate to Settings
                break;
              case 'Contact Us':
                // Navigate to Contact Us
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Home',
              child: Text('Home'),
            ),
            const PopupMenuItem<String>(
              value: 'Settings',
              child: Text('Settings'),
            ),
            const PopupMenuItem<String>(
              value: 'Contact Us',
              child: Text('Contact Us'),
            ),
          ],
          icon: Icon(Icons.menu),
        ),
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Add your profile navigation logic here
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KU Card Balance: ₹$kuCardBalance',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to ICardSIS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ServiceCard(icon: Icons.receipt_long, label: 'Statement'),
                  ServiceCard(
                      icon: Icons.card_membership, label: 'Load to KU Card'),
                  ServiceCard(icon: Icons.bus_alert, label: 'Bus Subscription'),
                  ServiceCard(icon: Icons.book, label: 'Library Fine'),
                  ServiceCard(icon: Icons.money, label: 'Fund Transfer'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;

  ServiceCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Add your service navigation logic here
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
