// ignore_for_file: unused_import, must_be_immutable, avoid_web_libraries_in_flutter, non_constant_identifier_names

import 'dart:convert';
import 'dart:html';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gapura/constants.dart';
import 'package:gapura/controllers/categories_controller.dart';
import 'package:gapura/responsive.dart';
import 'package:flutter/material.dart';
import 'package:gapura/screens/template/background_image_upload.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gapura/screens/components/my_fields.dart';
import 'package:gapura/screens/components/header.dart';
import 'package:gapura/screens/components/recent_files.dart';
import 'package:gapura/screens/components/storage_details.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoriesEditModal extends StatefulWidget {
  CategoriesEditModal({this.categories_id});
  String categories_id;
  @override
  State<CategoriesEditModal> createState() => _CategoriesEditModal();
}

class _CategoriesEditModal extends State<CategoriesEditModal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<int> imageBytes;
  String imageString;
  String imageUrl;

  List<int> imageBackgroundBytes;
  String imageBackgroundString;
  String imageBackroundUrl;

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

  pickBackgroundImage() async {
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
          imageBackgroundBytes = _bytesData;
          imageBackgroundString = reader.result;
        });
      });
      reader.readAsDataUrl(file);
    });
    uploadInput.remove();
  }

  getData() async {
    String url = dotenv.env['BASE_URL'] +
        "api/v1/categories/show/" +
        widget.categories_id;
    var uri = Uri.parse(url);

    var response = await http.get(uri);
    if (jsonDecode(response.body)["error"] == false) {
      setState(() {
        titleController.text = jsonDecode(response.body)["data"]["title"];
        subtitleController.text = jsonDecode(response.body)["data"]["subtitle"];
        descriptionController.text =
            jsonDecode(response.body)["data"]["description"];
        imageUrl = "https://" + jsonDecode(response.body)["data"]["imagelink"];
        imageBackroundUrl =
            "https://" + jsonDecode(response.body)["data"]["backgroundlink"];
        contentLoad = false;
      });
      notif("Updated");
    } else {
      setState(() {});
      notif("Error");
    }
  }

  patchData() async {
    if (imageString != null) {
      print("image available");
    }
    if (imageBackgroundString != null) {
      print("image background available");
    }
    String url = dotenv.env['BASE_URL'] + "api/v1/categories/update";
    var uri = Uri.parse(url);

    var response = await http.patch(
      uri,
      body: (imageString == null && imageBackgroundString == null)
          ? {
              "categories_id": widget.categories_id,
              "title": titleController.text,
              "subtitle": subtitleController.text,
              "description": descriptionController.text,
            }
          : (imageBackgroundString == null)
              ? {
                  "categories_id": widget.categories_id,
                  "title": titleController.text,
                  "subtitle": subtitleController.text,
                  "description": descriptionController.text,
                  "image": imageString,
                }
              : (imageString == null)
                  ? {
                      "categories_id": widget.categories_id,
                      "title": titleController.text,
                      "subtitle": subtitleController.text,
                      "description": descriptionController.text,
                      "background": imageBackgroundString,
                    }
                  : {
                      "categories_id": widget.categories_id,
                      "title": titleController.text,
                      "subtitle": subtitleController.text,
                      "description": descriptionController.text,
                      "background": imageBackgroundString,
                      "image": imageString,
                    },
    );

    print(response.body);

    if (jsonDecode(response.body)["error"] == false) {
      notif("Behasil Update");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      notif("Gagal Update");
      setState(() {});
    }
  }

  deleteData() async {
    String url = dotenv.env['BASE_URL'] +
        "api/v1/categories/delete/" +
        widget.categories_id;
    var uri = Uri.parse(url);

    var response = await http.delete(uri);
    print(response.body);

    if (jsonDecode(response.body)["error"] == false) {
      notif("Deleted");
      Navigator.pop(context);
    } else {
      setState(() {});
      notif("Error");
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
    print(widget.categories_id);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: (contentLoad)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: (Responsive.isDesktop(context))
                        ? MediaQuery.of(context).size.width / 5
                        : 20,
                    vertical: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Ubah Kategori",
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: defaultPadding),
                    (Responsive.isDesktop(context))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              imageBody(context),
                              imageBackgroundBody(context),
                            ],
                          )
                        : Column(children: [
                            imageBody(context),
                            SizedBox(height: defaultPadding),
                            imageBackgroundBody(context),
                          ]),
                    SizedBox(height: defaultPadding),
                    titleBody(context),
                    SizedBox(height: defaultPadding),
                    subtitleBody(context),
                    SizedBox(height: defaultPadding),
                    descriptionBody(context),
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
                            child: Text("Batal"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                            child: Text("Hapus"),
                            onPressed: () {
                              deleteData();
                            },
                          ),
                          SizedBox(width: 5),
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
            ),
    );
  }

  imageBody(BuildContext context) {
    double containerSize = (Responsive.isDesktop(context))
        ? MediaQuery.of(context).size.width / 3.7
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
                          "Unggah Ilustrasi",
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

  imageBackgroundBody(BuildContext context) {
    double containerSize = (Responsive.isDesktop(context))
        ? MediaQuery.of(context).size.width / 3.7
        : MediaQuery.of(context).size.width / 1;
    return Container(
      width: containerSize,
      height: 160,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: secondaryColor)),
      child: Center(
        child: imageBackroundUrl != null
            ? Stack(
                children: <Widget>[
                  Image.network(
                    imageBackroundUrl,
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
                          imageBackroundUrl = null;
                        });
                      },
                    ),
                  )
                ],
              )
            : imageBackgroundBytes == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          pickBackgroundImage();
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
                      Image.memory(imageBackgroundBytes),
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
                              imageBackgroundBytes = null;
                              imageBackgroundString = null;
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

  descriptionBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deskripsi",
            style: TextStyle(color: secondaryColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: descriptionController,
              maxLines: 4,
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
