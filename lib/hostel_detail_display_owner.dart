import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const Color bgcolor = Colors.red; // Background color
const Color inputboxcolor = Colors.green; // Input box color
const Color inputboxtextcolor = Colors.blue; // Input box text color

class HostelDetailPage extends StatefulWidget {
  final String hostelId;
  final String userEmail;

  const HostelDetailPage({
    super.key,
    required this.hostelId,
    required this.userEmail,
  });

  @override
  _HostelDetailPageState createState() => _HostelDetailPageState();
}

class _HostelDetailPageState extends State<HostelDetailPage> {
  bool isEditMode = false;
  Map<String, TextEditingController> controllers = {};

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your hostel name?',
      'type': 'text',
      'short': 'Hostel Name'
    },
    {
      'question': 'What is your hostel owner/manager name?',
      'type': 'text',
      'short': 'Manager Name'
    },
    {
      'question': 'What is owner/manager number?',
      'type': 'integer',
      'short': 'Contact Number'
    },
    {
      'question': 'Select the type of hostel:',
      'type': 'multiple_choice',
      'options': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
      'short': 'Hostel Type'
    },
    {
      'question': 'Select Rent Range:',
      'type': 'multiple_choice',
      'options': [
        'Less than 2000',
        'Between 2000 - 3000',
        'Between 3000 - 4000',
        'More than 4000'
      ],
      'short': 'Rent'
    },
    {'question': 'Enter Hostel location:', 'type': 'text', 'short': 'Location'},
    {
      'question':
          'Is there restriction for entering at night? If yes, mention time:',
      'type': 'multiple_choice',
      'options': [
        '10 PM or Before',
        '11 PM',
        '12 PM',
        'Anytime, but inform warden',
        'None'
      ],
      'short': 'Restriction'
    },
    {
      'question': 'Is Refrigerator available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'Refrigerator'
    },
    {
      'question': 'Is Washing Machine available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'Washing Machine'
    },
    {
      'question': 'Is Mess/Food available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'Mess'
    },
    {
      'question': 'Is Wi-Fi available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No', 'Installable'],
      'short': 'WiFi'
    },
    {
      'question': 'Number of vacancies:',
      'type': 'integer',
      'short': 'Vacancies'
    },
    {
      'question': 'Is Kitchen available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'Kitchen'
    },
    {
      'question': 'Distance from Institution:',
      'type': 'multiple_choice',
      'options': [
        'Less than 500 meters',
        'Between 0.5 - 1 Kilometer',
        'Between 1 - 1.5 Kilometers',
        'More than 2 Kilometers'
      ],
      'short': 'Distance'
    },
    {'question': 'Enter Hostel ID', 'type': 'integer', 'short': 'Hostel Id'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        title: const Text('Hostel Details'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () =>
                isEditMode ? _validateAndSaveUpdates() : _enableEditMode(),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('hostels')
            .doc(widget.hostelId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Hostel not found'));
          }

          var hostelData = snapshot.data!.data() as Map<String, dynamic>;

          if (hostelData['userEmail'] != widget.userEmail) {
            return const Center(child: Text('Unauthorized access'));
          }

          if (controllers.isEmpty) {
            for (var question in questions) {
              var short = question['short'];
              controllers[short] = TextEditingController(
                text: hostelData[short]?.toString() ?? '',
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                String shortKey = questions[index]['short'];
                return buildEditableField(
                    questions[index], controllers[shortKey]!, index);
              },
            ),
          );
        },
      ),
    );
  }

  void _enableEditMode() {
    setState(() {
      isEditMode = true;
    });
  }

  Future<void> _validateAndSaveUpdates() async {
    String managerNumber = controllers['contact_number']!.text.trim();

    if (managerNumber.length != 10 ||
        !RegExp(r'^\d{10}$').hasMatch(managerNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Manager number must be exactly 10 digits!')),
      );
      return;
    }

    setState(() {
      isEditMode = false;
    });

    Map<String, dynamic> updatedData = {};
    for (var question in questions) {
      updatedData[question['short']] = controllers[question['short']]!.text;
    }

    await FirebaseFirestore.instance
        .collection('hostels')
        .doc(widget.hostelId)
        .update(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hostel details updated successfully!')),
    );
  }

  Widget buildEditableField(Map<String, dynamic> question,
      TextEditingController controller, int index) {
    String type = question['type'];
    Color backgroundColor = inputboxcolor;
    Color textColor = inputboxtextcolor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question['question'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: type == 'multiple_choice'
                ? DropdownButtonFormField<String>(
                    value: controller.text.isNotEmpty ? controller.text : null,
                    items: (question['options'] as List<String>).map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: isEditMode
                        ? (value) {
                            setState(() {
                              controller.text = value!;
                            });
                          }
                        : null,
                    style: TextStyle(color: textColor),
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  )
                : TextField(
                    controller: controller,
                    enabled: isEditMode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                    style: TextStyle(color: textColor),
                    keyboardType: type == 'integer'
                        ? TextInputType.number
                        : TextInputType.text,
                  ),
          ),
        ],
      ),
    );
  }
}
