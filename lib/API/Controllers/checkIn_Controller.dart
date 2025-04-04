import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CheckInController extends GetxController {
  var isCheckedIn = false.obs;
  var elapsedSeconds = 0.obs;
  var checkInTime = Rxn<DateTime>();
  var checkOutTime = Rxn<DateTime>();
  var inImg = "".obs;
  var outImg = "".obs;
  var workedTime = "".obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadSessionData(); // ✅ Load check-in status when app starts
  }

  /// ✅ Load Check-In / Check-Out from SharedPreferences
  Future<void> loadSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String? storedCheckIn = prefs.getString('checkIn_$todayDate');
    String? storedCheckOut = prefs.getString('checkOut_$todayDate');

    if (storedCheckIn != null) {
      checkInTime.value = DateTime.parse(storedCheckIn);
      isCheckedIn.value = storedCheckOut == null;
      // outImg.value =

      if (storedCheckOut != null) {
        checkOutTime.value = DateTime.parse(storedCheckOut);
        calculateWorkedTime();
      } else {
        resumeTimer(); // ✅ Resume tracking elapsed time if still checked in
      }
    }
  }

  /// ✅ Handle Check-In
  Future<void> checkIn() async {
    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    isCheckedIn.value = true;
    checkInTime.value = DateTime.now();
    await prefs.setString('checkIn_$todayDate', checkInTime.value!.toIso8601String());

    await prefs.remove('checkOut_$todayDate'); // Clear old check-out
    checkOutTime.value = null;
    workedTime.value = "";
    resumeTimer(); // ✅ Continue elapsed time tracking
  }

  /// ✅ Handle Check-Out
  Future<void> checkOut() async {
    if (isCheckedIn.value) {
      final prefs = await SharedPreferences.getInstance();
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      checkOutTime.value = DateTime.now();
      await prefs.setString('checkOut_$todayDate', checkOutTime.value!.toIso8601String());

      calculateWorkedTime();
      isCheckedIn.value = false;
      elapsedSeconds.value = 0;
      _timer?.cancel();
    }
  }

  /// ✅ Resume Timer if the app was closed or user logs out
  void resumeTimer() {
    if (checkInTime.value != null) {
      Duration elapsed = DateTime.now().difference(checkInTime.value!);
      elapsedSeconds.value = elapsed.inSeconds;

      startTimer();
    }
  }

  /// ✅ Start Timer
  void startTimer() {
    _timer?.cancel(); // Avoid duplicate timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isCheckedIn.value) {
        timer.cancel();
      } else {
        elapsedSeconds.value++;
        workedTime.value = formatTime(elapsedSeconds.value);
      }
    });
  }

  /// ✅ Calculate Worked Time
  void calculateWorkedTime() {
    if (checkInTime.value != null && checkOutTime.value != null) {
      Duration difference = checkOutTime.value!.difference(checkInTime.value!);
      workedTime.value = formatTime(difference.inSeconds);
    }
  }

  /// ✅ Convert seconds to HH:MM:SS format
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }
}
