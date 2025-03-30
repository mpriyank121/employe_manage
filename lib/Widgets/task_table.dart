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

  @override
  void initState() {
    super.initState();
    fetchTasks();
    _scrollController.addListener(_scrollListener);
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
      );

      // Filter tasks based on date range
      if (widget.startDate != null && widget.endDate != null) {
        tasks = tasks.where((task) {
          DateTime taskDate = DateFormat('yyyy-MM-dd').parse(task['date']);
          return taskDate.isAfter(widget.startDate!.subtract(Duration(days: 1))) &&
              taskDate.isBefore(widget.endDate!.add(Duration(days: 1)));
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
      });
    } catch (e) {
      print("Error: $e");
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
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => fetchTasks(isRefreshing: true),
              child: ListView.builder(
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
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: task['date'] ?? "N/A"),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "BOD Task: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: task['bod'] ?? "N/A"),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "EOD Task: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: task['eod'] ?? "N/A"),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Hours: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: task['hours'] ?? "N/A"),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Rating: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: task['rating'] ?? "N/A"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (!_hasMore && _tasks.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No more tasks"),
            ),
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
