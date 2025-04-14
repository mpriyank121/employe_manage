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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // prevent closing the app
        }
        return true; // allow closing if already on Home tab
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          items: [
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 0 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  "assets/images/solar_home-2-linear.svg",
                  color: _selectedIndex == 0 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 1 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  "assets/images/category-1-svgrepo-com 1.svg",
                  color: _selectedIndex == 1 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 2 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  "assets/images/task-square.svg",
                  color: _selectedIndex == 2 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: AnimatedScale(
                scale: _selectedIndex == 3 ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  "assets/images/settings-02.svg",
                  color: _selectedIndex == 3 ? AppColors.secondary : Colors.grey,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

}
