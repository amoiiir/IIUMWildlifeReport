import 'package:flutter/material.dart';

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
      body: Padding(
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
          ],
        ),
      ),
    );
  }
}
