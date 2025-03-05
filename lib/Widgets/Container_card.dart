import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:employe_manage/Configuration/style.dart';



class ContainerCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final double iconSize;

  const ContainerCard({required this.title, required this.iconPath, required this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Expanded(

      child: Container(
        decoration: ShapeDecoration(shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
            borderRadius: BorderRadius.circular(6),
        )),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: iconSize, height: iconSize),
            SizedBox(height: 8),
            Text(title, style: AppStyles.textStyle),
          ],
        ),
      ),
    );

  }
}
