import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'style.dart';
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

        home:  assetspage(title: '',
        )
    );
  }
}
class assetspage extends StatefulWidget {
  const assetspage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<assetspage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<assetspage> {

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
      appBar: AppBar(
        centerTitle: true,
        title: Text('Assets', style: fontStyles.headingStyle,
        ),
        leading: Padding(padding: EdgeInsets.only(top: screenHeight * 0.01),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed : (){},)
        ),

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
                width: 30,
                height: 30,
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