// owner.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_hostel.dart'; // Import your AddHostel widget
import 'owner_drawer.dart'; // Import your Drawer widget
import 'hostel_detail_display.dart'; // Import the new detail page

class Owner extends StatefulWidget {
  const Owner({Key? key}) : super(key: key);

  @override
  _OwnerState createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  // Function to fetch the userId from the users collection
  Future<void> _fetchUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userId =
            userDoc['userId'].toString(); // Assuming userId is stored as such
      });
    }
  }

  // Function to fetch hostels based on the userId
  Stream<QuerySnapshot> _getHostels() {
    if (userId.isEmpty) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('hostel')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostels List'),
      ),
      drawer: const CustomDrawer(), // Use your CustomDrawer widget here
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getHostels(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final hostels = snapshot.data!.docs;

                if (hostels.isEmpty) {
                  return const Center(child: Text('No hostels found'));
                }

                return ListView.builder(
                  itemCount: hostels.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot hostel = hostels[index];

                    // Ensure answers array exists and has at least one element
                    List<dynamic> answers = hostel['answers'] ?? [];
                    String hostelName = answers.isNotEmpty
                        ? answers[0]
                        : 'No Name'; // Default value if array is empty

                    return ListTile(
                      title: Text(
                        hostelName, // Display the name of the hostel
                        style: const TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Navigate to the detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HostelDetailPage(
                              hostelId: hostel.id, // Pass the hostel ID
                              userId: userId, // Pass the user ID
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddHostel()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }
}
