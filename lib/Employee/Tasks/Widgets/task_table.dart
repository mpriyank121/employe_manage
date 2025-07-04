import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No tasks available"),
    );
  }
}