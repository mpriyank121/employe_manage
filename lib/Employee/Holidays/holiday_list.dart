import 'package:coreHrx_employeeapp/Employee/Holidays/controller/holiday_controller.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/holiday_list.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/model/holiday_model.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/widget/holiday_widget_list.dart';
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

