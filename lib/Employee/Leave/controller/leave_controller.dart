import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LeaveController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;

  // Manage expanded state per tab and index
  final Map<String, RxSet<int>> expandedItems = {
    'Pending': <int>{}.obs,
    'Approved': <int>{}.obs,
    'Declined': <int>{}.obs,
  };

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void updateDate(int year, int month) {
    selectedYear.value = year;
    selectedMonth.value = month;
  }

  bool isExpanded(String tab, int index) {
    return expandedItems[tab]?.contains(index) ?? false;
  }

  void toggleExpanded(String tab, int index) {
    if (expandedItems[tab] == null) return;
    if (expandedItems[tab]!.contains(index)) {
      expandedItems[tab]!.remove(index);
    } else {
      expandedItems[tab]!.add(index);
    }
    // Notify listeners
    expandedItems[tab]!.refresh();
  }
}
