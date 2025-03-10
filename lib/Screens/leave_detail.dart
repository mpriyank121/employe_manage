import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widgets/Leave_card.dart';
import '../Widgets/custom_anime.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/holiday_list_tile.dart';
import '../Widgets/year_selector.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'otp_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: leavepage(title: ''),
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
  final List<Map<String, dynamic>> items1 = [
    {"title": "Sick Leave", "subtitle": "8 Jan 2024"},
    {"title": "Casual Leave", "subtitle": "10 Jan 2024"},
  ];

  int selectedYear = DateTime.now().year;

  void onYearChanged(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: 'Leave Details'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Year Selector
            YearSelector(
              initialYear: selectedYear,
              onYearChanged: onYearChanged,
            ),


             SizedBox(height :screenHeight *0.02),

            // Leave Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                LeaveCard(
                  heightFactor: 0.075,
                    widthFactor: 0.4,
                    title: "Total Casual Leave", count: "3/12", icon: Icons.person_off),
                LeaveCard(
                  heightFactor: 0.075,
                    widthFactor: 0.4,
                    title: "Total Sick Leave", count: "5/10", icon: Icons.sick),
              ],
            ),

            SizedBox(height :screenHeight *0.02),
            // Status Row (Approved, Pending, Declined)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                customanime(initialtext: 'Approved'),
                customanime(initialtext: 'Pending'),
                customanime(initialtext: 'Declined'),
              ],
            ),

            SizedBox(height :screenHeight *0.02),
            // Leave List
            Expanded(
              child: ListView.builder(
                itemCount: items1.length,
                itemBuilder: (context, index) {
                  final item = items1[index];
                  return ListTile(
                    title: Text(item["title"], style: fontStyles.headingStyle),
                    subtitle: Text(item["subtitle"], style: fontStyles.subTextStyle),
                    trailing: const CustomButton(),
                  );
                },
              ),
            ),

            SizedBox(height :screenHeight *0.02),
            // Holiday List
            Container(
              width: screenWidth * 1,
              padding: const EdgeInsets.all(8),
              child: const Center(child: customanime(initialtext: 'Holiday This Month')),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: HolidayListTile.items.length,
                itemBuilder: (context, index) {
                  return CustomListTile(item: HolidayListTile.items[index]);
                },
              ),
            ),

            SizedBox(height :screenHeight *0.02),
            // Continue Button
            PrimaryButton(
              initialtext: 'Continue',
              onPressed: () {
                Get.to(() =>  OtpPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
