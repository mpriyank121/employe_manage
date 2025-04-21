import 'package:employe_manage/Widgets/Leave_container.dart';
import 'package:flutter/material.dart';

class CustomMultiSelectDialogField extends StatefulWidget {
  final List<Map<String, String>> items; // {'value': '1', 'label': 'HR'}
  final List<String> initialValue;
  final String title;
  final String buttonText;
  final Function(List<String>) onConfirm;

  const CustomMultiSelectDialogField({
    Key? key,
    required this.items,
    required this.initialValue,
    required this.title,
    required this.buttonText,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<CustomMultiSelectDialogField> createState() => _CustomMultiSelectDialogFieldState();
}

class _CustomMultiSelectDialogFieldState extends State<CustomMultiSelectDialogField> {
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = List.from(widget.initialValue);
  }

  void _showMultiSelectDialog() async {
    List<String> tempSelected = List.from(selectedValues);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(widget.title),
              content: SingleChildScrollView(
                child: Column(
                  children: widget.items.map((item) {
                    final isChecked = tempSelected.contains(item['value']);
                    return CheckboxListTile(
                      value: isChecked,
                      title: Text(item['label']!),
                      onChanged: (bool? checked) {
                        setStateDialog(() {
                          if (checked == true) {
                            tempSelected.add(item['value']!);
                          } else {
                            tempSelected.remove(item['value']);
                          }
                        });
                      },
                      activeColor: Color(0xFFF25922), // Selected checkbox color

                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CANCEL",style: TextStyle(color: Color(0xFFF25922)), // Cancel button color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedValues = List.from(tempSelected);
                    });
                    widget.onConfirm(selectedValues);
                    Navigator.pop(context);
                  },
                  child: const Text("OK",style: TextStyle(color:Color(0xFFF25922)), // Cancel button color
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedLabels = widget.items
        .where((item) => selectedValues.contains(item['value']))
        .map((item) => item['label'])
        .join(', ');

    return GestureDetector(
      onTap: _showMultiSelectDialog,
      child: LeaveContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedLabels.isEmpty ? widget.buttonText : selectedLabels,
                style: TextStyle(
                  color: selectedLabels.isEmpty ? Colors.black54 : Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
