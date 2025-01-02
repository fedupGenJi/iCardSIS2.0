import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isTextVisible = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange[900]!,
                          Colors.orange[800]!,
                          Colors.orange[400]!,
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Rs. 1000",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.replay_outlined),
                                onPressed: () {
                                  // Add your reload functionality here
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: IconButton(
                                icon: Icon(_isTextVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                iconSize: 40,
                                onPressed: () {
                                  setState(() {
                                    _isTextVisible = !_isTextVisible;
                                  });
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "KU Card Balance",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.95, -0.95),
                    child: SizedBox(
                      height: 100,
                      width: 50,
                      child: Image(image: AssetImage('assets/3135715.png')),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.5, -0.87),
                    child: Text(
                      "Aakash Thakur",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.89),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_down),
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment(1.05, -0.895),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications),
                      color: Colors.white,
                      iconSize: 40,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.7, -0.895),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      iconSize: 40,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.4, -0.67),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.account_balance_wallet),
                        color: Colors.black,
                        iconSize: 40,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9, -0.67),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.send_to_mobile),
                        color: Colors.black,
                        iconSize: 40,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9, -0.53),
                    child: Text(
                      "send money",
                      style: TextStyle(
                        color: Colors.white,
                        //  fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.4, -0.53),
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange[900]!,
                            Colors.orange[800]!,
                            Colors.orange[400]!,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.9, 0.96),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.home),
                            color: Colors.white,
                            iconSize: 40,
                          ),
                          Align(
                            alignment: Alignment(-0.35, 1.5),
                            child: Text(
                              "Home",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(1, 0.96),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.apps),
                            color: Colors.white,
                            iconSize: 40,
                          ),
                          Align(
                            alignment: Alignment(-0.35, 1.5),
                            child: Text(
                              "menu",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment(0, 0.96),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.text_snippet_outlined),
                            color: Colors.white,
                            iconSize: 40,
                          ),
                          Align(
                            alignment: Alignment(0, 2.9),
                            child: Text(
                              "Transaction",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
