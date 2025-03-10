import 'package:employe_manage/Screens/Categories.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:employe_manage/Screens/welcom_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final double iconSize;
  final double screenHeight;
  final int currentIndex;
  final Function(int) onItemTapped; // Callback for changing index

  const BottomNavBar({
    required this.iconSize,
    required this.screenHeight,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> navItems = [
      {"label": "Home", "iconPath": "assets/images/solar_home-2-linear.svg",
        "route": const welcomepage(title: "Home"),
      },
      {"label": "Categories", "iconPath": "assets/images/category-1-svgrepo-com 1.svg",
        "route": const CategoryPage(title: "Categories"),

      },
      {"label": "Settings", "iconPath": "assets/images/settings-02.svg",
        "route": const settingpage(title: "Settings"),
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(navItems.length, (index) {
          return TextButton(
            onPressed: () {
              if (index != currentIndex) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => navItems[index]["route"]),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  navItems[index]["iconPath"],
                  width: iconSize,
                  height: screenHeight * 0.025,
                  color: currentIndex == index ? Colors.orangeAccent : Colors.grey, // Highlight active item
                ),
                Text(
                  navItems[index]["label"],
                  style: TextStyle(
                    fontSize: 12,
                    color: currentIndex == index ? Colors.orangeAccent : Colors.grey, // Change color for selected tab
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
