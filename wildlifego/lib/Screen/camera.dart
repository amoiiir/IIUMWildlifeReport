import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wildlifego/Screen/camera_screen.dart';

class CameraPage extends StatefulWidget {
  final CameraController cameraController;

  const CameraPage({super.key, required this.cameraController});

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
        actions: [
    IconButton(
      icon: const Icon(Icons.photo_library),
      onPressed: () async {
        final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (imageFile != null) {
          // Handle the selected image file
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imageFile: File(imageFile.path),
                  ),
                ),
              );
        }
      },
    ),
  ],
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(widget.cameraController),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child : Align(
            alignment: Alignment.center,
            child: CustomPaint(
              painter: GridLinePainter(),
              child: Container(),
            ),
          ),
          ),
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

class GridLinePainter extends CustomPainter {
  final Paint gridPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double cellWidth = width / 3;
    final double cellHeight = height / 3;

    for (int i = 1; i < 3; i++) {
      final double x = cellWidth * i;
      final double y = cellHeight * i;
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(GridLinePainter oldDelegate) => false;
}
