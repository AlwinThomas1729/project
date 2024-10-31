//
//
//
//
//
//
//
//
// decide wether to display login/register page or home page
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<String?> getUserRole(String uid) async {
    try {
      // Fetch user role from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc['role'];
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }

  // Error dialog method to display the error message and a login button
  void _showError(BuildContext context) {
    // Ensure the dialog is shown after the build is done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        // Ensure context is still valid
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Oops... Something went wrong'),
              content: const Text('Error loading user role'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    }
                  },
                  child: const Text('Login Again'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return FutureBuilder<String?>(
              future: getUserRole(user!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  // Ensure that the error dialog is shown after the widget has built
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      _showError(context);
                    }
                  });
                  return const SizedBox
                      .shrink(); // Return an empty widget to avoid build issues
                }

                String userRole = snapshot.data!;
                return HomePage(userRole: userRole); // Navigate to home page
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
