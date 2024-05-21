import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_junkie/pages/profile_page.dart'; // Import the ProfilePage
import 'package:http/http.dart' as http;

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  @override
  _LoginWithGoogleState createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  @override
  void initState() {
    super.initState();
    _signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      String uuid = (FirebaseAuth.instance.currentUser?.uid)!;
      String email = (FirebaseAuth.instance.currentUser?.email)!;
      var url = Uri.https('mj-backend-api-7jy7nkqd4a-uc.a.run.app', '/users/${uuid}/${email}');
      await http.post(url);

      // Navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }
}
