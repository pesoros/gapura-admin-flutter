import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:gapura/constants.dart';
import 'package:gapura/screens/components/header.dart';

class FooterScreen extends StatefulWidget {
  @override
  State<FooterScreen> createState() => _StateFooterScreen();
}

class _StateFooterScreen extends State<FooterScreen> {
  TextEditingController copyrightController = TextEditingController();
  TextEditingController telponController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController dinasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/footer";
    var uri = Uri.parse(url);

    var response = await http.get(uri);
    if (jsonDecode(response.body)["status"] == 200) {
      setState(() {
        copyrightController.text =
            jsonDecode(response.body)["data"][0]["copyright"];
        telponController.text = jsonDecode(response.body)["data"][0]["phone"];
        alamatController.text = jsonDecode(response.body)["data"][0]["address"];
        dinasController.text = jsonDecode(response.body)["data"][0]["dinas"];
      });
      notif("Updated");
    } else {
      setState(() {});
      notif("Error");
    }
  }

  patchData() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/footer";
    var uri = Uri.parse(url);

    var response = await http.patch(uri, body: {
      "copyright": copyrightController.text,
      "address": alamatController.text,
      "phone": telponController.text,
      "dinas": dinasController.text,
    });

    if (jsonDecode(response.body)["status"] == 200) {
      notif("Behasil Update");
      setState(() {});
    } else {
      notif("Gagal Update");
      setState(() {});
    }
  }

  notif(String msg) async {
    Fluttertoast.showToast(
        msg: msg, webBgColor: "linear-gradient(to right, #F15A24, #F15A24)");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(titlePage: "Footer"),
            SizedBox(height: defaultPadding),
            copyrightBody(context),
            SizedBox(height: defaultPadding),
            telponBody(context),
            SizedBox(height: defaultPadding),
            alamatBody(context),
            SizedBox(height: defaultPadding),
            dinasBody(context),
            SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding,
                      ),
                    ),
                    child: Text("Simpan"),
                    onPressed: () {
                      patchData();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  copyrightBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Copyright",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: copyrightController,
              style: TextStyle(color: secondaryColor),
              decoration: InputDecoration(
                fillColor: secondaryColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  telponBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Telepon",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: telponController,
              style: TextStyle(color: secondaryColor),
              decoration: InputDecoration(
                fillColor: secondaryColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  alamatBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Alamat",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: alamatController,
              style: TextStyle(color: secondaryColor),
              decoration: InputDecoration(
                fillColor: secondaryColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dinasBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dinas",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: dinasController,
              style: TextStyle(color: secondaryColor),
              decoration: InputDecoration(
                fillColor: secondaryColor,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
