// ignore_for_file: non_constant_identifier_names, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:gapura/constants.dart';
import 'package:gapura/responsive.dart';
import 'package:gapura/screens/components/header.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AsetMerekScreen extends StatefulWidget {
  @override
  State<AsetMerekScreen> createState() => _StateAsetMerekScreen();
}

class _StateAsetMerekScreen extends State<AsetMerekScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  List<int> imageBytes;
  String imageString;
  String imageUrl;

  bool contentLoad = true;

  pickImage() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = false;
    uploadInput.accept = '.png,.jpg,.jpeg';
    uploadInput.size = 2000000;
    uploadInput.click();
    document.body.append(uploadInput);
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = FileReader();
      reader.onLoadEnd.listen((value) {
        var _bytesData =
            Base64Decoder().convert(reader.result.toString().split(",").last);
        setState(() {
          imageBytes = _bytesData;
          imageString = reader.result;
        });
      });
      reader.readAsDataUrl(file);
    });
    uploadInput.remove();
  }

  getData() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/about/show/2";
    var uri = Uri.parse(url);

    var response = await http.get(uri);
    if (jsonDecode(response.body)["error"] == false) {
      setState(() {
        titleController.text = jsonDecode(response.body)["data"]["title"];
        subtitleController.text =
            jsonDecode(response.body)["data"]["description"];
        imageUrl = "https://" + jsonDecode(response.body)["data"]["imagelink"];
        print(imageUrl);
        contentLoad = false;
      });
      notif("Updated");
    } else {
      setState(() {});
      notif("Error");
    }
  }

  patchData() async {
    String url = dotenv.env['BASE_URL'] + "api/v1/about/update";
    var uri = Uri.parse(url);

    var response = await http.patch(
      uri,
      body: (imageString == null)
          ? {
              "about_id": "2",
              "title": titleController.text,
              "description": subtitleController.text,
            }
          : {
              "about_id": "2",
              "title": titleController.text,
              "description": subtitleController.text,
              "image": imageString,
            },
    );

    if (jsonDecode(response.body)["error"] == false) {
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
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (contentLoad)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              primary: false,
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(titlePage: "Aset Merek"),
                  SizedBox(height: defaultPadding),
                  imageBody(context),
                  SizedBox(height: defaultPadding),
                  titleBody(context),
                  SizedBox(height: defaultPadding),
                  subtitleBody(context),
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

  imageBody(BuildContext context) {
    double containerSize = (Responsive.isDesktop(context))
        ? MediaQuery.of(context).size.width / 3
        : MediaQuery.of(context).size.width / 1;
    return Container(
      width: containerSize,
      height: 160,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: secondaryColor)),
      child: Center(
        child: imageUrl != null
            ? Stack(
                children: <Widget>[
                  Image.network(
                    imageUrl,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  Positioned(
                    right: 5.0,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 30,
                        color: Colors.red,
                      ),
                      onTap: () {
                        setState(() {
                          imageUrl = null;
                        });
                      },
                    ),
                  )
                ],
              )
            : imageBytes == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          pickImage();
                        },
                        icon: Icon(Icons.upload, color: secondaryColor),
                        label: Text(
                          "Unggah Background",
                          style: TextStyle(color: secondaryColor),
                        ),
                      ),
                      Text(
                        "Upload max: 2MB",
                        style: TextStyle(color: secondaryColor),
                      ),
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      Image.memory(imageBytes),
                      Positioned(
                        right: 5.0,
                        child: InkWell(
                          child: Icon(
                            Icons.remove_circle,
                            size: 30,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              imageBytes = null;
                              imageString = null;
                            });
                          },
                        ),
                      )
                    ],
                  ),
      ),
    );
  }

  titleBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Judul",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: titleController,
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

  subtitleBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sub Judul",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: subtitleController,
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
