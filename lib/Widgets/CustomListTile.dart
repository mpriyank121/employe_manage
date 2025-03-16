import 'package:flutter/material.dart';

import '../Configuration/app_cards.dart';

class CustomListTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final Widget? leading;
  final Widget? trailing;

  const CustomListTile({Key? key, required this.item, this.leading, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: TileConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: TileConfig.borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: ListTile(
        leading: leading, // ✅ Leading widget (used for holiday list)
        title: Text(item['title'] ?? "No Title", style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(item['subtitle'] ?? "No Date Available", style: const TextStyle(color: Colors.grey)),
        ),
        trailing: trailing, // ✅ Trailing widget (used for leave list)
      ),
    );
  }
}
