import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import 'login.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  int _selectedTabIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ReportsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WildlifeGo"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: _pages[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('AllReports').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final reports = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Pending Reports',
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
                    final imageURL =
                        report['imageURL'] as String?; // Handle null value
                    final title =
                        report['title'] as String?; // Handle null value
                    final description =
                        report['description'] as String?; // Handle null value
                    // final location =
                    //     report['location'] as String?; // Handle null value

                    return GestureDetector(
                      onTap: () {
                        // Navigate to details page and pass the report details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailsPage(
                              imageURL: imageURL ?? '',
                              title: title ?? '',
                              description: description ?? '',
                              // location: location ?? '',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: imageURL != null
                              ? Image.network(imageURL)
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
    );
  }
}

class ReportDetailsPage extends StatefulWidget {
  final String imageURL;
  final String title;
  final String description;
  // final String location;

  const ReportDetailsPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imageURL,
    // required this.location,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.imageURL.isNotEmpty
                ? SizedBox(
                    width: 450,
                    height: 450,
                    child: Image.network(
                      widget.imageURL,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            Text(
              'Title: ${widget.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Details: ${widget.description}'),
            const SizedBox(height: 16),
            // Text('Location: ${widget.location}'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SwipeableButtonView(
                  buttonText: "Done Inspections",
                  buttonWidget: Container(
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 0, 140, 255),
                    ),
                  ),
                  activeColor: const Color.fromARGB(255, 0, 140, 255),
                  isFinished: isFinished,
                  onWaitingProcess: () {
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isFinished = true;
                      });
                    });
                  },
                  onFinish: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Teacher(),
                      ),
                    );
                  },
                  buttontextstyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Reports Page'),
    );
  }
}
