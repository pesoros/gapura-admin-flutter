// ignore_for_file: must_be_immutable

import 'package:gapura/controllers/MenuController.dart';
import 'package:gapura/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gapura/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class Header extends StatefulWidget {
  Header({Key key, this.titlePage}) : super(key: key);
  String titlePage;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(
              Icons.menu,
              color: secondaryColor,
            ),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        Text(
          (widget.titlePage != null) ? widget.titlePage : "",
          style: TextStyle(
              color: secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          child: ProfileCard(),
          onTap: () {
            logoutUser();
          },
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text(
              "Logout",
              style: TextStyle(color: bgColor),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
