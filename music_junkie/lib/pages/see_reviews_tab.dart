import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SeeReviewsTab extends StatefulWidget{

  const SeeReviewsTab({super.key, required this.trackID});
  final String trackID;

  @override
  State<SeeReviewsTab> createState() => _SeeReviewsTab();
}

class _SeeReviewsTab extends State<SeeReviewsTab> {

  Future<List> getReviews() async {
    var url = Uri.https('mj-backend-api-7jy7nkqd4a-uc.a.run.app', '/songs/${widget.trackID}');
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
 Widget build(BuildContext context){
  return Scaffold(
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
                          "Nobody has left a review yet!"
                        )
                      )
                  );
                }
        String reviewContent = "";
        return SingleChildScrollView(
          child: Column(
            children:[
             for(var element in result)
             
              Padding(
                padding: const EdgeInsets.fromLTRB(12,0,12,0),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text("${element[7][1].toUpperCase()}"),
                    ),
                    title: Text("${element[7].substring(1)}"),
                    subtitle: Text('${element[3].substring(1)}\nposted at ${element[4].substring(1, (element[4].length-1))} '),
                    )
                    
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
    

     future: getReviews(), 
  )

    );
  }
 }
