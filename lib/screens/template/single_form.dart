// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gapura/screens/template/template_screen.dart';

import '../../../constants.dart';

class SingleForm extends StatefulWidget {
  SingleForm({this.titleForm, this.singleForm});
  String titleForm;
  String singleForm;

  @override
  State<SingleForm> createState() => _StateSingleForm();
}

class _StateSingleForm extends State<SingleForm> {
  TextEditingController singleFormController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
            widget.titleForm,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              onChanged: (value) {
                TemplateScreen.singleForm = value;
              },
              controller: singleFormController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
