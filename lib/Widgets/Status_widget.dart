import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String? status;

  const StatusWidget({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status?.toLowerCase()) {
      case "approved":
        bgColor = Color(0xFF3CAB88);
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case "requested":
        bgColor = Color(0xFFFF8F00);
        textColor = Colors.white;
        icon = Icons.access_time;
        break;
      case "rejected":
        bgColor = Color(0xFFC62828);
        textColor = Colors.white;
        icon = Icons.cancel;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status ?? "Unknown",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Icon(icon, color: textColor, size: 18),
        ],
      ),
    );
  }
}
