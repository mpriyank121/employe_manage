import 'package:employe_manage/Screens/otp_page.dart';
import 'package:employe_manage/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API/Controllers/employee_attendence_controller.dart';
import 'Screens/LoginPage.dart';


void main() async {
  Get.put(AttendanceController()); // ✅ Register Controller Before Running the App

  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/otp': (context) => OtpPage(phone: 'phone',),
        '/home': (context) => MainScreen(),
      },
    );
  }
}
