import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends GetxController {
  var empId = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initDates();
    loadEmpId();
  }
  void refreshTaskData() {
    resetDateRange();
    loadEmpId(); // load again if needed
  }

  void _initDates() {
    final now = DateTime.now();
    final fifteenDaysAgo = now.subtract(Duration(days: 15));
    startDate.value = fifteenDaysAgo;
    endDate.value = now;
  }

  Future<void> loadEmpId() async {
    final prefs = await SharedPreferences.getInstance();
    empId.value = prefs.getString('emp_id') ?? '';
    isLoading.value = false;
  }

  void resetDateRange() => _initDates();

  void updateDateRange(DateTime start, DateTime end) {
    startDate.value = start;
    endDate.value = end;
  }
}

