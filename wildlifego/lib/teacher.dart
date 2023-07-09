import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  int _selectedTabIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ReportsPage(),
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
                    final details =
                        report['details'] as String?; // Handle null value

                    return GestureDetector(
                      onTap: () {
                        // Navigate to details page and pass the report details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailsPage(
                              imageURL: imageURL ?? '',
                              title: title ?? '',
                              details: details ?? '',
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
                          subtitle: Text(details ?? 'No Details'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error retrieving data');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final String imageURL;
  final String title;
  final String details;

  const ReportDetailsPage({
    Key? key,
    required this.title,
    required this.details,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageURL.isNotEmpty
                ? Container(
                    width: 450,
                    height: 450,
                    child: Image.network(
                      imageURL,
                      fit: BoxFit.cover,
                    ))
                : const SizedBox(),
            const SizedBox(height: 16),
            Text(
              'Title: $title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Details: $details'),
          ],
        ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Reports Page'),
    );
  }
}
