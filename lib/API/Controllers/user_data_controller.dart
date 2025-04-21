import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/user_service.dart';

class UserController extends GetxController {
  var userName = 'Loading...'.obs;
  var jobRole = 'Loading...'.obs;
  var employeeType = 'Loading...'.obs;
  var imageUrl = ''.obs;
  var gender = ''.obs;

  final UserService userService = UserService(); // ✅ instantiate the service

  Future<void> loadUserData() async {
    try {
      final data = await userService.fetchUserData(); // ✅ use instance method


      final prefs = await SharedPreferences.getInstance();
      userName.value = prefs.getString('username') ?? 'Guest';
      jobRole.value = data?['designation'] ?? 'Unknown Role';
      employeeType.value = data?['emp_type'] ?? 'Unknown type';
      imageUrl.value = data?['image'] ?? '';
      gender.value = data?['gender'] ?? '';

      print("✅ API: User data loaded");
      data?.forEach((key, value) {
        print("🔹 $key: $value");
      });
    } catch (e) {
      print("❌ Failed to load user data: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/login');
    print('🚪 Logged out with GetX');
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Auto load on controller init
  }
}
