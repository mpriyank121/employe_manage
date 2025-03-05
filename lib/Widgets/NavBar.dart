import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../screens/categories.dart';
import '../screens/settings.dart';

class NavItem {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  NavItem({required this.label, required this.iconPath, required this.onTap});
}

// Navigation Items
List<NavItem> navItems = [
  NavItem(
    label: 'Home',
    iconPath: 'assets/images/home.svg',
    onTap: () {},
  ),
  NavItem(
    label: 'Categories',
    iconPath: 'assets/images/category.svg',
    onTap: () {
      Get.to(() => CategoryPage(title: 'Categories'));
    },
  ),
  NavItem(
    label: 'Settings',
    iconPath: 'assets/images/settings.svg',
    onTap: () {
      Get.to(() => settingpage(title: 'Settings'));
    },
  ),
];

// Navigation Bar Widget
class BottomNavBar extends StatelessWidget {
  final double iconSize;
  final double screenHeight;

  const BottomNavBar({required this.iconSize, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  width: iconSize,
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
        }).toList(),
      ),
    );
  }
}
