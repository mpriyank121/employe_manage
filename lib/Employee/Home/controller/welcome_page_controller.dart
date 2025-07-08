import 'package:get/get.dart';

class WelcomePageController extends GetxController {
  // Tab index for LeaveApplicationTabs
  RxInt selectedIndex = 1.obs;

  // Selected date for CustomDatePickerBox
  Rx<DateTime> selectedDate = DateTime.now().obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }
}
