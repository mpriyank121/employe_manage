import 'package:get/get.dart';
import '../Services/user_service.dart';
import '../models/attendence_model.dart';
class AttendanceController extends GetxController {
  final UserService _userService = UserService();

  var present = 0.obs;
  var absent = 0.obs;
  var halfday = 0.obs;
  var week_off = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    isLoading.value = true;
    try {
      AttendanceData? attendanceData = await _userService.fetchAttendanceData();
      if (attendanceData != null) {
        present.value = attendanceData.present;
        absent.value = attendanceData.absent;
        halfday.value = attendanceData.halfday;
        week_off.value = attendanceData.week_off;
      }
    } catch (error) {
      print("❌ Error fetching attendance: $error");
    } finally {
      isLoading.value = false;
    }
  }
}
