import 'package:flutter/material.dart';
import 'dart:io';
import 'package:music_junkie/musicBrainzAPI/mbAPIHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_junkie/screens/google_sign_in.dart';
import 'package:music_junkie/screens/auth_screen.dart';
import 'package:music_junkie/screens/home_screen.dart'; // Import the home_screen.dart file

//this is a test comment

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyB9OzkogGg5EUNWN9HfYLvYgT0i8Y4lG7w',
          appId: '1:209524540642:android:b1968e875b818d41f58abb',
          messagingSenderId: '209524540642',
          projectId: 'group-project-2-180bf',
        ))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Use the HomeScreen widget
    );
  }
}
