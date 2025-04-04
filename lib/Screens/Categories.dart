import 'package:employe_manage/Screens/attendence.dart';
import 'package:employe_manage/Screens/ticket_listing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../screens/assets_cat.dart';
import '../screens/holiday_list.dart';
import '../screens/leave_detail.dart';
import 'package:employe_manage/Widgets/Container_card.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: CategoryPage(title: ''),
    );
  }
}
class CategoryPage extends StatefulWidget {
  final String title;
  final String empId = '';
  const CategoryPage({super.key, required this.title});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}
class _CategoryPageState extends State<CategoryPage> {
  final List<Map<String, dynamic>> categoryItems = [
    {'title': 'Attendance', 'icon': 'assets/images/clock.png', 'route': () => AttendancePage(title: 'Attendence')},
    //{'title': 'Remuneration', 'icon': 'assets/images/wired-flat-290-coin 1.png', 'route': null},
    {'title': 'Assets', 'icon': 'assets/images/wired-flat-146-trolley 1.png', 'route': () => Assetspage(title: 'assets',empId : '')},
    {'title': 'Holidays', 'icon': 'assets/images/wired-flat-1103-confetti (1) 1.png', 'route': () => holidaypage(title: 'Holidays')},
    {'title': 'Leave', 'icon': 'assets/images/wired-flat-1725-exit-sign 1.png', 'route': () => leavepage(title: 'Leave')},
    {'title': 'Ticket Listing', 'icon': 'assets/images/wired-flat-56-document 1.png', 'route': ()=>TicketScreen()},
  ];
  @override
  Widget build(BuildContext context) {
    double iconSize = 50.0;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        showBackButton: false,

      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // 4% of screen width
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: MediaQuery.of(context).size.height * 0.15, // Controls height of each card
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: categoryItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (categoryItems[index]['route'] != null) {
                      Get.to(categoryItems[index]['route']()); // ✅ Correct way to navigate
                    }
                  },
                  child: ContainerCard(
                    title: categoryItems[index]['title'],
                    iconPath: categoryItems[index]['icon'],
                    iconSize: iconSize,
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

// Container Card Widget