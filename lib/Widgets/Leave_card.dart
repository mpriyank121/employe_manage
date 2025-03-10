import 'package:flutter/material.dart';
import 'package:employe_manage/Configuration/config_file.dart'; // Import config

class LeaveCard extends StatelessWidget {

  final String title;
  final double widthFactor;  // Allow custom width
  final double heightFactor;
  final String count;
  final IconData icon;

  const LeaveCard({
    Key? key,
    required this.title,
    this.widthFactor = 0.9,
    this.heightFactor = 0.1,
    required this.count,
    this.icon = Icons.person_off, // Default icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Container(
      height: screenHeight * heightFactor,

      width: screenWidth * widthFactor, // Apply width factor
      padding: LeaveCardConfig.globalPadding(context),
      margin: LeaveCardConfig.globalMargin(context),

      decoration: BoxDecoration(
        color: LeaveCardConfig.defaultBackgroundColor,
        border: Border.all(color: LeaveCardConfig.defaultBorderColor, width: 1),
        borderRadius: BorderRadius.circular(LeaveCardConfig.defaultBorderRadius(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: LeaveCardConfig.titleStyle(context)),
              Text(count, style: LeaveCardConfig.countStyle(context)),
            ],
          ),
        ],
      ),
    );
  }
}
