import 'package:employe_manage/Screens/otp_page.dart';
import 'package:employe_manage/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart%20';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'API/Controllers/employee_attendence_controller.dart';
import 'API/Controllers/task_controller.dart';
import 'API/Controllers/user_data_controller.dart';
import 'Screens/LoginPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock to portrait
  ]);
  Get.put(AttendanceController());
  Get.put(UserController());
  Get.put(TaskController());
// Register GetX controller
// ✅ Register Controller Before Running the App


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
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFFF25922), // 👈 Your desired global color
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
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
