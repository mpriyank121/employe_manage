import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../API/Controllers/user_data_controller.dart';
import '/Configuration/style.dart';

class settingpage extends StatelessWidget {
  const settingpage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Obx(() => ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/Ellipse.jpg'),
              backgroundColor: Colors.transparent,
            ),
            title: Row(
              children: [
                Text(userController.userName.value, style: fontStyles.headingStyle),
                SizedBox(width: 10),
                Text(
                  userController.employeeType.value,
                  style: TextStyle(
                    color: Color(0xFFF25922),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.60,
                    letterSpacing: 0.20,
                  ),
                ),
              ],
            ),
            subtitle: Text(userController.jobRole.value, style: fontStyles.subTextStyle),
          )),
          PrimaryButton(
            textColor: Color(0xFFCD0909),
            text: 'Log Out',
            widthFactor: 0.9,
            heightFactor: 0.05,
            buttonColor: Color(0x19CD0909),
            onPressed: userController.logout,
            icon: SvgPicture.asset('assets/images/ant-design_logout-outlined.svg'),
          ),
        ],
      ),
    );
  }
}
