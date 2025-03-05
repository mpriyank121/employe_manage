import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/holiday_list_tile.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'otp_page.dart';



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

        home:  leavepage(title: '',
        )
    );
  }
}
class leavepage extends StatefulWidget {
  const leavepage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widgets subclass are
  // always marked "final".

  final String title;


  @override
  State<leavepage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<leavepage> {

  final List<Map<String, dynamic>> items1 = [
    {"title": "Sick Leave", "subtitle": "8 Jan 2024"},
    {"title": "Casual Leave", "subtitle": "10 Jan 2024"},
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
    bool isExpanded = false;
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
        appBar: CustomAppBar(title: 'Leave Details',),
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

              (child:Column(

              children: [
                CustomRow(
                  items: [LeaveCard(child: Text('Total Casual leave')),
                    LeaveCard(

                        child: Text('Sick leve'))],),
              SizedBox(height: screenHeight*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distributes columns

                children: [
                customanime(initialtext: 'Approved',),
                  customanime(initialtext: 'Pending',),
                  customanime(initialtext: 'Declined',)

                ],),
                SizedBox(height: 10,),
                Expanded(child:Container

                  (
                  width: screenWidth * 0.9,

                  child:ListView.builder(
                    shrinkWrap: true,
                    itemCount: items1.length,
                    itemBuilder: (context, index) {
                      final item = items1[index];
                      return ListTile(
                        title: Text(item["title"], style: fontStyles.headingStyle),
                        subtitle: Text(item["subtitle"], style: fontStyles.subTextStyle),
                        trailing: const CustomButton(),
                      );
                    },
                  ),
                ))
              ],),
            )

            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Container(
                decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
                width: screenWidth*0.9,
                child:customanime(initialtext: 'Holiday This Month',) ,
              )]
              ,),

            Expanded(
              child: Container(
                width: screenWidth * 0.9,
                child: ListView.builder(
                  itemCount: HolidayListTile.items.length,
                  itemBuilder: (context, index) {
                    return CustomListTile(item: HolidayListTile.items[index]);
                  },
                ),
              ),
            ),
            Positioned(
                child: Container(
                  margin: EdgeInsets.only(bottom:screenHeight*0.01),
                  width: screenWidth*0.9,
                  height: screenHeight*0.05,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange, // Background color
                    borderRadius: BorderRadius.circular(10),
                    // Rounded corners

                  ),
                  child: TextButton(onPressed: (){
                    Get.to(() => OtpPage());
                  },
                      child:
                          Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),

                          child:Icon(Icons.add,color: Colors.white,) ,),
                          Text(
                            "Request Leave",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),


                           // Space between image and text

                        ],
                      )
                  ),

                )

            )
          ],
        ),
        )

    );
  }
}