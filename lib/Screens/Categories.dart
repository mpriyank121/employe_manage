import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../Configuration/config_file.dart';
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
  final List<Map<String, dynamic>> categoryItems = [
    {'title': 'Attendance', 'icon': 'assets/images/bc 3.svg', 'route': null},
    {'title': 'Remuneration', 'icon': 'assets/images/remuneration.svg', 'route': null},
    {'title': 'Assets', 'icon': 'assets/images/assets.svg', 'route': () => Assetspage(title: 'Assets')},
    {'title': 'Holidays', 'icon': 'assets/images/holidays.svg', 'route': () => holidaypage(title: 'Holidays')},
    {'title': 'Leave', 'icon': 'assets/images/leave.svg', 'route': () => leavepage(title: 'Leave')},
    {'title': 'Tasks', 'icon': 'assets/images/tasks.svg', 'route': null},
    {'title': 'Documents', 'icon': 'assets/images/tasks.svg', 'route': ()=>documentpage(title: 'document',)},
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
              padding: EdgeInsets.all(AppConfig.padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

          // Bottom Navigation Bar

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: navItems.map((item) {
                return TextButton(
                  onPressed: item.onTap,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        item.iconPath,
                        width: 24,
                        height: screenHeight * 0.025,
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(), // 🔹 Convert List<NavItem> → List<Widget>
            ),
          ),
        ],
      ),

    );
  }
}

// Container Card Widget


