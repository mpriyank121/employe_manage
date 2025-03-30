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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
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
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LeaveCard(
                            title: "Present",
                            count: controller.present.value.toString(),
                          ),
                          LeaveCard(
                            title: "Absent",
                            count: controller.absent.value.toString(),
                            backgroundColor: Color(0x19C13C0B),
                            borderColor: Color(0xFFC13C0B),
                          ),
                          LeaveCard(
                            title: "Leave",
                            count: controller.halfday.value.toString(),
                            backgroundColor: Color(0x1933B2E9),
                            borderColor: Color(0xFF33B2E9),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                // Calendar Section
                Container(
                  height: screenHeight * 0.6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AttendanceCalendar(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Container(
                    width: screenWidth * 0.7,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
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

                /// **Holiday Section**
                SizedBox(
                  height: screenHeight * 0.3,
                  child: Obx(() => HolidayList(
                    holidays: controllers.monthHolidays.toList(),
                    isLoading: controllers.isLoading.value,
                    phoneNumber: controllers.phoneNumber.value,
                  )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
