import 'dart:io';
import 'package:flutter/material.dart';


import 'form_screen.dart';

class DisplayPictureScreen extends StatelessWidget {
  final File imageFile;

  const DisplayPictureScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Container(
        child: GestureDetector(
          child: Stack(
            children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.file(imageFile),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.large(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormScreen(
                          imageFile: File(imageFile.path),
                      ),
                      )
                    );
                    },
                    child: const Icon(Icons.done, color: Colors.black),
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
