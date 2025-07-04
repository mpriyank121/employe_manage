
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/App_bar.dart';
import '../../Widgets/year_selector.dart';
import '../Configuration/app_spacing.dart';
import 'Widgets/holiday_list.dart';

class holidaypage extends StatefulWidget {
  final String title;

  const holidaypage({Key? key, required this.title}) : super(key: key);

  @override
  _holidaypageState createState() => _holidaypageState();
}

class _holidaypageState extends State<holidaypage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(title: "Holiday List"),
      body: Column(
        children: [
          AppSpacing.small(context),
          /// ✅ Year Selector
          YearMonthSelector(
            initialYear: DateTime.now().year,
            initialMonth: DateTime.now().month,
            showMonth: false,
            onDateChanged: (year, _) {}, // No-op
          ),
          AppSpacing.small(context),
          /// ✅ Holiday List (empty)
          Expanded(
            child: HolidayList(
              holidays: [],
              isLoading: false,
              phoneNumber: '',
            ),
          ),
        ],
      ),
    )) ;
  }
}
