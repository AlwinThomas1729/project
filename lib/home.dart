

import 'package:flutter/material.dart';

import 'student.dart';
import 'owner.dart';
import 'AdminWidget.dart';

class HomePage extends StatefulWidget {
  final String userRole; // 'Student', 'Owner', or 'Admin'

  const HomePage({super.key, required this.userRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnRole();
  }

  void _navigateBasedOnRole() {
    if (widget.userRole == 'Student') {
      // Navigate to StudentPage
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Student())));
    } else if (widget.userRole == 'Owner') {
      // Navigate to OwnerPage
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Owner())));
    } else if (widget.userRole == 'admin') {
      // Navigate to AdminWidget page
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AdminWidget())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return a placeholder widget while routing happens
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Loading indicator while routing
      ),
    );
  }
}
