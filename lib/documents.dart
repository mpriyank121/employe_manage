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

        home:  documentpage(title: '',
        )
    );
  }
}
class documentpage extends StatefulWidget {
  const documentpage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<documentpage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<documentpage> {

  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "title": "Offer Letter.docx",
        "subtitle" : "250 KB - Last update Dec 10, 2023",
        "icon": "assets/images/ion_document-text-outline.svg", // Custom icon for Word files
      },
      {
        "title": "Text.docs",
        "subtitle" : "250 KB - Last update Dec 10, 2023",
        "icon": "assets/images/ion_document-text-outline.svg", // Custom icon for PDF files
      },
      {
        "title": "Documents.docs",
        "subtitle" : "250 KB - Last update Dec 10, 2023",
        "icon": "assets/images/ion_document-text-outline.svg", // Custom icon for Excel files
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
        title: Text('Documents', style: fontStyles.headingStyle,
        ),
        leading: Padding(padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed : (){
                Get.back();
              },)
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
                  trailing:IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/solar_download-linear.svg", // Your SVG icon
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      print("SVG Icon pressed");
                    },
                  ),
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
                        Text(item['subtitle'],style: fontStyles.subTextStyle,),
                      ],),
                  )
              );
            }

        ),
      ),
    );
  }
}