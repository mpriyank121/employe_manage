import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../Widgets/primary_button.dart';
import '/Configuration/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const settingpage(title: ''),
    );
  }
}

class settingpage extends StatefulWidget {
  const settingpage({super.key, required this.title});
  final String title;

  @override
  State<settingpage> createState() => _settingpageState();
}

class _settingpageState extends State<settingpage> {
  String userName = "Loading...";
  String jobRole = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    print('✅ initState: Fetching user data...');  // ✅ Ensuring function call
  }

  /// ✅ Fetch Employee Data from SharedPreferences
  Future<void> _fetchUserData() async {
    print('🔍 Checking SharedPreferences for user data...'); // ✅ Debugging

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name'); // Stored user name
    String? role = prefs.getString('designation'); // Stored job role

    print('📌 Fetched from SharedPreferences → Name: $name, Role: $role'); // ✅ Debugging

    if (name != null && role != null) {
      setState(() {
        userName = userName;
        jobRole = jobRole;
      });
      print('✅ UI Updated → userName: $userName, jobRole: $jobRole');
    } else {
      print('⚠️ No user data found in SharedPreferences!');
    }
  }

  /// ✅ Logout Function
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🚪 User Logged Out: SharedPreferences cleared.');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),        actions: [],
      ),
      body: Column(
        children: [
          // ✅ User Profile Info
          ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/Ellipse.jpg'),
              backgroundColor: Colors.transparent,
            ),
            title: Row(
              children: [
                Text(userName, style: fontStyles.headingStyle), // ✅ Dynamic Username
                SizedBox(width: 10),
                Text(
                  'See All',
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
            subtitle: Text(jobRole, style: fontStyles.subTextStyle), // ✅ Dynamic Job Role
          ),

          // ✅ Menu Options
          Column(
            children: [
              _buildListTile(
                icon: 'assets/images/iconoir_profile-circle.svg',
                title: 'Edit Profile',
              ),
              _buildListTile(
                icon: 'assets/images/fluent_people-48-regular.svg',
                title: 'Tasks',
              ),

              // ✅ Logout Button
              PrimaryButton(
                textColor: Color(0xFFCD0909), // ✅ Custom text color

                text: 'Log Out',
                widthFactor: 0.7,
                heightFactor: 0.07,
                buttonColor: Color(0x19CD0909),
                onPressed: _logout,
                icon: SvgPicture.asset('assets/images/ant-design_logout-outlined.svg'),

              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Reusable ListTile Widget
  Widget _buildListTile({required String icon, required String title}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: SvgPicture.asset(icon),
      title: Text(title),
      trailing: SvgPicture.asset('assets/images/chevron-ups.svg'),
    );
  }
}
