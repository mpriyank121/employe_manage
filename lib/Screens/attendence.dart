import 'package:employe_manage/Widgets/attendance_calender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../API/Controllers/employee_attendence_controller.dart';
import '../API/Controllers/holiday_controller.dart';
import '../Widgets/Leave_card.dart';
import '../Widgets/holiday_list.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key, required this.title});

  final String title;

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceController controller = Get.put(AttendanceController());
  final HolidayController controllers = Get.put(HolidayController());


  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  @override
  void initState() {
    super.initState();
    controller.fetchAttendance();
    controllers.fetchHolidays();
    controllers.fetchHolidaysByMonth(DateTime.now().month); // Initialize current month view
  }
  void onMonthChanged(int year, int month) {
    setState(() {
      selectedYear = year;
      selectedMonth = month;
    });

    controller.fetchAttendanceByMonth(year, month);

    // ✅ Update selected year and fetch holidays again
    controllers.selectedYear.value = year;
    controllers.fetchHolidaysByMonth(month);
  }


  void changeYear(int step) {
    setState(() {
      selectedYear += step;
    });
  }

  void onYearChanged(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Leave Cards Section
                Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Obx(() => Row(
                        children: [
                          LeaveCard(
                            title: "Present",
                            count: controller.countData.value['present_count']?.toString() ?? '0',
                          ),
                          LeaveCard(
                            title: "Absent",
                            count: controller.countData.value['absent_count']?.toString() ?? '0',
                            backgroundColor: Color(0x19C13C0B),
                            borderColor: Color(0xFFC13C0B),
                          ),
                          LeaveCard(
                            title: "Leave",
                            count: controller.countData.value['leave_count']?.toString() ?? '0',
                            backgroundColor: Color(0x1933B2E9),
                            borderColor: Color(0xFF33B2E9),
                          ),
                        ],
                      )),
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // 📅 Calendar Section
                Container(
                  height: screenHeight * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: AttendanceCalendar(
                    onMonthChanged: onMonthChanged,
                  ),
                ),

                const SizedBox(height: 20),

                // 📢 "Holidays This Month" Title
                Center(
                  child: Container(
                    width: screenWidth * 0.7,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Holidays This Month",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🎉 Holiday List
                SizedBox(
                  height: screenHeight * 0.3,
                  child: Obx(() => HolidayList(
                    holidays: controllers.monthHolidays,
                    isLoading: controllers.isLoading.value,
                    phoneNumber: controllers.phoneNumber.value,
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
