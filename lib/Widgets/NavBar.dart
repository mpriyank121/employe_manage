import 'package:employe_manage/API/Controllers/task_controller.dart';
import 'package:employe_manage/Screens/Task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:employe_manage/Screens/Categories.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:employe_manage/Screens/welcome_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../API/Controllers/user_data_controller.dart';
import '../API/Controllers/welcome_page_controller.dart';
import '../Configuration/app_colors.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track current tab index

  // Define screens corresponding to each tab
  final List<Widget> _screens = [
    WelcomePage(title: "Home"),
    CategoryPage(title: "Categories"),
    TaskScreen(),
    settingpage(title: "Settings"),

  ];

  // Function to handle tab switching
  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.find<WelcomeController>().reloadWelcomeData();
    } else if (index == 2) {
      Get.find<TaskController>().refreshTaskData();
    } else if (index == 3) {
      Get.find<UserController>().loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens, // Show selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/solar_home-2-linear.svg",
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 0 ? AppColors.secondary : Colors.grey,
                ),
                Text(
                  "Home",
                  style: TextStyle(
                    color: _selectedIndex == 0 ? AppColors.secondary : Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/category-1-svgrepo-com 1.svg",
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 1 ? AppColors.secondary : Colors.grey,
                ),
                Text(
                  "Categories",
                  style: TextStyle(
                    color: _selectedIndex == 1 ? AppColors.secondary : Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/task-square.svg",
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 2 ? AppColors.secondary : Colors.grey,
                ),
                Text(
                  "Tasks",
                  style: TextStyle(
                    color: _selectedIndex == 2 ? AppColors.secondary : Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/images/settings-02.svg",
                  width: 24,
                  height: 24,
                  color: _selectedIndex == 3 ? AppColors.secondary : Colors.grey,
                ),
                Text(
                  "Settings",
                  style: TextStyle(
                    color: _selectedIndex == 3 ? AppColors.secondary : Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            label: '',
          ),


        ],
      ),
    );
  }
}
