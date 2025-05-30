// welcome_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controllers/checkIn_Controller.dart';
import '../Controllers/employee_attendence_controller.dart';
import 'package:intl/intl.dart';

import '../Services/attendance_service.dart';
import '../Services/user_service.dart';
import 'leave_controller.dart';

class WelcomeController extends GetxController {
  var userName = "Loading...".obs;
  var jobRole = "Loading...".obs;
  var employeeType = "Loading...".obs;
  var showCam = false.obs;
  var selectedDate = DateTime.now().obs;
  var selectedFirstIn = "N/A".obs;
  var selectedLastOut = "N/A".obs;
  var checkInImage = RxnString();
  var checkOutImage = RxnString();
  var checkInLocation = RxnString();
  var checkOutLocation = RxnString();
  var isTodayAttendanceComplete = false.obs;

  final UserService userService = UserService();
  final AttendanceController attendanceController = Get.find<AttendanceController>();
  final CheckInController checkInController = Get.find<CheckInController>();
  final LeaveController leaveController = Get.find<LeaveController>();


  Future<void> reloadWelcomeData() async {
    await _fetchUserData();
    await _loadInitialAttendance();

  }

  Future<void> _fetchUserData() async {
    var userData = await userService.fetchUserData();
    if (userData != null) {
      userName.value = userData['name'] ?? "Unknown";
      jobRole.value = userData['designation'] ?? "Unknown";
      employeeType.value = userData['emp_type'] ?? "Unknown";
      showCam.value = userData['show_cam'] ?? false;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('emp_type', employeeType.value);
      prefs.setString('username', userName.value);
      prefs.setString('jobRole', jobRole.value);
      print("✅ GetX: welcome data loaded");

    }
  }

  Future<void> _loadInitialAttendance() async {
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;
    var attendanceData = await AttendanceService.fetchAttendanceData(selectedYear,selectedMonth);
    print("📦 All Attendance Data: $attendanceData");

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var todayAttendance = await attendanceController.getAttendanceByDate(formattedDate, attendanceData);
    if (todayAttendance != null &&
        todayAttendance['first_in'] != null &&
        todayAttendance['last_out'] == null) {
      checkInController.isCheckedIn.value = true;
      checkInController.setFirstInAndStartTimer(todayAttendance['first_in']!);
    }

    print('First in raw value: ${todayAttendance['first_in']}');

    if (todayAttendance == null || todayAttendance.isEmpty) {
      checkInController.isCheckedIn.value = false;
    }
    print('to:::$todayAttendance');
    print("🖼️ Final Images -> CheckIn: ${todayAttendance['checkIn_image']} | CheckOut: ${todayAttendance['checkOut_image']}");

    updateAttendance(DateTime.now(), todayAttendance);
  }

  void updateAttendance(DateTime date, Map<String, dynamic> attendance) {
    selectedDate.value = date;
    selectedFirstIn.value = attendance['first_in'] ?? "N/A";
    selectedLastOut.value = attendance['last_out'] ?? "N/A";
    checkInImage.value = attendance['checkIn_image'];
    checkOutImage.value = attendance['checkOut_image'];
    checkInLocation.value = attendance['checkInLocation'];
    checkOutLocation.value = attendance['checkOutLocation'];
    isTodayAttendanceComplete.value =
        attendance['first_in'] != null &&
            attendance['first_in'] != "N/A" &&
            attendance['last_out'] != null &&
            attendance['last_out'] != "N/A";

    print("✅ isTodayAttendanceComplete: ${isTodayAttendanceComplete.value}");

  }

}
