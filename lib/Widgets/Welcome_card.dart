import 'package:flutter/material.dart';
import 'package:employe_manage/Configuration/config_file.dart';

class WelcomeCard extends StatelessWidget {
  final String userName;
  final String jobRole;
  final double screenWidth;
  final double screenHeight;
  final int elapsedSeconds; // ✅ Receive elapsed time
  final bool isCheckedIn; // ✅ Receive check-in state
  final DateTime checkInTime; // ✅ Receive check-in time

  const WelcomeCard({
    Key? key,
    required this.userName,
    required this.jobRole,
    required this.screenWidth,
    required this.screenHeight,
    required this.elapsedSeconds,
    required this.isCheckedIn, // ✅ Added
    required this.checkInTime, // ✅ Added
  }) : super(key: key);

  // ✅ Function to format elapsed time
  String formatElapsedTime(int elapsedSeconds) {
    int hours = elapsedSeconds ~/ 3600;
    int minutes = (elapsedSeconds % 3600) ~/ 60;
    int seconds = elapsedSeconds % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  // ✅ Function to format check-in time (HH:MM:SS)
  String _formatCheckInTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:"
        "${time.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: screenWidth * 0.03),
      width: screenWidth * 0.9,
      height: screenHeight * 0.17, // ✅ Increased height to fit timer
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: WelcomeCardConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WelcomeCardConfig.borderRadius),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ✅ Show Check-in Time or Default Welcome Message
          Text(
            isCheckedIn
                ? "Checked in at ${_formatCheckInTime(checkInTime)}"
                : "Let’s get to work!",
            style: WelcomeCardConfig.welcomeText,
          ),

          SizedBox(height: screenHeight * 0.005),

          // ✅ Show Elapsed Time Instead of Username When Checked In
          Text(
            isCheckedIn ? formatElapsedTime(elapsedSeconds) : userName,
            style: WelcomeCardConfig.welcomeText,
          ),

          SizedBox(height: screenHeight * 0.005),

          // ✅ Show "Today" Instead of Job Role When Checked In
          Text(
            isCheckedIn ? "Today" : jobRole,
            textAlign: TextAlign.center,
            style: WelcomeCardConfig.welcomeText,
          ),

          SizedBox(height: screenHeight * 0.01), // Space before timer

        ],
      ),
    );
  }
}
