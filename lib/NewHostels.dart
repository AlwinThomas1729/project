import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'hostel_detail_display_admin.dart';
import 'student_drawer.dart';

class NewHostels extends StatefulWidget {
  const NewHostels({super.key});

  @override
  State<NewHostels> createState() => _NewHostelsState();
}

class _NewHostelsState extends State<NewHostels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PGFinder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(
          color: Colors.red[50],
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future:
                  FirebaseFirestore.instance.collection('hostels').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No hostels available'));
                    }

                    var hostels = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: hostels.length,
                      itemBuilder: (context, index) {
                        var hostelData = hostels[index].data();
                        var hostelName =
                            hostelData['hostel_name'] ?? 'Unnamed Hostel';
                        var imageUrl = 'assets/hostel.jpg';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            leading: Image.asset(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              hostelName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HostelDetailPage(
                                      hostelId: hostels[index].id,
                                      userEmail: FirebaseAuth
                                          .instance.currentUser!.email!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Click here for more details',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
