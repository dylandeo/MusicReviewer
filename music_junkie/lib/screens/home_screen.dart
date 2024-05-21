import 'package:flutter/material.dart';
import 'package:music_junkie/screens/google_sign_in.dart';
import 'package:music_junkie/screens/auth_screen.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Music Junkie"),
        backgroundColor: Colors.blue, // Customize navigation bar color
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginWithGoogle(),
                  ),
                );
              },
              child: Text("Login with Google"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(),
                  ),
                );
              },
              child: Text("Email/Password Sign In/Up"),
            ),
          ],
        ),
      ),
    );
  }
}