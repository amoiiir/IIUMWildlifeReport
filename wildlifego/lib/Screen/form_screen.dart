import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/student.dart';

class FormScreen extends StatefulWidget {
  final File imageFile;

  const FormScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool _isUploading = false; // Flag to track if the file is being uploaded
  double _progress = 0.0; // Progress of the upload task

  final _formKey = GlobalKey<FormState>();
  late String _userEmail;
  String? _title;
  String? _animalType;
  String? _location;
  String? _description;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email!;
      });
    }
  }

  Future<void> uploadFile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Create a reference to the image file in Firebase Storage
      String fileName = DateTime.now().toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = reference.putFile(widget.imageFile);

      // Listen to the task state changes to track the progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _progress =
              snapshot.bytesTransferred / snapshot.totalBytes.toDouble();
        });
      });

      // Wait for the upload task to complete
      await uploadTask.whenComplete(() {
        print('File uploaded successfully');
        // Navigate back to the home page after the progress is complete
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });

      // Get the download URL of the uploaded file
      String downloadURL = await reference.getDownloadURL();

      // Create a data object containing the uploaded file details and other form fields
      Map<String, dynamic> reportData = {
        'userId': _userEmail,
        'title': _title,
        'animalType': _animalType,
        'location': _location,
        'description': _description,
        'imageURL': downloadURL,
      };

      // Upload the data object to Firebase Firestore or Realtime Database
      await FirebaseFirestore.instance
          .collection('AllReports')
          .add(reportData);

      // Navigate to the Student screen after successful submission
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Student(),
        ),
      );
    } catch (e) {
      print('Error uploading file: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

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
                  visible: _isUploading, // Show the progress bar only when uploading
                  child: LinearProgressIndicator(value: _progress, minHeight: 20),
                ),
                Text('User Email: $_userEmail'),
                Center(
                  child: SizedBox(
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                              if (!_isUploading && _formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                uploadFile();
                              }
                              MaterialPageRoute(
                                builder: (context) => const Student(),
                              );
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
