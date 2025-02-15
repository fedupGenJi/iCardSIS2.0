// import 'package:flutter/material.dart';

// import 'homepage.dart';

// class Activity extends StatelessWidget {
//   final String stdId;
//   const Activity({Key? key, required this.stdId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: ActivityPage(),
//       ),
//     );
//   }
// }

// class ActivityPage extends StatelessWidget {
//   final List<Map<String, String>> activities = [
//     {
//       'title': 'Lend Book',
//       'description': 'Lent "The Great Gatsby" to a friend',
//       'date': 'February 15, 2025',
//     },
//     {
//       'title': 'Return Book',
//       'description': 'Returned "1984" to the library',
//       'date': 'February 14, 2025',
//     },
//     {
//       'title': 'Pay Fine',
//       'description': 'Paid overdue fine for library book',
//       'date': 'February 13, 2025',
//     },
//     {
//       'title': 'Add Money',
//       'description': 'Added money to card',
//       'date': 'February 12, 2025',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFADCD5),
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => Homepage(
//                             stdId: "${widget.stdId}",
//                           )),
//                 );
//               },
//             );
//           },
//         ),
//         title: Center(
//           child: Text(
//             "Activity",
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Color(0xFFFADCD5),
//       body: ListView.builder(
//         itemCount: activities.length,
//         itemBuilder: (context, index) {
//           final activity = activities[index];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       activity['title']!,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(activity['description']!),
//                     SizedBox(height: 8),
//                     Text(
//                       activity['date']!,
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
