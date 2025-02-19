import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'config.dart';

class ReconfigurePage extends StatefulWidget {
  @override
  _ReconfigurePageState createState() => _ReconfigurePageState();
}

class _ReconfigurePageState extends State<ReconfigurePage> {
  TextEditingController _ipController = TextEditingController();
  String _currentIp = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadCurrentIp();
  }

  Future<void> _loadCurrentIp() async {
    String ip = await Config.ipAddress;
    setState(() {
      _currentIp = ip;
      _ipController.text = ip;
    });
  }

  bool isValidIp(String ip) {
    final regex = RegExp(r'^(?:\d{1,3}\.){3}\d{1,3}$');
    if (!regex.hasMatch(ip)) return false;
    return ip.split('.').every((part) => int.parse(part) <= 255);
  }

  Future<void> _updateConfigAndRestart() async {
  String newIp = _ipController.text.trim();
  if (!isValidIp(newIp)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid IP Address")),
    );
    return;
  }

  await Config.setIpAddress(newIp);

  Phoenix.rebirth(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reconfigure IP")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _ipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: _currentIp,
                  labelText: "Enter new IP Address",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateConfigAndRestart,
                child: Text("Reconfigure"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}