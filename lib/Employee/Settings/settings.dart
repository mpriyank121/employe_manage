import 'package:coreHrx_employeeapp/Employee/Settings/edit_profile/edit_profile_page.dart';
import 'package:coreHrx_employeeapp/Employee/Settings/team/team_page.dart';
import 'package:coreHrx_employeeapp/report_attendance/report_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';

import '../Configuration/style.dart';

class settingpage extends StatelessWidget {
  const settingpage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Settings',
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/green_logo.svg'),
            onPressed: () {},
          ),
          actions: [],
        ),
        body: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                backgroundImage: null,
                child: ClipOval(
                    child: Image.asset('assets/images/male_icon.png',
                        fit: BoxFit.cover)),
              ),
              title: Row(
                children: [
                  Text(
                    'User Name',
                    style: fontStyles.headingStyle,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Employee Type',
                    style: TextStyle(
                      color: const Color(0xFFF25922),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 1.60,
                      letterSpacing: 0.20,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Job Role',
                style: fontStyles.subTextStyle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline, size: 28),
              title: Text(
                'Edit Profile',
                style: fontStyles.headingStyle,
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
               Get.to(() => EditProfilePage());
              
              },
            ),
            PrimaryButton(
              textColor: const Color(0xFFCD0909),
              text: 'Log Out',
              widthFactor: 0.9,
              heightFactor: 0.05,
              buttonColor: const Color(0x19CD0909),
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/images/ant-design_logout-outlined.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
