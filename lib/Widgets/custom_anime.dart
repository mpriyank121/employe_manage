import 'package:flutter/material.dart';

class CustomAnime extends StatelessWidget {
  final String initialText;

  const CustomAnime({super.key, required this.initialText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: initialText == "Approved" ? Colors.green[300] :
        initialText == "Pending" ? Colors.orange[300] :
        Colors.red[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        initialText,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
