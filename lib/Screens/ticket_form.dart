import 'package:employe_manage/Configuration/app_spacing.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/Ticket_form_custom_container.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../Configuration/style.dart';
import '../Widgets/Custom_multi_select_dialog.dart';
import '../Widgets/Custom_quill_editor.dart';
import '../Widgets/Leave_container.dart';

class TicketForm extends StatelessWidget {
  TicketForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Ticket Form'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.small(context),
            buildLabeledField('Title', TextFormField(controller: _taskTitleController)),
            AppSpacing.small(context),
            buildLabeledField('Description', CustomQuillEditor(controller: _quillController)),
            AppSpacing.small(context),
            buildLabeledField('Date', TextFormField(controller: _dateController)),
            AppSpacing.small(context),
            PrimaryButton(
              onPressed: null, // Disabled
              text: 'Submit',
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: fontStyles.headingStyle),
        LeaveContainer(child: field),
      ],
    );
  }
}
