import 'package:employe_manage/Configuration/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class CustomQuillEditor extends StatefulWidget {
  final QuillController controller;
  final TextEditingController taskTitleController;
  final bool showTaskFields;
  final bool showDescriptionField;
  final FocusNode? focusNode; // 🔽 Add this

  const CustomQuillEditor({
    Key? key,
    required this.controller,
    required this.taskTitleController,
    this.showTaskFields = true,
    this.showDescriptionField = true,
    this.focusNode, // 🔽 Optional for safe use

  }) : super(key: key);

  @override
  _CustomQuillEditorState createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  embedButtons: FlutterQuillEmbeds.toolbarButtons(

                    videoButtonOptions: QuillToolbarVideoButtonOptions(


                    )
                  ),
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: false,
                  showListBullets: true,
                  showListNumbers: true,
                  showLink: false,
                  showListCheck: true,
                  showClipboardPaste: false,
                  showIndent: false,
                  showAlignmentButtons: false,
                  showFontFamily: false,
                  showQuote: false,
                  showInlineCode: false,
                  showStrikeThrough: false,
                  showFontSize: false,
                  showBackgroundColorButton: false,
                  showColorButton: false,
                  showCodeBlock: false,
                  showDirection: false,
                  showClearFormat: false,
                  showHeaderStyle: false,
                  showSearchButton: false,
                  showRedo: false,
                  showUndo: false,
                    showSubscript:false,
                  showSuperscript: false


                ),
              ),
              const Divider(color: Colors.grey),
              Container(
                height: screenHeight * 0.4,
                padding: const EdgeInsets.all(12),
                child: QuillEditor(
                  controller: widget.controller,
                  focusNode: widget.focusNode ?? _editorFocusNode,
                  scrollController: _editorScrollController,

                  config: QuillEditorConfig(
                    placeholder: 'Description',
                    embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                  ),
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
    _editorScrollController.dispose();
    super.dispose();
  }
}
