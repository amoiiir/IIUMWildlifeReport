import 'package:flutter/material.dart';
import 'package:wildlifego/student.dart';
import 'main.dart';

class ReportPage extends StatelessWidget {
  final Report report;

  const ReportPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set the desired background color
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                report.imageFile,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                'Title: ${report.title}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Animal Type: ${report.animalType}'),
              const SizedBox(height: 8),
              Text('Location: ${report.location}'),
              const SizedBox(height: 8),
              Text('Description: ${report.description}'),

              //Button to confirm and submit report and go to student.dart
             Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.large(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(                      

                      // Navigate to the Student page
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Student(),
                      ),
                    );
                  },
                  child: const Icon(Icons.upload, color: Colors.black),
                ),
              ),
            ),

              
            ],
          ),
        ),
      ),
    );
  }
}
