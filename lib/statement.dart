import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:icardsis/homepage.dart';
import 'config.dart';

class Statement extends StatefulWidget {
  final String stdId;
  const Statement({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  List<Map<String, String>> statements = [];
  bool isLoading = true;
  bool dataIsEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchStatements();
  }

  Future<void> fetchStatements() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/statement'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'stdId': widget.stdId}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          statements = jsonData.map<Map<String, String>>((statement) {
            return {
              'title': statement['title'].toString(),
              'description': statement['description'].toString(),
              'date': statement['date'].toString(),
              'time': statement['time'].toString(),
            };
          }).toList();
          isLoading = false;
          dataIsEmpty = statements.isEmpty;
        });
      } else {
        throw Exception('Failed to load statements');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        dataIsEmpty = true;
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
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Database is SLOW:(',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                  TypewriterAnimatedText(
                    'BE THERE IN A MOMENT!',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                repeatForever: true,
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.red),
            ],
          ),
        ),
      );
    }

    return Scaffold(
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
        title: const Center(
          child: Text(
            "Statement",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: statements.isEmpty
          ? Center(child: Text("No Statements Available"))
          : SingleChildScrollView(
              child: Column(
                children: statements.map((statement) {
                  return _buildStatementCard(
                    title: statement['title'] ?? '',
                    description: statement['description'] ?? '',
                    date: statement['date'] ?? '',
                  );
                }).toList(),
              ),
            ),
    );
  }

  Widget _buildStatementCard({
    required String title,
    required String description,
    required String date,
  }) {
    RegExp moneyRegex = RegExp(r'([+-]?\d*\.\d+)');
    String amount = moneyRegex.firstMatch(description)?.group(0) ?? '0.00';
    bool isPositive = description.toLowerCase().contains('received') || description.toLowerCase().contains('added');
    Color amountColor = isPositive ? Colors.green : Colors.red;
    String formattedAmount = isPositive ? "+$amount" : "-$amount";

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.all(14),
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(description),
                  SizedBox(height: 8),
                  Text("$date", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formattedAmount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: amountColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}