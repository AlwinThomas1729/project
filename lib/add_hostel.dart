import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'customtext.dart';
import 'customradio.dart'; // Import your custom widget file

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
      'width': 350.0,
      'height': 220.0,
    },
    {
      'question': 'What is your hostel owner/manager name?',
      'type': 'text',
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'What is owner/manager number?',
      'type': 'integer',
      'width': 350.0,
      'height': 220.0,
    },
    {
      'question': 'Select the type of hostel:',
      'type': 'multiple_choice',
      'options': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
      'width': 350.0,
      'height': 350.0,
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
      'width': 350.0,
      'height': 400.0,
    },
    {
      'question': 'Enter Hostel location :',
      'type': 'text',
      'width': 350.0,
      'height': 220.0,
    },
    {
      'question':
          'Is there restriction for entering at night? if yes mention time:',
      'type': 'multiple_choice',
      'options': [
        '9 PM',
        '10 PM',
        '11 PM',
        '12 PM',
        'Anytime, but inform warden',
        'None'
      ],
      'width': 350.0,
      'height': 500.0,
    },
    {
      'question': 'Is Refrigerator available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'Is washing Machine available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'Is Mess/Food available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'Is Wi-Fi available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No', 'installable'],
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'Number of vaccancies:',
      'type': 'integer',
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'Is Kitchen available:',
      'type': 'multiple_choice',
      'options': ['Yes', 'No'],
      'width': 350.0,
      'height': 250.0,
    },
    {
      'question': 'Distance:',
      'type': 'multiple_choice',
      'options': [
        'Less than 500 meters',
        'Between 0.5 - 1 Kilometer',
        'Between 1 - 1.5 Kilometers',
        'More than 2 Kilometers'
      ],
      'width': 350.0,
      'height': 450.0,
    },
    {
      'question': 'Enter Hostel ID',
      'type': 'integer', // Mark it as an integer question
      'width': 350.0,
      'height': 220.0,
    },
  ];

  int currentQuestionIndex = 0;
  List<dynamic> answers = [];
  bool isLoading = false;

  // Function to handle the "Next" button
  void nextQuestion() {
    if (validateAnswer()) {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        submitAnswers();
      }
    } else {
      showDialogBox(
          'Add Value', 'Please provide a valid value before proceeding.');
    }
  }

  // Validate if the user provided an answer
  bool validateAnswer() {
    var currentQuestion = questions[currentQuestionIndex];

    if (currentQuestion['type'] == 'text') {
      return answers.length > currentQuestionIndex &&
          answers[currentQuestionIndex].isNotEmpty;
    } else if (currentQuestion['type'] == 'multiple_choice') {
      return answers.length > currentQuestionIndex;
    } else if (currentQuestion['type'] == 'integer') {
      // For integer type, validate if the input is an integer
      if (answers.length > currentQuestionIndex) {
        String answer = answers[currentQuestionIndex];
        return int.tryParse(answer) != null;
      }
    }
    return false;
  }

  Future<void> submitAnswers() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not logged in!';
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw 'User document not found!';
      }

      String userId = userDoc['userId'].toString();

      Map<String, dynamic> hostelData = {
        'userId': userId,
        'answers': answers,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('hostel').add(hostelData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hostel details submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error submitting data. Please try again.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to show dialog box
  void showDialogBox(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hostel Details')),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 210, 17, 17),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 27, 53, 183).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            width: questions[currentQuestionIndex]['width'],
            height: questions[currentQuestionIndex]['height'],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          questions[currentQuestionIndex]['question'],
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (questions[currentQuestionIndex]['type'] ==
                                    'text')
                                  CustomTextField(
                                    onChanged: (value) {
                                      if (answers.length <=
                                          currentQuestionIndex) {
                                        answers.add(value);
                                      } else {
                                        answers[currentQuestionIndex] = value;
                                      }
                                    },
                                  ),
                                if (questions[currentQuestionIndex]['type'] ==
                                    'multiple_choice')
                                  Column(
                                    children: (questions[currentQuestionIndex]
                                            ['options'] as List<String>)
                                        .map((option) {
                                      return CustomRadioButton(
                                        title: option,
                                        groupValue: answers.length >
                                                currentQuestionIndex
                                            ? answers[currentQuestionIndex]
                                            : null,
                                        onChanged: (value) {
                                          setState(() {
                                            if (answers.length <=
                                                currentQuestionIndex) {
                                              answers.add(value);
                                            } else {
                                              answers[currentQuestionIndex] =
                                                  value;
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                if (questions[currentQuestionIndex]['type'] ==
                                    'integer')
                                  CustomTextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (answers.length <=
                                          currentQuestionIndex) {
                                        answers.add(value);
                                      } else {
                                        answers[currentQuestionIndex] = value;
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: nextQuestion,
                          child: Text(
                              currentQuestionIndex < questions.length - 1
                                  ? 'Next'
                                  : 'Submit'),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
