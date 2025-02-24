import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'otp_page.dart';


void main() {
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
    double screenWidth = MediaQuery.of(context).size.width; // Get screen width
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      body:
      Container(
        child:
      Padding(
        padding: EdgeInsets.all(screenWidth * 0.5), // 5% of screen width as padding
        child: Align(
          alignment: Alignment.topLeft, // Align everything to top-left
          child : Stack(
            children: [
              Positioned.fill(child:
              Container(child:SvgPicture.asset(
                'assets/Periwinkle.svg',
              ),)
              ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
            Row(children: [
              Padding(padding: EdgeInsets.only(top: screenHeight * 0.05),
              child:
              SvgPicture.asset(
                'assets/Bookchor.svg',
                height: screenHeight * 0.05,  // 10% of screen height
                width: screenWidth * 0.05,   // 20% of screen width
              ),
              ),
              Row(children: [
                Padding(padding: EdgeInsets.only(top: screenHeight * 0.05),
                child:
                SvgPicture.asset(
                'assets/bc 3.svg',
                height: screenHeight * 0.05,  // 10% of screen height
                width: screenWidth * 0.05,   // 20% of screen width
              )),],),],),
              SizedBox(height: screenHeight * 0.01), // Space below image
              Text(
                'HR Management App',
                style: TextStyle(
                  color: Color(0x993C3C43),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text('Enter Your Mobile number',
              style: TextStyle(color: Colors.black,
                fontSize: 22,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                height: 1.86),
              ),
              Text('Enter your mobile number to get started',
                style: TextStyle(color: Color(0xFF949494),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.75),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(decoration: InputDecoration(
                labelText: 'Mobile Number', // Label inside the field
                hintText: 'Enter your mobile number', // Placeholder text
                prefixIcon:Padding(padding:EdgeInsets.symmetric(vertical: 14,horizontal: 10),
                  child:

                  Text('+91',
                  style: TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.32,
                  ),
                ),), // Leading icon
                border: OutlineInputBorder( // Border style
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),)
              ),

            ],

          ),

              Positioned(
                bottom: 20, // Adjust spacing from the bottom
                left: 0,
                right: 0,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange, // Background color
                    borderRadius: BorderRadius.circular(10),
                    // Rounded corners

                  ),
                  child: TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpPage()),
                    );
                  },
                    child:
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SvgPicture.asset(
                            'assets/Arrow_Circle_Right.svg', // Replace with your image path
                          ),
                          SizedBox(width: 8), // Space between image and text

                        ],
                      )
                  ),

                )

              ),
            ] )
        ),


      ),
      )

         );
  }
}


