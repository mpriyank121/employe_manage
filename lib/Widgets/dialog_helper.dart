import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showAppDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = "OK",
  VoidCallback? onConfirm,
}) {
  return showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: Text(confirmText),
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm();
          },
        ),
      ],
    ),
  );
}
