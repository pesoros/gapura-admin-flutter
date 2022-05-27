import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gapura/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gapura/screens/to_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _StateLoginScreen();
}

class _StateLoginScreen extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool showPassword = true;
  bool usernameActive = true;
  bool passwordActive = true;
  String token;
  String expired;
  String fullname;
  String email;
  String role;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {});
    getPrefsData();
    if (token != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ToDashboard()));
    }
  }

  getPrefsData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      expired = prefs.getString('expired');
      fullname = prefs.getString('fullname');
      email = prefs.getString('email');
      role = prefs.getString('role');
    });
    print(token);
  }

  getData() async {
    print("1");
    final prefs = await SharedPreferences.getInstance();

    String url = dotenv.env['BASE_URL'] + "api/v1/auth/login";
    var uri = Uri.parse(url);

    var response = await http.post(uri, body: {
      "email": emailController.text,
      "password": passwordController.text
    });

    print(jsonDecode(response.body)["data"]["token"]);
    print(jsonDecode(response.body)["data"]["expired"]);
    print(jsonDecode(response.body)["data"]["fullname"]);
    print(jsonDecode(response.body)["data"]["email"]);
    print(jsonDecode(response.body)["data"]["role"]);
    if (jsonDecode(response.body)["error"] == false) {
      await prefs.setString(
          'token', jsonDecode(response.body)["data"]["token"]);
      await prefs.setString(
          'expired', jsonDecode(response.body)["data"]["expired"]);
      await prefs.setString(
          'fullname', jsonDecode(response.body)["data"]["fullname"]);
      await prefs.setString(
          'email', jsonDecode(response.body)["data"]["email"]);
      await prefs.setString('role', jsonDecode(response.body)["data"]["role"]);
      notif("Sukses Masuk");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ToDashboard()));
    } else {
      notif("Gagal Masuk: " + jsonDecode(response.body)["error"][0]["msg"]);
    }
  }

  notif(String msg) async {
    Fluttertoast.showToast(
        msg: msg, webBgColor: "linear-gradient(to right, #F15A24, #F15A24)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.height / 1.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: fontColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Masuk ke Akun anda",
                    style: TextStyle(
                        color: loginColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: defaultPadding),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          usernameActive = !hasFocus;
                        });
                      },
                      child: TextField(
                        controller: emailController,
                        focusNode: focusNode,
                        style: TextStyle(color: fontColor),
                        decoration: InputDecoration(
                          hintText: "nama akun",
                          hintStyle: TextStyle(color: fontColor),
                          fillColor: fontColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: loginColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: fontColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          prefixIcon: InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 5, top: 5, bottom: 5, right: 10),
                              child: (usernameActive == false)
                                  ? SvgPicture.asset(
                                      "assets/icons/__Username.svg",
                                    )
                                  : SvgPicture.asset(
                                      "assets/icons/Username.svg",
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: defaultPadding),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          passwordActive = !hasFocus;
                        });
                      },
                      child: TextField(
                        controller: passwordController,
                        obscureText: showPassword,
                        style: TextStyle(color: fontColor),
                        decoration: InputDecoration(
                          hintText: "kata sandi",
                          hintStyle: TextStyle(color: fontColor),
                          fillColor: fontColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: loginColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: fontColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          prefixIcon: InkWell(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 5, top: 5, bottom: 5, right: 10),
                              child: (passwordActive == false)
                                  ? SvgPicture.asset(
                                      "assets/icons/__Password.svg",
                                    )
                                  : SvgPicture.asset(
                                      "assets/icons/Password.svg",
                                    ),
                            ),
                          ),
                          suffixIcon: InkWell(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, top: 5, bottom: 5, right: 5),
                                child: (showPassword)
                                    ? SvgPicture.asset(
                                        "assets/icons/Tampilkan.svg",
                                      )
                                    : SvgPicture.asset(
                                        "assets/icons/__Sembunyikan.svg",
                                      )),
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: defaultPadding),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: loginColor,
                        padding: EdgeInsets.only(
                            right: 20, left: 5, top: 12, bottom: 12),
                        shape: StadiumBorder()),
                    icon: SvgPicture.asset(
                      'assets/icons/__Login.svg',
                      color: loginColor,
                    ),
                    label: Text("Masuk"),
                    onPressed: () {
                      getData();
                    },
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      "assets/images/gold_logo.svg",
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
