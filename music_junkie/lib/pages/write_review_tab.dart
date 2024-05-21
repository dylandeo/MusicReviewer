import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class WriteReviewTab extends StatefulWidget{

  const WriteReviewTab({super.key, required this.trackID});
  final String trackID;

  @override
  State<WriteReviewTab> createState() => _WriteReviewTab();
}

class _WriteReviewTab extends State<WriteReviewTab> {

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:
      
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(child:
              SizedBox(child: Text('Write a review!', style: TextStyle(fontSize: 30))),
                  ),
              Center(child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                    hintText: 'What do you think about this song?',
                  ),textAlign: TextAlign.center,))      
            ],
          ),
        ),


      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () async {
          String uuid = (FirebaseAuth.instance.currentUser?.uid)!;
          try{
            var url = Uri.https('mj-backend-api-7jy7nkqd4a-uc.a.run.app' , '/reviews/${widget.trackID}/${uuid}');
            await http.post(url, body: {'review': myController.text});
            myController.clear();
          }
          catch(e){
            print(e);
          };

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Your review has been added!'),
              );
            },
          );
        },
        child: const Icon(Icons.create),
      ),
    );
  }
}

 
