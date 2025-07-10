// controllers/holiday_controller.dart
import 'package:coreHrx_employeeapp/Employee/Holidays/model/holiday_model.dart';
import 'package:get/get.dart';
 // ✅ correct path to model

class HolidayController extends GetxController {
  var holidays = <Holiday>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHolidays();
  }

  void fetchHolidays() async {
    await Future.delayed(Duration(seconds: 1));
    holidays.value = [
      Holiday(title: 'New Year', date: '01 Jan 2025', weekday: 'Wednesday'),
      Holiday(title: 'Republic Day', date: '26 Jan 2025', weekday: 'Sunday'),
      Holiday(title: 'Holi', date: '17 Mar 2025', weekday: 'Monday'),
    ];
    isLoading.value = false;
  }
}
