import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:gapura/constants.dart';
import 'package:gapura/controllers/list_aset_controller.dart';
import 'package:gapura/models/list_aset_model.dart';
import 'package:gapura/screens/categories/categories_add_modal.dart';
import 'package:gapura/screens/categories/categories_edit_modal.dart';
import 'package:gapura/screens/components/header.dart';
import 'package:gapura/screens/list_aset/list_aset_add_modal.dart';

class ListAsetScreen extends StatefulWidget {
  @override
  State<ListAsetScreen> createState() => _StateListAsetScreen();
}

class _StateListAsetScreen extends State<ListAsetScreen> {
  List<ListAsetModel> _listAset;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asetList();
  }

  asetList() async {
    await ListAsetController.load().then((value) {
      setState(() {
        _listAset = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(titlePage: "List Aset"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // subHeader(context),
                      (isLoading)
                          ? Center(
                              child: LinearProgressIndicator(),
                            )
                          : table(context),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  subHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical: defaultPadding,
                ),
              ),
              icon: Icon(Icons.add),
              label: Text("Tambah"),
              onPressed: () async {
                await Navigator.of(context)
                    .push(
                  PageRouteBuilder(
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 300),
                    opaque: false,
                    pageBuilder: (_, __, ___) => ListAsetAddModal(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end);
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      );

                      return SlideTransition(
                        position: tween.animate(curvedAnimation),
                        child: child,
                      );
                    },
                  ),
                )
                    .then((value) {
                  setState(() {
                    asetList();
                  });
                });
              },
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }

  table(BuildContext context) {
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
            "List Aset",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Judul"),
                ),
                DataColumn(
                  label: Text("Thumbnail"),
                ),
                DataColumn(
                  label: Text("File"),
                ),
                // DataColumn(
                //   label: Text("Aksi"),
                // ),
              ],
              rows: List.generate(
                _listAset.length,
                (index) => recentFileDataRow(_listAset[index], context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow recentFileDataRow(ListAsetModel data, BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text((data.title == null) ? "" : data.title)),
        DataCell(Text((data.image == null) ? "" : data.image)),
        DataCell(Text((data.file == null) ? "" : data.file)),
        // DataCell(
        //   Text("Ubah"),
        //   onTap: (() {
        //     navigateModalEdit(context, data.id.toString());
        //   }),
        // )
      ],
    );
  }

  navigateModalEdit(BuildContext context, String dataid) async {
    await Navigator.of(context)
        .push(
      PageRouteBuilder(
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        opaque: false,
        pageBuilder: (_, __, ___) => CategoriesEditModal(categories_id: dataid),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    )
        .then((value) {
      setState(() {
        asetList();
      });
    });
  }
}
