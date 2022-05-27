// ignore_for_file: must_be_immutable

import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:gapura/screens/template/template_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';

class BackgroundImgageUpload extends StatefulWidget {
  XFile pickedImage;
  String titleDesc;

  BackgroundImgageUpload({this.titleDesc, this.pickedImage});

  @override
  State<BackgroundImgageUpload> createState() => _BackgroundImgageUpload();
}

class _BackgroundImgageUpload extends State<BackgroundImgageUpload> {
  chooseImage() async {
    XFile selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      widget.pickedImage = selectedImage;
      TemplateScreen.backgroundUploadimage = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerSize = MediaQuery.of(context).size.width / 3;
    return Container(
      width: containerSize,
      height: containerSize / 2,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: widget.pickedImage == null
            ? TextButton.icon(
                onPressed: () {
                  chooseImage();
                },
                icon: Icon(Icons.upload, color: fontColor),
                label: Text(
                  widget.titleDesc,
                  style: TextStyle(color: fontColor),
                ),
              )
            : Stack(
                children: <Widget>[
                  Image(
                      image: XFileImage(widget.pickedImage, scale: 1),
                      fit: BoxFit.cover),
                  Positioned(
                    right: 5.0,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 30,
                        color: Colors.red,
                      ),
                      // This is where the _image value sets to null on tap of the red circle icon
                      onTap: () {
                        setState(() {
                          widget.pickedImage = null;
                          TemplateScreen.backgroundUploadimage = null;
                        });
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
