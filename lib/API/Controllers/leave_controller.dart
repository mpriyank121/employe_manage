import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/leave_service.dart';
import '../models/leave_model.dart';

class LeaveController extends GetxController {
  final RxMap<String, List<LeaveModel>> leaveData = <String, List<LeaveModel>>{}.obs;
  final isLoading = true.obs;

  /// ✅ Fetch Leave Data Based on Employee ID
  Future<void> fetchLeaveData(int year, int month, bool useCustomRange) async {
    isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("emp_id");

    if (empId != null) {
      var data = await LeaveService.fetchLeaveData();
      print('yeaR:$year, month:$month');
      leaveData.assignAll(_filterLeaveData(data, year, month, useCustomRange));
      // leaveData.assignAll(data);
      leaveData.refresh();
    }

    isLoading.value = false;
  }

  /// ✅ Filter Data Based on Custom Range
  Map<String, List<LeaveModel>> _filterLeaveData(Map<String, List<LeaveModel>> data, int year, int month, bool useCustomRange) {
    DateTime startDate, endDate;

    if (useCustomRange) {
      if (month == 1) {
        startDate = DateTime(year - 1, 12, 26);
        endDate = DateTime(year, 1, 25);
      } else {
        startDate = DateTime(year, month - 1, 26);
        endDate = DateTime(year, month, 25);
      }
    } else {
      startDate = DateTime(year, month, 1);
      endDate = DateTime(year, month + 1, 0);
    }

    Map<String, List<LeaveModel>> filteredData = {};
    data.forEach((status, leaves) {
      filteredData[status] = leaves.where((leave) {
        DateTime leaveStart = DateTime.parse(leave.startDate);
        return leaveStart.isAfter(startDate.subtract(const Duration(days: 1))) &&
            leaveStart.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    });

    return filteredData;
  }
}
