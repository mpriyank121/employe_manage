import 'package:employe_manage/Widgets/CustomListTile.dart';
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
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTasks();
    _scrollController.addListener(_scrollListener);
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

      if (widget.startDate != null && widget.endDate != null) {
        DateFormat apiDateFormat = DateFormat('dd MMM, yyyy hh:mm a');
        tasks = tasks.where((task) {
          try {
            DateTime taskDate = apiDateFormat.parse(task['date']);
            return taskDate.isAfter(widget.startDate!.subtract(Duration(days: 1))) &&
                taskDate.isBefore(widget.endDate!.add(Duration(days: 1)));
          } catch (e) {
            print("⚠️ Date Parse Error: $e");
            return false;
          }
        }).toList();
      }

      setState(() {
        if (tasks.length < _limit) _hasMore = false;
        if (isRefreshing) {
          _tasks = tasks;
          _page = 2;
        } else {
          _tasks.addAll(tasks);
          _page++;
        }
        _calculateAverageRating();
      });
    } catch (e) {
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
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
                  heightFactor: 0.15,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTaskDetail("Date", task['date']),
                      _buildTaskDetail("BOD Task", task['bod']),
                      _buildTaskDetail("EOD Task", task['eod']),
                      _buildTaskDetail("Hours", task['hours']),
                      _buildTaskDetail("Rating", task['rating']),
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
