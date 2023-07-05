import 'dart:io';

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
      body: Stack(
        children: <Widget>[
          CameraPreview(widget.cameraController),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: FloatingActionButton.large(
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.camera,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () async {
                  final XFile imageFile =
                      await widget.cameraController.takePicture();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        imageFile: File(imageFile.path),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
