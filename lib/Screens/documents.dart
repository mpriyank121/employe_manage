import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widgets/Document_list.dart';

class documentpage extends StatelessWidget {
  const documentpage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(title: 'Documents'),
      body: ListView.builder(
        itemCount: DocumentList.documentItems.length,
        itemBuilder: (context, index) {
          return CustomListTile(item: DocumentList.documentItems[index],
            trailing: SvgPicture.asset("assets/images/solar_download-linear.svg",),
            leading: SvgPicture.asset("assets/images/ion_document-text-outline.svg"),
          );
        },
      ),
    )) ;
  }
}
