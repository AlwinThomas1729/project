// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'login.dart';
// import 'hostel_detail_display_student.dart';
// import 'filter.dart';
// import 'sort.dart';
// import 'student_drawer.dart';

// class Student extends StatefulWidget {
//   const Student({super.key});

//   @override
//   State<Student> createState() => _StudentState();
// }

// class _StudentState extends State<Student> {
//   String? _selectedSortOption;
//   List<QueryDocumentSnapshot<Map<String, dynamic>>>?
//       _sortedHostels; // Sorted hostels list

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "PGFinder",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       drawer: const CustomDrawer(),
//       body: SafeArea(
//         child: Container(
//           color: Colors.red[50],
//           child: Column(
//             children: [
//               // Filter and Sort area
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 color: Colors.blue,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         _showFilterOptions(context);
//                       },
//                       child: const Row(
//                         children: [
//                           Text(
//                             'Filter',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(width: 8.0),
//                           Icon(
//                             Icons.tune,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         _showSortOptions(context);
//                       },
//                       child: const Row(
//                         children: [
//                           Text(
//                             'Sort By',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           SizedBox(width: 8.0),
//                           Icon(
//                             Icons.sort,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   future:
//                       FirebaseFirestore.instance.collection('hostels').get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(child: Text('No hostels available'));
//                     }

//                     // If sorted hostels are available, use them; otherwise use original hostels
//                     var hostels = _sortedHostels ?? snapshot.data!.docs;

//                     return ListView.builder(
//                       itemCount: hostels.length,
//                       itemBuilder: (context, index) {
//                         var hostelData = hostels[index].data();
//                         var hostelName =
//                             hostelData['hostel_name'] ?? 'Unnamed Hostel';
//                         var imageUrl = 'assets/hostel.jpg';

//                         return Card(
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 16.0),
//                           color: Colors.white,
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.all(16.0),
//                             leading: Image.asset(
//                               imageUrl,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                             ),
//                             title: Text(hostelName,
//                                 style: const TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold)),
//                             subtitle: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => HostelDetailPage(
//                                       hostelId: hostels[index].id,
//                                       userEmail: FirebaseAuth
//                                           .instance.currentUser!.email!,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: const Text(
//                                 'Click here for more details',
//                                 style: TextStyle(
//                                     color: Colors.blue,
//                                     fontStyle: FontStyle.italic),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showFilterOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return filter(
//           selectedFilterOption: _selectedSortOption,
//           onFilterSelected: (option) {
//             setState(() {
//               _selectedSortOption = option;
//             });
//           },
//         );
//       },
//     );
//   }

//   void _showSortOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SortPopup(
//           selectedSortOption: _selectedSortOption,
//           onSortSelected: (sortedHostels) {
//             setState(() {
//               _sortedHostels = sortedHostels;
//             });
//           },
//         );
//       },
//     );
//   }

//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const LoginPage(),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'hostel_detail_display_student.dart';
import 'filter.dart';
import 'sort.dart';
import 'student_drawer.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String? _selectedSortOption;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? _sortedHostels;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PGFinder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Container(
          color: Colors.red[50],
          child: Column(
            children: [
              // Filter and Sort area
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showFilterOptions(context);
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(
                            Icons.tune,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showSortOptions(context);
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Sort By',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(
                            Icons.sort,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future:
                      FirebaseFirestore.instance.collection('hostels').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No hostels available'));
                    }

                    var hostels = _sortedHostels ?? snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: hostels.length,
                      itemBuilder: (context, index) {
                        var hostelData = hostels[index].data();
                        var hostelName =
                            hostelData['hostel_name'] ?? 'Unnamed Hostel';
                        var imageUrl = 'assets/hostel.jpg';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            leading: Image.asset(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(hostelName,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            subtitle: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HostelDetailPage(
                                      hostelId: hostels[index].id,
                                      userEmail: FirebaseAuth
                                          .instance.currentUser!.email!,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Click here for more details',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FilterPage(),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SortPopup(
          selectedSortOption: _selectedSortOption,
          onSortSelected: (sortedHostels) {
            setState(() {
              _sortedHostels = sortedHostels;
            });
          },
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }
}
