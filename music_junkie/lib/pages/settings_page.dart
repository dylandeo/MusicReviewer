import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_junkie/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
            onPressed: () async {
              // Revoke Google Sign-In credentials
              await _googleSignIn.signOut();

              // Sign out from Firebase Authentication
              await FirebaseAuth.instance.signOut();
              // Navigate back to the AuthScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            child: Text('Logout'),
          ),

          ElevatedButton(
              onPressed: ()  async {
                String uuid = (FirebaseAuth.instance.currentUser?.uid)!;
                var url = Uri.https('mj-backend-api-7jy7nkqd4a-uc.a.run.app', '/users/${uuid}');
                await http.delete(url);

                showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Your reviews have been deleted!'),
              );
            },
          );
              },
              child: Text('Delete Your Reviews', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 238, 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    //minimumSize: Size(300, 50),
              )
             ) ,
          ],
      ),
      ),
    );
  }
}
