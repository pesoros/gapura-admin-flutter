import 'package:gapura/constants.dart';
import 'package:gapura/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _StateMyApp();
}

class _StateMyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gapura',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme:
            GoogleFonts.signikaNegativeTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: fontColor),
        canvasColor: secondaryColor,
      ),
      home: LoginScreen(),
    );
  }
}
