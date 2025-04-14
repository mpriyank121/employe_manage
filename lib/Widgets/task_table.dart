import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:employe_manage/Widgets/Reason_view_button.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import '../API/Services/Task_service.dart';
import 'package:intl/intl.dart';

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
  final int _limit = 15;
  final ScrollController _scrollController = ScrollController();
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTasks();
    _scrollController.addListener(_scrollListener);
  }
  void _showDescriptionBottomSheet(Map<String, dynamic> task) {
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
                Text(task['bod'] ?? 'No BOD task'),
                const SizedBox(height: 12),
                const Text("BOD Description", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(task['bodDesc'] ?? 'No BOD description'),

                const Divider(height: 30),

                const Text("EOD Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(task['eod'] ?? 'No EOD task'),
                const SizedBox(height: 12),
                const Text("EOD Description", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(task['eodDesc'] ?? 'No EOD description'),
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
        offset: (_page - 1) * _limit,
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
        if (filteredTasks.length < _limit) _hasMore = false;
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (!_isLoading && _hasMore) {
        fetchTasks();
      }
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            " Average Rating: ${_averageRating.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => fetchTasks(isRefreshing: true),
            child: _hasError
                ? Center(child: Text("❌ Error fetching tasks. Try again."))
                : _tasks.isEmpty && !_isLoading
                ? Center(child: Text("📭 No tasks found for selected dates."))
                : ListView.builder(
              controller: _scrollController,
              itemCount: _tasks.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _tasks.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
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
                      ReasonViewButton(
                        onPressed: () => _showDescriptionBottomSheet(task),
                        text: "View EOD/BOD",
                      ),


                    ],
                  ),
                );
              },
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
          TextSpan(text: "$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value ?? "N/A"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
