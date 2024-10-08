// // // // hostel_detail_page.dart
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';

// // // class HostelDetailPage extends StatelessWidget {
// // //   final String hostelId;
// // //   final String userId;

// // //   const HostelDetailPage(
// // //       {Key? key, required this.hostelId, required this.userId})
// // //       : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Hostel Details')),
// // //       body: FutureBuilder<DocumentSnapshot>(
// // //         future:
// // //             FirebaseFirestore.instance.collection('hostel').doc(hostelId).get(),
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }

// // //           if (!snapshot.hasData || !snapshot.data!.exists) {
// // //             return const Center(child: Text('Hostel not found'));
// // //           }

// // //           DocumentSnapshot hostel = snapshot.data!;
// // //           List<dynamic> answers = hostel['answers'] ?? [];

// // //           return Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                     'Hostel Name: ${answers.isNotEmpty ? answers[0] : 'No Name'}',
// // //                     style: const TextStyle(fontSize: 24)),
// // //                 const SizedBox(height: 16),
// // //                 Text('Hostel ID: $hostelId',
// // //                     style: const TextStyle(fontSize: 20)),
// // //                 const SizedBox(height: 16),
// // //                 Text('User ID: $userId', style: const TextStyle(fontSize: 20)),
// // //                 // Display other details based on your data structure
// // //               ],
// // //             ),
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';

// // class HostelDetailPage extends StatelessWidget {
// //   final String hostelId;
// //   final String userId;

// //   // Define the questions as a list of maps (based on the structure you provided)
// //   final List<Map<String, dynamic>> questions = [
// //     {
// //       'question': 'What is your hostel name?',
// //       'type': 'text',
// //     },
// //     {
// //       'question': 'Select the type of hostel:',
// //       'type': 'multiple_choice',
// //       'options': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
// //     },
// //     {
// //       'question': 'Enter Hostel location:',
// //       'type': 'text',
// //     },
// //     {
// //       'question': 'Is washing Machine available:',
// //       'type': 'multiple_choice',
// //       'options': ['Yes', 'No'],
// //     },
// //     {
// //       'question': 'Is Mess/Food available:',
// //       'type': 'multiple_choice',
// //       'options': ['Yes', 'No'],
// //     },
// //     {
// //       'question': 'Enter Hostel ID',
// //       'type': 'integer',
// //     },
// //   ];

// //   HostelDetailPage({
// //     Key? key,
// //     required this.hostelId,
// //     required this.userId,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Hostel Details')),
// //       body: FutureBuilder<DocumentSnapshot>(
// //         future:
// //             FirebaseFirestore.instance.collection('hostel').doc(hostelId).get(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (!snapshot.hasData || !snapshot.data!.exists) {
// //             return const Center(child: Text('Hostel not found'));
// //           }

// //           DocumentSnapshot hostel = snapshot.data!;
// //           List<dynamic> answers = hostel['answers'] ?? [];

// //           // Check if the length of answers matches the number of questions
// //           if (answers.length != questions.length) {
// //             return const Center(
// //                 child: Text('Data mismatch. Could not load details.'));
// //           }

// //           return Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: ListView.builder(
// //               itemCount: questions.length,
// //               itemBuilder: (context, index) {
// //                 Map<String, dynamic> question = questions[index];
// //                 String questionText = question['question'];
// //                 String answer = answers[index]?.toString() ?? 'N/A';

// //                 // If the type is 'multiple_choice', use the index to map to the correct option
// //                 if (question['type'] == 'multiple_choice') {
// //                   List<String> options = List<String>.from(question['options']);
// //                   int answerIndex = int.tryParse(answer) ?? -1;
// //                   if (answerIndex >= 0 && answerIndex < options.length) {
// //                     answer = options[answerIndex];
// //                   } else {
// //                     answer = 'N/A';
// //                   }
// //                 }

// //                 return Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 8.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         '$questionText',
// //                         style: const TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         answer,
// //                         style: const TextStyle(fontSize: 16),
// //                       ),
// //                       const Divider(height: 20, thickness: 1),
// //                     ],
// //                   ),
// //                 );
// //               },
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class HostelDetailPage extends StatefulWidget {
//   final String hostelId;
//   final String userId;

//   const HostelDetailPage({
//     Key? key,
//     required this.hostelId,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   _HostelDetailPageState createState() => _HostelDetailPageState();
// }

// class _HostelDetailPageState extends State<HostelDetailPage> {
//   late DocumentSnapshot hostelSnapshot;
//   List<dynamic> answers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Hostel Details')),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('hostel')
//             .doc(widget.hostelId)
//             .get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('Hostel not found'));
//           }

//           hostelSnapshot = snapshot.data!;
//           answers = hostelSnapshot['answers'] ?? [];

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView(
//               children: [
//                 buildHostelDetail('Hostel Name:', answers[0]),
//                 buildHostelDetail('Hostel Type:', answers[1]),
//                 buildHostelDetail('Hostel Location:', answers[2]),
//                 buildHostelDetail('Washing Machine Available:', answers[3]),
//                 buildHostelDetail('Mess/Food Available:', answers[4]),
//                 buildHostelDetail('Hostel ID:', answers[5].toString()),
//                 const SizedBox(height: 20),
//                 buildEditButtons(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Helper function to build a hostel detail widget
//   Widget buildHostelDetail(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text(value, style: const TextStyle(fontSize: 16)),
//           const Divider(height: 20, thickness: 1),
//         ],
//       ),
//     );
//   }

//   // Function to show edit buttons
//   Widget buildEditButtons() {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () => editFieldDialog(context, 'Number of Vacancy', 6),
//           child: const Text('Edit Number of Vacancy'),
//         ),
//         ElevatedButton(
//           onPressed: () => editFieldDialog(context, 'Mess/Food Available', 4),
//           child: const Text('Edit Mess/Food Available'),
//         ),
//       ],
//     );
//   }

//   // Function to show a dialog to edit the field
//   void editFieldDialog(BuildContext context, String field, int index) {
//     TextEditingController controller = TextEditingController();
//     String initialValue = answers[index]?.toString() ?? '';

//     controller.text = initialValue;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit $field'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               labelText: field,
//               border: const OutlineInputBorder(),
//             ),
//             keyboardType:
//                 index == 6 ? TextInputType.number : TextInputType.text,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 updateField(index, controller.text);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to update the field value in Firestore
//   Future<void> updateField(int index, String newValue) async {
//     setState(() {
//       answers[index] = newValue;
//     });

//     // Update the hostel document in Firestore
//     await FirebaseFirestore.instance
//         .collection('hostel')
//         .doc(widget.hostelId)
//         .update({'answers': answers});

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Hostel details updated successfully!')),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HostelDetailPage extends StatefulWidget {
  final String hostelId;
  final String userId;

  const HostelDetailPage({
    super.key,
    required this.hostelId,
    required this.userId,
  });

  @override
  _HostelDetailPageState createState() => _HostelDetailPageState();
}

class _HostelDetailPageState extends State<HostelDetailPage> {
  late DocumentSnapshot hostelSnapshot;
  List<dynamic> answers = [];
  bool isEditMode = false; // To track edit mode
  List<TextEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Details'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditMode) {
                _saveUpdates(); // Save changes when in edit mode
              } else {
                _enableEditMode(); // Enable edit mode
              }
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('hostel')
            .doc(widget.hostelId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Hostel not found'));
          }

          hostelSnapshot = snapshot.data!;
          answers = hostelSnapshot['answers'] ?? [];

          // Initialize controllers only once
          if (controllers.isEmpty) {
            for (var answer in answers) {
              controllers.add(TextEditingController(text: answer.toString()));
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                buildEditableField('Hostel Name:', controllers[0], 0),
                buildEditableField('Owner/Manager Name:', controllers[1], 1),
                buildEditableField('Owner/Manager Number:', controllers[2], 2),
                buildEditableField('Hostel Type:', controllers[3], 3),
                buildEditableField('Rent Range:', controllers[4], 4),
                buildEditableField('Hostel Location:', controllers[5], 5),
                buildEditableField(
                    'Night Restriction Time:', controllers[6], 6),
                buildEditableField(
                    'Refrigerator Available:', controllers[7], 7),
                buildEditableField(
                    'Washing Machine Available:', controllers[8], 8),
                buildEditableField('Mess/Food Available:', controllers[9], 9),
                buildEditableField('Wi-Fi Available:', controllers[10], 10),
                buildEditableField(
                    'Number of Vaccancies:', controllers[11], 11),
                buildEditableField('Kitchen Available:', controllers[12], 12),
                buildEditableField(
                    'Distance from Institution:', controllers[13], 13),
                buildEditableField('Hostel ID:', controllers[14], 14),
              ],
            ),
          );
        },
      ),
    );
  }

  // Enable Edit Mode
  void _enableEditMode() {
    setState(() {
      isEditMode = true;
    });
  }

  // Save updated data to Firestore
  Future<void> _saveUpdates() async {
    setState(() {
      isEditMode = false;
    });

    // Update answers array with new values
    for (int i = 0; i < controllers.length; i++) {
      answers[i] = controllers[i].text;
    }

    // Save the updated answers to Firestore
    await FirebaseFirestore.instance
        .collection('hostel')
        .doc(widget.hostelId)
        .update({'answers': answers});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hostel details updated successfully!')),
    );
  }

  // Helper function to build an editable field
  Widget buildEditableField(
      String label, TextEditingController controller, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: isEditMode, // Enable editing only if in edit mode
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: (index == 2 || index == 11 || index == 14) // Numbers
                ? TextInputType.number
                : TextInputType.text, // Text fields
          ),
        ],
      ),
    );
  }
}
