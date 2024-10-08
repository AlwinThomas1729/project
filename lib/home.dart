//
//
//
//
//
//
//
//
// rout to logged in users pages ( could be student or owner )
import 'package:flutter/material.dart';

import 'student.dart';
import 'owner.dart';

class HomePage extends StatefulWidget {
  final String userRole; // 'student' or 'Owner'

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
          context, MaterialPageRoute(builder: (context) => Owner())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Corrected method signature
    // You can return a temporary placeholder widget while routing happens.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: const Center(
        child: CircularProgressIndicator(), // Loading indicator while routing
      ),
    );
  }
}
