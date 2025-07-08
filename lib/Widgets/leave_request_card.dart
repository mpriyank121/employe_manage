import 'package:flutter/material.dart';

class LeaveRequestCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String status;

  const LeaveRequestCard({
    Key? key,
    required this.title,
    required this.dateRange,
    required this.status,
  }) : super(key: key);

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getStatusBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green.shade50;
      case 'pending':
        return Colors.orange.shade50;
      case 'declined':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(dateRange,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getStatusBackgroundColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: getStatusColor(),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.check_circle,
                    size: 16,
                    color:
                        getStatusColor()), // or a timer or cancel icon based on status
              ],
            ),
          )
        ],
      ),
    );
  }
}
