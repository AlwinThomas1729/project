
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color pageBackground = Color.fromARGB(255, 186, 180, 185);
const Color appBarColor = Color.fromARGB(255, 192, 223, 21);
const Color submitButtonColor = Colors.green; // Color for submit button
const Color inputBoxColor =
    Color.fromARGB(255, 205, 153, 210); // Color for input box
const Color inputTextColor = Colors.purple; // Color for input text

class AddHostel extends StatefulWidget {
  const AddHostel({super.key});

  @override
  _AddHostelState createState() => _AddHostelState();
}

class _AddHostelState extends State<AddHostel> {
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
    {'question': 'Enter Hostel location:', 'type': 'text', 'short': 'location'},
    {
      'question':
          'Is there restriction for entering at night? if yes mention time:',
      'type': 'multiple_choice',
      'options': [
        '10 PM or Before that',
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

  List<TextEditingController> controllers = [];
  Map<String, dynamic> answers = {}; // Store answers as a key-value pair
  bool isLoading = false;
  bool isSubmitting = false; // Track submission state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(questions.length, (index) => TextEditingController());
  }

  bool validateFields() {
    bool allFieldsFilled = true;

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final shortKey = question['short'];
      if (question['type'] == 'multiple_choice') {
        if (answers[shortKey] == null || answers[shortKey].isEmpty) {
          allFieldsFilled = false;
        }
      } else {
        if (controllers[i].text.isEmpty) {
          allFieldsFilled = false;
        } else {
          answers[shortKey] = controllers[i].text;
        }
      }
    }

    String mobileNumber =
        controllers[2].text; // Owner/Manager number is at index 2
    bool isMobileValid = mobileNumber.length == 10;

    if (!allFieldsFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
    }

    if (!isMobileValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mobile number must be 10 digits.')),
      );
    }

    return allFieldsFilled && isMobileValid;
  }

  Future<void> submitAnswers() async {
    if (!validateFields() || isSubmitting) return;

    setState(() {
      isLoading = true;
      isSubmitting = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in!';
      String userEmail = user.email ?? 'Unknown User';

      answers['userEmail'] = userEmail;
      answers['timestamp'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance.collection('temphostels').add(answers);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Hostel details submitted successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error submitting data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error submitting data. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isSubmitting = false;
        });
      }
    }
  }

  Widget _buildTextField(String question, int index,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controllers[index],
        decoration: InputDecoration(
          labelText: question,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: inputTextColor)),
          fillColor: inputBoxColor,
          filled: true,
        ),
        keyboardType: keyboardType,
        style: const TextStyle(color: inputTextColor),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildDropdownField(String question, List<String> options, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: question,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: inputTextColor)),
          fillColor: inputBoxColor,
          filled: true,
        ),
        value: answers[questions[index]['short']],
        items: options
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(color: inputTextColor),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            answers[questions[index]['short']] = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Details'),
        backgroundColor: appBarColor,
      ),
      body: Container(
        color: pageBackground,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              if (question['type'] == 'text') {
                return _buildTextField(question['question'], index);
              } else if (question['type'] == 'multiple_choice') {
                return _buildDropdownField(
                    question['question'], question['options'], index);
              } else if (question['type'] == 'integer') {
                return _buildTextField(question['question'], index,
                    keyboardType: TextInputType.number);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: submitButtonColor,
        onPressed: submitAnswers,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
