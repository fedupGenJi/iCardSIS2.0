import 'package:flutter/material.dart';
import 'package:icardsis/homepage.dart';

class Statement extends StatefulWidget {
  final String stdId;
  const Statement({Key? key, required this.stdId}) : super(key: key);

  @override
  State<Statement> createState() => _StatementState();
}

class _StatementState extends State<Statement> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFFFADCD5),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Color(0xFFFADCD5),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Homepage(
                                stdId: "${widget.stdId}",
                              )),
                    );
                  },
                );
              },
            ),
            title: Center(
              child: Text(
                "Statement",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                _buildTransactionCard(
                  date: "Saturday, February 15",
                  type: "Ncell topup to 9807806602",
                  time: "10:38 AM",
                  amount: "-50.00",
                  amountColor: Colors.red,
                ),
                _buildTransactionCard(
                  date: "Saturday, February 15",
                  type: "Money transferred from LAXMI SUNRISE",
                  time: "10:29 AM",
                  amount: "+470.00",
                  amountColor: Colors.green,
                ),
                _buildTransactionCard(
                  date: "Friday, February 14",
                  type: "Paid for NISUM KIRANA STORE",
                  time: "07:34 PM",
                  amount: "-50.00",
                  amountColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required String date,
    required String type,
    required String time,
    required String amount,
    required Color amountColor,
    String? action,
  }) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 150,
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
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(type),
                  Text(
                    amount,
                    style: TextStyle(
                      color: amountColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Time: $time"),
              if (action != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(action),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
