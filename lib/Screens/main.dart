import 'package:employe_manage/Modules/App_bar.dart';
import 'package:flutter/material.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'otp_page.dart';
void main() {
  runApp(const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

debugShowCheckedModeBanner: false,
home: MyHomePage(title: 'home',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

@override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: CustomAppBar(title: 'Bookchor',
        leading: AppBarConfig.getIconImage(imagePath: 'assets/images/bc 3.svg'),
        actions: [],

),
      
      body:
  Padding(
  padding: EdgeInsets.all(screenWidth * 0.05), // 5% of screen width as padding
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text('HR Management App', style: fontStyles.commonTextStyle),
  SizedBox(height: screenHeight * 0.02),

  Text('Enter Your Mobile number', style: fontStyles.headingStyle),
  SizedBox(height: screenHeight * 0.01),

  Text(
  'Enter your mobile number to get started',
  style: fontStyles.commonTextStyle,
  ),
  SizedBox(height: screenHeight * 0.02),

  TextField(
  decoration: InputDecoration(
  labelText: 'Mobile Number',
  hintText: 'Enter your mobile number',
  prefixIcon: SizedBox(
  width: 40,
  child: Center(
  child: Text('+91', style: fontStyles.headingStyle),
  ),
  ),

  border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(color: Colors.blue, width: 2),
  ),
  ),
  ),
    Spacer(),
    MainButton(
      initialtext: 'Continue',
      onPressed: () {
        Get.to(() => OtpPage());
      },
    ),
    ])));

  }
}


