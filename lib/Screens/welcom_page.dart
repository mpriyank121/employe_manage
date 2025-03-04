import 'package:employe_manage/Modules/App_bar.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'Categories.dart';
import 'documents.dart';




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

        home:  welcomepage(title: '',
        )
    );
  }
}
class welcomepage extends StatefulWidget {
  const welcomepage({super.key, required this.title});


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<welcomepage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<welcomepage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = screenWidth * 0.05; // 5% of screen width
    double verticalPadding = screenHeight * 0.02;
    double horizontalMargin = screenWidth * 0.05; // 5% of screen width
    double verticalMargin = screenHeight * 0.02;// Get screen height
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final List<Map<String, dynamic>> items1 = [
      {
        "title": "Sick Leave ",
        "subtitle": "8 Jan 2024",

      },
      {
        "title" : "Casual Leave",
        "subtitle": "10 Jan 2024",

      }
    ];

    return Scaffold(

      appBar: CustomAppBar(title: 'Welcome',
      leading: AppBarConfig.getIconImage(imagePath: 'assets/images/bc 3.svg',),
      actions: [],
        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.notifications)),

    ),

      body:
      Column(children: [

      Container(
        width: screenWidth*0.9,
        height: screenWidth*0.15,

        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
              borderRadius: BorderRadius.circular(41),
            )
        ),
        child:
        Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center, // Align text to center
                    padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3 ),
                    height: screenHeight * 0.5,
                    child:
                    Center( child:Text('10 - Jan - 2024',
                      style: fontStyles.headingStyle,


                    ))
                ),

              ],
            ),



          ],

        ),

      ),

        SizedBox(height: screenHeight* 0.03,),
        Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03 ),

          width: screenWidth * 0.9,
          height: screenHeight * 0.25,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFF3CAB88),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          child:
          Column(

            children: [
            Container(
              child:Text(

              'Let’s get to work !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: screenHeight*0.001,
              ),
            ) ,)
            ,
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,),
                child: Text(

              'Priyank Mangal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: screenHeight*0.001,
              ),
            ))
            ,
            Container(

              child:Text(
              'Tech - UI/UX Designer',
              textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: screenHeight*0.001,
                ),


            ) ,),
            Column(

              children: [
                SizedBox(height: screenHeight*0.041,),
              Container(
                  width: screenWidth * 0.9,
                height: screenHeight * 0.1,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding*1,
                  vertical: verticalPadding*1.5,),

                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),

                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distributes columns


                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text('Worked Days',
                        textAlign: TextAlign.center,
                        style: fontStyles.commonTextStyle,
                      ),
                        Text('52 Days',
                            textAlign: TextAlign.center,

                            style: fontStyles.commonTextStyle),

                      ],
                    ),

                    ),
                    Container(
                      width: screenWidth*0.003, // Line width
                      height: screenHeight*0.1,// Line height
                      color: Colors.grey, // Line color
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text('Worked Days',
                        textAlign: TextAlign.center,
                        style: fontStyles.commonTextStyle,
                      ),
                        Text('52 Days',
                            textAlign: TextAlign.center,
                            style: fontStyles.commonTextStyle),
                      ],
                    ),
                    ),
                    Container(
                      width: screenWidth*0.003, // Line width
                      height: screenHeight*0.1, // Line height
                      color: Colors.grey, // Line color
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text('Worked Days',
                        textAlign: TextAlign.center,
                        style: fontStyles.commonTextStyle,
                      ),
                        Text('52 Days',
                            textAlign: TextAlign.center,

                            style: fontStyles.commonTextStyle),

                      ],
                    ),

                    )


                  ],
                ))],


  
),


          ],



        )

        ),
      Container(
margin: const EdgeInsets.only(top: 10),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

          children: [
            Padding(padding: EdgeInsets.only(left: 20), // Adjust left padding
            child: Text('Categories',
              style: fontStyles.headingStyle
            ),
            ),
            Padding(padding: EdgeInsets.only(right: 20),
            child: Text('See All',
              style: TextStyle(
                color: Color(0xFFF25922),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: screenHeight*0.001,
                letterSpacing: 0.20,
              ),
            ),
            )
            
          ],
        ),
        
      ),

      Container(
        margin:const EdgeInsets.only(top:10) ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distributes columns


            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Color(0xFFF9B79F),// Background color
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/bc 3.svg", // Your SVG icon
                      width: 30,
                      height: screenHeight*0.1,
                    ),
                    onPressed: () {
                    },
                  ), // Icon inside Avatar
                ),

                ],
              ),

              ),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Color(0xFFFFEFBF), // Background color
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/bc 3.svg", // Your SVG icon
                      width: 30,
                      height: screenHeight*0.1,
                    ),
                    onPressed: () {
                      print("SVG Icon pressed");
                    },
                  ), // Icon inside Avatar
                ),
                ],
              ),
              ),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Color(0xFFFCCFCF), // Background color
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/bc 3.svg", // Your SVG icon
                      width: 30,
                      height: screenHeight*0.1,
                    ),
                    onPressed: () {
                      print("SVG Icon pressed");
                    },
                  ), // Icon inside Avatar
                ),

                ],
              ),

              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Color(0xFF90D9F8), // Background color
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/bc 3.svg", // Your SVG icon
                      width: 30,
                      height: screenHeight*0.1,
                    ),
                    onPressed: () {
                      print("SVG Icon pressed");
                    },
                  ), // Icon inside Avatar


                ),],
              ),

              )


            ],
          )

      ),
        Container(
          margin: const EdgeInsets.only(top: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

            children: [
              Padding(padding: EdgeInsets.only(left: 20), // Adjust left padding
                child: Text('Leave Application',
                  style: fontStyles.normalText,

                ),
              ),
              Padding(padding: EdgeInsets.only(right: 20),
                child: Text('See All',
                  style: TextStyle(
                    color: Color(0xFFF25922),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: screenHeight*0.002,
                    letterSpacing: 0.20,
                  ),

                ),
              )

            ],
          ),

        ),
        Container(
          margin: const EdgeInsets.only(top: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

            children: [
              Padding(padding: EdgeInsets.only(left: 10), // Adjust left padding
                child: customanime(initialtext: 'Approved')
              ),
              Padding(padding: EdgeInsets.only(left: 10),
              child: customanime(initialtext: "Pending")
              ),
              Padding(padding: EdgeInsets.only(right: 10),
                child: customanime(initialtext: 'Declined')
              )

            ],
          ),

        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Expanded(
            child: Container(
              width: screenWidth*0.9,
              height: screenHeight*0.15,
              margin: EdgeInsets.all(screenWidth*0.03),
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: ListView.builder(
                  itemCount: items1.length,
                  itemBuilder: (context, index) {
                    final item = items1[index];

                    return
                      Container(

                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:ListTile(

                            title: Text(item["title"], style: fontStyles.headingStyle,),
                            trailing: CustomButton(),
                            subtitle: Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["subtitle"], style: fontStyles.subTextStyle,),
                                ],),
                            )
                        )
                        ,);

                  }

              ),
            ),

          ),],),
       //List
Container(
    width: screenWidth * 0.9,
    height: screenHeight * 0.08,
    margin: const EdgeInsets.only(top: 15),
    padding:  EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,

    ),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Color(0x193CAB88),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF3CAB88)),
        borderRadius: BorderRadius.circular(81),
        
      ),
    ),

  child: Row(
    children: [
      Container(
    width: screenWidth*0.1,
    height: screenHeight*0.05,
    decoration: ShapeDecoration(
      color: Color(0xFF3CAB88),
      shape: OvalBorder(),
      ),
        child: Icon(Icons.arrow_forward,color: Colors.white,),
      ),
      Container(
        padding: EdgeInsets.only(left: 70),
        child:Text('Slide to Check In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ) ,)

    ],
  )
    ),
        Container(


          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

            children: [
              Padding(padding: EdgeInsets.only(left: 20),
                  child: // Adjust left padding
                  TextButton(onPressed: (){


                  }, child:
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/solar_home-2-linear.svg', // Ensure the image is inside the assets folder
                        width: 24, // Set width
                        height: screenHeight*0.025, // Set height
                      ),
                      Text('Home'),
                    ],
                  ),
                  )
              ),
              Padding(padding: EdgeInsets.only(left: 20),
                  child: // Adjust left padding
                  TextButton(onPressed: (){
                    Get.to(() => categorypage(title: 'category'));
                  }, child:
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/category-1-svgrepo-com 1.svg', // Ensure the image is inside the assets folder
                        width: 24, // Set width
                        height: screenHeight*0.025, // Set height
                      ),
                      Text('Categories',

                      ),
                    ],
                  ),
                    )
              ),
              Padding(padding: EdgeInsets.only(left: 20),
                  child: // Adjust left padding
                  TextButton(onPressed: (){
                    Get.to(() => settingpage(title: 'settings'));

                  }, child:
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/settings-02.svg', // Ensure the image is inside the assets folder
                        width: 24, // Set width
                        height: screenHeight*0.025, // Set height
                      ),
                      Text('Settings'),
                    ],
                  ),
                    )
              ),
            ],
          ),

        ),


      ])


    );
  }

}