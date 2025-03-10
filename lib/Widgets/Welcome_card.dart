import 'package:flutter/material.dart';
import 'package:employe_manage/Configuration/config_file.dart';
class WelcomeCard extends StatelessWidget {
  final String userName;
  final String jobRole;
  final double screenWidth;
  final double screenHeight;

  const WelcomeCard({
    Key? key,
    required this.userName,
    required this.jobRole,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: screenWidth * 0.03),
      width: screenWidth * 0.9,
      height: screenHeight * 0.12,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: WelcomeCardConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: WelcomeCardConfig.borderWidth, color: WelcomeCardConfig.borderColor),
          borderRadius: BorderRadius.circular(WelcomeCardConfig.borderRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Let’s get to work!', style: WelcomeCardConfig.welcomeTextStyle),
          SizedBox(height: screenHeight * 0.005),
          Text(userName, style: WelcomeCardConfig.nameTextStyle),
          SizedBox(height: screenHeight * 0.005),
          Text(jobRole, textAlign: TextAlign.center, style: WelcomeCardConfig.roleTextStyle),
        ],
      ),
    );
  }
}
