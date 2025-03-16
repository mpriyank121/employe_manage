import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../Configuration/Custom_Animation.dart';
import '../Widgets/CustomListTile.dart';
import '../Widgets/Leave_card.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/year_selector.dart';
import 'package:employe_manage/Widgets/leave_list.dart';
import 'package:employe_manage/Widgets/holiday_list_tile.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const leavepage(title: 'Leave Details'),
    );
  }
}
class leavepage extends StatefulWidget {
  const leavepage({super.key, required this.title});
  final String title;

  @override
  State<leavepage> createState() => _leavepageState();
}

class _leavepageState extends State<leavepage> {
  int selectedYear = DateTime.now().year;

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
            // **Year Selector**
            YearSelector(
              initialYear: selectedYear,
              onYearChanged: onYearChanged,
            ),
            SizedBox(height: screenHeight * 0.02),

            // **Leave Cards**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LeaveCard(
                  widthFactor: 0.45, // ✅ Corrected widthFactor usage
                  title: "Total Casual Leave",
                  count: "3/12",
                  icon: Icons.person_off,
                ),
                LeaveCard(

                  widthFactor: 0.45,// ✅ Ensure both cards have correct widthFactor
                  title: "Total Sick Leave",
                  count: "5/10",
                  icon: Icons.sick,
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),

            // **Leave List**
            Expanded(
              child: ListView.builder(
                itemCount: leaveList.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    item: leaveList[index],
                    trailing: const CustomButton(),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight* 0.02,),

            // **Holiday Section Title**
            Expanded(
              child: CustomAnimation(
                heightFactor: 0.1,
                widthFactor: 0.9,
                initialText: "Holidays This Month",
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // **Holiday List**
            Expanded(
              child: ListView.builder(
                itemCount: holidayList.length,
                itemBuilder: (context, index) {
                  return CustomListTile(
                    item: holidayList[index],
                    leading: SvgPicture.asset("assets/images/Frame 427319800.svg"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
