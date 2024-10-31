// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// const Color pageBackground = Color.fromARGB(255, 186, 180, 185);
// const Color appBarColor = Color.fromARGB(255, 192, 223, 21);
// const Color submitButtonColor = Colors.green; // Color for submit button
// const Color inputBoxColor =
//     Color.fromARGB(255, 205, 153, 210); // Color for input box
// const Color inputTextColor = Colors.purple; // Color for input text

// class AddHostel extends StatefulWidget {
//   const AddHostel({super.key});

//   @override
//   _AddHostelState createState() => _AddHostelState();
// }

// class _AddHostelState extends State<AddHostel> {
//   final List<Map<String, dynamic>> questions = [
//     {
//       'question': 'What is your hostel name?',
//       'type': 'text',
//       'short': 'hostel_name'
//     },
//     {
//       'question': 'What is your hostel owner/manager name?',
//       'type': 'text',
//       'short': 'manager_name'
//     },
//     {
//       'question': 'What is owner/manager number?',
//       'type': 'integer',
//       'short': 'contact_number'
//     },
//     {
//       'question': 'Select the type of hostel:',
//       'type': 'multiple_choice',
//       'options': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
//       'short': 'hostel_type'
//     },
//     {
//       'question': 'Select Rent Range:',
//       'type': 'multiple_choice',
//       'options': [
//         'Less than 2000',
//         'Between 2000 - 3000',
//         'Between 3000 - 4000',
//         'More than 4000'
//       ],
//       'short': 'rent'
//     },
//     {'question': 'Enter Hostel location:', 'type': 'text', 'short': 'location'},
//     {
//       'question':
//           'Is there restriction for entering at night? if yes mention time:',
//       'type': 'multiple_choice',
//       'options': [
//         '10 PM or Before that',
//         '11 PM',
//         '12 PM',
//         'Anytime, but inform warden',
//         'None'
//       ],
//       'short': 'restriction'
//     },
//     {
//       'question': 'Is Refrigerator available:',
//       'type': 'multiple_choice',
//       'options': ['Yes', 'No'],
//       'short': 'refrigerator'
//     },
//     {
//       'question': 'Is Washing Machine available:',
//       'type': 'multiple_choice',
//       'options': ['Yes', 'No'],
//       'short': 'washing_machine'
//     },
//     {
//       'question': 'Is Mess/Food available:',
//       'type': 'multiple_choice',
//       'options': ['Yes', 'No'],
//       'short': 'mess'
//     },
//     {
//       'question': 'Is Wi-Fi available:',
//       'type': 'multiple_choice',
//       'options': ['Yes', 'No', 'Installable'],
//       'short': 'wifi'
//     },
//     {
//       'question': 'Number of vacancies:',
//       'type': 'integer',
//       'short': 'vacancies'
//     },
//     {
//       'question': 'Is Kitchen available:',
//       'type': 'multiple_choice',
//       'options': ['Yes', 'No'],
//       'short': 'kitchen'
//     },
//     {
//       'question': 'Distance from Institution:',
//       'type': 'multiple_choice',
//       'options': [
//         'Less than 500 meters',
//         'Between 0.5 - 1 Kilometer',
//         'Between 1 - 1.5 Kilometers',
//         'More than 2 Kilometers'
//       ],
//       'short': 'distance'
//     },
//     {'question': 'Enter Hostel ID', 'type': 'integer', 'short': 'hostel_id'},
//   ];

//   List<TextEditingController> controllers = [];
//   Map<String, dynamic> answers = {}; // Store answers as a key-value pair
//   bool isLoading = false;
//   bool isSubmitting = false; // Track submission state
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     controllers =
//         List.generate(questions.length, (index) => TextEditingController());
//   }

//   // Check if all fields are filled, and if mobile number is valid
//   bool validateFields() {
//     bool allFieldsFilled = true;

//     for (int i = 0; i < questions.length; i++) {
//       final question = questions[i];
//       final shortKey = question['short']; // Get the short key
//       if (question['type'] == 'multiple_choice') {
//         if (answers[shortKey] == null || answers[shortKey].isEmpty) {
//           allFieldsFilled = false;
//         }
//       } else {
//         if (controllers[i].text.isEmpty) {
//           allFieldsFilled = false;
//         } else {
//           // Store the text input into the answers map using short key
//           answers[shortKey] = controllers[i].text;
//         }
//       }
//     }

//     String mobileNumber =
//         controllers[2].text; // Owner/Manager number is at index 2
//     bool isMobileValid = mobileNumber.length == 10;

//     // Highlight invalid fields
//     if (!allFieldsFilled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields.')),
//       );
//     }

//     if (!isMobileValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Mobile number must be 10 digits.')),
//       );
//     }

//     return allFieldsFilled && isMobileValid;
//   }

//   Future<void> submitAnswers() async {
//     // Check if fields are valid before submitting
//     if (!validateFields() || isSubmitting) {
//       return; // Stop if form is not valid or already submitting
//     }

//     setState(() {
//       isLoading = true;
//       isSubmitting = true; // Set submitting state to true
//     });

//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw 'User not logged in!';
//       }

//       // Use user.email instead of fetching the userId from Firestore
//       String userEmail =
//           user.email ?? 'Unknown User'; // Fallback if email is null

//       // Add the userEmail and timestamp to the answers map
//       answers['userEmail'] = userEmail; // Store email in answers map
//       answers['timestamp'] = FieldValue.serverTimestamp();

//       await FirebaseFirestore.instance.collection('hostels').add(answers);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Hostel details submitted successfully!')),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       print('Error submitting data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Error submitting data. Please try again.')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//         isSubmitting = false; // Reset submitting state
//       });
//     }
//   }

//   Widget _buildTextField(String question, int index,
//       {TextInputType keyboardType = TextInputType.text}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10), // Add margin
//       child: TextFormField(
//         controller: controllers[index],
//         decoration: InputDecoration(
//           labelText: question,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: inputTextColor)),
//           fillColor: inputBoxColor, // Set input box background color
//           filled: true,
//         ),
//         keyboardType: keyboardType,
//         style: const TextStyle(color: inputTextColor), // Set input text color
//         onChanged: (value) {
//           setState(() {}); // Rebuild UI to check if all fields are filled
//         },
//       ),
//     );
//   }

//   Widget _buildDropdownField(String question, List<String> options, int index) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10), // Add margin
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           labelText: question,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: inputTextColor)),
//           fillColor: inputBoxColor, // Set dropdown background color
//           filled: true,
//         ),
//         value: answers[questions[index]['short']], // Use short key for value
//         items: options
//             .map((option) => DropdownMenuItem(
//                   value: option,
//                   child: Text(
//                     option,
//                     style: const TextStyle(color: inputTextColor),
//                   ),
//                 ))
//             .toList(),
//         onChanged: (value) {
//           setState(() {
//             answers[questions[index]['short']] = value!;
//           });
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hostel Details'),
//         backgroundColor: appBarColor,
//       ),
//       body: Container(
//         color: pageBackground,
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView.builder(
//             itemCount: questions.length,
//             itemBuilder: (context, index) {
//               final question = questions[index];
//               if (question['type'] == 'text') {
//                 return _buildTextField(question['question'], index);
//               } else if (question['type'] == 'multiple_choice') {
//                 return _buildDropdownField(
//                     question['question'], question['options'], index);
//               } else if (question['type'] == 'integer') {
//                 return _buildTextField(question['question'], index,
//                     keyboardType: TextInputType.number);
//               } else {
//                 return const SizedBox.shrink(); // Return empty widget
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: submitButtonColor,
//         onPressed: submitAnswers,
//         child: isLoading
//             ? const CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               )
//             : const Icon(Icons.save),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose(); // Clean up the controllers
//     }
//     super.dispose();
//   }
// }

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
      'short': 'hostel_name'
    },
    {
      'question': 'What is your hostel owner/manager name?',
      'type': 'text',
      'short': 'manager_name'
    },
    {
      'question': 'What is owner/manager number?',
      'type': 'integer',
      'short': 'contact_number'
    },
    {
      'question': 'Select the type of hostel:',
      'type': 'multiple_choice',
      'options': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
      'short': 'hostel_type'
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
      'short': 'rent'
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
      'short': 'restriction'
    },
    {
      'question': 'Is Refrigerator available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'refrigerator'
    },
    {
      'question': 'Is Washing Machine available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'washing_machine'
    },
    {
      'question': 'Is Mess/Food available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'mess'
    },
    {
      'question': 'Is Wi-Fi available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No', 'Installable'],
      'short': 'wifi'
    },
    {
      'question': 'Number of vacancies:',
      'type': 'integer',
      'short': 'vacancies'
    },
    {
      'question': 'Is Kitchen available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'short': 'kitchen'
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
      'short': 'distance'
    },
    {'question': 'Enter Hostel ID', 'type': 'integer', 'short': 'hostel_id'},
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

      await FirebaseFirestore.instance.collection('hostels').add(answers);

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
