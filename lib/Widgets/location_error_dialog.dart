import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void showLocationErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Location Required"),
      content: const Text("Please enable GPS/location services to proceed."),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await Geolocator.openLocationSettings();
          },
          child: const Text("Open Settings"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
}
