
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/App_bar.dart';
import '../../Widgets/year_selector.dart';
import 'Widgets/leave_tab_view.dart';

class leavepage extends StatefulWidget {
  const leavepage({super.key, required this.title});
  final String title;

  @override
  State<leavepage> createState() => _leavepageState();
}

class _leavepageState extends State<leavepage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(title: 'Leave Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Year & Month Selector
            YearMonthSelector(
              initialYear: selectedYear,
              initialMonth: selectedMonth,
              onDateChanged: (year, month) {
                setState(() {
                  selectedYear = year;
                  selectedMonth = month;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            /// Leave Data for Selected Month (empty)
            Expanded(
              child: LeaveTabView(
                heightFactor: 0.8,
                selectedYear: selectedYear,
                selectedMonth: selectedMonth,
                useCustomRange: false,
                // Provide empty data inside LeaveTabView widget
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            /// Request Leave Button (disabled)
            PrimaryButton(
              onPressed: null,
              icon: const Icon(Icons.add, color: Colors.white),
              text: "Request Leave",
            ),
          ],
        ),
      ),
    )) ;
  }
}
