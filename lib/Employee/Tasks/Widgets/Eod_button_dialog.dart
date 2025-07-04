import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Employee/Tasks/Widgets/Custom_quill_editor.dart';
import 'package:employe_manage/Widgets/primary_button.dart';

class Eodbuttondialog extends StatefulWidget {
  @override
  _EodbuttondialogState createState() => _EodbuttondialogState();
}

class _EodbuttondialogState extends State<Eodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('EOD Dialog'),
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
