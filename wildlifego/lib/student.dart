import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/login.dart';
import 'package:camera/camera.dart';

import 'Screen/camera.dart';
import 'login.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ),
  );
}

class _StudentState extends State<Student> {
  late List<CameraDescription> cameras;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    await _cameraController.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WildLife GO"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      //floating action button must be center
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(cameraController: _cameraController),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  MaterialButton(
                    minWidth: 150,
                    onPressed: () {
                      setState(() {
                        // currentScreen = const Home();
                        // currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.blueGrey,
                        ),
                        Text('Home')
                      ],
                    ),
                  )
                ],
              ),
              //right tab bar icons
              Row(
                children: [
                  MaterialButton(
                    minWidth: 150,
                    onPressed: () {
                      setState(() {
                        // currentScreen = const Home();
                        // currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment,
                          color: Colors.blueGrey,
                        ),
                        Text('My Reports')
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance.collection('AllReports').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final reports = snapshot.data!.docs;
      return ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index].data();
          final imageURL = report['imageURL'] as String?; // Handle null value
          final title = report['title'] as String?; // Handle null value
          final animalType = report['animalType'] as String?; // Handle null value
          final location = report['location'] as String?; // Handle null value
          final description = report['description'] as String?; // Handle null value
          //final details = report['details'] as String?; // Handle null value

          return ListTile(
            leading: Container(
              child: imageURL != null ? Image.network(imageURL) : const SizedBox(),
            ),
            
            // title: Text(title ?? 'No Title'),
            // subtitle: Text(animalType ?? 'No Animal Type'),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? 'Untitled'),
                Text(animalType ?? 'No Animal Type'),
                Text(location ?? 'No Location'),
                Text(description ?? 'No Description'),
              ],
            ),
            //subtitle: Text(details ?? 'No Details'),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Text('Error retrieving data');
    } else {
      return const CircularProgressIndicator();
    }
  },
),
    );
  }
}