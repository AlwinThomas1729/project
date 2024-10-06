import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userType = ''; // To store user type

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  Future<void> getUserType() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userType =
            userDoc['User_Type']; // Assuming 'type' field stores the user type
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 101, 136, 187),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to LoginPage when the back button is pressed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: userType.isEmpty
            ? const CircularProgressIndicator() // Show loading indicator while user type is fetched
            : userType == 'Admin'
                ? buildAdminView() // If admin, show admin content
                : buildRegularUserView(), // Otherwise, show regular user content
      ),
    );
  }

  // Widget for admin view
  Widget buildAdminView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome Admin!', style: TextStyle(fontSize: 24)),
        Icon(Icons.admin_panel_settings, size: 100, color: Colors.redAccent),
      ],
    );
  }

  // Widget for regular user view
  Widget buildRegularUserView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome Regular User!', style: TextStyle(fontSize: 24)),
        Icon(Icons.person, size: 100, color: Colors.blueAccent),
      ],
    );
  }
}
