import 'package:employe_manage/Widgets/holiday_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:flutter_svg/svg.dart';
import '../Widgets/CustomListTile.dart';
import '../Widgets/year_selector.dart';
import 'package:get/get.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home:  holidaypage(title: '',
        )
    );
  }
}
class holidaypage extends StatefulWidget {
  const holidaypage({super.key, required this.title});
  final String title;
  @override
  State<holidaypage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<holidaypage> {
  int selectedYear = DateTime.now().year;
  void onYearChanged(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }
  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery
          .of(context)
          .size
          .width; // Get screen width
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
            Expanded(child:Container(
              width: screenWidth * 0.9,
              child:ListView.builder(
                itemCount: holidayList.length,
                itemBuilder: (context, index) {
                  return CustomListTile(item: holidayList[index],
                    leading: SvgPicture.asset("assets/images/Frame 427319800.svg"),
                  );
                },
              ),
            ))],
        ),
          )
      );
    }
  }
