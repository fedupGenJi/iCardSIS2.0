import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'loginpage.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  OtpVerificationPage({required this.phoneNumber});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<bool> _hasError = List.generate(6, (index) => false);
  bool _isLoading = false;
  bool _isOtpExpired = false;
  Timer? _timer;
  int _remainingTime = 300;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isOtpExpired = true;
        });
        timer.cancel();
        _showDialog(DialogType.warning, 'OTP Expired',
            'Your OTP has expired. Please request a new one.');
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showDialog(DialogType type, String title, String desc,
      {VoidCallback? onOk}) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _hasError = _controllers.map((c) => c.text.isEmpty).toList();
    });

    if (_hasError.contains(true)) {
      _showDialog(
          DialogType.warning, 'Incomplete OTP', 'Please fill all OTP fields.');
      return;
    }

    if (_isOtpExpired) {
      _showDialog(DialogType.warning, 'OTP Expired',
          'Your OTP has expired. Please request a new one.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String otp = _controllers.map((controller) => controller.text).join();
    String phoneNumber = widget.phoneNumber;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.78:1000/register/otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // OTP Verified successfully, now validate registration
        _showDialog(
          DialogType.success,
          'Success',
          'OTP Verified Successfully!',
          onOk: () {
            _validateRegistrationxxx(phoneNumber);
          },
        );
      } else {
        final responseBody = jsonDecode(response.body);
        String error = responseBody['error'];

        if (error == 'OTP_EXPIRED') {
          _showDialog(DialogType.warning, 'OTP Expired',
              'Your OTP has expired. Please request a new one.');
        } else if (error == 'OTP_MISMATCH') {
          _showDialog(DialogType.error, 'Incorrect OTP',
              'The OTP you entered does not match. Please try again.');
        } else if (error == 'OTP_NOT_RECEIVED') {
          _showDialog(DialogType.error, 'OTP Not Received',
              'The OTP was not received. Please try again later.');
        } else {
          _showDialog(DialogType.error, 'Error',
              'An unexpected error occurred. Please try again.');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showDialog(DialogType.error, 'Network Error',
          'Could not connect to the server.');
    }
  }

  Future<void> _validateRegistrationxxx(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.78:1000/registe/otp/valid'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );

      if (response.statusCode == 200) {
        // Registration is successful
        _showDialog(
          DialogType.success,
          'Success',
          'Registration is Successful!',
          onOk: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            );
          },
        );
      } else {
        // Unexpected error
        _showDialog(
          DialogType.error,
          'Error',
          'Unexpected Error Occured!',
          onOk: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            );
          },
        );
      }
    } catch (e) {
      _showDialog(DialogType.error, 'Network Error',
          'Could not connect to the server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Check your phone',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "We've sent the code to your phone number:",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                widget.phoneNumber,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Expires in: ${_formatTime(_remainingTime)}',
                style: TextStyle(
                    fontSize: 16,
                    color: _isOtpExpired ? Colors.red : Colors.black),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _hasError[index] ? Colors.red : Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _hasError[index] = false;
                        });
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(_focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isOtpExpired ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor:
                            _isOtpExpired ? Colors.grey : Colors.amber,
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
