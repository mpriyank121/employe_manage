import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class CheckInController extends GetxController {
  var isCheckedIn = false.obs;
  var checkInTime = Rxn<DateTime>();
  var checkOutTime = Rxn<DateTime>();
  var firstIn = ''.obs; // <-- fetched from API
  var inImg = "".obs;
  var outImg = "".obs;
  var workedTime = "".obs;


  Timer? _liveTimer;

  @override
  void onInit() {
    super.onInit();
    loadSessionData(); // ✅ SharedPref session data
  }

  /// ✅ Call this when API returns firstIn
  RxInt elapsedSeconds = 0.obs;
  Timer? _timer;

  void setFirstInAndStartTimer(String firstInTime) {
    try {
      final now = DateTime.now();
      final parsed = DateFormat('hh:mm a').parse(firstInTime); // from server
      final checkInTime = DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
      this.checkInTime.value = checkInTime;

      final diff = now.difference(checkInTime);
      elapsedSeconds.value = diff.inSeconds;

      startTimer(); // ⏱ Start timer
      isCheckedIn.value = true;
    } catch (e) {
      print("❌ Error parsing check-in time: $e");
    }
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds.value += 1;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    elapsedSeconds.value = 0;
  }



  /// ✅ Live timer from server time
  void startLiveElapsedTimeFromServer() {
    _liveTimer?.cancel(); // Avoid duplicate timers

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
        resumeTimer(); // local timer if needed
      }
    }
  }

  Future<void> checkIn() async {
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
    if (isCheckedIn.value) {
      final prefs = await SharedPreferences.getInstance();
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      checkOutTime.value = DateTime.now();
      await prefs.setString('checkOut_$todayDate', checkOutTime.value!.toIso8601String());

      calculateWorkedTime();
      isCheckedIn.value = false;
      elapsedSeconds.value = 0;
      _timer?.cancel();
      _liveTimer?.cancel();
    }
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
