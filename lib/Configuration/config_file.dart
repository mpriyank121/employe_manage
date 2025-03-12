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

//PrimaryButton


class PrimaryButtonConfig {
  // Button Colors
  static const Color primaryButtonColor = Colors.deepOrange;
  static const Color borderColor = Color(0xFFE6E6E6);
  static const Color textColor = Colors.white;
  static const Color splashColor = Colors.blue;

  // Button Sizing Factors (relative to screen size)
  static const double buttonWidthFactor = 0.9;
  static const double buttonHeightFactor = 0.07;

  // Border Styling
  static const double borderRadius = 15.0;

  // Default Padding & Margin
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric();
  static const EdgeInsets defaultMargin = EdgeInsets.symmetric();

  // Animation Settings
  static const Duration animationDuration = Duration(milliseconds: 300);
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
  final double widthFactor;
  final double heightFactor;
  final double fontSizeFactor;
  final Color textColor;
  final Color borderColor;

  const OtpTextFieldConfig({
    this.backgroundColor = Colors.grey,
    this.widthFactor = 0.1, // 10% of screen width
    this.heightFactor = 0.06, // 6% of screen height
    this.fontSizeFactor = 0.022,
    this.textColor = Colors.white,
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
  static SizedBox small(BuildContext context) => SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  static SizedBox medium(BuildContext context) => SizedBox(height: MediaQuery.of(context).size.height * 0.02);
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
  static double padding(BuildContext context) => MediaQuery.of(context).size.width * 0.04;
  static double iconSize(BuildContext context) => MediaQuery.of(context).size.width * 0.06;
  static double spacing(BuildContext context) => MediaQuery.of(context).size.width * 0.025;
}
class TileConfig {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const Color tileBackgroundColor =
    Color(0x193CAB88);

  static const Color tileBorderColor = Color(0xFF3CAB88);

  static const TextStyle subTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const EdgeInsets padding = EdgeInsets.all(10);
}

class WelcomeCardConfig {
  static const Color backgroundColor = Color(0xFF3CAB88);
  static const Color borderColor = Color(0xFFE6E6E6);
  static const double borderRadius = 8.0;
  static const double borderWidth = 1.0;
  static const TextStyle welcomeTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const TextStyle nameTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
  );
  static const TextStyle roleTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
  );
}

class BottomCardConfig {
  static const Color backgroundColor = Colors.white;
  static const double borderRadius = 8.0;
  static const Color separatorColor = Colors.grey;
  static const double separatorWidthFactor = 0.003;
  static const double separatorHeightFactor = 0.08;

  static const TextStyle commonTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
  );
}
class LeaveCardConfig {

  static EdgeInsets globalPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.02, // 2% of screen width
    vertical: MediaQuery.of(context).size.height * 0.01, // 1% of screen height
  );

  static EdgeInsets globalMargin(BuildContext context) => EdgeInsets.all(
    MediaQuery.of(context).size.width * 0.01, // 1% of screen width
  );

  static const Color defaultBorderColor = Color(0xFF62A898);

  static double defaultBorderRadius(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.025; // 2.5% of screen width

  static const Color defaultBackgroundColor = Color(0xFFE9F7F5);

  static TextStyle titleStyle(BuildContext context) => TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.035, // 3.5% of screen width
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  static TextStyle countStyle(BuildContext context) => TextStyle(
    fontSize: MediaQuery.of(context).size.width * 0.04, // 4% of screen width
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}