// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'add_hostel.dart'; // Import your AddHostel widget
// import 'owner_drawer.dart'; // Import your Drawer widget
// import 'hostel_detail_display_owner.dart'; // Import the new detail page

// const Color tilelistcolor = Color.fromARGB(255, 138, 38, 219);
// const Color pagebackgroundcolor = Color.fromARGB(201, 183, 214, 8);
// const Color appbarcolor = Color.fromARGB(200, 214, 8, 138);
// const Color bodyColor =
//     Color.fromARGB(255, 130, 221, 133); // Background color for body

// class Owner extends StatefulWidget {
//   const Owner({super.key});

//   @override
//   _OwnerState createState() => _OwnerState();
// }

// class _OwnerState extends State<Owner> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String userEmail = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserEmail();
//   }

//   // Function to fetch the user's email from FirebaseAuth
//   Future<void> _fetchUserEmail() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         userEmail = user.email!; // Assuming user email is not null
//       });
//     }
//   }

//   // Function to fetch hostels based on the userEmail
//   Stream<QuerySnapshot> _getHostels() {
//     if (userEmail.isEmpty) {
//       return const Stream.empty();
//     }

//     return FirebaseFirestore.instance
//         .collection('hostels')
//         .where('userEmail', isEqualTo: userEmail) // Compare userEmail
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Hostels'),
//         backgroundColor: appbarcolor,
//       ),
//       drawer: const CustomDrawer(), // Use your CustomDrawer widget here
//       body: Container(
//         color: bodyColor, // Updated body background color
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _getHostels(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: Text('No hostels found'));
//                   }

//                   final hostels = snapshot.data!.docs;

//                   if (hostels.isEmpty) {
//                     return const Center(child: Text('No hostels found'));
//                   }

//                   return ListView.builder(
//                     itemCount: hostels.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot hostel = hostels[index];

//                       // Access the hostel name directly using the 'hostel_name' short key
//                       String hostelName = hostel['hostel_name'] ??
//                           'No Name'; // Default value if field is empty
//                       var imageUrl = 'assets/hostel.jpg'; // Adjust image path

//                       return HostelCard(
//                         hostelName: hostelName,
//                         imageUrl: imageUrl, // Pass the image URL
//                         onTap: () {
//                           // Navigate to the detail page
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => HostelDetailPage(
//                                 hostelId: hostel.id, // Pass the hostel ID
//                                 userEmail: userEmail, // Pass the user email
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const AddHostel()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16.0,
//                     horizontal: 32.0,
//                   ),
//                   textStyle: const TextStyle(fontSize: 18),
//                   backgroundColor: Colors.green, // Button color
//                 ),
//                 child: const Text('Add Hostel'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // HostelCard widget definition
// class HostelCard extends StatelessWidget {
//   final String hostelName;
//   final String imageUrl; // Add an imageUrl parameter
//   final VoidCallback onTap;

//   const HostelCard({
//     super.key,
//     required this.hostelName,
//     required this.imageUrl, // Initialize imageUrl
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: tilelistcolor, // Change this to your desired color
//           borderRadius: BorderRadius.circular(10.0),
//           boxShadow: const [
//             BoxShadow(
//               color: pagebackgroundcolor,
//               blurRadius: 5.0,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Display the hostel image on the left
//             Image.asset(
//               imageUrl,
//               width: 60, // Set the width of the image
//               height: 60, // Set the height of the image
//               fit: BoxFit.cover, // Adjust the image size
//             ),
//             const SizedBox(width: 16), // Space between image and text
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     hostelName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: onTap, // Navigate to details when tapped
//                     child: const Text(
//                       'Click here to view and edit details',
//                       style: TextStyle(
//                           color: Colors.blue, fontStyle: FontStyle.italic),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_hostel.dart'; // Import your AddHostel widget
import 'owner_drawer.dart'; // Import your Drawer widget
import 'hostel_detail_display_owner.dart'; // Import the new detail page

const Color tilelistcolor = Color.fromARGB(255, 138, 38, 219);
const Color pagebackgroundcolor = Color.fromARGB(201, 183, 214, 8);
const Color appbarcolor = Color.fromARGB(200, 214, 8, 138);
const Color bodyColor =
    Color.fromARGB(255, 130, 221, 133); // Background color for body

class Owner extends StatefulWidget {
  const Owner({super.key});

  @override
  _OwnerState createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });
    }
  }

  Stream<QuerySnapshot> _getHostels() {
    if (userEmail.isEmpty) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('hostels')
        .where('userEmail', isEqualTo: userEmail) // Compare userEmail
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Hostels'),
        backgroundColor: appbarcolor,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        color: bodyColor,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getHostels(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }

                  final hostels = snapshot.data?.docs ?? [];

                  if (hostels.isEmpty) {
                    return const Center(child: Text('No hostels found'));
                  }

                  return ListView.builder(
                    itemCount: hostels.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot hostel = hostels[index];
                      String hostelName = hostel['Hostel Name'] ?? 'No Name';
                      String imageUrl = 'assets/hostel.jpg'; // Static image URL

                      return HostelCard(
                        hostelName: hostelName,
                        imageUrl: imageUrl, // Pass the static image URL
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HostelDetailPage(
                                hostelId: hostel.id,
                                userEmail: userEmail,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddHostel()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 32.0,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.green,
                ),
                child: const Text('Add Hostel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HostelCard extends StatelessWidget {
  final String hostelName;
  final String imageUrl; // Keep this parameter to use the static image URL
  final VoidCallback onTap;

  const HostelCard({
    super.key,
    required this.hostelName,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: tilelistcolor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: pagebackgroundcolor,
              blurRadius: 5.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Display the static image
            Image.asset(
              imageUrl,
              width: 60, // Set the width of the image
              height: 60, // Set the height of the image
              fit: BoxFit.cover, // Adjust the image size
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostelName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      'Click here to view and edit details',
                      style: TextStyle(
                          color: Colors.blue, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
