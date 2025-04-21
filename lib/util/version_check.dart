import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../API/Services/version_service.dart'; // Required for rendering HTML in description

void showUpdateDialog(
    {required String title,
      required String description,
      required String updateButtonText,
      required String skipButtonText,
      required bool showSkip,
      void Function()? onPressed}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => showSkip ? true : false, // Prevent closing with back button
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Wrap the content in a Flexible + SingleChildScrollView
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Html(
                        data: description,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  showSkip
                      ? TextButton(
                    onPressed: () async{
                      Get.back();
                    },
                    child: Text(skipButtonText),
                  )
                      : const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Colors.blue, // Set your primary color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      updateButtonText,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: showSkip, // Allow dismissing by tapping outside if skip is true
  );
}


void checkAppVersion() async {
  // 🔹 Get current app version
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;

  // 🔹 Fetch update info using the current version
  final result = await VersionService.checkAppVersion(appVersion);
  print("versiooon:$appVersion");
  final prefs = await SharedPreferences.getInstance();
  final skipped = prefs.getBool('updateSkipped') ?? false;

  if (skipped) return;

  if (result != null) {
    final isUpdateAvailable = result['check']?.toString().trim() == "1";
    final isMandatory = result['mandatory']?.toString().trim() == "1";
    final message = result['description']?.toString() ?? '';
    final link =result['app_link'].toString();

    if (isMandatory) {
      showUpdateDialog(
        title: "Update Required",
        description: message,
        updateButtonText: "Update Now",
        skipButtonText: "",
        showSkip: false,
        onPressed: () {
          launchUrl(
            Uri.parse(link),
            mode: LaunchMode.externalApplication,
          );
        },
      );
    } else if (isUpdateAvailable) {
      showUpdateDialog(
        title: "Update Available",
        description: message,
        updateButtonText: "Update Now",
        skipButtonText: "Skip",
        showSkip: true,
        onPressed: () async {
          launchUrl(
            Uri.parse(link),
            mode: LaunchMode.externalApplication,
          );
          Get.back();
        },
      );
    }
  }
}
