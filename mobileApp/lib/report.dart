import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:icardsis/payfine.dart';
import 'config.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'homepage.dart';

class Report extends StatefulWidget {
  final String stdId;
  const Report({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Report> createState() => Reportpage();
}

class Reportpage extends State<Report> {
  bool isLoading = true;
  bool dataIsEmpty = false;
  List<dynamic> reportData = [];

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http
          .get(Uri.parse('$baseUrl/errorReport/get?studentId=${widget.stdId}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["success"] == true) {
          setState(() {
            reportData = responseData["data"] ?? [];
            dataIsEmpty = reportData.isEmpty;
            isLoading = false;
          });
        } else {
          throw Exception(responseData["message"]);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        dataIsEmpty = true;
      });
    }
  }

  Future<void> reportIssue(String bookId, int daysDued) async {
    try {
      String baseUrl = await Config.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/errorReport/report?studentId=${widget.stdId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'bookId': bookId, 'days_dued': daysDued}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        showDialogMessage(
            "Success", "Report submitted successfully.", DialogType.success);
      } else {
        showDialogMessage(
            "Error",
            responseData['message'] ?? "Failed to submit report.",
            DialogType.error);
      }
    } catch (e) {
      showDialogMessage(
          "Error", "An unexpected error occurred.", DialogType.error);
    }
  }

  void showDialogMessage(String title, String message, DialogType type) {
    bool isSuccess = false;
    if (type == DialogType.success) {
      isSuccess = true;
    }
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(
                stdId: widget.stdId,
              ),
            ),
          );
        }
      },
    ).show();
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
      backgroundColor: Color(0xFFFADCD5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFADCD5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Payfine(stdId: widget.stdId)),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/ICARDSIS.png'),
                ),
                SizedBox(width: 30),
                Text(
                  "ICardSIS",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Righteous',
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Center(
              child: Text(
                "Library Report",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Book ID')),
                          DataColumn(label: Text('Days Due')),
                          DataColumn(label: Text('')),
                        ],
                        rows: reportData.map((data) {
                          return DataRow(cells: [
                            DataCell(Text(data['bookId'].toString())),
                            DataCell(Text(data['days_dued'].toString())),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  reportIssue(data['bookId'].toString(),
                                      data['days_dued']);
                                },
                                child: Text('Report'),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}