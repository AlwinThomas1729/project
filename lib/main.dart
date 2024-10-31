//
//
//
//
//
// calls main main function
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Suppress all non-error log messages
  FlutterError.onError = (FlutterErrorDetails details) {
    // Print errors only
    FlutterError.dumpErrorToConsole(details);
  };

  // Suppress logs except explicit prints and errors
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && message.contains('ERROR')) {
      // Print only errors or critical logs
      print(message);
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: const MainPage(),
    );
  }
}
