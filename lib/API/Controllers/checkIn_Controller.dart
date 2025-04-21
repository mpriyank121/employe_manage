import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CheckInController extends GetxController {
  var isCheckedIn = false.obs;
  var checkInTime = Rxn<DateTime>();
  var checkOutTime = Rxn<DateTime>();
  var firstIn = ''.obs;
  var inImg = "".obs;
  var outImg = "".obs;
  var workedTime = "".obs;

  RxInt elapsedSeconds = 0.obs;
  Timer? _timer;
  Timer? _liveTimer;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    stopAllTimers();
    super.onClose();
  }

  void stopAllTimers() {
    _timer?.cancel();
    _liveTimer?.cancel();
  }

  void setFirstInAndStartTimer(String firstInTime) {
    try {
      final parsedTime = DateFormat('hh:mm a').parse(firstInTime);
      final checkIn = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        parsedTime.hour,
        parsedTime.minute,
      );

      if (checkInTime.value == null || checkInTime.value != checkIn) {
        checkInTime.value = checkIn;

        final now = DateTime.now();
        final diff = now.difference(checkIn);
        elapsedSeconds.value = diff.inSeconds;

        startTimer();
        isCheckedIn.value = true;
      }
    } catch (e) {
      print("❌ Error parsing check-in time: $e");
    }
  }

  void startTimer() {
     if (!isCheckedIn.value) return;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      elapsedSeconds.value += 1;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    elapsedSeconds.value = 0;
  }

  void startLiveElapsedTimeFromServer() {
    // ✅ Only run this if user is still checked in
    if (!isCheckedIn.value) return;

    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      try {
        DateTime serverCheckInTime = DateTime.parse(firstIn.value);
        Duration diff = DateTime.now().difference(serverCheckInTime);
        workedTime.value = formatTime(diff.inSeconds);
      } catch (e) {
        print("❌ Error parsing check-in time: $e");
      }
    });
  }


  Future<void> checkIn() async {
    if (isCheckedIn.value) return;

    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    isCheckedIn.value = true;
    checkInTime.value = DateTime.now();
    await prefs.setString('checkIn_$todayDate', checkInTime.value!.toIso8601String());

    await prefs.remove('checkOut_$todayDate');
    await prefs.remove('workedTime_$todayDate');
    checkOutTime.value = null;
    workedTime.value = "";

    resumeTimer();
  }

  Future<void> checkOut() async {
    if (!isCheckedIn.value) return;

    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    checkOutTime.value = DateTime.now();
    await prefs.setString('checkOut_$todayDate', checkOutTime.value!.toIso8601String());

    // ✅ Calculate and save final worked time
    calculateWorkedTime();
    await prefs.setString('workedTime_$todayDate', workedTime.value);

    isCheckedIn.value = false;
    elapsedSeconds.value = 0;
    stopAllTimers();
  }
  void resumeTimer() {
    if (checkInTime.value != null && checkOutTime.value == null) {
      Duration elapsed = DateTime.now().difference(checkInTime.value!);
      elapsedSeconds.value = elapsed.inSeconds;
      startTimer();
    }
  }


  void calculateWorkedTime() {
    if (checkInTime.value != null && checkOutTime.value != null) {
      Duration difference = checkOutTime.value!.difference(checkInTime.value!);
      workedTime.value = formatTime(difference.inSeconds);
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }
}
