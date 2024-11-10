

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'hostel_details_display_verified.dart'; // Assuming you have this page for hostel details

class VerifiedHostels extends StatelessWidget {
  const VerifiedHostels({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verified Hostels",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.red[50],
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('hostels')
                      .snapshots(), // Listening for real-time updates in the 'hostels' collection
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
                            hostelData['Hostel Name'] ?? 'Unnamed Hostel';
                        var imageUrl = 'assets/hostel.jpg'; // Replace with actual image if available
                        var userEmail = hostelData['userEmail'] ?? ''; // Fetch the userEmail from the hostel data

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
                                      userEmail: userEmail, // Pass userEmail fetched from the hostel data
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
}
