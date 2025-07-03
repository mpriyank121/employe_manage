import 'package:employe_manage/Configuration/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class CustomQuillEditor extends StatelessWidget {
  final QuillController controller;
  final TextEditingController? taskTitleController;

  const CustomQuillEditor({
    Key? key,
    required this.controller,
    this.taskTitleController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (taskTitleController != null)
          TextField(
            controller: taskTitleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
        // QuillToolbar.basic(controller: controller),
        Container(
          height: 150,
          child: QuillEditor.basic(
            controller: controller,

          ),
        ),
      ],
    );
  }
}