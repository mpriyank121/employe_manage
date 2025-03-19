import 'dart:async';
import 'package:get/get.dart';

class CheckInController extends GetxController {
  var isCheckedIn = false.obs;
  var elapsedSeconds = 0.obs;
  var checkInTime = DateTime.now().obs;
  var checkOutTime = Rxn<DateTime>(); // ✅ Nullable checkout time
  var workedTime = "".obs; // ✅ Store total worked time
  Timer? _timer;

  /// ✅ Start Timer when user checks in
  void startTimer() {
    elapsedSeconds.value = 0;
    _timer?.cancel(); // Ensure no duplicate timers

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isCheckedIn.value) {
        timer.cancel();
      } else {
        elapsedSeconds.value++;
      }
    });
  }

  /// ✅ Handle Check-In
  void checkIn() {
    isCheckedIn.value = true;
    checkInTime.value = DateTime.now();
    workedTime.value = ""; // ✅ Reset worked time
    checkOutTime.value = null; // ✅ Reset checkout time
    startTimer();
  }

  /// ✅ Handle Check-Out
  void checkOut() {
    if (isCheckedIn.value) {
      checkOutTime.value = DateTime.now(); // ✅ Store checkout time
      workedTime.value = formatTime(elapsedSeconds.value); // ✅ Store total worked time
      print("✅ Total Worked Time: ${workedTime.value}");
      print("✅ Check Out Time: ${CheckOutTime()}"); // ✅ Debugging

      isCheckedIn.value = false;
      elapsedSeconds.value = 0; // ✅ Reset after storing worked time
      _timer?.cancel();
    }
  }

  /// ✅ Convert seconds into HH:MM:SS format
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  /// ✅ Format Check-Out Time for UI
  String CheckOutTime() {
    return checkOutTime.value != null
        ? "${checkOutTime.value!.hour.toString().padLeft(2, '0')}:${checkOutTime.value!.minute.toString().padLeft(2, '0')}"
        : "Not Checked Out";
  }
}
