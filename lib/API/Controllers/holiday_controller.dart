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
  var filteredHolidays = <Holiday>[].obs;
  var allHolidays = <Holiday>[].obs; // ✅ Global cache
  var monthHolidays = <Holiday>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPhoneNumber();
  }

  /// ✅ Load phone number from SharedPreferences
  Future<void> _loadPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');

    if (phone != null) {
      phoneNumber.value = phone;
      await fetchHolidaysForYear(selectedYear.value); // fetch current year on init
    } else {
      print("❌ Phone number not found in SharedPreferences");
    }
  }

  /// ✅ Filter from cached holidays by selected year
  void filterHolidaysBySelectedYear() {
    final year = selectedYear.value;
    filteredHolidays.value = allHolidays.where((holiday) {
      DateTime holidayDate = DateTime.parse(holiday.holiday_date);
      return holidayDate.year == year;
    }).toList();
  }

  /// ✅ Called when year changes in selector
  void updateYear(int newYear) async {
    selectedYear.value = newYear;
    isLoading.value = true;

    try {
      final phone = phoneNumber.value ?? await _getPhoneFromPrefs();
      if (phone == null) return;

      phoneNumber.value = phone;

      final holidays = await _userService.fetchHolidays(phone); // Optional: send year if needed
      allHolidays.value = holidays;
      filteredHolidays.value = holidays.where((h) {
        final date = DateTime.parse(h.holiday_date);
        return date.year == newYear;
      }).toList();
    } catch (e) {
      print("❌ Error: $e");
      allHolidays.clear();
      filteredHolidays.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _getPhoneFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }


  /// ✅ Fetch holidays from API for specific year only
  Future<void> fetchHolidaysForYear(int year) async {
    if (phoneNumber.value == null) return;
    isLoading.value = true;

    try {
      List<Holiday> fetched = await _userService.fetchHolidays(phoneNumber.value!);

      // Extract only the holidays of that year
      List<Holiday> yearHolidays = fetched.where((h) {
        final date = DateTime.parse(h.holiday_date);
        return date.year == year;
      }).toList();

      // Add to global cache
      allHolidays.addAll(yearHolidays);

      // Update filtered view
      filteredHolidays.value = yearHolidays;
    } catch (e) {
      print("❌ Error fetching holidays: $e");
      filteredHolidays.clear(); // show empty if API fails
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Filter holidays by month (optional use)
  void fetchHolidaysByMonth(int month) {
    if (allHolidays.isEmpty) {
      print("⚠️ No holiday data available to filter.");
      return;
    }

    monthHolidays.value = allHolidays.where((holiday) {
      final date = DateFormat("yyyy-MM-dd").parse(holiday.holiday_date);
      return date.year == selectedYear.value && date.month == month;
    }).toList();

    print("📅 Holidays for month $month | Found: ${monthHolidays.length}");
  }
}
