import 'package:employe_manage/Configuration/config_file.dart';
import 'package:employe_manage/Widgets/holiday_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import '../Widgets/year_selector.dart';
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
  // used by the build method of the State. Fields in a Widgets subclass are
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
  int selectedYear = DateTime.now().year;

  void onYearChanged(int newYear) {
    setState(() {
      selectedYear = newYear;
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
          .height;

      // Get screen height

      // This method is rerun every time setState is called, for instance as done
      // by the _incrementCounter method above.
      //
      // The Flutter framework has been optimized to make rerunning build methods
      // fast, so that you can just rebuild anything that needs updating rather
      // than having to individually change instances of widgets.
      return Scaffold(
          appBar: CustomAppBar(title: 'Holiday List',

          ),
        body:
        Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                YearSelector(
                  initialYear: selectedYear,
                  onYearChanged: onYearChanged,
                ),
              ],
            ),
          ),
            Expanded(child:Container

              (
              width: screenWidth * 0.9,

              child:ListView.builder(
                itemCount: HolidayListTile.items.length,
                itemBuilder: (context, index) {
                  return CustomListTile(item: HolidayListTile.items[index]);
                },
              ),
            ))],



        ),
          )

      );
    }
  }
