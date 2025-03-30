import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class CustomListTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final VoidCallback? onFirstButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final double? widthFactor;
  final double? heightFactor;

  const CustomListTile({
    Key? key,
    this.item = const {},
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.onFirstButtonPressed,
    this.onSecondButtonPressed,
    this.widthFactor,
    this.heightFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;  // ✅ Get Screen Width
    double screenHeight = MediaQuery.of(context).size.height; // ✅ Get Screen Height

    return Container(
      width: screenWidth * (widthFactor ?? 0.9),   // ✅ Custom Width
      height: screenHeight * (heightFactor ?? 0.1), // ✅ Custom Height
      margin: const EdgeInsets.all(7),
      decoration: ShapeDecoration(
        color: TileConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: TileConfig.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: leading,
        title: title ??
            (item['title'] != null && item['title']!.isNotEmpty
                ? Text(
              item['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
                : null), // ✅ Null hides the title without taking space

        subtitle: subtitle ??
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item['subtitle'] ?? "No Date Available",
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // ✅ Ensures subtitle remains in one line
              ),
            ),
        trailing: IntrinsicHeight( // ✅ Prevents overflow by adapting to content size
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
