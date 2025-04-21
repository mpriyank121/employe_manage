import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateController extends GetxController {
  bool hasSkippedUpdate = false;

  @override
  void onInit() {
    super.onInit();

  }


  Future<void> setSkipState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('updateSkipped', value);
    hasSkippedUpdate = value;
  }

  Future<void> resetSkip() async {
    await setSkipState(false);
  }
}
