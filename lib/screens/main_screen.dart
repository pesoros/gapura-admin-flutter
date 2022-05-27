// ignore_for_file: must_be_immutable

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gapura/constants.dart';
import 'package:gapura/controllers/MenuController.dart';
import 'package:gapura/responsive.dart';
import 'package:flutter/material.dart';
import 'package:gapura/screens/about/about_screen.dart';
import 'package:gapura/screens/about/aset_merk_screen.dart';
import 'package:gapura/screens/articles/articles_screen.dart';
import 'package:gapura/screens/categories/categories_screen.dart';
import 'package:gapura/screens/dashboard_screen.dart';
import 'package:gapura/screens/footer/footer_screen.dart';
import 'package:gapura/screens/home/landing_screen.dart';
import 'package:gapura/screens/home/widget_1_screen.dart';
import 'package:gapura/screens/home/widget_2_screen.dart';
import 'package:gapura/screens/home/widget_3_screen.dart';
import 'package:gapura/screens/list_aset/list_aset_screen.dart';
import 'package:gapura/screens/user/user_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

enum Section {
  Landing,
  Widget1,
  Widget2,
  Widget3,
  About,
  BrandAssets,
  ListAset,
  Categories,
  Articles,
  Footer,
  User,
}
var section;

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Widget switchBody;

    switch (section) {
      case Section.Landing:
        switchBody = LandingScreen();
        break;

      case Section.Widget1:
        switchBody = Widget1Screen();
        break;

      case Section.Widget2:
        switchBody = Widget2Screen();
        break;

      case Section.Widget3:
        switchBody = Widget3Screen();
        break;

      case Section.About:
        switchBody = AboutScreen();
        break;

      case Section.BrandAssets:
        switchBody = AsetMerekScreen();
        break;
      case Section.ListAset:
        switchBody = ListAsetScreen();
        break;

      case Section.Categories:
        switchBody = CategoriesScreen();
        break;

      case Section.Articles:
        switchBody = ArticlesScreen();
        break;

      case Section.Footer:
        switchBody = FooterScreen();
        break;

      case Section.User:
        switchBody = UserScreen();
        break;
    }
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: sideMenu(context),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: sideMenu(context),
              ),
            Expanded(
              flex: 5,
              child: (switchBody != null) ? switchBody : DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget sideMenu(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: ListView(
        children: [
          DrawerHeader(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SvgPicture.asset(
                "assets/images/gold_logo.svg",
              ),
            ),
          ),
          ExpansionTile(
            textColor: primaryColor,
            collapsedTextColor: fontColor,
            iconColor: primaryColor,
            collapsedIconColor: fontColor,
            leading: Icon(Icons.circle),
            title: Text("Halaman Utama"),
            children: [
              ListTile(
                onTap: () {
                  setState(() => section = Section.Landing);
                },
                title: Text(
                  "Header",
                  style: TextStyle(color: fontColor),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() => section = Section.Widget1);
                },
                title: Text(
                  "Section 1",
                  style: TextStyle(color: fontColor),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() => section = Section.Widget2);
                },
                title: Text(
                  "Section 2",
                  style: TextStyle(color: fontColor),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() => section = Section.Widget3);
                },
                title: Text(
                  "Section 3",
                  style: TextStyle(color: fontColor),
                ),
              ),
            ],
          ),
          ExpansionTile(
            textColor: primaryColor,
            collapsedTextColor: fontColor,
            iconColor: primaryColor,
            collapsedIconColor: fontColor,
            leading: Icon(Icons.circle),
            title: Text("Halaman Tentang"),
            children: [
              ListTile(
                onTap: () {
                  setState(() => section = Section.About);
                },
                title: Text(
                  "Tentang",
                  style: TextStyle(color: fontColor),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() => section = Section.BrandAssets);
                },
                title: Text(
                  "Aset Merek",
                  style: TextStyle(color: fontColor),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() => section = Section.ListAset);
                },
                title: Text(
                  "List Aset",
                  style: TextStyle(color: fontColor),
                ),
              ),
            ],
          ),
          ListTile(
            onTap: () {
              setState(() => section = Section.Categories);
            },
            leading: Icon(Icons.circle),
            title: Text(
              "Kategori",
              style: TextStyle(color: fontColor),
            ),
          ),
          ListTile(
            onTap: () {
              setState(() => section = Section.Articles);
            },
            leading: Icon(Icons.circle),
            title: Text(
              "Artikel",
              style: TextStyle(color: fontColor),
            ),
          ),
          ListTile(
            onTap: () {
              setState(() => section = Section.Footer);
            },
            leading: Icon(Icons.circle),
            title: Text(
              "Footer",
              style: TextStyle(color: fontColor),
            ),
          ),
          ListTile(
            onTap: () {
              setState(() => section = Section.User);
            },
            leading: Icon(Icons.circle),
            title: Text(
              "Manajemen Pengguna",
              style: TextStyle(color: fontColor),
            ),
          ),
        ],
      ),
    );
  }
}
