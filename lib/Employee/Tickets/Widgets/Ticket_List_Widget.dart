import 'package:flutter/material.dart';
import '../../../Widgets/No_data_found.dart';

class TicketListWidget extends StatelessWidget {
  final String empId;

  const TicketListWidget({
    Key? key,
    required this.empId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No tickets found'),
    );
  }
}
