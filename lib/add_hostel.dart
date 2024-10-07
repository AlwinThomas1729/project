import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    },
    {
      'question': 'Select the type of hostel:',
      'type': 'multiple_choice',
      'options': ['Boys Hostel', 'Girls Hostel', 'Co-ed Hostel'],
    },
    {
      'question': 'Rate the hostel facilities:',
      'type': 'rating',
    },
  ];

  int currentQuestionIndex = 0;
  List<dynamic> answers = [];

  // Function to handle the "Next" button
  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  // Function to handle the "Submit" button
  Future<void> submitAnswers() async {
    try {
      // Get the current user ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not logged in!';
      }

      // Fetch the userId from the 'users' collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw 'User document not found!';
      }

// Fetch the userId from Firestore
      String userId = userDoc['userId'].toString(); // Ensure it's a String
      print("Fetched userId: $userId");

// Prepare the data to be submitted to Firestore
      Map<String, dynamic> hostelData = {
        'userId': userId, // Store the fetched userId, do not overwrite it
        'answers': answers,
        'timestamp': FieldValue.serverTimestamp(), // Store the timestamp
      };

      await FirebaseFirestore.instance.collection('hostel').add(hostelData);

      // Confirm submission with a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hostel details submitted successfully!')),
      );
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error submitting data. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hostel Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Render different input types based on the question type
            if (questions[currentQuestionIndex]['type'] == 'text')
              TextField(
                onChanged: (value) {
                  if (answers.length <= currentQuestionIndex) {
                    answers.add(value);
                  } else {
                    answers[currentQuestionIndex] = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your answer',
                  border: OutlineInputBorder(),
                ),
              ),
            if (questions[currentQuestionIndex]['type'] == 'multiple_choice')
              Column(
                children:
                    (questions[currentQuestionIndex]['options'] as List<String>)
                        .map((option) {
                  return RadioListTile(
                    title: Text(option),
                    value: option,
                    groupValue: answers.length > currentQuestionIndex
                        ? answers[currentQuestionIndex]
                        : null,
                    onChanged: (value) {
                      setState(() {
                        if (answers.length <= currentQuestionIndex) {
                          answers.add(value);
                        } else {
                          answers[currentQuestionIndex] = value;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            if (questions[currentQuestionIndex]['type'] == 'rating')
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index <
                              (answers.length > currentQuestionIndex
                                  ? answers[currentQuestionIndex]
                                  : 0)
                          ? Icons.star
                          : Icons.star_border,
                    ),
                    onPressed: () {
                      setState(() {
                        if (answers.length <= currentQuestionIndex) {
                          answers.add(index + 1);
                        } else {
                          answers[currentQuestionIndex] = index + 1;
                        }
                      });
                    },
                  );
                }),
              ),
            const Spacer(),
            // Show the "Next" or "Submit" button depending on the current question
            if (currentQuestionIndex < questions.length - 1)
              ElevatedButton(
                onPressed: nextQuestion,
                child: const Text('Next'),
              )
            else
              ElevatedButton(
                onPressed: submitAnswers,
                child: const Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }
}
