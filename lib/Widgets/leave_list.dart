import 'package:flutter/material.dart';
import '../API/models/leave_model.dart';
import 'custom_button.dart';

class LeaveList extends StatelessWidget {
  final List<LeaveModel> items;

  const LeaveList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Center(child: Text("No leaves available"))
        : ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var leave = items[index];
        return ListTile(
          leading: Icon(Icons.event_note),
          title: Text(leave.leaveName),
          subtitle: Text("From: ${leave.startDate} To: ${leave.endDate}"),
          trailing: CustomButton(),
        );
      },
    );
  }
}
