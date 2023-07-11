import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'register.dart';

List<CameraDescription> cameras = [];
List<Widget> imageWidgets = [];

class Report {
  final String reportId;
  final String userId;
  final String title;
  final String animalType;
  final String location;
  final String description;
  final File imageFile;

  Report({
    required this.reportId,
    required this.userId,
    required this.title,
    required this.animalType,
    required this.location,
    required this.description,
    required this.imageFile,
  });
}



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 51, 55, 85),
      ),
      home: const Register(),
    );
  }
}