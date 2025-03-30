import 'package:employe_manage/Widgets/Request_leave_form.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void onYearChanged(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
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
            /// **Year Selector**
            YearMonthSelector(
              initialYear: DateTime.now().year,
              initialMonth: DateTime.now().month,
              onDateChanged: (year, month) {
                print("📆 Selected Date: $month/$year");

                setState(() {  // ✅ Update both selectedYear & selectedMonth
                  selectedYear = year;
                  selectedMonth = month;
                });
              },
            ),

            SizedBox(height: screenHeight * 0.02),
            LeaveTabView(heightFactor: 0.3,
            selectedMonth: selectedMonth,
              selectedYear: selectedYear,

            ),
            /// **Holiday This Month Button**

            PrimaryButton( onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestLeavePage()));
            },
              icon: Icon(Icons.add, color: Colors.white),  // Set icon color to white
              text: "Request Leave",
            )
          ],
        ),
      ),
    );
  }
}
