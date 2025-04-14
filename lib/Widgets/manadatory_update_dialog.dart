import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void showMandatoryUpdateDialog(String message) {
  Get.defaultDialog(
    title: "Update Required",
    content: Text(message),
    barrierDismissible: false,
    confirm: ElevatedButton(
      onPressed: () {
        launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=your.package.name"));
      },
      child: Text("Update Now"),
    ),
  );
}

void showOptionalUpdateDialog(String message) {
  Get.defaultDialog(
    title: "Update Available",
    content: Text(message),
    barrierDismissible: false,
    confirm: ElevatedButton(
      onPressed: () {
        launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=your.package.name"));
      },
      child: Text("Update"),
    ),
    cancel: TextButton(
      onPressed: () {
        Get.back(); // dismiss the dialog
      },
      child: Text("Skip"),
    ),
  );
}
