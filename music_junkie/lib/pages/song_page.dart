import 'package:flutter/widgets.dart';
import 'package:music_junkie/buttons/settings_button.dart';
import 'package:music_junkie/buttons/profile_and_search_button.dart';
import 'package:flutter/material.dart';
import 'package:music_junkie/pages/see_reviews_tab.dart';
import 'package:music_junkie/pages/write_review_tab.dart';

class SongPage extends StatefulWidget {

  const SongPage({super.key, required this.title, required this.artistName, required this.trackID});

  final String title;
  final String artistName;
  final String trackID;

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext)
  {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true ,
          title: Text('${widget.title} by ${widget.artistName}'),
          actions: [
            SettingsButton(),
          ],
        ),
         body: Column(children: [
          TabBar(
            tabs: [
              Tab(icon: Icon(Icons.rate_review,
              color: Colors.deepPurple),),
              Tab(icon: Icon(Icons.dynamic_feed,
              color: Colors.deepOrange))
            ]),

            Expanded(
              child: TabBarView(children: [
                WriteReviewTab(trackID: widget.trackID),
                SeeReviewsTab(trackID: widget.trackID)
              ]),
            )
        ],),)
        

    );
  
  }


}