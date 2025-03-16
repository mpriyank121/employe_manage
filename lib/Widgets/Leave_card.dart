import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class LeaveCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final double? widthFactor;  // ✅ Custom width factor
  final double? heightFactor; // ✅ Custom height factor
  final Color? backgroundColor; // ✅ Custom background color

  const LeaveCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    this.widthFactor,
    this.heightFactor,
    this.backgroundColor, // Optional background color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthFactor != null
          ? MediaQuery.of(context).size.width * widthFactor!
          : LeaveCardConfig.defaultWidth(context),
      height: heightFactor != null
          ? MediaQuery.of(context).size.height * heightFactor!
          : LeaveCardConfig.defaultHeight(context),
      padding: LeaveCardConfig.padding(context),
      margin: LeaveCardConfig.margin(context),
      decoration: BoxDecoration(
        color: backgroundColor ?? LeaveCardConfig.backgroundColor,
        borderRadius: BorderRadius.circular(LeaveCardConfig.borderRadius),
        border: Border.all(color: LeaveCardConfig.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 24), // Using blue as default icon color
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: LeaveCardConfig.titleStyle),
              Text(count, style: LeaveCardConfig.countStyle),
            ],
          ),
        ],
      ),
    );
  }
}
