import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/holiday_controller.dart';
import '../Widgets/App_bar.dart';
import '../Widgets/year_selector.dart';
import 'package:employe_manage/Widgets/holiday_list.dart';

class holidaypage extends StatefulWidget {
  final String title;

  const holidaypage({Key? key, required this.title}) : super(key: key);

  @override
  _holidaypageState createState() => _holidaypageState();
}

class _holidaypageState extends State<holidaypage> {
  final HolidayController controller = Get.put(HolidayController());

  @override
  void initState() {
    super.initState();
    // 🔁 Optionally fetch or filter on load
    controller.updateYear(DateTime.now().year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Holiday List"),
      body: Column(
        children: [
          /// ✅ Year Selector
          YearMonthSelector(
            initialYear: DateTime.now().year,
            initialMonth: DateTime.now().month,
            showMonth: false,
            onDateChanged: (year, _) {
              controller.updateYear(year); // Only filters locally
            },
          ),

          /// ✅ Holiday List
          Expanded(
            child: Obx(() => HolidayList(
              holidays: controller.filteredHolidays,
              isLoading: controller.isLoading.value,
              phoneNumber: controller.phoneNumber.value,
            )),
          ),
        ],
      ),
    );
  }
}
