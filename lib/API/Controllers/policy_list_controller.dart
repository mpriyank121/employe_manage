import 'package:get/get.dart';

import '../Services/policy_list_service.dart';
class PolicyController extends GetxController {
  final expandedIndex = RxnInt(); // nullable int
  final policyActions = <int, String>{}.obs; // map of policyId to status
  var policyList = <dynamic>[].obs;

  void toggleExpanded(int index) {
    expandedIndex.value = (expandedIndex.value == index) ? null : index;
  }

  void setPolicyAction(int policyId, String status) {
    policyActions[policyId] = status;

  }
  bool isExpanded(int index) => expandedIndex.value == index;
  Future<void> updatePolicyFromApi({
    required String empId,
    required int limit,
    required int page,
    required int superUser,
  }) async {
    try {
      List<dynamic> updatedPolicies = await fetchPolicies(
        empId: empId,
        limit: limit,
        page: page,
        superUser: superUser,
      );

      policyList.value = updatedPolicies;
    } catch (e) {
      print('Error updating policies from API: $e');
    }
  }
}
