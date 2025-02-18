import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'homepage.dart';
import 'config.dart';

class LibraryLogPage extends StatefulWidget {
  final String stdId;
  LibraryLogPage({required this.stdId});

  @override
  _LibraryLogPageState createState() => _LibraryLogPageState();
}

class _LibraryLogPageState extends State<LibraryLogPage> {
  bool isLoading = true;
  bool dataIsEmpty = false;
  List<Map<String, String>> activities = [];

  @override
  void initState() {
    super.initState();
    _fetchLibraryData();
  }

  Future<void> _fetchLibraryData() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.get(
        Uri.parse('$baseUrl/librarylog/${widget.stdId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = json.decode(response.body);

        if (responseData.isEmpty) {
          setState(() {
            isLoading = false;
            dataIsEmpty = true;
          });
        } else {
          setState(() {
            activities = responseData.map((item) {
              return {
                'book_name': item['bookName']?.toString() ?? 'Unknown',
                'book_id': item['bookId']?.toString() ?? 'Unknown',
                'date_taken': item['borrowedDate']?.toString() ?? '',
              };
            }).toList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          dataIsEmpty = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        dataIsEmpty = true;
      });
    }
  }

  String _calculateDeadline(String dateTaken) {
    if (dateTaken.isEmpty) return 'Unknown';
    try {
      final dateTakenDate = DateFormat('yyyy-MM-dd').parse(dateTaken);

      final deadlineDate = dateTakenDate.add(Duration(days: 30));

      return DateFormat('MMMM dd, yyyy').format(deadlineDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  bool _isDeadlineApproaching(String deadline) {
    if (deadline == 'Unknown' || deadline == 'Invalid Date') return false;
    try {
      final deadlineDate = DateFormat('MMMM dd, yyyy').parse(deadline);
      final currentDate = DateTime.now();
      return deadlineDate.difference(currentDate).inDays <= 5;
    } catch (e) {
      return false;
    }
  }

  bool _isDeadlinePassed(String deadline) {
    try {
      final deadlineDate = DateFormat('MMMM dd, yyyy').parse(deadline);
      return DateTime.now().isAfter(deadlineDate);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: dataIsEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Database is SLOW:(',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'BE THERE IN A MOMENT!',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'Here we go again:(',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                      ],
                      repeatForever: true,
                    ),
                    SizedBox(height: 30),
                    CircularProgressIndicator(color: Colors.red),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFADCD5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(
                  stdId: widget.stdId,
                ),
              ),
            );
          },
        ),
        title: Center(
          child: Text(
            "Library Log",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFFFADCD5),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final deadline = _calculateDeadline(activity['date_taken'] ?? '');
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
                      activity['book_name'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Book ID: ${activity['book_id'] ?? 'Unknown'}'),
                    SizedBox(height: 8),
                    Text('Date Taken: ${activity['date_taken'] ?? 'Unknown'}'),
                    SizedBox(height: 8),
                    Text(
                      'Deadline: $deadline',
                      style: TextStyle(
                        color: _isDeadlinePassed(deadline)
                            ? Colors.grey
                            : (_isDeadlineApproaching(deadline)
                                ? Colors.red
                                : Colors.black),
                        fontStyle: FontStyle.italic,
                        decoration: _isDeadlinePassed(deadline)
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
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
