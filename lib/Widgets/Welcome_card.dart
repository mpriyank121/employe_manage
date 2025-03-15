import 'package:flutter/material.dart';
import '../Configuration/config_file.dart';
import 'package:intl/intl.dart'; // ✅ For date formatting

class WelcomeCard extends StatelessWidget {
  final String userName;
  final String jobRole;
  final double screenWidth;
  final double screenHeight;
  final int elapsedSeconds;
  final bool isCheckedIn;
  final DateTime checkInTime;
  final String workedTime; // ✅ NEW: Worked Time

  const WelcomeCard({
    Key? key,
    required this.userName,
    required this.jobRole,
    required this.screenWidth,
    required this.screenHeight,
    required this.elapsedSeconds,
    required this.isCheckedIn,
    required this.checkInTime,
    this.workedTime = "", // ✅ Default empty if not checked out
  }) : super(key: key);

  /// ✅ Convert seconds into HH:MM:SS format
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  /// ✅ Format DateTime to readable Check-in Time
  String formatCheckInTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
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
        children: [
          Text(
            isCheckedIn
                ? "Checked in at ${formatCheckInTime(checkInTime)}"
                : "Let’s get to work!",
            style: WelcomeCardConfig.welcomeText,
          ),
          AppSpacing.small(context),
          Text(
            isCheckedIn ? "Today" : userName,
            style: WelcomeCardConfig.nameText,
          ),
          if (!isCheckedIn)
            Text(jobRole, style: WelcomeCardConfig.roleText),

          if (isCheckedIn) ...[
            Text(
              " ${formatTime(elapsedSeconds)}",
              style: WelcomeCardConfig.welcomeText,
            ),
          ] else if (workedTime.isNotEmpty) ...[
            Text(
              "Total Worked Time: $workedTime",
              style: WelcomeCardConfig.welcomeText,
            ),
          ],
        ],
      ),
    );
  }
}
