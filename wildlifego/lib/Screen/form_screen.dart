import 'dart:io';
import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {
  final File imageFile;

  const FormScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue Report')),
      body: Container(
        child: GestureDetector(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  heightFactor: 1.5,
                  child: Container(
                    width: 144,
                    height: 256,
                    child: Image.file(imageFile),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                      // Handle form submission
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
