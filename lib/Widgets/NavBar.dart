import 'package:employe_manage/Screens/Tasks_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:employe_manage/Screens/Categories.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:employe_manage/Screens/welcome_page.dart';

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
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/solar_home-2-linear.svg",
              width: 24,
              height: 24,
              color: _selectedIndex == 0 ? Colors.orangeAccent : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/category-1-svgrepo-com 1.svg",
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? Colors.orangeAccent : Colors.grey,
            ),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/task-square.svg",
              width: 24,
              height: 24,
              color: _selectedIndex == 2 ? Colors.orangeAccent : Colors.grey,
            ),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/settings-02.svg",
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? Colors.orangeAccent : Colors.grey,
            ),
            label: "Settings",
          ),

        ],
      ),
    );
  }
}
