import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static Future<String> get ipAddress async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ipAddress') ?? "0.0.0.0";
  }

  static Future<String> get baseUrl async {
    String ip = await ipAddress;
    return "http://$ip:1000";
  }

  static Future<void> setIpAddress(String newIp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', newIp);
  }
}