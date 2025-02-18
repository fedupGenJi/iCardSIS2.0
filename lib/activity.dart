import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'config.dart';

import 'homepage.dart';

class Activity extends StatelessWidget {
  final String stdId;
  const Activity({Key? key, required this.stdId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ActivityPage(stdId: stdId),
      ),
    );
  }
}

class ActivityPage extends StatefulWidget {
  final String stdId;
  const ActivityPage({Key? key, required this.stdId}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Map<String, String>> activities = [];
  bool isLoading = true;
  bool dataIsEmpty = false;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/activity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'stdId': widget.stdId}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          activities = jsonData.map<Map<String, String>>((activity) {
            return {
              'title': activity['title'].toString(),
              'description': activity['description'].toString(),
              'date': activity['date'].toString(),
            };
          }).toList();
          isLoading = false;
          dataIsEmpty = activities.isEmpty;
        });
      } else {
        throw Exception('Failed to load activities');
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFFADCD5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(stdId: widget.stdId),
              ),
            );
          },
        ),
        title: const Center(
          child: Text(
            "Activity",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFADCD5),
      body: dataIsEmpty
          ? const Center(
              child: Text(
                "No activities found!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(activity['description']!),
                          const SizedBox(height: 8),
                          Text(
                            activity['date']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}