import 'package:employe_manage/Configuration/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class CustomQuillEditor extends StatefulWidget {
  final QuillController controller;
  final TextEditingController taskTitleController;
  final bool showTaskFields;
  final bool showDescriptionField; // New parameter to toggle fields

  const CustomQuillEditor({
    Key? key,
    required this.controller,
    required this.taskTitleController,
    this.showTaskFields = true, // Default: Show fields
    this.showDescriptionField = true, // Default: Show description label

  }) : super(key: key);

  @override
  _CustomQuillEditorState createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  final FocusNode _editorFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ Show task title fields only if showTaskFields is true
        if (widget.showTaskFields) ...[
          Text("Today's To-do Heading", style: fontStyles.headingStyle),
          TextField(
            controller: widget.taskTitleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (widget.showDescriptionField)
          Text("To-do's description", style: fontStyles.headingStyle),
        // ✅ Quill Editor with Toolbar
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: widget.controller,
                config: QuillSimpleToolbarConfig(
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showIndent: false,
                  showAlignmentButtons: false,
                  showFontFamily: false,
                  showLink: true,
                  showQuote: true,
                  showInlineCode: false,
                  showStrikeThrough: false,
                  showFontSize: false,
                  showBackgroundColorButton: false,
                  showColorButton: false,
                  showCodeBlock: false,
                  showListCheck: true,
                  showDirection: false,
                  showClearFormat: false,
                  showHeaderStyle: false,
                  showSearchButton: false,
                  showRedo: false,
                  showUndo: false,
                ),
              ),
              Divider(color: Colors.grey), // Separator
              Container(
                height: screenHeight * 0.2,
                padding: const EdgeInsets.all(12),
                child: QuillEditor.basic(
                  controller: widget.controller,
                  focusNode: _editorFocusNode,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    super.dispose();
  }
}
