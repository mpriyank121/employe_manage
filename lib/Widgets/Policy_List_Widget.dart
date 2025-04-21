import 'package:employe_manage/Widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Services/policy_list_service.dart';
import 'No_data_found.dart';
import '../Widgets/CustomListTile.dart';

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

    return ListView.builder(
      controller: _scrollController,
      itemCount: policies.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == policies.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        var policy = policies[index];

        return CustomListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPolicyDetail("Policy Name", policy['policy_name']),
              _buildPolicyDetail("Address", policy['address']),
              _buildPolicyDetail("Created At", policy['created_at']),
              _buildPolicyDetail("Status", policy['status']),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PDFViewerScreen(
                        url: policy['policy_details'],
                        title: "Policy",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text("View PDF", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPolicyDetail(String title, String? value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value ?? "N/A"),
        ],
      ),
    );
  }
}
