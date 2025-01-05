import 'package:flutter/material.dart';
import 'package:icardsis/loginpage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPhoneValid = true;
  bool _isPasswordMatch = true;

  void _validatePhoneNumber() {
    setState(() {
      String phone = _phoneController.text;
      _isPhoneValid = phone.length == 10 && phone.startsWith('9');
    });
  }

  void _validatePasswords() {
    setState(() {
      _isPasswordMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background1.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Color(0xFF4B2138)
                  // ignore: deprecated_member_use
                  .withOpacity(0.55), // Semi-transparent overlay
            ),
          ),
          Align(
            alignment: Alignment(0, -0.7),
            child: Text(
              "iCardSIS",
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Righteous',
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.73, -0.47),
            child: Text(
              "Email:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.4),
            child: Container(
              height: 46,
              width: 365,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Stack(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "ram123@gmail.com",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9, 0),
                    child: Icon(Icons.alternate_email_outlined),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.73, -0.28),
            child: Text(
              "Phone Number:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.2),
            child: Container(
              height: 46,
              width: 365,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(
                  color: _isPhoneValid ? Colors.transparent : Colors.red,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "9812345678",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (text) => _validatePhoneNumber(),
                  ),
                  Align(
                    alignment: Alignment(0.9, 0),
                    child: IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.73, -0.08),
            child: Text(
              "Password:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Container(
              height: 46,
              width: 365,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(
                  color: _isPasswordMatch ? Colors.transparent : Colors.red,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    obscureText: _obscureText,
                    onChanged: (text) => _validatePasswords(),
                  ),
                  Align(
                    alignment: Alignment(0.9, 0),
                    child: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.69, 0.12),
            child: Text(
              "Confirm Password:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.2),
            child: Container(
              height: 46,
              width: 365,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(
                  color: _isPasswordMatch ? Colors.transparent : Colors.red,
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    obscureText: _obscureText,
                    onChanged: (text) => _validatePasswords(),
                  ),
                  Align(
                    alignment: Alignment(0.9, 0),
                    child: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.73, 0.31),
            child: Text(
              "PIN Number:",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.4),
            child: Container(
              height: 46,
              width: 365,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Stack(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "1234",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.9, 0),
                    child: Icon(Icons.key),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.6),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loginpage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B0C1A),
                minimumSize: Size(365, 46),
              ),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          // Add other widgets here if needed
        ],
      ),
    );
  }
}
