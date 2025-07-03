import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../Configuration/app_spacing.dart';
import '../Configuration/style.dart';
import '../Widgets/Date_Picker.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/bottom_card.dart';
import '../Widgets/leave_tab_view.dart';
import '../Widgets/slide_checkin.dart';
import '../Widgets/welcome_card.dart';

class WelcomePage extends StatefulWidget {
  final String title;
  const WelcomePage({super.key, required this.title});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: widget.title,showBackButton: false,),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [

            AppSpacing.small(context),

            // DatePickerWidget(
            //   onDateSelected: (date) {},
            // ),
            AppSpacing.small(context),
            // Welcome Card (static placeholder)
            WelcomeCard(
              userName: 'User',
              jobRole: 'Role',
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              elapsedSeconds: 0,
              isCheckedIn: false,
              checkInTime: DateTime.now(),
              // workedTime: Duration.zero,
              checkOutTime: null,
              selectedFirstIn: 'N/A',
              selectedLastOut: 'N/A',
              checkInImage: null,
              checkOutImage: null,
              checkInLocation: '',
              checkOutLocation: '',
              selectedDate: DateTime.now(),
            ),
            BottomCard(screenWidth: screenWidth, screenHeight: screenHeight),
          ],
        ),),
        bottomNavigationBar: Container(
          height: screenHeight * 0.1,
          child: SlideCheckIn(
            showCam: false,
            text: 'Slide To CheckIn',
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isEnabled: true,
            isCheckedIn: false,

          ),
        ),
      ),
    );
  }
}
