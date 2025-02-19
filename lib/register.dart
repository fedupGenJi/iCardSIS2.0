import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'otpVerification.dart';
import 'config.dart';

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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  bool _isPhoneValid = true;
  bool _isPasswordMatch = true;
  bool _isEmailValid = true;
  bool _isPinValid = true;
  bool _isFormValid = false;
  bool _isButtonPressed = false;
  bool _isLoading = false;

  void _validateFields() {
    setState(() {
      _isEmailValid = _emailController.text.isEmpty ||
          (_emailController.text.endsWith('@gmail.com') &&
              _emailController.text.length > 10);
      _isPhoneValid = _phoneController.text.isEmpty ||
          (_phoneController.text.length == 10 &&
              _phoneController.text.startsWith('9'));
      _isPasswordMatch = _passwordController.text.isEmpty ||
          (_passwordController.text == _confirmPasswordController.text);
      _isPinValid = _pinController.text.isEmpty ||
          (_pinController.text.length == 4 &&
              int.tryParse(_pinController.text) != null);

      _isFormValid = _isEmailValid &&
          _isPhoneValid &&
          _isPasswordMatch &&
          _isPinValid &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _pinController.text.isNotEmpty;
    });
  }

  void _onRegisterPressed() async {
    if (_isLoading) return; // Prevent multiple presses

    setState(() {
      _isButtonPressed = true; // Ensure empty fields turn red
      _validateFields();
    });

    if (_isFormValid) {
      setState(() {
        _isLoading = true; // Show loading state
      });

      List<String> userData = [
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
        _pinController.text
      ];

      try {
        String baseUrl = await Config.baseUrl;
        var response = await http.post(
          Uri.parse(
              '$baseUrl/register'), // Replace with server ip from the server
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": userData[0],
            "phone": userData[1],
            "password": userData[2],
            "pin": userData[3]
          }),
        );

        setState(() {
          _isLoading = false; // Stop loading
        });

        var responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData["success"] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                  phoneNumber: userData[1]), // Pass phone number
            ),
          );
        } else {
          // Show error popup
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: "Error",
            desc: responseData["message"] ?? "Unknown error occurred",
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
          ).show();
        }
      } catch (e) {
        setState(() {
          _isLoading = false; // Stop loading
        });

        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: "Server Error",
          desc: "Server unavailable. Please try again later.",
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset("assets/background1.jpg", fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Color(0xFF4B2138).withOpacity(0.55))),
          Align(
            alignment: Alignment(0, -0.7),
            child: Text("iCardSIS",
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Righteous',
                    color: Colors.white)),
          ),
          _buildLabel("Email:", -0.47),
          Align(
            alignment: Alignment(0, -0.4),
            child: _buildTextField(_emailController, "ram123@gmail.com",
                Icons.alternate_email_outlined, _isEmailValid),
          ),
          _buildLabel("Phone Number:", -0.28),
          Align(
            alignment: Alignment(0, -0.2),
            child: _buildTextField(
                _phoneController, "9812345678", Icons.phone, _isPhoneValid),
          ),
          _buildLabel("Password:", -0.08),
          Align(
            alignment: Alignment(0, 0),
            child: _buildPasswordField(_passwordController, "Password"),
          ),
          _buildLabel("Confirm Password:", 0.12),
          Align(
            alignment: Alignment(0, 0.2),
            child: _buildPasswordField(
                _confirmPasswordController, "Confirm Password"),
          ),
          _buildLabel("PIN Number:", 0.31),
          Align(
            alignment: Alignment(0, 0.4),
            child:
                _buildTextField(_pinController, "1234", Icons.key, _isPinValid),
          ),
          Align(
            alignment: Alignment(0, 0.6),
            child: GestureDetector(
              onTap: _isLoading ? null : _onRegisterPressed,
              child: Container(
                width: 365,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isLoading
                      ? Colors.grey
                      : (_isFormValid ? Color(0xFF1B0C1A) : Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text, double alignmentY) {
    return Align(
      alignment: Alignment(-0.73, alignmentY),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, bool isValid) {
    return Container(
      height: 46,
      width: 365,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: (!_isButtonPressed || (controller.text.isNotEmpty && isValid))
              ? Colors.transparent
              : Colors.red,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
            onChanged: (text) => _validateFields(),
          ),
          Align(alignment: Alignment(0.9, 0), child: Icon(icon)),
        ],
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return Container(
      height: 46,
      width: 365,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: (!_isButtonPressed ||
                  (controller.text.isNotEmpty && _isPasswordMatch))
              ? Colors.transparent
              : Colors.red,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
            obscureText: _obscureText,
            onChanged: (text) => _validateFields(),
          ),
          Align(
            alignment: Alignment(0.9, 0),
            child: IconButton(
              icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
