import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/student.dart';

class FormScreen extends StatefulWidget {
  final File imageFile;
  //final String imageFile;

  const FormScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  UploadTask? _uploadTask;
  double _progress = 0.0;

  Future<void> uploadFile() async {
    try {
      // Create a reference to the image file in Firebase Storage
      String fileName = DateTime.now().toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      _uploadTask = reference.putFile(widget.imageFile);

      // Listen to the task state changes to track the progress
      _uploadTask!.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _progress =
              snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        });
      });

      // Wait for the upload task to complete
      await _uploadTask!.whenComplete(() {
        print('File uploaded successfully');
        // Navigate back to the home page after the progress is complete
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });

      // Get the download URL of the uploaded file
      String downloadURL = await reference.getDownloadURL();

      // Print the download URL
      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _animalType;
  String? _location;
  String? _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue Report')),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Visibility(
                  visible: _uploadTask != null,
                  child:
                      LinearProgressIndicator(value: _progress, minHeight: 20),
                ),
                Center(
                  child: Container(
                    width: 256,
                    height: 256,
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            _title = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Animal Type',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            _animalType = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            _location = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                          onSaved: (value) {
                            _description = value;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton.large(
                            backgroundColor: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // Save the form fields
                                String title = _title!;
                                String animalType = _animalType!;
                                String location = _location!;
                                String description = _description!;

                                // Create a reference to the image file in Firebase Storage
                                String fileName = DateTime.now().toString();
                                Reference reference = FirebaseStorage.instance
                                    .ref()
                                    .child('images/$fileName');

                                // Upload the file to Firebase Storage
                                UploadTask uploadTask =
                                    reference.putFile(widget.imageFile);

                                // Wait for the upload task to complete
                                TaskSnapshot taskSnapshot = await uploadTask;
                                print('File uploaded successfully');

                                // Get the download URL of the uploaded file
                                String downloadURL =
                                    await reference.getDownloadURL();

                                // Create a data object containing the uploaded file details and other form fields
                                Map<String, dynamic> reportData = {
                                  'title': title,
                                  'animalType': animalType,
                                  'location': location,
                                  'description': description,
                                  'imageURL': downloadURL,
                                };

                                // Upload the data object to Firebase Firestore or Realtime Database
                                // Replace the `collectionName` with your desired collection name
                                await FirebaseFirestore.instance
                                    .collection('AllReports')
                                    .add(reportData);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Student(), // Replace with your actual Student screen widget
                                  ),
                                );
                              }
                            },
                            child: const Icon(Icons.done, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
