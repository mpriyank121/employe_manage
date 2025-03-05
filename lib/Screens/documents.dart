import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../Configuration/config_file.dart';
import '../widgets/list_tiles.dart';
import 'Categories.dart';


class documentpage extends StatelessWidget {
  const documentpage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Documents'),
      body: ListView.builder(
        itemCount: TileConfig.documentItems.length,
        itemBuilder: (context, index) {
          return DocumentListTile(item: TileConfig.documentItems[index]);
        },
      ),
    );
  }
}
