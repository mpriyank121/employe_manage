import 'package:employe_manage/Configuration/app_spacing.dart';
import 'package:employe_manage/Widgets/attendance_calender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Widgets/App_bar.dart';

import '../Configuration/Leave_Card_colors.dart';
import '../Widgets/Leave_card.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key, required this.title});

  final String title;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.small(context),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child:  Row(
                  children: [
                    LeaveCard(
                      title: "Present",
                      count:   '0',
                      backgroundColor: blendWithWhite(LeaveColors.present),
                      borderColor: LeaveColors.present,
                    ),
                    LeaveCard(
                      title: "Absent",
                      count: '0',
                      backgroundColor: blendWithWhite(LeaveColors.absent),
                      borderColor: LeaveColors.absent,
                    ),
                    LeaveCard(
                      title: "Half Day",
                      count: '0',
                      backgroundColor: blendWithWhite(LeaveColors.halfDay),
                      borderColor: LeaveColors.halfDay,
                    ),
                    LeaveCard(
                      title: "Sick Leave",
                      count: '0',
                      backgroundColor: blendWithWhite(LeaveColors.sickLeave),
                      borderColor: LeaveColors.sickLeave,
                    ),
                    LeaveCard(
                      title: "Casual Leave",
                      count: '0',
                      backgroundColor: blendWithWhite(LeaveColors.casualLeave),
                      borderColor: LeaveColors.casualLeave,
                    ),
                    LeaveCard(
                      title: "Earned Leave",
                      count: '0',
                      backgroundColor: blendWithWhite(LeaveColors.earnedLeave),
                      borderColor: LeaveColors.earnedLeave,
                    ),
                    LeaveCard(
                      title: "Off",
                      count: '0',
                      backgroundColor: blendWithWhite(LeaveColors.off),
                      borderColor: LeaveColors.off,
                    ),
                    LeaveCard(
                      title: "Holiday",
                      count:  '0',
                      backgroundColor: blendWithWhite(LeaveColors.holiday),
                      borderColor: LeaveColors.holiday,
                    ),
                  ]
                  ,
                ),
              ),
            ),

                // Calendar (static, not interactive)
                AttendanceCalendar(
                  onDateSelected: null,
                  onMonthChanged: null,
                  popOnDateTap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
