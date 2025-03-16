import 'package:employe_manage/Screens/attendence.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_bar.dart';
import '../screens/assets_cat.dart';
import '../screens/holiday_list.dart';
import '../screens/leave_detail.dart';
import '../screens/documents.dart';
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
  const CategoryPage({super.key, required this.title});
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}
class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Map<String, dynamic>> categoryItems = [
    {'title': 'Attendance', 'icon': 'assets/images/wired_clock.jpg', 'route': () => attendencepage(title: 'Attendence')},
    {'title': 'Remuneration', 'icon': 'assets/images/remuneration.svg', 'route': null},
    {'title': 'Assets', 'icon': 'assets/images/assets.svg', 'route': () => Assetspage(title: 'Assets')},
    {'title': 'Holidays', 'icon': 'assets/images/holidays.svg', 'route': () => holidaypage(title: 'Holidays')},
    {'title': 'Leave', 'icon': 'assets/images/leave.svg', 'route': () => leavepage(title: 'Leave')},
    {'title': 'Tasks', 'icon': 'assets/images/tasks.svg', 'route': null},
    {'title': 'Documents', 'icon': 'assets/images/wired-flat-245-edit-document 1.jpg', 'route': ()=>documentpage(title: 'document',)},
  ];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = 50.0;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
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