import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wildlifego/login.dart';
import 'package:camera/camera.dart';
import 'package:wildlifego/student.dart';
import 'Screen/camera.dart';
import 'editReport.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({Key? key}) : super(key: key);
  @override
  State<MyReportsPage> createState() => _myReportsState();
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

class _myReportsState extends State<MyReportsPage> {
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
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.medium);
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
        title: const Text("WildLifeGO"),
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
              builder: (context) =>
                  CameraPage(cameraController: _cameraController),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  MaterialButton(
                    minWidth: 150,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Student(),
                        ),
                      );
                    
                  },
                    child: const Column(
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
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyReportsPage(), // Navigate to MyReportsPage
                      ),
                    );
                    },
                    child: const Column(
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
      stream: FirebaseFirestore.instance
      .collection('AllReports')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots(),
        
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reports = snapshot.data!.docs;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'My Reports',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index].data();
                      final reportID = report['reportId'] as String?;
                      final userID =
                          report['userId'] as String?; // Handle null value
                      final animalType =
                          report['animalType'] as String?; // Handle null value
                      final imageURL =
                          report['imageURL'] as String?; // Handle null value
                      final title =
                          report['title'] as String?; // Handle null value
                      final description =
                          report['description'] as String?; // Handle null value
                      final location =
                          report['location'] as String?; // Handle null value

                      return GestureDetector(
                        onTap: () {
                          // Navigate to details page and pass the report details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetailsPage(
                                reportID: reportID ?? '',
                                userID: userID ?? '',
                                animalType: animalType ?? '',
                                imageURL: imageURL ?? '',
                                title: title ?? '',
                                description: description ?? '',
                                location: location ?? '',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: imageURL != null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      imageURL,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const SizedBox(),
                            title: Text(title ?? 'No Title'),
                            subtitle: Text(description ?? 'No Details'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Error retrieving data');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class ReportDetailsPage extends StatefulWidget {
  final String reportID;
  final String userID;
  final String animalType;
  final String imageURL;
  final String title;
  final String description;
  final String location;

  const ReportDetailsPage({
    Key? key,
    required this.reportID,
    required this.userID,
    required this.animalType,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.location,
  }) : super(key: key);
  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 1, // Only one item in the list
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.imageURL.isNotEmpty)
                SizedBox(
                  width: 450,
                  height: 450,
                  child: Image.network(
                    widget.imageURL,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Title: ${widget.title}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('Animal Type: ${widget.animalType}'),
              const SizedBox(height: 10),
              Text('By: ${widget.userID}'),
              const SizedBox(height: 10),
              Text('Details: ${widget.description}'),
              const SizedBox(height: 10),
              Text('Location: ${widget.location}'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditReportPage(
                        reportId : widget.reportID,
                        originalTitle : widget.title,
                        originalAnimalType : widget.animalType,
                        originalLocation : widget.location,
                        originalDescription : widget.description,
                      ),
                    ),
                  );
                },
                child: const Text('Edit Report'),
              ),
            ],
          );
        },
      ),
    );
  }
}
