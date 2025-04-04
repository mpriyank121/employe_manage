import 'package:employe_manage/Widgets/Request_leave_form.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/leave_controller.dart';
import '../Widgets/App_bar.dart';
import '../API/Controllers/holiday_controller.dart';
import '../Widgets/leave_tab_view.dart';
import '../Widgets/year_selector.dart';

class leavepage extends StatefulWidget {
  const leavepage({super.key, required this.title});
  final String title;

  @override
  State<leavepage> createState() => _leavepageState();
}

class _leavepageState extends State<leavepage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month; // ✅ Initialize selectedMonth

  final HolidayController controller = Get.put(HolidayController());
  final LeaveController leaveController = Get.put(LeaveController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    leaveController.fetchLeaveData(selectedYear,selectedMonth,false);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Leave Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// **📅 Year & Month Selector**
            YearMonthSelector(
              initialYear: selectedYear,
              initialMonth: selectedMonth,
              onDateChanged: (year, month) {
                setState(() {
                  selectedYear = year;
                  selectedMonth = month;
                });
                leaveController.fetchLeaveData(year, month, false);
              },
            ),

            SizedBox(height: screenHeight * 0.02),

            /// **📜 Leave Data for Selected Month**
            Expanded(
              child: LeaveTabView(
                heightFactor: 0.8, // Adjusted height for better display
                selectedYear: selectedYear,
                selectedMonth: selectedMonth,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            /// **➕ Request Leave Button**
            PrimaryButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestLeavePage()),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white), // Set icon color to white
              text: "Request Leave",
            ),
          ],
        ),
      ),
    );
  }
}
