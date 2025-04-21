import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Configuration/app_cards.dart';
import '../Configuration/app_spacing.dart';
import 'Image_preview.dart';

class WelcomeCard extends StatelessWidget {
  final String userName;
  final String jobRole;
  final double screenWidth;
  final double screenHeight;
  final int elapsedSeconds;
  final bool isCheckedIn;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String workedTime;
  final String selectedFirstIn;
  final String selectedLastOut;
  final String? checkInImage;
  final String? checkOutImage;
  final String? checkOutLocation;
  final String? checkInLocation;
  final DateTime? selectedDate;

  const WelcomeCard({
    Key? key,
    required this.userName,
    required this.jobRole,
    required this.screenWidth,
    required this.screenHeight,
    required this.elapsedSeconds,
    required this.isCheckedIn,
    required this.checkInTime,
    required this.checkOutImage,
    required this.checkInImage,
    required this.checkOutLocation,
    required this.checkInLocation,
    this.checkOutTime,
    this.workedTime = "",
    this.selectedFirstIn = "N/A",
    this.selectedLastOut = "N/A",
    this.selectedDate,
  }) : super(key: key);


  /// ✅ Convert time string (hh:mm a) to DateTime object
  DateTime? parseTime(String time) {
    try {
      return DateFormat("hh:mm a").parse(time);
    } catch (e) {
      return null;
    }
  }

  /// ✅ Calculate total worked time between First In & Last Out
  String calculateWorkedTime() {
    DateTime? firstInTime = parseTime(selectedFirstIn);
    DateTime? lastOutTime = parseTime(selectedLastOut);

    if (firstInTime != null && lastOutTime != null) {
      Duration difference = lastOutTime.difference(firstInTime);
      return formatTime(difference.inSeconds);
    }
    return userName;
  }

  /// ✅ Format time as HH:MM:SS
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    final bool isCheckedOut = checkOutTime != null;
    final bool hasValidDateData = selectedDate != null;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime selected = DateTime(
      (selectedDate ?? now).year,
      (selectedDate ?? now).month,
      (selectedDate ?? now).day,
    );

    final bool isToday = selected == today;

    return Container(
        padding: EdgeInsets.only(top: screenWidth * 0.03),
        width: screenWidth * 0.9,
        height: screenHeight * 0.20,
        decoration: ShapeDecoration(
          color: WelcomeCardConfig.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(WelcomeCardConfig.borderRadius),
              topRight: Radius.circular(WelcomeCardConfig.borderRadius),
            ),
          ),
        ),
        child: Column(
          children: [
            if (!isCheckedIn)
              Text(
                "Let’s get to work!",
                style: WelcomeCardConfig.welcomeText,
              ),
            AppSpacing.small(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ✅ Check-in Image Slot (fixed width)
                SizedBox(
                  width: 60, // same width as your image preview
                  height: 60,
                  child: (checkInImage != null)
                      ? ImagePreviewWidget(
                    imageUrl: checkInImage,
                    checkInLocation: checkInLocation,
                  )
                      : const SizedBox.shrink(),
                ),

                // 🔁 Dynamic Center Text
                Builder(
                  builder: (context) {
                    if (isToday) {
                      if (isCheckedOut) {
                        return Text(
                          calculateWorkedTime(),
                          style: WelcomeCardConfig.nameText,
                        );
                      } else if (isCheckedIn) {
                        return Text(
                          formatTime(elapsedSeconds),
                          style: WelcomeCardConfig.nameText,
                        );
                      } else {
                        return Text(
                          calculateWorkedTime(),
                          style: WelcomeCardConfig.nameText,
                        );
                      }
                    } else {
                      if (selectedFirstIn != null && selectedLastOut != null)
                      {
                        return Text(
                          calculateWorkedTime(),
                          style: WelcomeCardConfig.nameText,
                        );
                      } else {
                        return Text(
                          userName,
                          style: WelcomeCardConfig.nameText,
                        );
                      }
                    }
                  },
                ),

                // ✅ Check-out Image Slot (fixed width)
                SizedBox(
                  width: 60, // same width as your image preview
                  height: 60,
                  child: (checkOutImage != null)
                      ? ImagePreviewWidget(
                    imageUrl: checkOutImage,
                    checkOutLocation: checkOutLocation,
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),

            if (isCheckedIn && isToday)
              Text("Today", style: WelcomeCardConfig.welcomeText),
            if (hasValidDateData)
              Column(
                children: [

                  Text(jobRole, style: WelcomeCardConfig.roleText),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (selectedFirstIn != "N/A" && selectedFirstIn.isNotEmpty)
                        Text("Check-in: $selectedFirstIn", style: WelcomeCardConfig.welcomeText),
                      if (selectedLastOut != "N/A" && selectedLastOut.isNotEmpty)
                        Text("Check-out: $selectedLastOut", style: WelcomeCardConfig.welcomeText),
                    ],
                  ),

                ],
              ),
          ],
        ));
  }
}