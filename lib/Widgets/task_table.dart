import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:employe_manage/Widgets/Reason_view_button.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import '../API/Services/Task_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import '../Configuration/app_spacing.dart';
import 'No_data_found.dart';

class TaskListWidget extends StatefulWidget {
  final String employeeId;
  final DateTime? startDate;
  final DateTime? endDate;

  const TaskListWidget({
    Key? key,
    required this.employeeId,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  List<dynamic> _tasks = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 200;
  final ScrollController _scrollController = ScrollController();
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTasks();
    _scrollController.addListener(_scrollListener);
  }

  void _showDescriptionBottomSheet(Map<String, dynamic> task) {
    print("eoood: ${task['eodDesc'] ?? '<p>No EOD description</p>'}");
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Text("BOD Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Html(
                  data: task['bod'] ?? '<p>No BOD task</p>',
                ),
                const SizedBox(height: 12),
                const Text("BOD Description", style: TextStyle(fontWeight: FontWeight.bold)),
                Html(
                  data: task['bodDesc'] ?? '<p>No BOD description</p>',
                ),
                const Divider(height: 30),
                const Text("EOD Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Html(
                  data: task['eod'] ?? '<p>No EOD task</p>',
                ),
                const SizedBox(height: 12),
                const Text("EOD Description", style: TextStyle(fontWeight: FontWeight.bold)),
                Html(
                  data: task['eodDesc'] ?? '<p>No EOD description</p>',
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _calculateAverageRating() {
    if (_tasks.isEmpty) {
      _averageRating = 0.0;
      return;
    }
    double totalRating = 0;
    int count = 0;

    for (var task in _tasks) {
      if (task['rating'] != null) {
        try {
          totalRating += double.parse(task['rating'].toString());
          count++;
        } catch (e) {
          print("⚠️ Rating Parse Error: $e");
        }
      }
    }

    _averageRating = count > 0 ? totalRating / count : 0.0;
  }

  Future<void> fetchTasks({bool isRefreshing = false}) async {
    if (_isLoading || (!_hasMore && !isRefreshing)) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      if (isRefreshing) {
        _tasks.clear();
        _page = 1;
        _hasMore = true;
      }
    });

    try {
      List<dynamic> tasks = await TaskService.fetchTaskList(
        widget.employeeId,
        limit: _limit,
        offset: _page ,
        startDate: widget.startDate,
        endDate: widget.endDate,
      );

      final existingIds = _tasks.map((e) => e['id']).toSet(); // Avoid duplicates
      final apiDateFormat = DateFormat('dd MMM, yyyy hh:mm a');

      final filteredTasks = tasks.where((task) {
        try {
          DateTime taskDate = apiDateFormat.parse(task['date']);
          bool isInRange = widget.startDate != null && widget.endDate != null
              ? taskDate.isAfter(widget.startDate!.subtract(const Duration(days: 1))) &&
              taskDate.isBefore(widget.endDate!.add(const Duration(days: 1)))
              : true;
          return isInRange && !existingIds.contains(task['id']);
        } catch (e) {
          print("⚠️ Date Parse Error: $e");
          return false;
        }
      }).toList();

      // Sort ascending
      filteredTasks.sort((a, b) {
        try {
          DateTime dateB = apiDateFormat.parse(a['date']);
          DateTime dateA = apiDateFormat.parse(b['date']);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

      setState(() {
        _tasks.addAll(filteredTasks);
        _hasMore = filteredTasks.length >= _limit;
        _page++;
        _calculateAverageRating();
      });
    } catch (e) {
      print("❌ Error fetching tasks: $e");
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    // Check if we're near the bottom of the list
    if (_scrollController.position.extentAfter < 200 && !_isLoading && _hasMore) {
      print("📜 Loading more tasks. Current page: ${_page-1}, Next page: $_page");
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: screenWidth * 0.9,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Average Rating: ${_averageRating.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        AppSpacing.small(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => fetchTasks(isRefreshing: true),
            child: _hasError
                ? NoDataWidget(
              message: "Error loading tasks",
              imagePath: "assets/images/Error_image.png",
            )
                : _tasks.isEmpty && !_isLoading
                ? NoDataWidget(
              message: "No tasks found for selected date",
              imagePath: "assets/images/Error_image.png",
            )
                : Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: _tasks.length + 1, // +1 for loading indicator
                  itemBuilder: (context, index) {
                    if (index == _tasks.length) {
                      // This will be our footer loading indicator
                      return _hasMore
                          ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : index > 0
                          ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "No more tasks to load",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                          : const SizedBox.shrink();
                    }

                    var task = _tasks[index];

                    return CustomListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTaskDetail("Date", task['date']),
                          _buildTaskDetail("BOD Task", task['bod']),
                          _buildTaskDetail("EOD Task", task['eod']),
                          _buildTaskDetail("Hours", task['hours']),
                          _buildTaskDetail("Rating", task['rating']),
                          // ReasonViewButton(
                          //   onPressed: () => _showDescriptionBottomSheet(task),
                          //   text: "View EOD/BOD",
                          // ),
                        ],
                      ),
                    );
                  },
                ),
                if (_isLoading && _tasks.isEmpty)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetail(String title, String? value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value ?? "N/A"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}