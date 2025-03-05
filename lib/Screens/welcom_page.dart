import 'package:employe_manage/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        child: Column(children: [
          // Date Container
          Container(
            width: screenWidth * 0.9,
            height: screenWidth * 0.15,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(41),
              ),
            ),
            child: Center(child: Text('10 - Jan - 2024', style: fontStyles.headingStyle)),
          ),

          AppSpacing.medium,

          // Welcome Card
          Container(
            padding: EdgeInsets.only(top: screenWidth * 0.03),
            width: screenWidth * 0.9,
            height: screenHeight * 0.2,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Color(0xFF3CAB88),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Welcome Text
                Text(
                  'Let’s get to work!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),

                // User Name
                Text(
                  'Priyank Mangal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),

                // Job Role
                Text(
                  'Tech - UI/UX Designer',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * 0.022),

                // Bottom Card Section
                Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.07,
                  padding: EdgeInsets.only(top: screenHeight*0.02),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Worked Days',
                              textAlign: TextAlign.center,
                              style: fontStyles.commonTextStyle,
                            ),
                            Text(
                              '52 Days',
                              textAlign: TextAlign.center,
                              style: fontStyles.commonTextStyle,
                            ),
                          ],
                        ),
                      );
                    }).expand((widget) => [
                      widget,
                      if (widget != null)
                        Container(
                          width: screenWidth * 0.003,
                          height: screenHeight * 0.1,
                          color: Colors.grey,
                        ),
                    ]).toList()..removeLast(), // Remove last separator
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Categories', style: fontStyles.normalText),
              TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: AppColors.secondaryColor))),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryIcon(
                initialText: " Attendence",
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
                initialText: "Remuniration",
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


          AppSpacing.medium,


          // Leave Applications
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Leave Application', style: fontStyles.normalText),
              TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: AppColors.secondaryColor))),
            ]),
          ),
          Container(
            margin:  EdgeInsets.only(top:screenHeight*0.01 ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

              children: [
                Padding(padding: EdgeInsets.only(left: 10), // Adjust left padding
                    child: customanime(initialtext: 'Approved')
                ),
                Padding(padding: EdgeInsets.only(left: 10),
                    child: customanime(initialtext: "Pending")
                ),
                Padding(padding: EdgeInsets.only(right: 10),
                    child: customanime(initialtext: 'Declined')
                )

              ],
            ),

          ),

          ListView.builder(
            shrinkWrap: true,
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
          SlideCheckIn(screenWidth: screenWidth, screenHeight: screenHeight),


          // Bottom Navigation
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


        )
      ,

    );
  }
}
