import 'package:employe_manage/Configuration/app_spacing.dart';
import 'package:employe_manage/Widgets/Action_button.dart';
import 'package:employe_manage/Widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Controllers/policy_list_controller.dart';
import '../API/Services/policy_list_service.dart';
import 'No_data_found.dart';
import '../Widgets/CustomListTile.dart';
import 'Reason_view_button.dart';

class PolicyListWidget extends StatefulWidget {
  final String empId;

  const PolicyListWidget({
    Key? key,
    required this.empId,
  }) : super(key: key);

  @override
  State<PolicyListWidget> createState() => _PolicyListWidgetState();
}

class _PolicyListWidgetState extends State<PolicyListWidget> {
  List<dynamic> policies = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  final int limit = 100;
  String? errorMessage;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    loadPolicies();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMorePolicies();
    }
  }

  Future<void> loadPolicies({int page = 1}) async {
    if (page == 1) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int superUser = prefs.getInt('super_user') ?? 0;

      List<dynamic> fetchedPolicies = await fetchPolicies(
        empId: widget.empId,
        limit: limit,
        page: page,
        superUser: superUser,
      );

      setState(() {
        if (page == 1) {
          policies = fetchedPolicies;
        } else {
          policies.addAll(fetchedPolicies);
        }
        hasMore = fetchedPolicies.length == limit;
        currentPage = page;
      });
    } catch (e) {
      if (page > 1) return;
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (page == 1) {
        setState(() => isLoading = false);
      } else {
        setState(() => isLoadingMore = false);
      }
    }
  }
  Future<void> _loadMorePolicies() async {
    if (!isLoadingMore && hasMore) {
      setState(() => isLoadingMore = true);
      await loadPolicies(page: currentPage + 1);
    }
  }
  bool _isExpanded(int index) => _expandedIndex == index;

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return const NoDataWidget(
        message: "No policies found",
        imagePath: "assets/images/Error_image.png",
      );
    }

    if (policies.isEmpty) {
      return const Center(child: Text("No policies found"));
    }
    final PolicyController controller = Get.put(PolicyController());

    return ListView.builder(
      itemCount: policies.length,
      itemBuilder: (context, index) {
        final policy = policies[index];
        final policyId = int.parse(policy['id'].toString());

        return Obx(() {
          final isExpanded = controller.isExpanded(index);
          final actionStatus = controller.policyActions[policyId] ?? policy['status'] ?? 'Unknown';

          return GestureDetector(
            onTap: () => controller.toggleExpanded(index),  // Toggle expansion on tap
            child: CustomListTile(
              title:Padding(padding: EdgeInsets.only(top: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                '${index + 1}.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              AppSpacing.medium(context),
              Expanded(
                child: Text(
                  (policy['policy_name'] ?? 'Unnamed Policy').replaceAll('\n', ''),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              ],
            ),),
              trailing:_buildStatusIcon(actionStatus),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isExpanded) ...[
                      AppSpacing.small(context),
                      _buildPolicyDetail("Address", Text(policy['address'])),
                      AppSpacing.small(context),
                      _buildPolicyDetail("Accepted on", Text(policy['created_at'])),
                      AppSpacing.small(context),
                      _buildPolicyDetail(
                        "Read at",
                        ReasonViewButton(
                          widthFactor: 0.3,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PDFViewerScreen(
                                  url: policy['policy_details'],
                                  title:policy['policy_name'].replaceAll('\n', ''),
                                ),
                              ),
                            );
                          },
                          text: "Read",
                        ),
                      ),
                      AppSpacing.small(context),
                      if (actionStatus != 'Agree') ...[
                        Column(children: [Divider(
                          color: Color(0xFFE6E6E6),      // Divider color
                          thickness: 2.0,          // Divider thickness
                        ),Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            ActionButton(
                              widthFactor: 0.42,
                              label: 'Agree',
                              bgColor: Colors.green.shade100,
                              textColor: Colors.green.shade800,
                              onPressed: () async {
                                final success = await handlePolicyAction(policyId, '1');
                                if (success) {
                                  controller.setPolicyAction(policyId, 'Agree');
                                  controller.toggleExpanded(index);

                                  final prefs = await SharedPreferences.getInstance();
                                  final superUser = prefs.getInt('super_user') ?? 0;

                                  await controller.updatePolicyFromApi(
                                    empId: widget.empId,
                                    limit: 100,
                                    page: 1,
                                    superUser: superUser,
                                  );

                                  setState(() {
                                    policies = controller.policyList;
                                  });
                                }
                              },

                            ),
                            ActionButton(
                              widthFactor: 0.42,
                              label: 'Disagree',
                              bgColor: Colors.red.shade100,
                              textColor: Colors.red.shade800,
                              onPressed: () async {
                                final success = await handlePolicyAction(policyId, '2');
                                if (success) {
                                  controller.setPolicyAction(policyId, 'Disagree');
                                  controller.toggleExpanded(index);

                                  final prefs = await SharedPreferences.getInstance();
                                  final superUser = prefs.getInt('super_user') ?? 0;

                                  await controller.updatePolicyFromApi(
                                    empId: widget.empId,
                                    limit: 100,
                                    page: 1,
                                    superUser: superUser,
                                  );
                                  setState(() {
                                    policies = controller.policyList;
                                  });
                                }
                              },
                            ),
                          ],
                        ),],)

                      ],
                    ],
                  ],
                ),
              ),
            ),

          );
        });
      },
    );

  }

  Widget _buildPolicyDetail(String title, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: valueWidget,
          ),
        ],
      ),
    );
  }
  Widget _buildStatusIcon(String status) {
    if (status == 'Agree') {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.check, color: Colors.green, size: 20),
      );
    } else if (status == 'Disagree') {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.close, color: Colors.red, size: 20),
      );
    } else {
      return const SizedBox(); // No icon for other statuses
    }
  }

}
