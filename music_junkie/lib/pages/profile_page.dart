import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_junkie/buttons/settings_button.dart';
import 'package:music_junkie/buttons/profile_and_search_button.dart';
import 'package:music_junkie/pages/search_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_junkie/pages/song_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _email = '';
  String uuid = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? '';
        uuid = user.uid;
      });
    }
  }

  Future<List> getUserReviews() async {
    var url = Uri.https('mj-backend-api-7jy7nkqd4a-uc.a.run.app', '/users/${uuid}');
    var response = await http.get(url);

    if(response.body == "[]")
    {
      return List.empty();
    }

    var bodyString = response.body.substring(1, (response.body.length-1));
    var initalSplit = bodyString.split('[*]');
    List result = [];
    for(var element in initalSplit){
      //print(element);
      var splitter = element.substring(1, element.length-1).split(',');
      for(int i = 0; i <= splitter.length-8; i+= 8){
        var anotherSplit = splitter.sublist(i, i+8);
        //print(anotherSplit);
        if(i < splitter.length-8){
          anotherSplit[7] = anotherSplit[7].substring(0, anotherSplit[7].length-1);
        }
        result.add(anotherSplit);
      }      
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('$_email'),
        actions: [
          SettingsButton(),
        ],
      ),
      body: 
            FutureBuilder(
        builder: (ctx, snapshot) {
    // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
      // If we got an error
        if (snapshot.hasError) {
        return Center(
          child: Text(
            '${snapshot.error} occurred',
            style: TextStyle(fontSize: 18),
          ),
        );
         
        // if we got our data
      } else if (snapshot.hasData) {
        final List result = snapshot.data as List;
        

        if (result.isEmpty){
                  return(
                    Center(
                      child: 
                        Text(
                          "You haven't left any reviews yet!"
                        )
                      )
                  );
                }
        return SingleChildScrollView(
          child: Column(
            children:[
             for(var element in result)
             
              Padding(
                padding: const EdgeInsets.fromLTRB(12,0,12,0),
                child: GestureDetector(
                  onDoubleTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SongPage(title: element[5].substring(1), artistName: element[6].substring(1), trackID: element[1].substring(1))),);
                    },
                   
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text("${element[7][1].toString().toUpperCase()}"),
                      ),
                      title: Text("${element[5].substring(1)} by ${element[6].substring(1)}"),
                      
                      subtitle: Text('${element[3].substring(1)}\nposted at ${element[4].substring(1, (element[4].length-1))} '),
                      )
                      
                      ),
                ),
              ),
             
            ],
          ),
        );
      }

      

    }
      return Center(
        child: CircularProgressIndicator(),
        );
  },
    

     future: getUserReviews(),
  ),


      bottomNavigationBar: BottomButtons(
        musicButtonOnPressed: () {
          // Navigate to the search page when the music button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        profileButtonOnPressed: () {
          // Handle profile button press
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
      ),
    );
  }
}