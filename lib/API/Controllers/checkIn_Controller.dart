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
    loadSessionData();
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
      final parsedTime = DateFormat('hh:mm a').parse(firstInTime); // Adjust format as necessary
      final checkIn = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, parsedTime.hour, parsedTime.minute);

      // Only update the checkInTime if it's different
      if (checkInTime.value == null || checkInTime.value != checkIn) {
        checkInTime.value = checkIn;

        final now = DateTime.now();
        final diff = now.difference(checkIn);
        elapsedSeconds.value = diff.inSeconds;

        startTimer(); // Start the timer only if checkInTime is new or has changed
        isCheckedIn.value = true;
      }
    } catch (e) {
      print("❌ Error parsing check-in time: $e");
    }
  }


  void startTimer() {
    if (!isCheckedIn.value) return; // ⛔ Don't start if already checked out
    _timer?.cancel();  // Ensure that any previously running timer is stopped
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds.value += 1;
    });
  }


  void stopTimer() {
    _timer?.cancel();
    elapsedSeconds.value = 0;
  }

  void startLiveElapsedTimeFromServer() {
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

  Future<void> loadSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? storedCheckIn = prefs.getString('checkIn_$todayDate');
    String? storedCheckOut = prefs.getString('checkOut_$todayDate');

    if (storedCheckIn != null) {
      checkInTime.value = DateTime.parse(storedCheckIn);
      isCheckedIn.value = storedCheckOut == null;

      if (storedCheckOut != null) {
        checkOutTime.value = DateTime.parse(storedCheckOut);
        calculateWorkedTime();
      } else {
        resumeTimer();
      }
    }
  }

  Future<void> checkIn() async {
    if (isCheckedIn.value) return; // 🛡 Prevent double check-in

    final prefs = await SharedPreferences.getInstance();
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    isCheckedIn.value = true;
    checkInTime.value = DateTime.now();
    await prefs.setString('checkIn_$todayDate', checkInTime.value!.toIso8601String());

    await prefs.remove('checkOut_$todayDate');
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

    calculateWorkedTime();
    isCheckedIn.value = false;
    elapsedSeconds.value = 0;
    stopAllTimers();
  }

  void resumeTimer() {
    if (checkInTime.value != null) {
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
