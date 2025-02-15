import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'homepage.dart';

class LibraryLog extends StatelessWidget {
  final String stdId;
  const LibraryLog({Key? key, required this.stdId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LibraryLogPage(stdId: stdId),
      ),
    );
  }
}

class LibraryLogPage extends StatelessWidget {
  final String stdId;
  LibraryLogPage({required this.stdId});

  final List<Map<String, String>> activities = [
    {
      'book_name': 'physics',
      'book_id': 'BK001',
      'date_taken': 'February 10, 2025',
    },
    {
      'book_name': 'chemistry',
      'book_id': 'BK002',
      'date_taken': 'February 8, 2025',
    },
    {
      'book_name': 'computer',
      'book_id': 'BK003',
      'date_taken': 'February 12, 2025',
    },
    {
      'book_name': 'engg',
      'book_id': 'BK004',
      'date_taken': 'February 5, 2025',
    },
  ];

  String _calculateDeadline(String dateTaken) {
    final dateTakenDate = DateFormat('MMMM dd, yyyy').parse(dateTaken);
    final deadlineDate = dateTakenDate.add(Duration(days: 30));
    return DateFormat('MMMM dd, yyyy').format(deadlineDate);
  }

  bool _isDeadlineApproaching(String deadline) {
    try {
      final deadlineDate = DateFormat('MMMM dd, yyyy').parse(deadline);
      final currentDate = DateTime.now();
      final difference = deadlineDate.difference(currentDate).inDays;
      return difference <= 5;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  stdId: stdId,
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
          final deadline = _calculateDeadline(activity['date_taken']!);
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
                      ' ${activity['book_name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Book ID: ${activity['book_id']}'),
                    SizedBox(height: 8),
                    Text('Date Taken: ${activity['date_taken']}'),
                    SizedBox(height: 8),
                    Text(
                      'Deadline: $deadline',
                      style: TextStyle(
                        color: _isDeadlineApproaching(deadline)
                            ? Colors.red
                            : Colors.black,
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
