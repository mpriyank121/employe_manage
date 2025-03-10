import 'package:employe_manage/Widgets/Welcome_card.dart';
import 'package:employe_manage/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widgets/Bottom_card.dart';
import '../Widgets/NavBar.dart';
import '../Widgets/category_icon.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/slide_checkin.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';

class welcomepage extends StatefulWidget {
  const welcomepage({super.key, required this.title});
  final String title;

  @override
  State<welcomepage> createState() => _welcomepageState();
}

class _welcomepageState extends State<welcomepage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final List<Map<String, dynamic>> items1 = [
      {"title": "Sick Leave", "subtitle": "8 Jan 2024"},
      {"title": "Casual Leave", "subtitle": "10 Jan 2024"},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Welcome',
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% of screen width for padding
            vertical: screenHeight * 0.03, // 3% of screen height for padding
          ),
          child: Column(
            children: [
              // ✅ Responsive Date Container
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06, // 6% of screen height
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(screenWidth * 0.1),
                  ),
                ),
                child: Center(
                  child: Text('10 - Jan - 2024', style: fontStyles.headingStyle),
                ),
              ),

              AppSpacing.medium(context),

              // ✅ Responsive Welcome Card & Bottom Card
              WelcomeCard(
                userName: 'Priyank Mangal',
                jobRole: 'Tech - UI/UX Designer',
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              BottomCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),

              // ✅ Categories Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories', style: fontStyles.normalText),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All', style: TextStyle(color: AppColors.secondaryColor)),
                    ),
                  ],
                ),
              ),

              // ✅ Responsive Category Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryIcon(
                    initialText: "Attendence",
                    assetPath: "assets/images/bc 3.svg",
                    bgColor: Color(0xFFF9B79F),
                    screenHeight: screenHeight,
                  ),
                  CategoryIcon(
                    initialText: "Leave",
                    assetPath: "assets/images/bc 3.svg",
                    bgColor: Color(0xFFFFEFBF),
                    screenHeight: screenHeight,
                  ),
                  CategoryIcon(
                    initialText: "Remuneration",
                    assetPath: "assets/images/bc 3.svg",
                    bgColor: Color(0xFFFCCFCF),
                    screenHeight: screenHeight,
                  ),
                  CategoryIcon(
                    initialText: "Document",
                    assetPath: "assets/images/bc 3.svg",
                    bgColor: Color(0xFF90D9F8),
                    screenHeight: screenHeight,
                  ),
                ],
              ),

              AppSpacing.medium(context),

              // ✅ Leave Applications Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Leave Application', style: fontStyles.normalText),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All', style: TextStyle(color: AppColors.secondaryColor)),
                    ),
                  ],
                ),
              ),

              // ✅ Responsive Leave Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customanime(initialtext: 'Approved'),
                  customanime(initialtext: "Pending"),
                  customanime(initialtext: 'Declined'),
                ],
              ),

              SizedBox(height: screenHeight * 0.02), // Responsive spacing

              // ✅ Leave Application List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items1.length,
                itemBuilder: (context, index) {
                  final item = items1[index];
                  return ListTile(
                    title: Text(item["title"], style: fontStyles.headingStyle),
                    subtitle: Text(item["subtitle"], style: fontStyles.subTextStyle),
                    trailing: const CustomButton(),
                  );
                },
              ),


              // ✅ Responsive SlideCheckIn Button
              SlideCheckIn(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),

              SizedBox(height: screenHeight * 0.02), // Responsive spacing

              // ✅ Bottom Navigation Bar

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        iconSize: 24,
        screenHeight: screenHeight,
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
