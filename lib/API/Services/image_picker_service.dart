import 'dart:io';
import 'package:camera/camera.dart';

class CustomCameraService {
  late CameraController controller;

  Future<void> initializeFrontCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(frontCamera, ResolutionPreset.high);
    await controller.initialize();
  }

  Future<File?> captureImage() async {
    if (!controller.value.isInitialized) return null;
    final XFile image = await controller.takePicture();
    return File(image.path); // ✅ Convert XFile to File
  }

  void dispose() {
    controller.dispose();
  }
}
