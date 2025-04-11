import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var userName = 'Loading...'.obs;
  var jobRole = 'Loading...'.obs;
  var employeeType = 'Loading...'.obs;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('username') ?? 'Guest';
    jobRole.value = prefs.getString('jobRole') ?? 'Unknown Role';
    employeeType.value = prefs.getString('emp_type') ?? 'Unknown type';

    print("✅ GetX: User data loaded");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login'); // Navigate to login
    print('🚪 Logged out with GetX');
  }
}
