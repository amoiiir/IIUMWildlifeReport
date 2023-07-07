import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wildlifego/main.dart';
import 'package:wildlifego/reportCard.dart';

class FormScreen extends StatefulWidget {
  final File imageFile;

  const FormScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
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
                Center(
                  child: Container(
                    width: 256,
                    height: 256,
                    child: Image.file(
                      widget.imageFile,
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Report myReport = Report(
                                  title: _title!,
                                  animalType: _animalType!,
                                  location: _location!,
                                  description: _description!,
                                  imageFile: widget.imageFile,
                                );
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportPage(report: myReport),
                                ),
                              );
                                print('Submitted report: $myReport\nTitle: ${myReport.title}\nAnimal Type: ${myReport.animalType}\nLocation: ${myReport.location}\nDescription: ${myReport.description}\nImage File: ${myReport.imageFile}');
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
