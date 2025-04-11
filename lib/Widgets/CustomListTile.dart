import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class CustomListTile extends StatefulWidget {
  final Map<String, dynamic> item;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final VoidCallback? onFirstButtonPressed;
  final VoidCallback? onSecondButtonPressed;
  final double? widthFactor;

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
  }) : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          width: screenWidth * (widget.widthFactor ?? 0.9),
          margin: const EdgeInsets.all(7),
          decoration: ShapeDecoration(
            color: TileConfig.backgroundColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: TileConfig.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            leading: widget.leading,
            title: widget.title ??
                (widget.item['title'] != null &&
                    widget.item['title']!.isNotEmpty
                    ? Text(
                  widget.item['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
                    : null),
            subtitle: widget.subtitle ??
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    widget.item['subtitle'] ?? "No Date Available",
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.fade,
                    maxLines: _isExpanded ? null : 1, // Expand or trim text
                  ),
                ),
            trailing: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.trailing != null) widget.trailing!,

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
