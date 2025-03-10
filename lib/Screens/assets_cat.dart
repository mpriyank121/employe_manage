import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:employe_manage/Configuration/style.dart';
import 'package:get/get.dart';
import '/Widgets/App_bar.dart';


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

        home:  Assetspage(title: '',
        )
    );
  }
}
class Assetspage extends StatefulWidget {
  const Assetspage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widgets subclass are
  // always marked "final".

  final String title;


  @override
  State<Assetspage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<Assetspage> {

  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
    {
    "title": "Lenovo Flex 5",
     "subtitle" : "Specification Details",
      "sub2" : "i7, 500 GB SSD Drive, 16 GB RAM & Window Pro",
    "size": "Serial No : 254465256595466",
    "icon": "assets/images/laptop-3-svgrepo-com 1.svg", // Custom icon for Word files
    },
    {
    "title": "Lenovo Mouse",
      "subtitle" : "Specification Details",
      "sub2" : "i7, 500 GB SSD Drive, 16 GB RAM & Window Pro",
    "size": "Serial No : 254465256595466",
    "icon": "assets/images/mouse-minimalistic-svgrepo-com 1.svg", // Custom icon for PDF files
    },
    {
    "title": "Lenovo Keyboard",
    "size": "Serial No : 254465256595466",
      "subtitle" : "Specification Details",
      "sub2" : "i7, 500 GB SSD Drive, 16 GB RAM & Window Pro",
    "icon": "assets/images/keyboard-svgrepo-com 1.svg", // Custom icon for Excel files
    }

    ];

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
      appBar: CustomAppBar(title: 'Assets',

      ),

      body: Container(

        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context,index){
    final item = items[index];

    return ListTile(
              leading: CircleAvatar(
                radius: 24, // Size of the CircleAvatar
                backgroundColor: Color(0x193CAB88),// Background color
                child:SvgPicture.asset(item['icon'],
                  width: screenWidth * (30 / 375), // Assuming 375 is the base width

                  height: screenHeight * (30 / 812), // Assuming 375 is the base width

                )
              ),
              title: Text(item['title'],style: fontStyles.headingStyle,),
              subtitle:Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        )
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(item['size'],style: fontStyles.subTextStyle,),
                  Text(item['subtitle'],style: fontStyles.subTextStyle,),
                  Text(item['sub2'],style: fontStyles.subTextStyle,)
                ],),
                )
              );
          }

        ),
      ),
    );
  }
}