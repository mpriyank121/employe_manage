import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraPreviewScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraPreviewScreen({required this.camera, Key? key}) : super(key: key);

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    await _initializeControllerFuture;
    final image = await _controller.takePicture();
    setState(() {
      _capturedImage = image;
    });
  }

  void _confirmImage() {
    if (_capturedImage != null) {
      Navigator.pop(context, _capturedImage);
    }
  }

  void _retakeImage() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Positioned.fill(
                child: _capturedImage == null
                    ? Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: CameraPreview(_controller),
                      ),
                    )
                    ,
                  ),
                )
                    : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
              ),
              // Top back button
              Positioned(
                top: 40,
                left: 20,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Bottom control buttons
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: _capturedImage == null
                    ? Center(
                  child: FloatingActionButton(
                    onPressed: _captureImage,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.camera_alt, color: Colors.black),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _retakeImage,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retake"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _confirmImage,
                      icon: const Icon(Icons.check),
                      label: const Text("Use Photo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
