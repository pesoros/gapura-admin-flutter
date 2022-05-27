// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:gapura/screens/template/template_screen.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

import '../../../constants.dart';

class HtmlForm extends StatelessWidget {
  HtmlForm({this.titleForm, this.htmlEditor});
  String titleForm;
  String htmlEditor;

  final HtmlEditorController controller = HtmlEditorController();

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
            titleForm,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 10),
          HtmlEditor(
            callbacks: Callbacks(
              onChangeContent: (String value) {
                TemplateScreen.htmlEditor = value;
              },
            ),
            controller: controller,
            htmlEditorOptions: HtmlEditorOptions(
              hint: '',
              darkMode: false,
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
                OtherOptions(height: MediaQuery.of(context).size.height / 1.6),
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
