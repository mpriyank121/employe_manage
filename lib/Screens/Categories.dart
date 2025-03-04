import 'package:employe_manage/Modules/App_bar.dart';
import 'package:employe_manage/Screens/assets_cat.dart';
import 'package:employe_manage/Screens/holiday_list.dart';
import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:employe_manage/Screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'documents.dart';
import 'package:employe_manage/Configuration/config_file.dart';

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

        home:  categorypage(title: '',
        )
    );
  }
}
class categorypage extends StatefulWidget {
  const categorypage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<categorypage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<categorypage> {

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

      appBar: CustomAppBar(title: 'Categories',
        leading:AppBarConfig.getIconImage(imagePath: 'assets/images/bc 3.svg',) ,
        actions: [],
        trailing: IconButton(onPressed: (){}, icon: Icon(Icons.notifications)),

      ),
      body: Stack(
        children: [
          Column(
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distributes columns

            children: [
              ContainerCard(

                child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
                  Text('Attendence')
                ],) ,
              ),
              ContainerCard(
                child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
              Text('Remuneration')
            ],) ,

              ),
            ],

          ),
              SizedBox(height: MediaQuery.of(context).size.height *0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [GestureDetector(
                  onTap:() {
                    Get.to(() => Assetspage(title: 'assets'));

                  },
                  child:ContainerCard(
                  child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
                    Text('Assets')
                  ],) ,

                ), ),
                  GestureDetector(
                    onTap: (){
                      Get.to(() => holidaypage(title: 'holiday'));
                    },
                    child: ContainerCard(

                    child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
                      Text('Holidays')
                    ],) ,

                  ),)


                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height *0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(()=> leavepage(title: 'leave',));
                    },
                    child:ContainerCard(
                    child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
                      Text('Leave')
                    ],) ,

                  ), ),
                  
                  GestureDetector(
                    onTap:(){
                      Get.to(() => documentpage(title: 'document'));
                    } ,
                    child:
                  ContainerCard(
                    child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
                      Text('Document')
                    ],) ,

                  ),)

                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height *0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContainerCard(
                    child:Column(children: [SvgPicture.asset('assets/images/bc 3.svg'),
                      Text('Tasks')
                    ],) ,

                  ),
                ],
              )
            ],),
          Positioned(
            bottom:  MediaQuery.of(context).size.height * 0.02,
            left: 0,
            right: 0,
            child:
          Container(
            margin: const EdgeInsets.only(top: 45),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes items to edges

              children: [
                Padding(padding: EdgeInsets.only(left: 20),
                    child: // Adjust left padding
                    TextButton(onPressed: (){
                      Get.back();
                    }, child:
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/solar_home-2-linear.svg', // Ensure the image is inside the assets folder
                          width: 24,// Set width
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
                          'assets/images/category-1-svgrepo-com 1.svg', // Ensure the image is inside the assets folder
                          width: 24, // Set width
                          height: 24, // Set height
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
                      Get.to(() => settingpage(title: 'setting'));

                    }, child:
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/settings-02.svg', // Ensure the image is inside the assets folder
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

          )
        ],


          ),
    );
  }
}