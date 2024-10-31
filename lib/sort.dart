// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class SortPopup extends StatefulWidget {
//   final String? selectedSortOption;
//   final Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>?)
//       onSortSelected;

//   const SortPopup({
//     Key? key,
//     required this.selectedSortOption,
//     required this.onSortSelected,
//   }) : super(key: key);

//   @override
//   State<SortPopup> createState() => _SortPopupState();
// }

// class _SortPopupState extends State<SortPopup> {
//   String? _selectedOption;

//   @override
//   void initState() {
//     super.initState();
//     _selectedOption = widget.selectedSortOption;
//   }

//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
//       _fetchAndSortHostels(String criteria) async {
//     // Fetch hostels from Firestore
//     QuerySnapshot<Map<String, dynamic>> snapshot =
//         await FirebaseFirestore.instance.collection('hostels').get();
//     List<QueryDocumentSnapshot<Map<String, dynamic>>> hostels = snapshot.docs;

//     // Map and sort logic
//     if (criteria == 'Rent') {
//       hostels.sort((a, b) {
//         var rentA = a['rent'] as String?;
//         var rentB = b['rent'] as String?;
//         int rankA = _mapRentToValue(rentA);
//         int rankB = _mapRentToValue(rentB);
//         return rankA.compareTo(rankB);
//       });
//     } else if (criteria == 'Distance') {
//       hostels.sort((a, b) {
//         var distanceA = a['distance'] as String?;
//         var distanceB = b['distance'] as String?;
//         int rankA = _mapDistanceToValue(distanceA);
//         int rankB = _mapDistanceToValue(distanceB);
//         return rankA.compareTo(rankB);
//       });
//     } else if (criteria == 'Mess') {
//       hostels.sort((a, b) {
//         var messA = a['mess'] as String?;
//         var messB = b['mess'] as String?;
//         int rankA = _mapMessToValue(messA);
//         int rankB = _mapMessToValue(messB);
//         return rankA.compareTo(rankB);
//       });
//     }

//     return hostels;
//   }

//   // Mapping functions for rent, distance, and mess
//   int _mapRentToValue(String? rent) {
//     if (rent == 'Less than 2000') return 1;
//     if (rent == 'Between 2000 - 3000') return 2;
//     if (rent == 'Between 3000 - 4000') return 3;
//     if (rent == 'More than 4000') return 4;
//     return 5; // Fallback if undefined
//   }

//   int _mapDistanceToValue(String? distance) {
//     if (distance == 'Less than 500 meters') return 1;
//     if (distance == 'Between 0.5 - 1 Kilometer') return 2;
//     if (distance == 'Between 1 - 1.5 Kilometers') return 3;
//     if (distance == 'More than 2 Kilometers') return 4;
//     return 5; // Fallback if undefined
//   }

//   int _mapMessToValue(String? mess) {
//     if (mess == 'Yes') return 1;
//     if (mess == 'No') return 2;
//     return 3; // Fallback if undefined
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             'Sort By',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           // Distance Sort Option
//           ListTile(
//             title: const Text('Distance'),
//             trailing: Radio<String>(
//               value: 'Distance',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value;
//                 });
//                 _fetchAndSortHostels('Distance').then((sortedHostels) {
//                   widget.onSortSelected(sortedHostels);
//                   Navigator.pop(context); // Close bottom sheet
//                 });
//               },
//             ),
//           ),
//           // Rent Sort Option
//           ListTile(
//             title: const Text('Rent'),
//             trailing: Radio<String>(
//               value: 'Rent',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value;
//                 });
//                 _fetchAndSortHostels('Rent').then((sortedHostels) {
//                   widget.onSortSelected(sortedHostels);
//                   Navigator.pop(context); // Close bottom sheet
//                 });
//               },
//             ),
//           ),
//           // Mess Sort Option
//           ListTile(
//             title: const Text('Mess'),
//             trailing: Radio<String>(
//               value: 'Mess',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value;
//                 });
//                 _fetchAndSortHostels('Mess').then((sortedHostels) {
//                   widget.onSortSelected(sortedHostels);
//                   Navigator.pop(context); // Close bottom sheet
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SortPopup extends StatefulWidget {
  final String? selectedSortOption;
  final Function(List<QueryDocumentSnapshot<Map<String, dynamic>>>?)
      onSortSelected;

  const SortPopup({
    Key? key,
    required this.selectedSortOption,
    required this.onSortSelected,
  }) : super(key: key);

  @override
  State<SortPopup> createState() => _SortPopupState();
}

class _SortPopupState extends State<SortPopup> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedSortOption;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchAndSortHostels(String criteria) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('hostels').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> hostels = snapshot.docs;

    // Sorting logic
    if (criteria == 'Rent') {
      hostels.sort((a, b) {
        int rankA = _mapRentToValue(a['rent'] as String?);
        int rankB = _mapRentToValue(b['rent'] as String?);
        return rankA.compareTo(rankB);
      });
    } else if (criteria == 'Distance') {
      hostels.sort((a, b) {
        int rankA = _mapDistanceToValue(a['distance'] as String?);
        int rankB = _mapDistanceToValue(b['distance'] as String?);
        return rankA.compareTo(rankB);
      });
    } else if (criteria == 'Mess') {
      hostels.sort((a, b) {
        int rankA = _mapMessToValue(a['mess'] as String?);
        int rankB = _mapMessToValue(b['mess'] as String?);
        return rankA.compareTo(rankB);
      });
    }

    return hostels;
  }

  int _mapRentToValue(String? rent) {
    if (rent == null) return 0;
    if (rent == 'Less than 2000') return 1;
    if (rent == 'Between 2000 - 3000') return 2;
    if (rent == 'Between 3000 - 4000') return 3;
    if (rent == 'More than 4000') return 4;
    return 0;
  }

  int _mapDistanceToValue(String? distance) {
    if (distance == null) return 0;
    if (distance == 'Less than 500 meters') return 1;
    if (distance == 'Between 0.5 - 1 Kilometer') return 2;
    if (distance == 'Between 1 - 1.5 Kilometers') return 3;
    if (distance == 'More than 2 Kilometers') return 4;
    return 0;
  }

  int _mapMessToValue(String? mess) {
    if (mess == null) return 0;
    return mess == 'Yes' ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Expanded(child: Text('Distance')),
                Radio<String>(
                  value: 'Distance',
                  groupValue: _selectedOption,
                  onChanged: (value) async {
                    setState(() {
                      _selectedOption = value;
                    });
                    var sortedHostels = await _fetchAndSortHostels(value!);
                    widget.onSortSelected(sortedHostels);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Expanded(child: Text('Rent')),
                Radio<String>(
                  value: 'Rent',
                  groupValue: _selectedOption,
                  onChanged: (value) async {
                    setState(() {
                      _selectedOption = value;
                    });
                    var sortedHostels = await _fetchAndSortHostels(value!);
                    widget.onSortSelected(sortedHostels);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Expanded(child: Text('Mess')),
                Radio<String>(
                  value: 'Mess',
                  groupValue: _selectedOption,
                  onChanged: (value) async {
                    setState(() {
                      _selectedOption = value;
                    });
                    var sortedHostels = await _fetchAndSortHostels(value!);
                    widget.onSortSelected(sortedHostels);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
