import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _RegisterState();
}

class _RegisterState extends State<Homepage> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFFFADCD5)),
          ),
          Align(
            alignment: Alignment(0, -0.872),
            child: Stack(
              children: [
                Container(
                  height: 236,
                  width: double.infinity,
                  color: Color(0xFF4B2138),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(-1, 0.5),
                        child: Container(
                          height: 120,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Color(0xFF6D3C52),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(19),
                              bottomRight: Radius.circular(19),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.07, 0.1),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Color(0xFF6D3C52),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.replay_outlined,
                              size: 25,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.8, 0),
                        child: Text(
                          "card Balance",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.9, 0.5),
                        child: Text(
                          "Rs: ",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.6, 0.5),
                        child: Text(
                          "1000 ",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.2, 0.5),
                        child: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            size: 35,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.95, -0.9),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Image(image: AssetImage("assets/3135715.png")),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.4, -0.75),
                        child: Text(
                          "Aakash thakur",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.55, -0.8),
                        child: Text(
                          "STD ID:",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.95, -0.8),
                        child: Text(
                          "1234",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.43, 0.6),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFF1B0C1A),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.attach_money,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.95, 0.6),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(0xFF1B0C1A),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.send,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.4, 0.9),
                        child: Text(
                          "Add money",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.95, 0.9),
                        child: Text(
                          "Send money",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      //Add other widgets here if needed
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Color(0xFF4B2138),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.qr_code,
                      size: 55,
                    ),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(-0.9, -0.3),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFF1B0C1A),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     size: 40,
              //   ),
              // ),
            ),
          ),
          Align(
            alignment: Alignment(-0.9, -0.1),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFF1B0C1A),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     size: 40,
              //   ),
              // ),
            ),
          ),
          Align(
            alignment: Alignment(-0.9, 0.1),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFF1B0C1A),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     size: 40,
              //   ),
              // ),
            ),
          ),
          Align(
            alignment: Alignment(-0.9, 0.3),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFF1B0C1A),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     size: 40,
              //   ),
              // ),
            ),
          ),
          Align(
            alignment: Alignment(-0.9, 0.5),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFF1B0C1A),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     size: 40,
              //   ),
              // ),
            ),
          ),
          Align(
            alignment: Alignment(-0.9, 0.7),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFF1B0C1A),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              // child: IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.send,
              //     size: 40,
              //   ),
              // ),
            ),
          ),
          // Add other widgets here if needed
        ],
      ),
    );
  }
}
