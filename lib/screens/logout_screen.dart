import 'package:flutter/material.dart';
import 'package:gapura/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends StatefulWidget {
  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    logoutUser();
  }

  logoutUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");
    await prefs.remove("expired");
    await prefs.remove("fullname");
    await prefs.remove("email");
    await prefs.remove("role");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
