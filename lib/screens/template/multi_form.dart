// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gapura/screens/template/template_screen.dart';

import '../../../constants.dart';

class MultiForm extends StatefulWidget {
  MultiForm({this.titleForm, this.multiForm});
  String titleForm;
  String multiForm;

  @override
  State<MultiForm> createState() => _StateMultiForm();
}

class _StateMultiForm extends State<MultiForm> {
  TextEditingController multiFormController = TextEditingController();
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
                TemplateScreen.multiForm = value;
              },
              maxLines: 4,
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
