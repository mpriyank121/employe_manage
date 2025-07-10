import 'package:coreHrx_employeeapp/Employee/Holidays/controller/holiday_controller.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/holiday_list.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/model/holiday_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Widgets/App_bar.dart';
import '../../Widgets/year_selector.dart';
import '../Configuration/app_spacing.dart';

class HolidayPage extends StatelessWidget {
  final String title;

  HolidayPage({Key? key, required this.title}) : super(key: key);

  final HolidayController controller = Get.put(HolidayController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: title),
        body: Column(
          children: [
            AppSpacing.small(context),

            /// Year Selector
            YearMonthSelector(
              initialYear: DateTime.now().year,
              initialMonth: DateTime.now().month,
              showMonth: false,
              onDateChanged: (year, _) {
                // You can filter by year here if needed
              },
            ),

            AppSpacing.small(context),

            /// Holiday List
            Expanded(
              child: Obx(() => HolidayList(
                    holidays: controller.holidays,
                    isLoading: controller.isLoading.value,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class HolidayList extends StatelessWidget {
  final List<Holiday> holidays;
  final bool isLoading;

  const HolidayList({
    Key? key,
    required this.holidays,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (holidays.isEmpty) return Center(child: Text('No holidays found.'));

    return ListView.builder(
      itemCount: holidays.length,
      itemBuilder: (context, index) {
        final holiday = holidays[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/holiday_cal.png",
                height: 35,
                width: 30,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holiday.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text('${holiday.date} • ${holiday.weekday}',
                        style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
