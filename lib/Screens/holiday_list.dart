import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/holiday_controller.dart';
import '../Widgets/App_bar.dart';
import '../Widgets/year_selector.dart';
import 'package:employe_manage/Widgets/holiday_list.dart';


class holidaypage extends StatelessWidget {
  final String title;  // ✅ Add title parameter

  holidaypage({Key? key, required this.title}) : super(key: key);

  final HolidayController controller = Get.put(HolidayController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Holiday List"),  // ✅ Pass title here
      body: Column(
        children: [
          /// ✅ Year Selector Widget
          Obx(() => YearSelector(
            initialYear: controller.selectedYear.value,
            onYearChanged: controller.updateYear,
          )),

          /// ✅ Holiday List Widget
          Expanded(
            child: Obx(() => HolidayList(
              holidays: controller.allHolidays.toList(),
              isLoading: controller.isLoading.value,
              phoneNumber: controller.phoneNumber.value,
            )),
          ),
        ],
      ),
    );
  }
}
