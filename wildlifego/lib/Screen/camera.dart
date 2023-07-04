import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/Screen/camera_screen.dart';

class CameraPage extends StatefulWidget {
  final CameraController cameraController;

  const CameraPage({required this.cameraController});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    startCameraPreview();
  }

  void startCameraPreview() async {
    try {
      await widget.cameraController.startImageStream((CameraImage image) {
        // Handle camera image stream
      });
    } catch (e) {
      print("Error starting camera stream: $e");
    }
  }

  @override
  void dispose() {
    widget.cameraController.stopImageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Issue Report"),
      ),
      body: CameraPreview(widget.cameraController),
      // Additional UI or functionality can be added here
    );
  }
}
