import 'package:employe_manage/assets_cat.dart';
import 'package:employe_manage/otp_page.dart';
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

    return GetMaterialApp(


        title: 'Flutter Demo',

        home:  holidaypage(title: '',
        )
    );
  }
}
class holidaypage extends StatefulWidget {
  const holidaypage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  State<holidaypage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<holidaypage> {
  final List<Map<String, dynamic>> items = [
    {
      "title": "New Year",
      "subtitle": "Monday",
      "icon": "assets/images/ion_document-text-outline.svg",
      // Custom icon for Word files
    },
    {
      "title": "Makar Sakranti",
      "subtitle": "14 Jan",
      "icon": "assets/images/ion_document-text-outline.svg",
      // Custom icon for PDF files
    },
    {
      "title": "Diwali",
      "subtitle": "10 November",
      "icon": "assets/images/ion_document-text-outline.svg",
      // Custom icon for Excel files
    }

  ];
  int selectedYear = DateTime
      .now()
      .year; // Get current year

  void changeYear(int step) {
    setState(() {
      selectedYear += step; // Increase or decrease year
    });
  }
@override
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
        appBar: AppBar(
          centerTitle: true,
          title: Text('Holidays', style: fontStyles.headingStyle,
          ),
          leading: Padding(padding: EdgeInsets.only(top: screenHeight * 0.01),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {


                },)
          ),

        ),
        body:
        Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Container(

            width: screenWidth * 0.85,
            height: screenWidth * 0.15,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () => changeYear(-1), icon:SvgPicture.asset('assets/images/chevron-u.svg')),
                Text("$selectedYear",style: TextStyle(
                  color: Color(0xFFF25922),
                  fontSize: 22,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                  letterSpacing: 0.22,
                ),),

    IconButton(onPressed: () => changeYear(1), icon:SvgPicture.asset('assets/images/chevron-up.svg'),)

              ],
            ),
          ),
            Expanded(child:Container

              (
              width: screenWidth * 0.9,

              child:ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return
                      Container(
                        margin: EdgeInsets.all(10),

                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:ListTile(


                            leading: SvgPicture.asset("assets/images/Frame 427319800.svg"),
                            title: Text(item['title'], style: fontStyles.headingStyle,),
                            subtitle: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['subtitle'], style: fontStyles.subTextStyle,),
                                ],),
                            )
                        )
                        ,);

                  }

              ),) )],



        ),
          )

      );
    }
  }
