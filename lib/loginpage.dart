import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:icardsis/homepage.dart';
import 'dart:convert';
import 'config.dart';
import 'register.dart';
import 'reconfigurepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _obscureText = true;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPhoneValid = true;
  bool _isPasswordValid = true;
  bool _isButtonEnabled = false;
  bool _hasTriedLogin = false;
  bool _isLoading = false;

  void _validateInputs() {
    setState(() {
      String phone = _phoneController.text.trim();
      String password = _passwordController.text.trim();

      _isPhoneValid = phone.length == 10 && phone.startsWith('9');
      _isPasswordValid = password.isNotEmpty;
      _isButtonEnabled = _isPhoneValid && _isPasswordValid;
    });
  }

  void _showForgotPasswordPopup() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      animType: AnimType.bottomSlide,
      title: "Oops!",
      desc: "Go and cry about it :P",
      btnOkText: "Fine:(",
      btnOkOnPress: () {},
      btnOkColor: Colors.deepPurple,
    ).show();
  }

  Future<void> _login() async {
  setState(() {
    _hasTriedLogin = true;
    _validateInputs();
  });

  if (!_isPhoneValid || !_isPasswordValid) return;

  setState(() {
    _isLoading = true;
  });

  String phone = _phoneController.text.trim();
  String password = _passwordController.text.trim();

  try {
    String baseUrl = await Config.baseUrl;
    var response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "password": password}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String stdId = responseData["stdId"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("stdId", stdId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage(stdId: stdId)),
      );
    } else {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String message = responseData["message"];

      if (message == "Phone number not registered") {
        _showErrorDialog("Phone number not registered");
      } else if (message == "Incorrect password") {
        _showErrorDialog("Incorrect password");
      } else {
        _showErrorDialog("Unexpected error occurred");
      }
    }
  } catch (e) {
    _showErrorDialog("Server unavailable. Please try again later.");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: "Login Failed",
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    ).show();
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: "Success",
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.green,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(decoration: BoxDecoration(color: Color(0xFFFADCD5))),
            Align(
              alignment: Alignment(0.9, 0.97), // Adjust for positioning
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.black, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReconfigurePage()),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment(0, -0.15),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D222F)),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.1),
              child: Container(
                height: 46,
                width: 365,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(
                      color: (!_isPhoneValid && _hasTriedLogin)
                          ? Colors.red
                          : Colors.transparent,
                      width: 2),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "9800000000",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    suffixIcon: Icon(Icons.person,
                        color: Colors.grey), // User icon added
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (text) => _validateInputs(),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.3),
              child: Container(
                height: 46,
                width: 365,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(
                      color: (!_isPasswordValid && _hasTriedLogin)
                          ? Colors.red
                          : Colors.transparent,
                      width: 2),
                ),
                child: TextField(
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  onChanged: (text) => _validateInputs(),
                ),
              ),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment(0.8, 0.4),
              child: TextButton(
                onPressed: _showForgotPasswordPopup,
                child: Text("Forgot password?"),
              ),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment(0, 0.5),
              child: ElevatedButton(
                onPressed: () {
                  if (!_isButtonEnabled) {
                    setState(() {
                      _hasTriedLogin = true; // Trigger red error borders
                      _validateInputs();
                    });
                  } else {
                    _login();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_isButtonEnabled && !_isLoading)
                      ? Color(0xFF1B0C1A)
                      : Colors.grey,
                  minimumSize: Size(365, 46),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            SizedBox(height: 25),
            Align(
              alignment: Alignment(0, 0.6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Have not registered yet?",
                      style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ),
            ClipPath(
              clipper: CurveClipper(),
              child: SizedBox(
                height: 350,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset("assets/background.jpg",
                          fit: BoxFit.cover),
                    ),
                    Positioned.fill(
                      child:
                          Container(color: Color(0xFF4B2138).withOpacity(0.55)),
                    ),
                    Align(
                      alignment: Alignment(0, -0.2),
                      child: Text(
                        "iCardSIS",
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'Righteous',
                            color: Colors.white),
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

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.65,
        size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
