import 'dart:io';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final File imageFile;

  const DisplayPictureScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Container(
        width: 1080,
        height: 1920,
        child: GestureDetector(
          child: Stack(
            children: [
              Expanded(
                child: Image.file(imageFile),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.large(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      //uploadFile();
                    },
                    child: const Icon(Icons.upload, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          onDoubleTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
