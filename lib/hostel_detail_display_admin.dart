

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color bgcolor = Color.fromARGB(255, 156, 87, 82); // Background color
const Color textColor = Colors.blue; // Text color

class HostelDetailPage extends StatelessWidget {
  final String hostelId;
  final String userEmail; // Confirm logged-in user via email

  const HostelDetailPage({
    super.key,
    required this.hostelId,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text('Hostel Details'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection:
                Axis.horizontal, // Horizontal scrolling for the whole page
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.5, // Adjust as needed
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('hostels')
                        .doc(hostelId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text('Hostel not found'));
                      }

                      var hostelData = snapshot.data!.data() as Map<String, dynamic>;

                      // Remove unwanted fields
                      hostelData.remove('timestamp');
                      hostelData.remove('hostel_id');
                      hostelData.remove('userEmail');

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical, // Vertical scrolling for the content
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: hostelData.entries.map((entry) {
                            return buildKeyValueWidget(entry.key, entry.value);
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Buttons at the bottom center
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add Approve button functionality here
                    },
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 16), // Space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Add Delete button functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red color for delete button
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKeyValueWidget(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Align at the top for better key-value display
        children: [
          // Key part
          SizedBox(
            width: 150, // Fixed width for key text to avoid overflow
            child: Text(
              key
                  .replaceAll('_', ' ')
                  .capitalizeFirstOfEach(), // Format the key
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          // Value part
          Expanded(
            child: Text(
              value?.toString() ?? 'Not provided', // Handle null values
              style: const TextStyle(fontSize: 18, color: textColor),
              overflow: TextOverflow.ellipsis, // Truncate long text
              maxLines: 3, // Limit the number of lines
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize the first letter of each word
extension StringExtension on String {
  String capitalizeFirstOfEach() {
    return split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
  }
}
