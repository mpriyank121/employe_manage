import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:employe_manage/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../Widgets/No_data_found.dart';

class Assetspage extends StatelessWidget {
  final String empId; // Pass Dynamic empId
  final String title;

  const Assetspage({Key? key,required this.empId, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
      appBar: CustomAppBar(title: "Assets",),
      body:Padding(padding:EdgeInsets.only(top: 10),
      child: const NoDataWidget(
        message: "No Assets found",
        imagePath: "assets/images/Error_image.png", // your image path
      ),
      ),
    ));
  }
}
