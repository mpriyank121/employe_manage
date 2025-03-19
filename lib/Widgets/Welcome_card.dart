import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';
import 'package:intl/intl.dart';

import '../Configuration/app_spacing.dart'; // ✅ For date formatting

class WelcomeCard extends StatelessWidget {
  final String userName;
  final String jobRole;
  final double screenWidth;
  final double screenHeight;
  final int elapsedSeconds;
  final bool isCheckedIn;
  final DateTime checkInTime;
  final DateTime? checkOutTime; // ✅ Allow nullable checkout time
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
    this.checkOutTime, // ✅ Allow optional checkOutTime
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
  String formatCheckOutTime(DateTime? time) {
    if (time == null) return "Not checked out yet";
    return DateFormat('hh:mm a').format(time); // Example: 02:30 PM
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(WelcomeCardConfig.borderRadius),
            topRight: Radius.circular(WelcomeCardConfig.borderRadius),
          )
        ),
      ),
      child: Column(
        children: [
          Text(
            isCheckedIn
                ? "Check in at ${formatCheckInTime(checkInTime)}"
                : "Let’s get to work!",
            style: WelcomeCardConfig.welcomeText,
          ),
          AppSpacing.small(context),

// ✅ Show "Today" when checked in, otherwise show Username
          Text(
            isCheckedIn ? "${formatTime(elapsedSeconds)}" : userName,
            style: WelcomeCardConfig.nameText,
          ),

// ✅ Show worked time instead of jobRole after checkout
          if (!isCheckedIn && workedTime.isNotEmpty)
            Column(

              children: [Text("Total Worked Time: $workedTime",style: WelcomeCardConfig.welcomeText),
              SizedBox(height: screenHeight* 0.01,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ✅ Distributes space evenly

                children: [Text("Check in  ${formatCheckInTime(checkInTime)}",style: WelcomeCardConfig.welcomeText),
                Text("Check Out: ${formatCheckOutTime(checkOutTime)}",style: WelcomeCardConfig.welcomeText),
              ],)
              ,],)

          else if (!isCheckedIn)
            Text(jobRole, style: WelcomeCardConfig.roleText),

// ✅ Show elapsed time only when checked in
          if (isCheckedIn)
            Text(
              " Today",
              style: WelcomeCardConfig.welcomeText,
            ),

        ],
      ),
    );
  }
}
