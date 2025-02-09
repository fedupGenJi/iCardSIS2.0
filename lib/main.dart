import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'loginpage.dart';
import 'package:khalti/khalti.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: '1a943421ce0f4fb8b3fd5364a3400cea',
      enabledDebugging: true,
      builder: (context, navKey) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Loginpage(),
        navigatorKey: navKey,
        localizationsDelegates: const [
          KhaltiLocalizations.delegate
        ],
      );
    });
  }
}
