import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Slightly rounded corners
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Padding inside the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content size
              crossAxisAlignment: CrossAxisAlignment.start, // Align text left
              children: [
                /// **Title**
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                /// **Separator (Grey Line)**
                const Divider(
                  thickness: 1,
                  color: Colors.grey, // Light grey color
                ),

                const SizedBox(height: 4),

                /// **Content**
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.left, // Left-align content
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),

          /// **Close Button (Top Right)**
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 20, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
