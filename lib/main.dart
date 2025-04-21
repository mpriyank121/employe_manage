import 'package:employe_manage/Screens/otp_page.dart';
import 'package:employe_manage/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API/Controllers/checkIn_Controller.dart';
import 'API/Controllers/employee_attendence_controller.dart';
import 'API/Controllers/leave_controller.dart';
import 'API/Controllers/task_controller.dart';
import 'API/Controllers/update_controller.dart';
import 'API/Controllers/user_data_controller.dart';
import 'API/Services/version_service.dart';
import 'Screens/LoginPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'Widgets/Custom_Splash_Screen.dart';
import 'Widgets/manadatory_update_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(UpdateController()); // 🔑 Register before version check

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Get.put(AttendanceController());
  Get.put(UserController());
  Get.put(TaskController());
  Get.put(CheckInController());
  Get.put(LeaveController()); // <--- Add this
// Register the controller globally


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFF25922),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // 🔁 Start from SplashScreen always
      routes: {
        '/': (context) =>  CustomSplashScreen(), // ✅ Now runs first
        '/login': (context) => LoginScreen(),
        '/otp': (context) =>  OtpPage(phone: 'phone'),
        '/home': (context) => MainScreen(),
      },
    );
  }
}
