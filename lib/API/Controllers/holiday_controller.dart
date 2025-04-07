import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:employe_manage/API/models/holiday_model.dart';

class HolidayController extends GetxController {
  final UserService _userService = UserService();

  /// ✅ Reactive state variables
  var selectedYear = DateTime.now().year.obs;
  var phoneNumber = RxnString(null);
  var allHolidays = <Holiday>[].obs; // ✅ Stores full year's holidays
  var monthHolidays = <Holiday>[].obs; // ✅ Stores only current month's holidays
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPhoneNumber();
  }

  /// ✅ Fetch phone number and holidays
  Future<void> _loadPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');

    if (phone != null) {
      phoneNumber.value = phone;
      fetchHolidays();
    } else {
      print("❌ Phone number not found in SharedPreferences");
    }
  }

  /// ✅ Fetch holidays from API
  Future<void> fetchHolidays() async {
    if (phoneNumber.value == null) return;

    isLoading.value = true;

    try {
      List<Holiday> fetchedHolidays = await _userService.fetchHolidays(phoneNumber.value!);

      // ✅ Store full year's holidays
      allHolidays.value = fetchedHolidays.where((holiday) {
        return DateTime.parse(holiday.holiday_date).year == selectedYear.value;
      }).toList();

      // ✅ Filter for the current month
      int currentMonth = DateTime.now().month;
      monthHolidays.value = allHolidays.where((holiday) {
        DateTime holidayDate = DateFormat("yyyy-MM-dd").parse(holiday.holiday_date);
        return holidayDate.month == currentMonth;
      }).toList();
    } catch (error) {
      print("❌ Error fetching holidays: $error");
      allHolidays.clear();
      monthHolidays.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Update year and fetch holidays again
  void updateYear(int newYear) {
    selectedYear.value = newYear;
    fetchHolidays();
    fetchHolidaysByMonth(DateTime.now().month); // Initialize current month view

  }
  /// 🔁 Fetch holidays for a specific month (uses already loaded allHolidays list)
  void fetchHolidaysByMonth(int month) {
    if (allHolidays.isEmpty) {
      print("⚠️ No holiday data available to filter. Make sure fetchHolidays() has run.");
      return;
    }

    monthHolidays.value = allHolidays.where((holiday) {
      DateTime holidayDate = DateFormat("yyyy-MM-dd").parse(holiday.holiday_date);
      return holidayDate.month == month && holidayDate.year == selectedYear.value;
    }).toList();

    print("📅 Holidays updated for month: $month | Found: ${monthHolidays.length}");
  }

}
