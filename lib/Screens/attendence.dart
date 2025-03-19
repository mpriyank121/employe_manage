import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../API/Controllers/employee_attendence_controller.dart';
import '../Widgets/Calender_widget.dart';
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
        trailing: TextButton(
          onPressed: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: ShapeDecoration(
              color: Color(0xFFF25922),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Apply',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
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
                            icon: Icons.person,
                          ),
                          LeaveCard(
                            title: "Absent",
                            count:  controller.absent.value.toString(),
                            icon: Icons.person_off,
                          ),
                          LeaveCard(
                            title: "Leave",
                            count: controller.halfday.value.toString(),
                            icon: Icons.sick,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Space after Leave Cards
                SizedBox(height: screenHeight * 0.012),

                // Calendar Section (Scrollable)
                SizedBox(
                  height: screenHeight * 0.7,
                  child: SingleChildScrollView(
                    child: CalendarWidget(),
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
