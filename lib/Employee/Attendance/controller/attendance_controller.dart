import 'package:get/get.dart';

class AttendanceController extends GetxController {
  // Store expanded cards' dates
  var expandedDates = <String>{}.obs;

  void toggleSection(String date) {
    if (expandedDates.contains(date)) {
      expandedDates.remove(date);
    } else {
      expandedDates.add(date);
    }
  }

  bool isExpanded(String date) => expandedDates.contains(date);
}
