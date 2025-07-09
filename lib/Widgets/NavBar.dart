import 'package:coreHrx_employeeapp/Employee/Categories/Categories.dart';
import 'package:coreHrx_employeeapp/Employee/Attendance/attendence.dart';
import 'package:coreHrx_employeeapp/Employee/Settings/team/team_page.dart';
import 'package:coreHrx_employeeapp/Widgets/nav_bar_controller/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coreHrx_employeeapp/Employee/Settings/settings.dart';
import 'package:coreHrx_employeeapp/Employee/Home/welcome_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Employee/Configuration/app_colors.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final MainScreenController controller = Get.put(MainScreenController());

  final List<Widget> _screens = [
    WelcomePage(title: "Home"),
    CategoryPage(title: "Categories"),
    TeamPage(),
    AttendancePage(title: "Attendance"),
    settingpage(title: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.changeTab(0);
          return false;
        }
        return true;
      },
      child: Obx(() => Scaffold(
            body: IndexedStack(
              index: controller.selectedIndex.value,
              children: _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTab,
              selectedItemColor: AppColors.secondary,
              unselectedItemColor: Colors.grey,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 24,
              items: [
                _buildNavItem(
                    "Home", "assets/images/solar_home-2-linear.svg", 0),
                _buildNavItem("Categories",
                    "assets/images/category-1-svgrepo-com 1.svg", 1),
                _buildNavItem("Team", "assets/images/team_icn.svg", 2),
                _buildNavItem("Attendance", "assets/images/task-square.svg", 3),
                _buildNavItem("Settings", "assets/images/settings-02.svg", 4),
              ],
            ),
          )),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String label, String assetPath, int index) {
    return BottomNavigationBarItem(
      icon: Obx(() => AnimatedScale(
            scale: controller.selectedIndex.value == index ? 1.2 : 1.0,
            duration: Duration(milliseconds: 200),
            child: SvgPicture.asset(
              assetPath,
              color: controller.selectedIndex.value == index
                  ? AppColors.secondary
                  : Colors.grey,
            ),
          )),
      label: label,
    );
  }
}
