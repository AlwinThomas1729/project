import 'package:flutter/material.dart';

// Assuming you have StudentPage and TeacherPage widgets
import 'student.dart'; // Import your StudentPage widget
import 'teacher.dart'; // Import your TeacherPage widget

class HomePage extends StatefulWidget {
  final String userRole; // 'student' or 'teacher'

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
    } else if (widget.userRole == 'Teacher') {
      // Navigate to TeacherPage
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Teacher())));
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
