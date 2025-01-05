import 'package:flutter/material.dart';
import 'package:icardsis/homepage.dart';
import 'register.dart';

void main() {
  runApp(const Loginpage());
}

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _obscureText =
      true; // Add a boolean variable to track password visibility

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xFFFADCD5)),
            ),
            Align(
              alignment: Alignment.center,
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
                        hintText: "Mobile Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      keyboardType: TextInputType.phone,
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
              alignment: Alignment(0, 0.17),
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
              alignment: Alignment(0.8, 0.25),
              child: TextButton(
                onPressed: () {},
                child: Text("Forgot password?"),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.4),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1B0C1A),
                  minimumSize: Size(365, 46),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.49),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Have not registered yet?",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ),
            ClipPath(
              clipper: curve(),
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/background.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        // ignore: deprecated_member_use
                        color: Color(0xFF4B2138).withOpacity(0.55),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.2),
                      child: Text(
                        "iCardSIS",
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Righteous',
                          color: Colors.white,
                        ),
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

// ignore: camel_case_types
class curve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.5,
        size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 1, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
