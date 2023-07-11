import 'package:flutter/material.dart';

class EditReportPage extends StatefulWidget {
  final String reportId;
  final String originalTitle;
  final String originalAnimalType;
  final String originalLocation;
  final String originalDescription;

  const EditReportPage({
    required this.reportId,
    required this.originalTitle,
    required this.originalAnimalType,
    required this.originalLocation,
    required this.originalDescription,
  });

  @override
  _EditReportPageState createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  late TextEditingController _titleController;
  late TextEditingController _animalTypeController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.originalTitle);
    _animalTypeController =
        TextEditingController(text: widget.originalAnimalType);
    _locationController = TextEditingController(text: widget.originalLocation);
    _descriptionController =
        TextEditingController(text: widget.originalDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animalTypeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report ID: ${widget.reportId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  // Update the new value in the state
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _animalTypeController,
              decoration: const InputDecoration(labelText: 'Animal Type'),
              onChanged: (value) {
                setState(() {
                  // Update the new value in the state
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                setState(() {
                  // Update the new value in the state
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  // Update the new value in the state
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform the update operation with the new values
                String newTitle = _titleController.text;
                String newAnimalType = _animalTypeController.text;
                String newLocation = _locationController.text;
                String newDescription = _descriptionController.text;

                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
