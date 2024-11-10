//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Import for launching URLs
import 'login.dart'; // Import the LoginPage
import 'contact_admin_page.dart'; // Import the new ContactAdminPage widget

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Owner Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Optionally, navigate to Home page (if needed)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact Admin'),
            onTap: () {
              // Navigate to the ContactAdminPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactAdminPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await _logout(context);
            },
          ),

        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the LoginPage directly after logout
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }
}
//
// // New widget to display the admin's details
// class ContactAdminPage extends StatelessWidget {
//   const ContactAdminPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Contact Admin'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               'Admin Details:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text('Name: Alwin'),
//             Text('Number: 123456'),
//             Text('Email: alwin@gmail.com'),
//           ],
//         ),
//       ),
//     );
//   }
// }
