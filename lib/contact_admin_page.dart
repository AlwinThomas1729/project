
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color bgcolor = Colors.blue;

class ContactAdminPage extends StatefulWidget {
  const ContactAdminPage({super.key});

  @override
  _ContactAdminPageState createState() => _ContactAdminPageState();
}

class _ContactAdminPageState extends State<ContactAdminPage> {
  bool isLoading = false;

  // Admin details (you can fetch this from Firebase or hardcode for now)
  final Map<String, String> adminDetails = {
    'name': 'Alwin',
    'contact': '1234567890',
    'email': 'alwin@gmail.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text("Contact Admin"),
        backgroundColor: bgcolor,
        automaticallyImplyLeading: false, // This removes the back arrow
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.blue)
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildAdminDetailsForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDetailsForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Admin Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow("Name", adminDetails['name'] ?? 'N/A'),
              const SizedBox(height: 20),
              _buildDetailRow("Contact", adminDetails['contact'] ?? 'N/A'),
              const SizedBox(height: 20),
              _buildDetailRow("Email", adminDetails['email'] ?? 'N/A'),
              const SizedBox(height: 20),
              _buildGoBackButton(context),  // Go back button inside the card
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildGoBackButton(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5.0,
      height: 40,
      onPressed: () {
        Navigator.pop(context); // Navigate back to the previous screen
      },
      color: Colors.blue[900],
      child: const Text(
        "Go Back",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
