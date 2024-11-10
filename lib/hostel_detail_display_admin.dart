

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color bgcolor = Color.fromARGB(255, 156, 87, 82); // Background color
const Color textColor = Colors.blue; // Text color

class HostelDetailPage extends StatelessWidget {
  final String hostelId;
  final String userEmail;

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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('temphostels')
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

            // Debug: Check data structure
            print('Hostel Data: $hostelData'); // Debugging print

            // Remove unwanted fields
            hostelData.remove('timestamp');
            hostelData.remove('Hostel Id');
            // hostelData.remove('userEmail');
            //
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: hostelData.length,
                    itemBuilder: (context, index) {
                      var entry = hostelData.entries.elementAt(index);
                      return buildKeyValueWidget(entry.key, entry.value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            var snapshot = await FirebaseFirestore.instance
                                .collection('temphostels')
                                .doc(hostelId)
                                .get();

                            if (snapshot.exists) {
                              var hostelData = snapshot.data() as Map<String, dynamic>;

                              await FirebaseFirestore.instance
                                  .collection('hostels')
                                  .add(hostelData);

                              String hostelName = hostelData['Hostel Name'] ?? 'Unknown Hostel';

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Hostel $hostelName approved')),
                              );

                              await FirebaseFirestore.instance
                                  .collection('temphostels')
                                  .doc(hostelId)
                                  .delete();

                              Navigator.pop(context);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to approve hostel: $e')),
                            );
                          }
                        },
                        child: const Text('Approve'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('temphostels')
                              .doc(hostelId)
                              .delete();

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildKeyValueWidget(String key, dynamic value) {
    print('$key: $value'); // Debugging print for each key-value pair

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              key.replaceAll('_', ' ').capitalizeFirstOfEach(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not provided',
              style: const TextStyle(fontSize: 18, color: textColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirstOfEach() {
    return split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
  }
}
