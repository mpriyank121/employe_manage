import 'package:coreHrx_employeeapp/Employee/Attendance/attendence.dart';
import 'package:coreHrx_employeeapp/Employee/Documents/documents.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/holiday_list.dart';
import 'package:coreHrx_employeeapp/Employee/Leave/leave_detail.dart';
import 'package:coreHrx_employeeapp/Employee/Policy/policy_page.dart';
import 'package:coreHrx_employeeapp/remuneration/remuneration.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/Container_card.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // ⬅ Changed to GetMaterialApp for GetX navigation
      title: 'Flutter Demo',
      home: CategoryPage(title: ''),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String title;
  final String empId;

  CategoryPage({super.key, required this.title, this.empId = ''});
  final List<Map<String, dynamic>> categoryItems = [
    {
      'title': 'Attendance',
      'icon': 'assets/images/clock.png',
      'route': () => AttendancePage(title: 'Attendance'), // ✅
    },
    {
      'title': 'Policy',
      'icon': 'assets/images/policy.png',
      'route': () => PolicyScreen(), // ✅
    },
    {
      'title': 'Remuneration',
      'icon': 'assets/images/wired-flat-146-trolley 1.png',
      'route': () => RemunerationPage(), // ✅
    },
    {
      'title': 'Holidays',
      'icon': 'assets/images/wired-flat-1103-confetti (1) 1.png',
      'route': () => HolidayPage(title: 'Holidays'), // ✅
    },
    {
      'title': 'Leave',
      'icon': 'assets/images/wired-flat-1725-exit-sign 1.png',
      'route': () => leavepage(title: 'Leave'), // ✅
    },
  ];

  @override
  Widget build(BuildContext context) {
    double iconSize = 50.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Categories',
          showBackButton: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(screenWidth * 0.04),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: screenHeight * 0.15,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: categoryItems.length,
                itemBuilder: (context, index) {
                  final item = categoryItems[index];
                  return GestureDetector(
                    onTap: () {

                      debugPrint("${item['route']}");
                      Get.to(item['route']());
                      
                    },
                    child: ContainerCard(
                      title: item['title'],
                      iconPath: item['icon'],
                      iconSize: iconSize,
                    ),
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
