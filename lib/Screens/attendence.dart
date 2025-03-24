import 'package:employe_manage/Widgets/attendance_calender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../API/Controllers/employee_attendence_controller.dart';
import '../Widgets/Leave_card.dart';
class attendencepage extends StatefulWidget {
  const attendencepage({super.key, required this.title});

  final String title;

  @override
  State<attendencepage> createState() => _attendencepageState();
}

class _attendencepageState extends State<attendencepage> {
  final AttendanceController controller = Get.put(AttendanceController());
  int selectedYear = DateTime.now().year;

  void changeYear(int step) {
    setState(() {
      selectedYear += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
                // ✅ Leave Cards Section (Uses GetX Observer)
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator()); // ✅ Show Loading Indicator
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
                            count:  controller.present.value.toString(),

                          ),
                          LeaveCard(
                            title: "Absent",
                            count:  controller.absent.value.toString(),
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
                // Space after Leave Cards
                SizedBox(height: screenHeight * 0.012),
                // Calendar Section (Scrollable)
                Container(
                height: screenHeight * 0.6,  // Set height dynamically
                child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AttendanceCalendar(
                ),  // Embed Attendance Calendar here
                ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
