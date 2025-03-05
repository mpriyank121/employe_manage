import 'package:employe_manage/Screens/Categories.dart';
import 'package:employe_manage/Screens/welcom_page.dart';
import 'package:employe_manage/Screens/documents.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Screens/settings.dart';



//Custom anime
class customanime extends StatefulWidget {
  final String initialtext;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;

  const customanime({
    Key? key,
    required this.initialtext,
    this.widthFactor = 0.25,
    this.heightFactor = 0.05,
    this.padding = const EdgeInsets.symmetric(),
    this.margin = const EdgeInsets.symmetric(),
    this.borderColor = const Color(0xFFE6E6E6),
    this.borderRadius = 15.0,
  }) : super(key: key);

  @override
  _customanime createState() => _customanime();
}

class _customanime extends State<customanime> {
  bool isClicked = false; // Track state

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(

      child: InkWell(
        onTap: toggleColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: Colors.blue,
        child: Padding(
          padding: widget.padding,
          child:  AnimatedContainer(
            duration: Duration(milliseconds: 300), // Smooth transition
            width: screenWidth*0.3,
            height: screenHeight*0.03,
            alignment: Alignment.center,
            decoration: ShapeDecoration( color: isClicked ? Color(0xFFF25922): Colors.white, // Toggle colors
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              ),
            child: Text(
              isClicked ? widget.initialtext : widget.initialtext,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

//MainButton
class MainButton extends StatefulWidget {
  final String initialtext;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;
  final VoidCallback? onPressed; // Add callback function


  const MainButton({
    Key? key,
    required this.initialtext,
    this.widthFactor = 0.9,
    this.heightFactor = 0.07,
    this.padding = const EdgeInsets.symmetric(),
    this.margin = const EdgeInsets.symmetric(),
    this.borderColor = const Color(0xFFE6E6E6),
    this.borderRadius = 15.0,
    this.onPressed,
  }) : super(key: key);

  @override
  _MainButton createState() => _MainButton();
}

class _MainButton extends State<MainButton> {
  bool isClicked = false; // Track state

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
    });
    if (widget.onPressed != null) {
      widget.onPressed!(); // Call the callback function
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(

      child: InkWell(
        onTap: toggleColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: Colors.blue,
        child: Padding(
          padding: widget.padding,
          child:  AnimatedContainer(
            duration: Duration(milliseconds: 300), // Smooth transition
            width: screenWidth*widget.widthFactor,
            height: screenHeight*widget.heightFactor,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.deepOrange, // Background color
              borderRadius: BorderRadius.circular(10),
              // Rounded corners

            ),
            child: Text(
              isClicked ? widget.initialtext : widget.initialtext,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

//AppBarConfig
class AppBarConfig {
  static Widget getIconImage({required String imagePath}) {
    return SizedBox(

      child:IconButton(onPressed: (){
        Get.to(() => welcomepage(title: 'welcome'));

      }, icon:  SvgPicture.asset("assets/images/bc 3.svg")),
    );
  }
  static const BoxDecoration bottomBorderDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Color(0xFFE6E6E6), // Border color
        width: 1.0, // Border thickness
      ),
    ),
  );
}
class OtpTextFieldConfig {
  final Color backgroundColor;
  final double width;
  final double height;
  final double fontSize;
  final Color textColor;
  final Color borderColor;

  const OtpTextFieldConfig({
    this.backgroundColor = Colors.grey,
    this.width = 40.0,
    this.height = 50.0,
    this.fontSize = 18.0,
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
  });
}

class AppColors {
  static const primaryColor = Color(0xFF3CAB88);
  static const secondaryColor = Color(0xFFF25922);
  static const borderColor = Color(0xFFE6E6E6);
}

class AppPadding {
  static double horizontal(BuildContext context) => MediaQuery.of(context).size.width * 0.05;
  static double vertical(BuildContext context) => MediaQuery.of(context).size.height * 0.02;
}

class AppSpacing {
  static const small = SizedBox(height: 10);
  static const medium = SizedBox(height: 20);
}
class NavItem {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  NavItem({required this.label, required this.iconPath, required this.onTap});
}

// List of Navigation Items
List<NavItem> navItems = [
  NavItem(
    label: 'Home',
    iconPath: 'assets/images/solar_home-2-linear.svg',
    onTap: () {
      Get.to(() => welcomepage(title: 'Welcome'));
    },
  ),
  NavItem(
    label: 'Categories',
    iconPath: 'assets/images/category-1-svgrepo-com 1.svg',
    onTap: () {
      Get.to(() => CategoryPage(title: 'category'));
    },
  ),
  NavItem(
    label: 'Settings',
    iconPath: 'assets/images/settings-02.svg',
    onTap: () {
      Get.to(() => settingpage(title: 'settings'));
    },
  ),
];
class AppConfig {
  static const double padding = 16.0;
  static const double iconSize = 24.0;
  static const double spacing = 10.0;
}

class TileConfig {
  // Document List Data
  static final List<Map<String, dynamic>> documentItems = [
    {
      "title": "Offer Letter.docx",
      "subtitle": "250 KB - Last update Dec 10, 2023",
      "icon": "assets/images/ion_document-text-outline.svg",
    },
    {
      "title": "Text.docs",
      "subtitle": "250 KB - Last update Dec 10, 2023",
      "icon": "assets/images/ion_document-text-outline.svg",
    },
    {
      "title": "Documents.docs",
      "subtitle": "250 KB - Last update Dec 10, 2023",
      "icon": "assets/images/ion_document-text-outline.svg",
    }
  ];

  static const TextStyle headingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const EdgeInsets padding = EdgeInsets.all(10);
}


class HolidayListTile {
  // Sample List Data
  static final List<Map<String, dynamic>> items = [
    {
      "title": "New Year",
      "subtitle": "1 Jan",
      "icon": "assets/images/Frame 427319800.svg",
    },
    {
      "title": "Diwali",
      "subtitle": "20 Nov",
      "icon": "assets/images/Frame 427319800.svg",
    },
    {
      "title": "Holi",
      "subtitle": "5 Mar",
      "icon": "assets/images/Frame 427319800.svg",
    },
  ];
}
class LeaveListTile{
  final List<Map<String, dynamic>> items = [
    {
      "title": "Sick Leave ",
      "subtitle": "8 Jan 2024",

    },
    {
      "title" : "Casual Leave",
      "subtitle": "10 Jan 2024",

    }
  ];
}



