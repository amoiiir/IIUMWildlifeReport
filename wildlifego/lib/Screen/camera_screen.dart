import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  // Future<void> uploadFile() async {
  //   try {
  //     // Create a reference to the image file in Firebase Storage
  //     String fileName = DateTime.now().toString();
  //     Reference reference =
  //         FirebaseStorage.instance.ref().child('images/$fileName');

  //     // Upload the file to Firebase Storage
  //     TaskSnapshot taskSnapshot = await reference.putFile(File(imagePath));

  //     // Get the download URL of the uploaded file
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();

  //     // Print the download URL
  //     print('Download URL: $downloadURL');
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Preview')),
      body: Container(
        width: 1080,
        height: 1920,
        child: GestureDetector(
          // child: Stack(
          //   children: [
          //     Expanded(
          //       child: Image.file(File(imagePath)),
          //     ),
          //     const SizedBox(height: 10),
          //     Align(
          //         alignment: Alignment.bottomCenter,
          //         child: Container(
          //             margin: const EdgeInsets.only(bottom: 20),
          //             alignment: Alignment.bottomCenter,
          //             child: FloatingActionButton.large(
          //               backgroundColor: Colors.white,
          //               onPressed: () async {
          //                 uploadFile();
          //               },
          //               child: const Icon(Icons.upload, color: Colors.black),
          //             ))),
          //   ],
          // ),
          onDoubleTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
