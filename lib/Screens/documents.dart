import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../Widgets/Document_list.dart';
import '../widgets/list_tiles.dart';

class documentpage extends StatelessWidget {
  const documentpage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Documents'),
      body: ListView.builder(
        itemCount: DocumentList.documentItems.length,
        itemBuilder: (context, index) {
          return DocumentListTile(item: DocumentList.documentItems[index]);
        },
      ),
    );
  }
}
