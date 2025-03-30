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
    this.checkOutTime,
    this.workedTime = "",
    this.selectedFirstIn = "N/A",
    this.selectedLastOut = "N/A",
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
    return "N/A";
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
    void _showImagePreview(BuildContext context, String imageUrl) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: InteractiveViewer(
              panEnabled: true, // Enable dragging
              minScale: 0.2,
              maxScale: 2.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 10, color: Colors.grey);
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    bool hasValidDateData = selectedFirstIn.isNotEmpty &&
        selectedFirstIn != "N/A" &&
        selectedLastOut.isNotEmpty &&
        selectedLastOut != "N/A";

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
          Text(
            isCheckedIn ? "Check in at ${DateFormat('hh:mm a').format(checkInTime)}" : "Let’s get to work!",
            style: WelcomeCardConfig.welcomeText,
          ),
          AppSpacing.small(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ✅ Check-in Image
              ImagePreviewWidget(imageUrl: checkInImage),
              Text(
                isCheckedIn ? formatTime(elapsedSeconds) : userName,
                style: WelcomeCardConfig.nameText,
              ),


              // ✅ Check-out Image
              ImagePreviewWidget(imageUrl: checkOutImage),
            ],
          ),

          if (!isCheckedIn) Text(jobRole, style: WelcomeCardConfig.roleText),

          if (isCheckedIn)
            Text(
              "Today",
              style: WelcomeCardConfig.welcomeText,
            ),

          if (hasValidDateData)
            Column(
              children: [

                Text("Total Worked Time: ${calculateWorkedTime()}", style: WelcomeCardConfig.welcomeText),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Check-in: $selectedFirstIn", style: WelcomeCardConfig.welcomeText),
                    Text("Check-out: $selectedLastOut", style: WelcomeCardConfig.welcomeText),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}