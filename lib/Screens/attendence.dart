import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../Widgets/Calender_widget.dart';
import '../Widgets/Leave_card.dart';

class attendencepage extends StatefulWidget {
  const attendencepage({super.key, required this.title});

  final String title;

  @override
  State<attendencepage> createState() => _attendencepageState();
}

class _attendencepageState extends State<attendencepage> {
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
                // Leave Cards Section (Scrollable Row to prevent overflow)
                SingleChildScrollView(


                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LeaveCard(
                          widthFactor: 0.3,
                          heightFactor: 0.08, // Increased height to prevent shrinkage
                          title: "Present",
                          count: "3/12",
                          icon: Icons.person_off,
                        ),
                        LeaveCard(
                          widthFactor: 0.3,
                          heightFactor: 0.08,
                          title: "Absent",
                          count: "5/10",
                          icon: Icons.sick,
                        ),
                        LeaveCard(
                          widthFactor: 0.3,
                          heightFactor: 0.08,
                          title: "Leave",
                          count: "5/10",
                          icon: Icons.sick,
                        ),
                      ],
                    ),
                  ),
                ),

                // Space after Leave Cards
                SizedBox(height: screenHeight * 0.012),

                // Calendar Section (Scrollable & Avoid Overflow)
                SizedBox(
                  height: screenHeight * 0.7, // Set height dynamically
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
