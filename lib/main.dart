import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:uni_links3/uni_links.dart';
import 'dart:async';
import 'loginpage.dart';

void main() {
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
    _handleInitialUri(); 
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      debugPrint("Deep Link Error: $err");
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final Uri? uri = await getInitialUri();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (err) {
      debugPrint("Failed to get initial deep link: $err");
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.host == "payment-success") {
      debugPrint("Payment Successful! Redirecting...");
      _navigateToSuccessPage();
    }
  }

  void _navigateToSuccessPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PaymentSuccessPage(),
    ));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Loginpage(),
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Successful")),
      body: const Center(child: Text("Your payment was successful! 🎉")),
    );
  }
}
