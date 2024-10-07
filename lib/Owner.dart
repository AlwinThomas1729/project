//
//
//
//
//
//
//
// for logged in owner.option to add new hostel and edit existing hostels
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_hostel.dart';
import 'owner_drawer.dart';

class Owner extends StatefulWidget {
  const Owner({super.key});

  @override
  _OwnerState createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String ownerId = ''; // Initialize ownerId to an empty string

  @override
  void initState() {
    super.initState();
    _fetchOwnerId();
  }

  // Function to fetch the owner ID from the users collection
  Future<void> _fetchOwnerId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        ownerId = userDoc['userId']
            .toString(); // Assuming owner_id is stored as userId
      });
    }
  }

  // Function to fetch hostels owned by the logged-in owner
  Stream<QuerySnapshot> _getHostels() {
    if (ownerId.isEmpty) {
      // Return an empty stream if ownerId is not set
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('hostel')
        .where('hostel_owner_number', isEqualTo: ownerId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
      ),
      drawer: const CustomDrawer(), // Add the drawer here
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
                    return ListTile(
                      title: Text(
                        hostel['hostelName'], // Display hostel name
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text('Room Number: ${hostel['roomNumber']}'),
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
                if (ownerId.isNotEmpty) {
                  // Ensure ownerId is set
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddHostel()),
                  );
                } else {
                  // Optionally, show an error message or snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Owner ID not defined. Please try again later.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Add Hostel'),
            ),
          ),
        ],
      ),
    );
  }
}
