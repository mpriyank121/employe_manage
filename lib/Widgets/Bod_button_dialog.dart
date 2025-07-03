import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'Custom_quill_editor.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';

class Bodbuttondialog extends StatefulWidget {
  @override
  _BodbuttondialogState createState() => _BodbuttondialogState();
}

class _BodbuttondialogState extends State<Bodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('BOD Dialog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskTitleController,
            decoration: InputDecoration(labelText: 'Task Title'),
          ),
          SizedBox(height: 10),
          CustomQuillEditor(controller: _quillController),
        ],
      ),
      actions: [
        PrimaryButton(
          text: 'Submit',
          onPressed: null, // Disabled
        ),
      ],
    );
  }
}
