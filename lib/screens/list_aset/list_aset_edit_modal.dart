// ignore_for_file: unused_import, must_be_immutable, avoid_web_libraries_in_flutter, non_constant_identifier_names

import 'dart:convert';
import 'dart:html';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gapura/constants.dart';
import 'package:gapura/controllers/categories_controller.dart';
import 'package:gapura/responsive.dart';
import 'package:flutter/material.dart';
import 'package:gapura/screens/template/background_image_upload.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:gapura/screens/components/my_fields.dart';
import 'package:gapura/screens/components/header.dart';
import 'package:gapura/screens/components/recent_files.dart';
import 'package:gapura/screens/components/storage_details.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListAsetEditModal extends StatefulWidget {
  ListAsetEditModal({this.assets_id});
  String assets_id;
  @override
  State<ListAsetEditModal> createState() => _ListAsetEditModal();
}

class _ListAsetEditModal extends State<ListAsetEditModal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  HtmlEditorController descriptionController = HtmlEditorController();

  List<int> imageBytes;
  String imageString;
  String imageUrl;

  List<int> imageBackgroundBytes;
  String imageBackgroundName;
  String imageBackgroundString;
  String imageBackroundUrl;

  String descriptionText = "";

  bool contentLoad = true;

  getData() async {
    String url =
        dotenv.env['BASE_URL'] + "api/v1/assets/show/" + widget.assets_id;
    var uri = Uri.parse(url);

    var response = await http.get(uri);
    if (jsonDecode(response.body)["error"] == false) {
      setState(() {
        titleController.text = jsonDecode(response.body)["data"]["title"];
        descriptionText = jsonDecode(response.body)["data"]["attention"];
        imageUrl = "https://" + jsonDecode(response.body)["data"]["imagelink"];
        imageBackgroundName = jsonDecode(response.body)["data"]["file"];
        contentLoad = false;
      });
      notif("Updated");
    } else {
      setState(() {});
      notif("Error");
    }
  }

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
    uploadInput.accept = '';
    uploadInput.size = 2000000;
    uploadInput.click();
    document.body.append(uploadInput);
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      setState(() {
        imageBackgroundName = file.name;
      });
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

  patchData() async {
    var descriptionText = await descriptionController.getText();

    String url = dotenv.env['BASE_URL'] + "api/v1/assets/update";
    var uri = Uri.parse(url);

    var response = await http.patch(
      uri,
      body: (imageString == null && imageBackgroundString == null)
          ? {
              "assets_id": widget.assets_id,
              "title": titleController.text,
              "attention": descriptionText,
            }
          : (imageBackgroundString == null)
              ? {
                  "assets_id": widget.assets_id,
                  "title": titleController.text,
                  "attention": descriptionText,
                  "image": imageString,
                }
              : (imageString == null)
                  ? {
                      "assets_id": widget.assets_id,
                      "title": titleController.text,
                      "attention": descriptionText,
                      "document": imageBackgroundString,
                    }
                  : {
                      "assets_id": widget.assets_id,
                      "title": titleController.text,
                      "attention": descriptionText,
                      "document": imageBackgroundString,
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
    String url =
        dotenv.env['BASE_URL'] + "api/v1/assets/delete/" + widget.assets_id;
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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: (contentLoad)
          ? Center(child: CircularProgressIndicator())
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
                          "Tambah Aset",
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
        child: imageBackgroundName == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      pickBackgroundImage();
                    },
                    icon: Icon(Icons.upload, color: secondaryColor),
                    label: Text(
                      "Unggah File",
                      style: TextStyle(color: secondaryColor),
                    ),
                  ),
                  Text(
                    "Upload max: 2MB",
                    style: TextStyle(color: secondaryColor),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                    child: Text(
                      imageBackgroundName,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                          imageBackgroundBytes = null;
                          imageBackgroundString = null;
                          imageBackgroundName = null;
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

  descriptionBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deskripsi",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10),
          HtmlEditor(
            controller: descriptionController,
            htmlEditorOptions: HtmlEditorOptions(
              hint: '',
              darkMode: false,
              initialText: descriptionText,
            ),
            htmlToolbarOptions: HtmlToolbarOptions(
              defaultToolbarButtons: [
                StyleButtons(),
                FontSettingButtons(
                  fontName: false,
                  fontSizeUnit: false,
                ),
                ListButtons(
                  listStyles: false,
                ),
                FontButtons(
                  clearAll: false,
                  strikethrough: false,
                  superscript: false,
                  subscript: false,
                ),
                InsertButtons(
                  table: false,
                  audio: false,
                  hr: false,
                ),
                OtherButtons(
                  help: false,
                  copy: false,
                  paste: false,
                ),
              ],

              toolbarPosition: ToolbarPosition.aboveEditor, //by default
              toolbarType: ToolbarType.nativeScrollable, //by default
              onButtonPressed:
                  (ButtonType type, bool status, Function() updateStatus) {
                return true;
              },
              onDropdownChanged: (DropdownType type, dynamic changed,
                  Function(dynamic) updateSelectedItem) {
                return true;
              },
              mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                return true;
              },
              mediaUploadInterceptor:
                  (PlatformFile file, InsertFileType type) async {
                //filename
                return true;
              },
            ),
            otherOptions:
                OtherOptions(height: MediaQuery.of(context).size.height / 2),
            plugins: [
              SummernoteAtMention(
                  getSuggestionsMobile: (String value) {
                    var mentions = <String>['test1', 'test2', 'test3'];
                    return mentions
                        .where((element) => element.contains(value))
                        .toList();
                  },
                  mentionsWeb: ['test1', 'test2', 'test3'],
                  onSelect: (String value) {}),
            ],
          ),
        ],
      ),
    );
  }
}
