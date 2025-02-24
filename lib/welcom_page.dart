import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'otp_page.dart';

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

        home:  MyHomePage(title: '',
        )
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

  Widget build(BuildContext context) {
    const TextStyle commonTextStyle = TextStyle(
      color: Color(0xFF666666),
      fontSize: 12,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      height: 1,
    );
    double _value =30;
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title:
            Center(child:

        Text('Welcome',style: TextStyle(color: Colors.black,
          fontSize: 18,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,),),),
        leading: Padding(padding: EdgeInsets.only(top: screenHeight * 0.01),
        child: SvgPicture.asset('assets/bc 3.svg',
          height: screenHeight * 0.02,  // 10% of screen height
          width: screenWidth * 0.02,),
        ),
          actions: [IconButton(onPressed: (){},

          icon: Icon(Icons.notifications))],
      ),

      body:
      Column(children: [

      Container(
        width: 391,
        height: 49,

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
                      style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,

                      ),
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
                height: 1.60,
              ),
            ) ,)
            ,
            Container(
              margin: const EdgeInsets.only(top:20),
                child: Text(

              'Priyank Mangal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.60,
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
                  height: 1.60,
                ),


            ) ,),
            Container(

              width: screenWidth * 0.9,
              height: screenHeight * 0.1,
              margin: const EdgeInsets.only(top:19),
              padding: const EdgeInsets.all(30),
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
        style: commonTextStyle,
      ),
        Text('52 Days',
            textAlign: TextAlign.center,

            style: commonTextStyle),

      ],
    ),

      ),
    Container(
      width: 1, // Line width
      height: 30, // Line height
      color: Colors.grey, // Line color
    ),
    Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text('Worked Days',
        textAlign: TextAlign.center,
        style: commonTextStyle,
      ),
        Text('52 Days',
            textAlign: TextAlign.center,
            style: commonTextStyle),
      ],
    ),
    ),
    Container(
      width: 1, // Line width
      height: 30, // Line height
      color: Colors.grey, // Line color
    ),
    Expanded(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text('Worked Days',
        textAlign: TextAlign.center,
        style: commonTextStyle,
      ),
        Text('52 Days',
            textAlign: TextAlign.center,

            style: commonTextStyle),

      ],
    ),

    )


   ],
 )
  
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
            child: Text('Categories'),
            ),
            Padding(padding: EdgeInsets.only(right: 20),
            child: Text('See All'),
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
                  child: Icon(Icons.person, color: Colors.white, size: 24), // Icon inside Avatar
                ),

                ],
              ),

              ),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Colors.blue, // Background color
                  child: Icon(Icons.person, color: Colors.white, size: 24), // Icon inside Avatar
                ),
                ],
              ),
              ),

              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Colors.blue, // Background color
                  child: Icon(Icons.person, color: Colors.white, size: 24), // Icon inside Avatar
                ),

                ],
              ),

              ),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 24, // Size of the CircleAvatar
                  backgroundColor: Colors.blue, // Background color
                  child: Icon(Icons.person, color: Colors.white, size: 24), // Icon inside Avatar
                ),

                ],
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
                child: Text('Leave Application'),
              ),
              Padding(padding: EdgeInsets.only(right: 20),
                child: Text('See All'),
              )

            ],
          ),

        ),
        Container(
          margin: const EdgeInsets.only(top: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

            children: [
              Padding(padding: EdgeInsets.only(left: 20), // Adjust left padding
                child: Text('Approved'),
              ),
              Padding(padding: EdgeInsets.only(left: 20),
              child: Text('Pending'),
              ),
              Padding(padding: EdgeInsets.only(right: 20),
                child: Text('Declined'),
              )

            ],
          ),

        ),
       Container(
         child:
         ListTile(
           title: Text('Sick Leave Request'),
           subtitle: Text('12-14 Jan'),
           trailing: TextButton(onPressed: (){}, child: Text('Approved')),

         ),
       ),
        Container(
          child: ListTile(
            title: Text('Casual Leave Request'),
            subtitle: Text('12-14 Jan'),
            trailing: TextButton(onPressed: (){}, child: Text('Approved')),

          ),
        ),
Container(
    width: screenWidth * 0.9,
    height: screenHeight * 0.08,
    margin: const EdgeInsets.only(top: 15),
    padding: const EdgeInsets.only(
      top: 10,
      left: 10,
      right: 126,
      bottom: 9,
    ),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Color(0x193CAB88),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF3CAB88)),
        borderRadius: BorderRadius.circular(81),
      ),
    ),
    child:
    Slider(
  value: _value,
  min: 0,
  max: 100,
  activeColor: Colors.green, // Color of filled part
  inactiveColor: Colors.grey, // Color of unfilled part
  thumbColor: Colors.red, // Color of the slider knob
  onChanged: (newValue) {
    setState(() {

    });
  },
)),
        Container(
          margin: const EdgeInsets.only(top: 50),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

            children: [
              Padding(padding: EdgeInsets.only(left: 20),
                  child: // Adjust left padding
                  TextButton(onPressed: (){}, child:
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/solar_home-2-linear.svg', // Ensure the image is inside the assets folder
                        width: 24, // Set width
                        height: 24, // Set height
                      ),
                      Text('Home'),
                    ],
                  ),
                  )
              ),
              Padding(padding: EdgeInsets.only(left: 20),
                  child: // Adjust left padding
                  TextButton(onPressed: (){}, child:
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/category-1-svgrepo-com 1.svg', // Ensure the image is inside the assets folder
                        width: 24, // Set width
                        height: 24, // Set height
                      ),
                      Text('Categories'),
                    ],
                  ),
                    )
              ),
              Padding(padding: EdgeInsets.only(left: 20),
                  child: // Adjust left padding
                  TextButton(onPressed: (){}, child:
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/settings-02.svg', // Ensure the image is inside the assets folder
                        width: 24, // Set width
                        height: 24, // Set height
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