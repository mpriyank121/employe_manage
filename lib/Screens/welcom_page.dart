import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Configuration/config_file.dart';
import '../Configuration/style.dart';
import '../Widgets/App_bar.dart';
import '../Widgets/Bottom_card.dart';
import '../Widgets/Welcome_card.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/slide_checkin.dart';

// ✅ Define the StatefulWidget with a title parameter
class welcomepage extends StatefulWidget {
  final String title;
  const welcomepage({super.key, required this.title});

  @override
  State<welcomepage> createState() => _welcomepageState();
}

class _welcomepageState extends State<welcomepage> {
  bool isCheckedIn = false; // ✅ Track Check-in State
  int elapsedSeconds = 0;   // ✅ Track Timer

  // ✅ Sample items list for ListView (Replace with your actual data)
  final List<Map<String, String>> items1 = [
    {"title": "Sick Leave", "subtitle": "12 Jan"},
    {"title": "Annual Leave", "subtitle": "8 October"},
  ];

  void _startTimer() {
    elapsedSeconds = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isCheckedIn) {
        timer.cancel(); // Stop timer if checked out
      } else {
        setState(() {
          elapsedSeconds++; // Increase timer every second
        });
      }
    });
  }
  DateTime checkInTime = DateTime.now(); // ✅ Store check-in time

  void onCheckIn() {
    setState(() {
      isCheckedIn = true;
      checkInTime = DateTime.now(); // ✅ Store check-in time
      elapsedSeconds = 0;
    });
    _startTimer();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title, // ✅ Use the passed title parameter
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          children: [
            // ✅ Date Container
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.06,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(screenWidth * 0.1),
                ),
              ),
              child: Center(
                child: Text('10 - Jan - 2024', style: fontStyles.headingStyle),
              ),
            ),

            AppSpacing.medium(context),

            // ✅ Welcome Card - Dynamically Updates on Check-in
            WelcomeCard(
              userName: isCheckedIn ? "" : 'Priyank Mangal',
              jobRole: isCheckedIn ? "" : 'Tech - UI/UX Designer',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              elapsedSeconds: isCheckedIn ? elapsedSeconds : 0,
              isCheckedIn: isCheckedIn, // ✅ Pass check-in state
              checkInTime: checkInTime,
            ),

            BottomCard(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),


            AppSpacing.medium(context),

            // ✅ Leave Applications Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leave Application', style: fontStyles.normalText),
                  TextButton(
                    onPressed: () {},
                    child: Text('See All', style: TextStyle(color: AppColors.secondaryColor)),
                  ),
                ],
              ),
            ),

            // ✅ Responsive Leave Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customanime(initialtext: 'Approved'),
                customanime(initialtext: 'Pending'),
                customanime(initialtext: 'Declined'),
              ],
            ),

            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // ✅ Leave Application List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items1.length,
              itemBuilder: (context, index) {
                final item = items1[index];
                return ListTile(
                  title: Text(item["title"] ?? "", style: fontStyles.headingStyle),
                  subtitle: Text(item["subtitle"] ?? "", style: fontStyles.subTextStyle),
                  trailing: CustomButton(), // ✅ Fixed CustomButton
                );
              },
            ),

            // ✅ Slide Check-In Button
            SlideCheckIn(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isCheckedIn: isCheckedIn,
              onCheckIn: () {
                setState(() {
                  isCheckedIn = true;
                });
                _startTimer(); // Start timer
              },
              onCheckOut: () {
                setState(() {
                  isCheckedIn = false;
                  elapsedSeconds = 0; // Reset timer
                });
              },
            ),

            SizedBox(height: screenHeight * 0.02), // Responsive spacing
          ],
        ),
      ),
    );
  }
}
