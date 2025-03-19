import 'package:employe_manage/Configuration/Custom_Animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/App_bar.dart';
import '../API/Controllers/holiday_controller.dart';
import '../Widgets/Leave_card.dart';
import '../Widgets/holiday_list.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Year Selector**
            YearSelector(
              initialYear: selectedYear,
              onYearChanged: onYearChanged,
            ),
            SizedBox(height: screenHeight * 0.02),

            /// **Leave Cards Row**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LeaveCard(
                  widthFactor: 0.45,
                  title: "Total Casual Leave",
                  count: "3/12",
                  icon: Icons.person_off,
                ),
                LeaveCard(
                  widthFactor: 0.45,
                  title: "Total Sick Leave",
                  count: "5/10",
                  icon: Icons.sick,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            LeaveTabView(heightFactor: 0.3),


            /// **Holiday This Month Button**
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0), // ✅ Added padding for proper spacing
              child: CustomAnimation(
                widthFactor: 0.9,
                heightFactor: 0.05,
                initialText: "Holiday This Month",
              ),
            ),

            /// **Holiday Section**
            Expanded(
              flex: 4, // ✅ Adjusted flex to distribute space evenly
              child: Obx(() => HolidayList(
                holidays: controller.monthHolidays.toList(),
                isLoading: controller.isLoading.value,
                phoneNumber: controller.phoneNumber.value,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
