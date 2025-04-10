import 'package:get/get.dart';
import '../Services/attendance_service.dart';
import '../Services/user_service.dart';
import '../models/attendence_model.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final UserService _userService = UserService();

  var present = 0.obs;
  var absent = 0.obs;
  var halfday = 0.obs;
  var week_off = 0.obs;
  var isLoading = false.obs;
  var isCheckInDisabled = false.obs;

  var checkInImage = RxnString();
  var checkOutImage = RxnString();
  var countData = <String, dynamic>{
    'present_count': 0,
    'absent_count': 0,
    'halfday_count': 0,
    'week_off_count': 0,
  }.obs;



  @override
  void onInit() {
    super.onInit();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    isLoading.value = true;
    try {
      AttendanceData? attendanceData = await _userService.fetchAttendanceData(startDate: '', endDate: '');
      if (attendanceData != null) {
        present.value = attendanceData.present;
        absent.value = attendanceData.absent;
        halfday.value = attendanceData.halfday;
        week_off.value = attendanceData.week_off;
      }
      print('fetch');
    } catch (error) {
      print("❌ Error fetching attendance: $error");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchAttendanceByMonth(int year, int month) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> attendanceData =
      await AttendanceService.fetchAttendanceDataByMonth(year, month);
      print("attendanceData['countData']:${attendanceData['countData']}");

      countData.value = attendanceData['countData'];
      print("📆 Fetched Attendance for $month/$year: $attendanceData");

      // Update UI if needed
    } catch (error) {
      print("❌ Error fetching monthly attendance: $error");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Fetch Attendance for Any Selected Date
  Future<Map<String, String?>> getAttendanceByDate(String selectedDate, List<dynamic> attendanceData) async {
    for (var record in attendanceData) {
      if (record['date'] == selectedDate) {
        print('rrr$record');
        return {
          'first_in': record['first_in'],
          'last_out': record['last_out'] == "N/A" ? null : record['last_out'],
          'checkIn_image':record['checkinImage'],
          'checkOut_image' : record['checkoutImage'],
          'checkInLocation' :record['checkInLocation'],
          'checkOutLocation':record['checkOutLocation']
        };
      }
    }

    // Reset values if no data found
    // checkInImage.value = null;
    // checkOutImage.value = null;

    return {'first_in': null, 'last_out': null};
  }

  /// ✅ Disable check-in if first_in & last_out exist for the selected date
  Future<void> checkIfCheckInDisabled(String selectedDate, List<dynamic> attendanceData) async {
    var selectedDateAttendance = await getAttendanceByDate(selectedDate, attendanceData);

    isCheckInDisabled.value = selectedDateAttendance['first_in'] != null && selectedDateAttendance['last_out'] != null;

    print("🔹 Check-In Disabled for $selectedDate: ${isCheckInDisabled.value}");
  }


}
