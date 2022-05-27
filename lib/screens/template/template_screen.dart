// ignore_for_file: unused_import, must_be_immutable

import 'package:gapura/responsive.dart';
import 'package:flutter/material.dart';
import 'package:gapura/screens/template/background_image_upload.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';

import 'package:gapura/screens/components/my_fields.dart';
import 'package:gapura/screens/components/header.dart';
import 'package:gapura/screens/components/recent_files.dart';
import 'package:gapura/screens/components/storage_details.dart';

import 'package:gapura/screens/template/html_form.dart';
import 'package:gapura/screens/template/multi_form.dart';
import 'package:gapura/screens/template/single_form.dart';
import 'package:gapura/screens/template/single_image_upload.dart';

class TemplateScreen extends StatefulWidget {
  static XFile uploadimage;
  static XFile backgroundUploadimage;
  static String singleForm;
  static String multiForm;
  static String htmlEditor;
  @override
  State<TemplateScreen> createState() => _TemplateScreen();
}

class _TemplateScreen extends State<TemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              titlePage: "Template",
            ),
            SizedBox(height: defaultPadding),
            Row(
              children: [
                SingleImageUpload(
                    titleDesc: "Upload Gambar",
                    pickedImage: TemplateScreen.uploadimage),
                SizedBox(width: defaultPadding),
                BackgroundImgageUpload(
                    titleDesc: "Upload Background",
                    pickedImage: TemplateScreen.backgroundUploadimage),
              ],
            ),
            SizedBox(height: defaultPadding),
            SingleForm(
                titleForm: "Single Form",
                singleForm: TemplateScreen.singleForm),
            SizedBox(height: defaultPadding),
            MultiForm(titleForm: "Multi Form"),
            SizedBox(height: defaultPadding),
            HtmlForm(titleForm: "HTML Editor"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding,
                      ),
                    ),
                    child: Text("Submit"),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 5,
            //       child: Column(
            //         children: [
            //           MyFiles(),
            //           SizedBox(height: defaultPadding),
            //           RecentFiles(),
            //           if (Responsive.isMobile(context))
            //             SizedBox(height: defaultPadding),
            //           if (Responsive.isMobile(context)) StarageDetails(),
            //         ],
            //       ),
            //     ),
            //     if (!Responsive.isMobile(context))
            //       SizedBox(width: defaultPadding),
            //     // On Mobile means if the screen is less than 850 we dont want to show it
            //     if (!Responsive.isMobile(context))
            //       Expanded(
            //         flex: 2,
            //         child: StarageDetails(),
            //       ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
