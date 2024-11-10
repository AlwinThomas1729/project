
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<String> _categories = [
    'Rent',
    'Distance',
    'Mess',
    'Hostel Type',
    'Restriction',
    'Refrigerator',
    'Washing Machine',
    'WiFi',
    'Kitchen'
  ];

  final Map<String, List<String>> _filterOptions = {
    'Rent': [
      'Less than 2000',
      'Between 2000 - 3000',
      'Between 3000 - 4000',
      'More than 4000'
    ],
    'Distance': [
      'Less than 500 meters',
      'Between 0.5 - 1 Kilometer',
      'Between 1 - 1.5 Kilometers',
      'More than 2 Kilometers'
    ],
    'Mess': ['Yes', 'No'],
    'Hostel Type': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
    'Restriction': [
      '10 PM or Before that',
      '11 PM',
      '12 AM',
      'Anytime, but inform warden',
      'None'
    ],
    'Refrigerator': ['Yes', 'No'],
    'Washing Machine': ['Yes', 'No'],
    'WiFi': ['Yes', 'No', 'Installable'],
    'Kitchen': ['Yes', 'No'],
  };

  final Map<String, Set<String>> _selectedFilters = {
    'Rent': {},
    'Distance': {},
    'Mess': {},
    'Hostel Type': {},
    'Restriction': {},
    'Refrigerator': {},
    'Washing Machine': {},
    'WiFi': {},
    'Kitchen': {},
  };

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Options'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // 45% width for filter categories
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blue[50],
                  child: ListView(
                    children: _categories.map((category) {
                      return ListTile(
                        title: Text(category, textAlign: TextAlign.left),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selected: _selectedCategory == category,
                        selectedTileColor: Colors.blue[100],
                      );
                    }).toList(),
                  ),
                ),
                // 55% width for displaying corresponding options
                Expanded(
                  child: _selectedCategory == null
                      ? const Center(
                          child: Text('Select a category to see options'),
                        )
                      : _buildOptionsForSelectedCategory(),
                ),
              ],
            ),
          ),
          // "Apply" button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsForSelectedCategory() {
    final options = _filterOptions[_selectedCategory];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Options for $_selectedCategory',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              children: options!.map((option) {
                return CheckboxListTile(
                  title: Text(option),
                  value:
                      _selectedFilters[_selectedCategory]?.contains(option) ??
                          false,
                  onChanged: (selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedFilters[_selectedCategory]?.add(option);
                      } else {
                        _selectedFilters[_selectedCategory]?.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Print selected filters for debugging
    print('Selected filters: $_selectedFilters');

    // Pass the selected filters back to the previous screen
    Navigator.pop(context, _selectedFilters);
  }
}
