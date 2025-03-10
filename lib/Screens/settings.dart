import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../Widgets/primary_button.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';


void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',

        home:  settingpage(title: '',
        )
    );
  }
}
class settingpage extends StatefulWidget {
  const settingpage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widgets subclass are
  // always marked "final".

  final String title;


  @override
  State<settingpage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<settingpage> {

  Widget build(BuildContext context) {
    double _value = 30;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width; // Get screen width
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height; // Get screen height

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: CustomAppBar(title: 'Settings',
        leading: AppBarConfig.getIconImage(imagePath: 'assets/images/bc 3.svg',),
        actions: [],

      ),
      body: Column(
        children: [ListTile(

          leading:CircleAvatar(
            radius: 24, // Adjust size as needed
            backgroundImage: AssetImage('assets/images/Ellipse.jpg'),
            backgroundColor: Colors.transparent,
          ),
          title:Column(children: [Row(children: [
            Text('Priyank Mangal',style: fontStyles.headingStyle,),
            SizedBox(width: 10,),
            Text('See All',style: TextStyle(
              color: Color(0xFFF25922),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.60,
              letterSpacing: 0.20,
            ),)
          ],)],) ,
          subtitle:Text('UI UX design',style: fontStyles.subTextStyle,),
        ),
        Column(

          children: [
            Container(


              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16), // Same padding as above

                leading: SvgPicture.asset('assets/images/iconoir_profile-circle.svg'),
                title: Text('Edit Profie'),
                trailing:SvgPicture.asset('assets/images/chevron-ups.svg') ,
              ),
            ),
            Container(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16), // Same padding as above

                leading: SvgPicture.asset('assets/images/fluent_people-48-regular.svg'),
                title: Text('Tasks'),
                trailing:SvgPicture.asset('assets/images/chevron-ups.svg'),
              ),
            ),
            PrimaryButton(
              initialtext: 'Log Out',
              widthFactor: 0.7,
              heightFactor: 0.07,
              buttonColor: Color(0x19CD0909),


              onPressed: () {
              },
            ),
          ],
        )
        ],


      ),
    );
  }
}